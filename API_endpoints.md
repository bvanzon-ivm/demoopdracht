

# API Endpoints

## Overzicht
Deze applicatie is een projectmanagement tool waarmee gebruikers workspaces en taken kunnen beheren, samenwerken en bestanden delen. De backend biedt een REST API voor authenticatie, workspace- en taakbeheer.

## Authentication
- `POST /api/auth/login` — Login met e-mail en wachtwoord. Retourneert een JWT token en gebruikersinfo.
- `POST /api/auth/register` — Registreer een nieuwe gebruiker. Retourneert een JWT token en gebruikersinfo.

## Workspaces
- `GET /api/workspaces` — Haal alle workspaces op waar de gebruiker lid of eigenaar van is.
- `POST /api/workspaces` — Maak een nieuwe workspace aan. De ingelogde gebruiker wordt eigenaar.
- `GET /api/workspaces/{id}` — Haal details van een specifieke workspace op.
- `POST /api/workspaces/{id}/members` — Voeg een gebruiker toe aan een workspace op basis van e-mail.
- `DELETE /api/workspaces/{id}/members/{userId}` — Verwijder een gebruiker uit een workspace.

## Tasks (per workspace)
- `GET /api/workspaces/{workspaceId}/tasks` — Haal alle taken op binnen een workspace.
- `POST /api/workspaces/{workspaceId}/tasks` — Maak een nieuwe taak aan in een workspace.
- `GET /api/workspaces/{workspaceId}/tasks/{id}` — Haal details van een taak op.
- `PATCH /api/workspaces/{workspaceId}/tasks/{id}` — Update velden van een taak (deels).
- `DELETE /api/workspaces/{workspaceId}/tasks/{id}` — Verwijder een taak (soft delete).
- `GET /api/workspaces/{workspaceId}/tasks/{id}/audit` — Haal auditlog op van wijzigingen aan een taak.
- `POST /api/workspaces/{workspaceId}/tasks/{id}/rollback` — Zet een veld van een taak terug naar een vorige versie.

## Task Attachments
- `POST /api/workspaces/{workspaceId}/tasks/{id}/attachments` — Upload een bestand als attachment bij een taak (multipart/form-data).
- `GET /api/workspaces/{workspaceId}/tasks/{id}/attachments` — Haal alle attachments van een taak op.
- `GET /api/workspaces/{workspaceId}/tasks/{id}/attachments/{attachmentId}` — Download een attachment.


## LET OP niet alle end points zijn momenteel in de frontend aanwezig dit is het schema wat totaal de applicatie zou moeten gaan doen

## Voorbeeld Request
```http
POST /api/auth/login
Content-Type: application/json
{
  "email": "user@example.com",
  "password": "yourpassword"
}
```

## Voorbeeld Response
```json
{
  "token": "jwt-token",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "name": "User Name"
  }
}
```
