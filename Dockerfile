FROM node:lts AS BUILDER
WORKDIR /usr/src/app
COPY package.json ./
COPY pnpm-lock.yaml ./
RUN npm install -g pnpm && pnpm install
COPY . .
RUN pnpm run build
FROM node:alpine

WORKDIR /usr/src/app
COPY --from=BUILDER /usr/src/app/dist ./dist
COPY ./public ./public
ARG SERVER_CONFIG
RUN echo $SERVER_CONFIG | base64 -d > ./.env
CMD ["node", "dist/app.js"]

