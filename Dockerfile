FROM node:20-alpine AS build
WORKDIR /src
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run less

FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /src/index.html /src/favicon.ico /usr/share/nginx/html/
COPY --from=build /src/css   /usr/share/nginx/html/css
COPY --from=build /src/js    /usr/share/nginx/html/js
COPY --from=build /src/audio /usr/share/nginx/html/audio
COPY --from=build /src/font  /usr/share/nginx/html/font
EXPOSE 80
