# Stage 0, for downloading project’s npm dependencies, building and compiling the app.
# Angular 6 requires node:8.9+
FROM node:16.10.0 as node
WORKDIR /app
COPY package.json /app/
RUN npm install
COPY ./ /app/
RUN npm run build --prod
# Stage 1, for copying the compiled app from the previous step and making it ready for production with Nginx
FROM nginx:latest
COPY --from=node /app/dist/angular-nginx /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
RUN apt-get update
RUN apt-get upgrade -y
RUN /bin/bash -c "openssl req -x509 -out etc/ssl/localhost.crt -keyout etc/ssl/localhost.key \
      -newkey rsa:2048 -nodes -sha256 \
      -subj '/CN=localhost' -extensions EXT -config <( \
       printf '[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth')"
