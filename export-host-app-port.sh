#!/bin/bash
CONTAINER_INTERNAL_PORT="8001/tcp"
CONTAINER_NAME="rui-server-container"
BLUE_CONTAINER_HOST_PORT=$(docker inspect --format '{{json .NetworkSettings.Ports}}' $CONTAINER_NAME | jq -r '."'$CONTAINER_INTERNAL_PORT'"[0].HostPort' )
printf "\n\n"
echo "[#] Start blue-green deploy...."
printf "\n\n"

if [ $BLUE_CONTAINER_HOST_PORT = "null" ]; then
    echo "::: Blue Container is stopped"
    BLUE_CONTAINER_HOST_PORT=8002
fi

if [ "$BLUE_CONTAINER_HOST_PORT" -eq 8001 ]; then
    GREEN_CONTAINER_HOST_PORT=8002
else
    GREEN_CONTAINER_HOST_PORT=8001
fi

echo "::: So, Green Container port will be $GREEN_CONTAINER_HOST_PORT"
echo "::: Export APP_PORT, it will be using in Docker-Build."
export HOST_APP_PORT=$GREEN_CONTAINER_HOST_PORT

printf "\n\n"

echo "[#] HOST_APP_PORT is exported."



# if docker ps --filter "name=$CONTAINER_NAME" --format "{{.Names}}" | grep -wq "$CONTAINER_NAME"; then
#     export IS_RUNNING_BLUE="true"
# else
#     export IS_RUNNING_BLUE="false"
# fi

# if  [ $IS_RUNNING_BLUE = "true" ]; then
#     echo "Delete blue container and Start Green Container"
    
#     rm -f blue_container_status.log
#     docker events --filter "container=$CONTAINER_NAME" --format 'Status={{.Status}}' > blue_container_status.log &
#     EVENT_PID=$!

#     docker stop $CONTAINER_NAME && docker start $CONTAINER_NAME &
#     echo "stop and start"
    
#     while true; do
#         if grep -q "start" blue_container_status.log; then
#             echo "$CONTAINER_NAME is starting~!"
#             break
#         elif grep -q "kill" blue_container_status.log; then
#             echo "$CONTAINER_NAME is kill...."
#         elif grep -q "stop" blue_container_status.log; then
#             echo "$CONTAINER_NAME is stop!"
#         fi
#         sleep 1
#     done
#     kill $EVENT_PID 2>/dev/null
#     rm -f blue_container_status.log
# else 
#     # rm -f blue_container_status.log
#     # docker events --filter "container=$CONTAINER_NAME" --format 'Status={{.Status}}' > blue_container_status.log &
#     # EVENT_PID=$!
# fi
# echo "fininshed"

