# ---------- Build Stage ----------
FROM node:18-alpine AS build

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .
RUN npm run build --prod


# ---------- Runtime Stage ----------
FROM nginx:alpine

RUN rm /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/conf.d/default.conf

# 🔴 REPLACE app-name with the one from angular.json
COPY --from=build /app/dist/compodoc-demo-todomvc-angular /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
