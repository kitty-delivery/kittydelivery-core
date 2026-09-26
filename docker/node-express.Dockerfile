# Dockerfile generique pour les microservices KittyDelivery generes avec express-generator
# (KittyDelivery_API, mc_user, mc_auth, mc_component, mc_notif, mc_article, mc_order),
# aucun d'entre eux n'ayant son propre Dockerfile. Base sur leur package.json commun
# (script "start": "node ./bin/www", port par defaut 3000).
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --omit=dev
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
