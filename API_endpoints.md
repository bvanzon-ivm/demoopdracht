# Anchiano API

**Basis-URL:** `/`  
**Authenticatie:** JWT Bearer token via header  
```
Authorization: Bearer <token>
```

## Inhoudsopgave
- [Authenticatie](#authenticatie)
- [Workspaces](#workspaces)
  - [Leden](#leden)
  - [Audit](#audit)
- [Tasks](#tasks)
  - [Attachments](#attachments)
  - [Comments](#comments)
- [Voorbeelden](#voorbeelden)
  - [Login](#login)
  - [Beveiligde request](#beveiligde-request)
- [DTO-overzicht](#dto-overzicht)
- [Foutafhandeling](#foutafhandeling)

---

## Authenticatie

### POST `/api/auth/login`
Login met e-mail en wachtwoord. Retourneert JWT + gebruiker.

**Request body**
```json
{
  "email": "user@example.com",
  "password": "yourpassword"
}
```

**Response 200**
```json
{
  "token": "jwt-token",
  "user": {
    "id": 1,
    "name": "User Name",
    "email": "user@example.com",
    "createdAt": "2025-09-26T20:15:30",
    "lastLoginAt": "2025-09-27T01:05:22"
  }
}
```

### POST `/api/auth/register`
Registreer nieuwe gebruiker. Retourneert JWT + gebruiker.

**Request body**
```json
{
  "name": "User Name",
  "email": "user@example.com",
  "password": "yourpassword"
}
```

**Response 200**
```json
{
  "token": "jwt-token",
  "user": {
    "id": 1,
    "name": "User Name",
    "email": "user@example.com",
    "createdAt": "2025-09-26T20:15:30",
    "lastLoginAt": null
  }
}
```

---

## Workspaces

### GET `/api/workspaces`
Haal alle workspaces op van de ingelogde gebruiker (eigenaar of lid).

**Response 200**
```json
[
  {
    "id": 10,
    "name": "Project Alpha",
    "description": "Planning en taken",
    "owner": { "id": 1, "name": "Owner", "email": "owner@ex.com" },
    "createdAt": "2025-09-20T09:00:00",
    "updatedAt": "2025-09-22T12:00:00",
    "deletedAt": null
  }
]
```

### POST `/api/workspaces`
Maak een nieuwe workspace aan. De ingelogde gebruiker wordt eigenaar.

**Request body**
```json
{
  "name": "Nieuw Project",
  "description": "Beschrijving"
}
```

**Response 200**
```json
{
  "id": 11,
  "name": "Nieuw Project",
  "description": "Beschrijving",
  "owner": { "id": 1, "name": "Owner", "email": "owner@ex.com" },
  "createdAt": "2025-09-27T09:00:00",
  "updatedAt": "2025-09-27T09:00:00",
  "deletedAt": null
}
```

### GET `/api/workspaces/{id}`
Haal één workspace op.

### PUT `/api/workspaces/{id}`
Update naam/beschrijving van een workspace.

**Request body**
```json
{
  "name": "Nieuwe naam",
  "description": "Bijgewerkte beschrijving"
}
```

### DELETE `/api/workspaces/{id}`
Verwijder een workspace (soft delete).

### Leden

#### GET `/api/workspaces/{id}/members`
Ledenlijst van een workspace.

**Response 200**
```json
[
  { "id": 100, "workspaceId": 10, "user": { "id": 2, "name": "Alice", "email": "alice@ex.com" }, "role": "MEMBER", "createdAt": "2025-09-21T10:00:00" }
]
```

#### POST `/api/workspaces/{id}/members`
Voeg een gebruiker toe (bijv. via `user.id`).

**Request body**
```json
{
  "user": { "id": 2 },
  "role": "MEMBER"
}
```

**Response 200**
```json
{ "id": 101, "workspaceId": 10, "user": { "id": 2, "name": "Alice", "email": "alice@ex.com" }, "role": "MEMBER", "createdAt": "2025-09-27T10:00:00" }
```

#### DELETE `/api/workspaces/{id}/members/{memberId}`
Verwijder lidmaatschap.

### Audit

#### GET `/api/workspaces/{id}/audits`
Auditlog records voor workspace.

**Response 200**
```json
[
  {
    "id": 800,
    "workspaceId": 10,
    "userId": 1,
    "userName": "Owner",
    "userEmail": "owner@ex.com",
    "action": "TASK_UPDATED",
    "timestamp": "2025-09-26T12:34:56",
    "oldValue": "{\"title\":\"Oud\"}",
    "newValue": "{\"title\":\"Nieuw\"}"
  }
]
```

---

## Tasks

### GET `/api/workspaces/{workspaceId}/tasks`
Lijst taken in workspace.

**Response 200**
```json
[
  {
    "id": 501,
    "workspaceId": 10,
    "title": "Spec uitwerken",
    "description": "Detailplanning",
    "status": "TODO",
    "priority": "MEDIUM",
    "dueDate": "2025-10-01T17:00:00",
    "labels": [{ "id": 1, "workspaceId": 10, "name": "Backend", "color": "#0088FF", "active": true }],
    "assignees": [{ "id": 2, "name": "Alice", "email": "alice@ex.com" }],
    "createdBy": { "id": 1, "name": "Owner", "email": "owner@ex.com" },
    "createdAt": "2025-09-21T11:00:00",
    "updatedAt": "2025-09-22T12:00:00",
    "deletedAt": null
  }
]
```

### POST `/api/workspaces/{workspaceId}/tasks`
Maak taak aan.

**Request body**
```json
{
  "title": "Nieuwe taak",
  "description": "Omschrijving",
  "status": "TODO",
  "priority": "MEDIUM",
  "dueDate": "2025-10-01T17:00:00"
}
```

### GET `/api/workspaces/{workspaceId}/tasks/{taskId}`
Haal één taak op.

### PUT `/api/workspaces/{workspaceId}/tasks/{taskId}`
Update taak (volledige of gedeeltelijke velden).

**Request body**
```json
{
  "title": "Bijgewerkt",
  "description": "Nieuwe omschrijving",
  "status": "IN_PROGRESS",
  "priority": "HIGH",
  "dueDate": "2025-10-05T12:00:00"
}
```

### DELETE `/api/workspaces/{workspaceId}/tasks/{taskId}`
Soft delete.

---

## Labels

### GET `/api/workspaces/{workspaceId}/labels`
Alle actieve labels in workspace.

### POST `/api/workspaces/{workspaceId}/labels`
Maak label aan.

**Request body**
```json
{
  "name": "Backend",
  "color": "#0088FF",
  "description": "Server-side werk",
  "active": true
}
```

### DELETE `/api/workspaces/{workspaceId}/labels/{labelId}`
Verwijder label.

---

## Attachments

### GET `/api/workspaces/{workspaceId}/tasks/{taskId}/attachments`
Lijst attachments.

**Response 200**
```json
[
  {
    "id": 900,
    "taskId": 501,
    "filename": "ontwerp.pdf",
    "contentType": "application/pdf",
    "size": 123456,
    "path": "/var/data/att/ontwerp.pdf",
    "uploadedAt": "2025-09-23T09:30:00"
  }
]
```

### POST `/api/workspaces/{workspaceId}/tasks/{taskId}/attachments`
Upload bestand (multipart).

**Form-data**
- `file`: (binary)

**Response 200**
```json
{
  "id": 901,
  "taskId": 501,
  "filename": "nieuw.png",
  "contentType": "image/png",
  "size": 45678,
  "path": "/var/data/att/nieuw.png",
  "uploadedAt": "2025-09-27T12:00:00"
}
```

### DELETE `/api/workspaces/{workspaceId}/tasks/{taskId}/attachments/{attachmentId}`
Verwijder attachment.

---

## Comments

### GET `/api/workspaces/{workspaceId}/tasks/{taskId}/comments`
Lijst comments.

**Response 200**
```json
[
  {
    "id": 700,
    "taskId": 501,
    "authorId": 2,
    "parentCommentId": null,
    "body": "Laten we dit opsplitsen.",
    "createdAt": "2025-09-22T08:00:00",
    "editedAt": "2025-09-22T09:00:00",
    "editedById": 2
  }
]
```

### POST `/api/workspaces/{workspaceId}/tasks/{taskId}/comments`
Nieuwe comment.

**Request body**
```json
{
  "body": "Nieuw comment",
  "parentCommentId": null
}
```

### PUT `/api/workspaces/{workspaceId}/tasks/{taskId}/comments/{commentId}`
Bewerk comment.

**Request body**
```json
{
  "body": "Bijgewerkt comment"
}
```

### DELETE `/api/workspaces/{workspaceId}/tasks/{taskId}/comments/{commentId}`
Verwijder comment.

---

## Voorbeelden

### Login
```bash
curl -X POST http://localhost:8080/api/auth/login   -H "Content-Type: application/json"   -d '{"email":"user@example.com","password":"yourpassword"}'
```

### Beveiligde request
```bash
curl http://localhost:8080/api/workspaces   -H "Authorization: Bearer <jwt-token>"
```

---

## DTO-overzicht

### UserDto
```json
{ "id": 1, "name": "User Name", "email": "user@example.com", "createdAt": "...", "lastLoginAt": "..." }
```

### WorkspaceDto
```json
{ "id": 10, "name": "Project", "description": "Desc", "owner": { "id": 1, "name": "Owner", "email": "owner@ex.com" }, "createdAt": "...", "updatedAt": "...", "deletedAt": null }
```

### TaskDto
```json
{
  "id": 501,
  "workspaceId": 10,
  "title": "Titel",
  "description": "Omschrijving",
  "status": "TODO|IN_PROGRESS|DONE",
  "priority": "LOW|MEDIUM|HIGH",
  "dueDate": "2025-10-01T17:00:00",
  "labels": [ { "id": 1, "workspaceId": 10, "name": "Backend", "color": "#0088FF", "active": true } ],
  "assignees": [ { "id": 2, "name": "Alice", "email": "alice@ex.com" } ],
  "createdBy": { "id": 1, "name": "Owner", "email": "owner@ex.com" },
  "createdAt": "...",
  "updatedAt": "...",
  "deletedAt": null
}
```

### LabelDto
```json
{ "id": 1, "workspaceId": 10, "name": "Backend", "color": "#0088FF", "description": "Server-side", "active": true, "createdAt": "...", "updatedAt": "..." }
```

### MembershipDto
```json
{ "id": 100, "workspaceId": 10, "user": { "id": 2, "name": "Alice", "email": "alice@ex.com" }, "role": "OWNER|ADMIN|MEMBER", "createdAt": "..." }
```

### AttachmentDto
```json
{ "id": 900, "taskId": 501, "filename": "doc.pdf", "contentType": "application/pdf", "size": 12345, "path": "/var/data/att/doc.pdf", "uploadedAt": "..." }
```

### CommentDto
```json
{ "id": 700, "taskId": 501, "authorId": 2, "parentCommentId": null, "body": "Tekst", "createdAt": "...", "editedAt": "...", "editedById": 2 }
```

---

## Foutafhandeling

### Validatiefout (400)
```json
{
  "status": 400,
  "error": "Bad Request",
  "fieldErrors": {
    "email": "must be a well-formed email address",
    "password": "must not be blank"
  }
}
```

### Unauthorized (401)
```json
{
  "status": 401,
  "error": "Unauthorized",
  "message": "Full authentication is required to access this resource",
  "path": "/api/workspaces"
}
```

### Not Found (404)
```json
{
  "status": 404,
  "error": "Not Found",
  "message": "Resource not found"
}
```
