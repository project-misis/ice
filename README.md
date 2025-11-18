# Ice

## Endpoints

### Список эндпоинтов

— **GET /users**  
  Возвращает список пользователей. [Сущность: User](#user)

— **GET /users/:id**  
  Возвращает пользователя по его id. [Сущность: User](#user)

— **POST /users**  
  Создаёт нового пользователя. В теле запроса нужно передать данные пользователя. [Сущность: User](#user)

— **PUT /users/:id**  
  Обновляет данные пользователя по id. В теле запроса передаются изменяемые данные. [Сущность: User](#user)

— **DELETE /users/:id**  
  Удаляет пользователя по id. [Сущность: User](#user)

— **GET /books**  
  Возвращает список всех книг. [Сущность: Book](#book)

— **GET /books/:id**  
  Возвращает книгу по её id. [Сущность: Book](#book)

— **POST /books**  
  Создаёт новую книгу. В теле запроса нужны данные книги. [Сущность: Book](#book)

— **PUT /books/:id**  
  Обновляет книгу по id. В теле запроса — изменяемые данные. [Сущность: Book](#book)

— **DELETE /books/:id**  
  Удаляет книгу по id. [Сущность: Book](#book)

— **GET /events**  
  Возвращает список событий. [Сущность: Event](#event)

— **GET /events/:id**  
  Возвращает событие по его id. [Сущность: Event](#event)

— **POST /events**  
  Создаёт новое событие. В теле запроса необходимы поля события. [Сущность: Event](#event)

— **PUT /events/:id**  
  Обновляет событие по id. В теле запроса — изменяемые данные. [Сущность: Event](#event)

— **DELETE /events/:id**  
  Удаляет событие по id. [Сущность: Event](#event)


## Entities

### User

Schema:
```json
{
  "id": "string (UUID)",
  "first_name": "string",
  "last_name": "string",
  "email": "string",
  "telegram": "string",
  "role": "string (enum: mentor, normie)",
  "pfp": "string",
  "password": "string (not exposed)"
}
```
#### Required fields
- first_name
- last_name
- email
- telegram
- role (`mentor` or `normie`, default: `normie`)
- pfp
- password (only writable; not returned in responses)

#### Notes
- `id` is auto-generated
- Email must be unique

---

### Book

Schema:
```json
{
  "id": "string (UUID)",
  "name": "string",
  "author": "string",
  "language": "string",
  "link": "string"
}
```
#### Required fields
- name
- author
- language
- link

---

### Event

Schema:
```json
{
  "id": "string (UUID)",
  "name": "string",
  "where": "string",
  "link": "string",
  "desc": "string",
  "start": "string",
  "end": "string"
}
```
#### Required fields
- name
- where
- link
- desc
- start
- end

