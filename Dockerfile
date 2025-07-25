# Etapa 1: Construcción de la aplicación
# Usamos una imagen oficial de Node.js ligera
FROM node:18-alpine AS builder

# Establecemos el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiamos los archivos de dependencias y las instalamos
# Esto aprovecha el caché de Docker para no reinstalar si no cambian
COPY package*.json ./
RUN npm install

# Copiamos el resto del código de la aplicación
COPY . .

# Construimos la versión de producción optimizada
RUN npm run build

# Etapa 2: Servidor de producción
# Usamos una imagen más pequeña solo para ejecutar
FROM node:18-alpine

WORKDIR /app

# Copiamos solo los archivos necesarios de la etapa de construcción
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# Exponemos el puerto en el que Next.js corre por defecto
EXPOSE 3000

# El comando para iniciar la aplicación en modo producción
CMD ["npm", "start"]
