# Build stage
FROM node:18-alpine AS build

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build --prod

# Run stage
FROM nginx:alpine

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d

# Copy Angular build
COPY --from=build /app/dist/your-app-name /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
