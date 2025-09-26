

# Installation Guide

## Overzicht
Anchiano is een projectmanagement applicatie waarmee je workspaces en taken kunt beheren, samenwerken en bestanden delen. De backend draait als Spring Boot applicatie en is ook te starten via Docker. De frontend is gebouwd met Flutter.

Zie [API_endpoints.md](API_endpoints.md) voor uitleg over alle beschikbare API endpoints.

## Backend draaien in Docker
1. Zorg dat Docker geïnstalleerd is
2. Ga naar de `backend` folder
3. Start de containers met:
   ```shell
   docker compose up --build
   ```
4. De backend is nu bereikbaar op poort 8080

## Frontend
1. Installeer Flutter SDK
2. Ga naar de `frontend` folder
3. Run `flutter pub get`
4. Run `flutter run`

