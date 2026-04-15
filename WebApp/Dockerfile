FROM node:18-alpine AS builder

WORKDIR /app

COPY WebApp/package*.json ./
COPY WebApp/.npmrc ./.npmrc
COPY WebApp/babel.config.js ./
COPY WebApp/vue.config.js ./

RUN npm ci

COPY WebApp ./

ARG VUE_APP_BASE_API=/api
ENV VUE_APP_BASE_API=${VUE_APP_BASE_API}

RUN npm run build

FROM nginx:1.27-alpine

COPY deploy/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80
