FROM node:18-alpine

RUN apk update && apk add python3 make g++
RUN apk add --update nodejs npm

WORKDIR /app

COPY . ./

RUN npm install -g webpack webpack-cli
RUN npm install

EXPOSE 8080

ENTRYPOINT ["sh", "./docker/entrypoint.sh"]