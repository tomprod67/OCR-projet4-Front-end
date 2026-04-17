# =========================
#  BUILD ANGULAR
# =========================
FROM node:20-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm ci --cache .npm --prefer-offline

COPY . .

RUN npm run build


# =========================
# 🌐 NGINX
# =========================
FROM nginx:alpine

# Nettoyer dossier par défaut nginx
RUN rm -rf /usr/share/nginx/html/*


# On copie Angular DANS /app car nginx.conf utilise root /app
COPY --from=build /app/dist/olympic-games-starter/browser/ /app/

# Charger le nginx.conf fourni
COPY nginx/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

# Permet de garder le container actif
CMD ["nginx", "-g", "daemon off;"]