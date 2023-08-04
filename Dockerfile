ARG NODE_VERSION=18.16.1
ARG ALPINE_VERSION=3.17
ARG NGINX_VERSION=1.24.0

FROM node:${NODE_VERSION}-alpine${ALPINE_VERSION} AS base

RUN SYS_MAJ_VER=$( grep '^VERSION' /etc/os-release|awk -F= '{ print $2 }'|awk -F. '{ print($1"."$2) }') \
    && echo -e "http://nl.alpinelinux.org/alpine/v$SYS_MAJ_VER/main\nhttp://nl.alpinelinux.org/alpine/v$SYS_MAJ_VER/community" > /etc/apk/repositories \
    && apk update && apk upgrade && apk --no-cache add \
    tini \
    && rm -rf /var/cache/* \
    && mkdir /var/cache/apk

WORKDIR /root/app
ENTRYPOINT ["/sbin/tini", "--"]

FROM base as dependencies
COPY package.json package-lock.json .npmrc* ./
# download prod deps and cache them
RUN npm set progress false \
  && npm config set depth 0 
# download dev dependencies
RUN npm install

FROM dependencies as build
COPY . .
RUN npm run build

FROM nginx:${NGINX_VERSION}-alpine${ALPINE_VERSION}

COPY --from=base /etc/apk/repositories /etc/apk/repositories
RUN  apk update && apk upgrade

RUN mkdir -p /usr/share/nginx/html/typescript-reactjs-base-web
COPY --from=build /root/app/dist /usr/share/nginx/html/typescript-reactjs-base-web/
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

#Non Root User Configuration
RUN addgroup -S -g 10001 appGrp \
    && adduser -S -D -u 10000 -s /sbin/nologin -h /usr/share/nginx/html/typescript-reactjs-base-web -G appGrp app \
    && chown -R app:appGrp /usr/share/nginx/html \
    && mkdir -p /var/cache/nginx \
    && touch /var/run/nginx.pid \
    && chown -R app:appGrp /var/run/nginx.pid \
    && chown -R app:appGrp /var/cache/nginx

#Override as non-root user
USER 10000:10001

EXPOSE 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]