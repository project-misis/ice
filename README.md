# Docs

[![Tests](https://github.com/project-misis/ice/actions/workflows/tests.yml/badge.svg)](https://github.com/project-misis/ice/actions/workflows/tests.yml)
[![Coverage](https://img.shields.io/badge/coverage-artifact-blue)](https://github.com/project-misis/ice/actions/workflows/tests.yml)

## Endpoints

### Users

#### List Users
**Method:** GET  
**Path:** `/users`  
**Description:** Returns an array of all users.
**Response:**
- 200 OK: Array of [User](#user) objects

#### Get User by ID
**Method:** GET  
**Path:** `/users/{id}`  
**Description:** Returns details for a user by ID.
**Response:**
- 200 OK: [User](#user) object
- 404 Not Found

#### Create User
**Method:** POST  
**Path:** `/users`  
**Description:** Creates a new user with provided data.
**Request Body:**
```json
{
  "first_name": "string",
  "last_name": "string",
  "email": "string",
  "telegram": "string",
  "role": "mentor | normie",
  "pfp": "string",
  "password": "string"
}
```
Required: All fields except `role` (default: normie)
**Response:**
- 200 OK: Created [User](#user)
- 400 Bad Request

#### Update User
**Method:** PUT  
**Path:** `/users/{id}`  
**Description:** Update existing user’s information by ID.
**Request Body:** (any subset of user fields)
**Response:**
- 200 OK: Updated [User](#user)
- 404 Not Found

#### Delete User
**Method:** DELETE  
**Path:** `/users/{id}`  
**Description:** Remove a user by ID.
**Response:**
- 204 No Content
- 404 Not Found

---

### Books

#### List Books
**Method:** GET  
**Path:** `/books`  
**Description:** Returns an array of all books.
**Response:**
- 200 OK: Array of [Book](#book) objects

#### Get Book by ID
**Method:** GET  
**Path:** `/books/{id}`  
**Description:** Returns details for a book by ID.
**Response:**
- 200 OK: [Book](#book) object
- 404 Not Found

#### Create Book
**Method:** POST  
**Path:** `/books`  
**Description:** Creates a new book with provided data.
**Request Body:**
```json
{
  "name": "string",
  "author": "string",
  "language": "string",
  "link": "string"
}
```
Required: All fields
**Response:**
- 200 OK: Created [Book](#book)
- 400 Bad Request

#### Update Book
**Method:** PUT  
**Path:** `/books/{id}`  
**Description:** Updates a book’s information by ID.
**Request Body:** (any subset of book fields)
**Response:**
- 200 OK: Updated [Book](#book)
- 404 Not Found

#### Delete Book
**Method:** DELETE  
**Path:** `/books/{id}`  
**Description:** Remove a book by ID.
**Response:**
- 204 No Content
- 404 Not Found

---

### Events

#### List Events
**Method:** GET  
**Path:** `/events`  
**Description:** Returns an array of all events.
**Response:**
- 200 OK: Array of [Event](#event) objects

#### Get Event by ID
**Method:** GET  
**Path:** `/events/{id}`  
**Description:** Returns details for an event by ID.
**Response:**
- 200 OK: [Event](#event) object
- 404 Not Found

#### Create Event
**Method:** POST  
**Path:** `/events`  
**Description:** Creates a new event with provided data.
**Request Body:**
```json
{
  "name": "string",
  "where": "string",
  "link": "string",
  "desc": "string",
  "start": "string",
  "end": "string"
}
```
Required: All fields
**Response:**
- 200 OK: Created [Event](#event)
- 400 Bad Request

#### Update Event
**Method:** PUT  
**Path:** `/events/{id}`  
**Description:** Updates an event’s information by ID.
**Request Body:** (any subset of event fields)
**Response:**
- 200 OK: Updated [Event](#event)
- 404 Not Found

#### Delete Event
**Method:** DELETE  
**Path:** `/events/{id}`  
**Description:** Remove an event by ID.
**Response:**
- 204 No Content
- 404 Not Found

---

## Entities

### User
```json
{
  "id": "string (UUID)",
  "first_name": "string",
  "last_name": "string",
  "email": "string (unique)",
  "telegram": "string",
  "role": "mentor | normie", // default: normie
  "pfp": "string (profile picture URL)",
  "password": "string (write-only)"
}
```
- All fields are required except role (defaults to normie)
- `password` is required on creation and never returned in responses
- `id` is UUID, auto-generated

### Book
```json
{
  "id": "string (UUID)",
  "name": "string",
  "author": "string",
  "language": "string",
  "link": "string (URL)"
}
```
- All fields required
- `id` is UUID, auto-generated

### Event
```json
{
  "id": "string (UUID)",
  "name": "string",
  "where": "string",
  "link": "string (URL)",
  "desc": "string",
  "start": "string (date/time)",
  "end": "string (date/time)"
}
```
- All fields required
- `id` is UUID, auto-generated

