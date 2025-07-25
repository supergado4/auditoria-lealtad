# Etapa de build
FROM node:18 AS builder

WORKDIR /app
COPY codigo-react/package*.json ./ 
RUN npm install

COPY codigo-react/ ./
RUN npm run build

# Etapa de producción
FROM nginx:stable-alpine
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
