<div align="center">

  <h1>KittyDelivery, architecture microservices</h1>

  <p>
    Depot chapeau du projet KittyDelivery, une application de livraison de repas realisee dans le cadre de mes etudes, decoupee en plusieurs microservices Node.js / Express independants.
  </p>

  <p>
    <img src="https://img.shields.io/badge/status-projet_scolaire-lightgrey" alt="status" />
    <img src="https://img.shields.io/badge/Node.js-339933?style=flat-square&logo=nodedotjs&logoColor=white" alt="Node.js" />
    <img src="https://img.shields.io/badge/Express-000000?style=flat-square&logo=express&logoColor=white" alt="Express" />
    <img src="https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white" alt="Docker" />
  </p>

</div>

<br />

## Table des matieres

- [A propos](#a-propos)
- [Architecture](#architecture)
- [Depots du projet](#depots-du-projet)
- [Demarrage](#demarrage)
  * [Prerequis](#prerequis)
  * [Cloner avec les sous-modules](#cloner-avec-les-sous-modules)
  * [Lancer avec Docker Compose](#lancer-avec-docker-compose)
- [Contact](#contact)

## A propos

KittyDelivery est une application de livraison de repas (type Uber Eats) pensee comme un exercice d'architecture microservices : chaque brique metier (utilisateurs, restaurants, authentification, notifications, articles, commandes, menus, logs) vit dans son propre depot GitHub, avec son propre `package.json` et, pour certains, son propre Dockerfile.

Ce depot ne contient pas de code metier : il sert de point d'entree unique pour naviguer entre les services, comprendre l'architecture globale, et lancer l'ensemble en local via Docker Compose.

A ce stade, la majorite des microservices sont des squelettes generes avec `express-generator` (route d'accueil et route `/users` d'exemple, sans logique metier ajoutee). `KittyDelivery_mc_restaurant` declare Express et Mongoose comme dependances et possede un Dockerfile, mais son point d'entree (`index.js`, declare comme `main` dans son `package.json`) est absent du depot et aucun script `start` n'y est defini : le conteneur se build mais ne demarre pas en l'etat. `KittyDelivery_mc_log` et `KittyDelivery_mc_menu` sont des depots vides, reserves pour une future implementation.

## Architecture

```mermaid
graph TD
    Client[Client web / mobile] --> API[KittyDelivery_API<br/>passerelle API]
    API --> Auth[KittyDelivery_mc_auth<br/>authentification]
    API --> User[KittyDelivery_mc_user<br/>comptes utilisateurs]
    API --> Restaurant[KittyDelivery_mc_restaurant<br/>restaurants, MongoDB]
    API --> Article[KittyDelivery_mc_article<br/>produits et plats]
    API --> Menu[KittyDelivery_mc_menu<br/>menus, vide]
    API --> Order[KittyDelivery_mc_order<br/>commandes]
    API --> Notif[KittyDelivery_mc_notif<br/>notifications]
    API --> Component[KittyDelivery_mc_component<br/>composants partages]
    Order --> Log[KittyDelivery_mc_log<br/>logs, vide]
    Restaurant --> Log
```

Ce schema represente les interactions probables entre services d'apres leur role declare. A ce stade du projet, la passerelle API ne contient pas encore de logique de routage effective vers les autres services : elle expose uniquement les routes par defaut du squelette Express.

## Depots du projet

| Depot | Role | Statut |
| --- | --- | --- |
| [KittyDelivery](https://github.com/kitty-delivery/KittyDelivery) | Depot principal, point d'entree du projet | Documentation seule |
| [KittyDelivery_API](https://github.com/kitty-delivery/KittyDelivery_API) | Passerelle API, cense router vers les autres services | Squelette Express |
| [KittyDelivery_mc_user](https://github.com/kitty-delivery/KittyDelivery_mc_user) | Gestion des comptes utilisateurs (nomme "Delivery" en interne) | Squelette Express |
| [KittyDelivery_mc_restaurant](https://github.com/kitty-delivery/KittyDelivery_mc_restaurant) | Gestion des restaurants (Express, MongoDB prevus) | Dockerfile present, point d'entree manquant |
| [KittyDelivery_mc_auth](https://github.com/kitty-delivery/KittyDelivery_mc_auth) | Authentification (nomme "General" en interne) | Squelette Express |
| [KittyDelivery_mc_component](https://github.com/kitty-delivery/KittyDelivery_mc_component) | Composants partages (nomme "Developer" en interne) | Squelette Express |
| [KittyDelivery_mc_notif](https://github.com/kitty-delivery/KittyDelivery_mc_notif) | Notifications (nomme "Client" en interne) | Squelette Express |
| [KittyDelivery_mc_article](https://github.com/kitty-delivery/KittyDelivery_mc_article) | Produits et plats (nomme "Restaurant" en interne) | Squelette Express |
| [KittyDelivery_mc_log](https://github.com/kitty-delivery/KittyDelivery_mc_log) | Centralisation des logs | Depot vide |
| [KittyDelivery_mc_menu](https://github.com/kitty-delivery/KittyDelivery_mc_menu) | Gestion des menus | Depot vide |
| [KittyDelivery_mc_order](https://github.com/kitty-delivery/KittyDelivery_mc_order) | Commandes (nomme "Commercial" en interne) | Squelette Express |

## Demarrage

### Prerequis

- Git
- Docker et Docker Compose
- Node.js (pour un lancement sans Docker)

### Cloner avec les sous-modules

```bash
git clone --recurse-submodules https://github.com/kitty-delivery/kittydelivery-core.git
cd kittydelivery-core
```

Si le depot a deja ete clone sans l'option `--recurse-submodules` :

```bash
git submodule update --init --recursive
```

### Lancer avec Docker Compose

```bash
docker compose up --build
```

Chaque squelette Express ecoute par defaut sur le port 3000 a l'interieur de son conteneur ; ils sont exposes sur des ports hote distincts (voir `docker-compose.yml`) pour pouvoir tourner simultanement, via un Dockerfile generique partage (`docker/node-express.Dockerfile`) puisqu'aucun d'eux n'en a un propre. `KittyDelivery_mc_log` et `KittyDelivery_mc_menu` etant des depots vides, et `KittyDelivery_mc_restaurant` n'ayant pas de point d'entree fonctionnel, ces trois services sont laisses commentes dans le `docker-compose.yml` en attendant du code applicatif.

## Contact

Brieuc Dumortier, [LinkedIn](https://www.linkedin.com/in/dumortier-brieuc/), [GitHub](https://github.com/BaditSad), dumortier.contact@gmail.com
