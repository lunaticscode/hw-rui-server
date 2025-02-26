#!/bin/bash
if [ "$1" = "" ]; then
    echo "(!)Must need first argument(=SERVER_CONFIG)."
    exit 1
fi

SERVER_CONFIG=$1
CONTAINER_INNER_PORT=$(echo "$SERVER_CONFIG" | base64 -d | xargs | grep -o 'APP_PORT=[^ ]*' | sed 's/APP_PORT=//')
CONTAINER_INTERNAL_PORT="$CONTAINER_INNER_PORT/tcp"
DOCKER_IMAGE_NAME="hw-rui-server-image"
DOCKER_CONTAINER_NAME="hw-rui-server-container"
DOCKER_BLUE_CONTAINER_NAME=$DOCKER_CONTAINER_NAME-blue

BLUE_CONTAINER_HOST_PORT=$(docker inspect --format '{{json .NetworkSettings.Ports}}' $DOCKER_CONTAINER_NAME | jq -r '."'$CONTAINER_INTERNAL_PORT'"[0].HostPort' )
echo "[#] Start blue-green deploy...."
printf "\n\n blue-port: $BLUE_CONTAINER_HOST_PORT"

if [ -z "$BLUE_CONTAINER_HOST_PORT" ]; then
    BLUE_CONTAINER_HOST_PORT=8002
fi

if [ $BLUE_CONTAINER_HOST_PORT -eq 8001 ]; then
    GREEN_CONTAINER_HOST_PORT=8002
else
    GREEN_CONTAINER_HOST_PORT=8001
fi

echo "\n:::green-port: $GREEN_CONTAINER_HOST_PORT / blue-port: $BLUE_CONTAINER_HOST_PORT"
echo "[#] Green Container build..."

docker build -t $DOCKER_IMAGE_NAME --build-arg SERVER_CONFIG=$SERVER_CONFIG --no-cache . || echo "::: (!) build failed."
docker rename $DOCKER_CONTAINER_NAME $DOCKER_BLUE_CONTAINER_NAME || echo "::: Blue container is not running"
docker run -it -d -p $GREEN_CONTAINER_HOST_PORT:$CONTAINER_INNER_PORT --name $DOCKER_CONTAINER_NAME $DOCKER_IMAGE_NAME || echo "::: (!) run failed."

echo "[#] Green Container run on $GREEN_CONTAINER_HOST_PORT:$CONTAINER_INNER_PORT"

docker ps --filter "name=$DOCKER_CONTAINER_NAME"

if docker ps --filter "name=$DOCKER_BLUE_CONTAINER_NAME" --format "{{.Names}}" | grep -wq "$DOCKER_BLUE_CONTAINER_NAME"; then
    export IS_RUNNING_BLUE="true"
else
    export IS_RUNNING_BLUE="false"
fi

if  [ $IS_RUNNING_BLUE = "true" ]; then
    echo "[#] Delete blue container"
    
    rm -f blue_container_status.log
    docker events --filter "container=$DOCKER_BLUE_CONTAINER_NAME" --format 'Status={{.Status}}' > blue_container_status.log &
    EVENT_PID=$!

    docker stop $DOCKER_BLUE_CONTAINER_NAME
    echo "::: Stop blue container..."
    
    while true; do
        if grep -q "stop" blue_container_status.log; then
            echo "::: blue container is stoped...!"
            docker rm -f $DOCKER_BLUE_CONTAINER_NAME
            break
        else 
            echo "::: kill...."
        fi
        sleep 1
    done
    kill $EVENT_PID 2>/dev/null
    rm -f blue_container_status.log
    echo "[#] Change nginx config file from blue to green."
else 
    # rm -f blue_container_status.log
    # docker events --filter "container=$CONTAINER_NAME" --format 'Status={{.Status}}' > blue_container_status.log &
    # EVENT_PID=$!
fi
echo "fininshed"

