# Stage 0, for downloading project’s npm dependencies, building and compiling the app.
# Angular 6 requires node:8.9+
FROM node:10 as node
WORKDIR /app
COPY package.json /app/
RUN npm install
COPY ./ /app/
RUN npm run build --prod
# Stage 1, for copying the compiled app from the previous step and making it ready for production with Nginx
FROM nginx:alpine
COPY --from=node /app/dist/angular-nginx /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf