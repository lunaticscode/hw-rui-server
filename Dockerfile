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
ENV APP_PORT="8001"
ENV API_HEADER_TOKEN="hw-rui-server-test"
EXPOSE 8000
CMD ["node", "dist/app.js"]

