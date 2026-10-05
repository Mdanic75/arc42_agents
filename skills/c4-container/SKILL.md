---
name: c4-container
description: >
  Subtopic skill for the C4 page, Level 2 Containers. Says what the level contains and how it
  looks: the separately runnable or deployable units inside the system — apps, services, jobs,
  databases, queues, file stores — each with technology and responsibility, one Mermaid
  `C4Container` block and one table whose technology cells link the ADR that chose them.
  Invoked by section-worker when the C4 interview reaches Level 2.
---

# Level 2 — Containers — content and shape

Answer one question: **what runs, separately, inside the system?** A container is a unit that
runs or is deployed on its own: a web application, a single-page app, a mobile app, an API
service, a worker, a scheduled job, a database, a blob store, a message broker, a serverless
function. Not necessarily a Docker container. Every container has a technology, and every
technology the team chose has a record.

## How to ask

- Open with the hypothesis from the manifests: "I see four things that run: … Which are real,
  which are missing?"
- "What else runs?" — jobs, workers and brokers hide behind the obvious apps.
- "Which of these stores data?" — every store is its own container.
- "What would you deploy separately?" — the merge test: two things always deployed together with
  no network between them are one container.
- For every technology cell: **chosen or imposed?** The topic skill says what happens next; the
  level's decisions are recorded before the block is drawn.
- Four to ten containers is typical. More: ask whether some are one container, or belong to
  Level 3 of another.

## Shape

1. **One caption sentence.**
2. **One `C4Container` block**: the persons and external systems from Level 1 with the **same
   aliases and labels**; one `Container_Boundary` with the system's alias and label holding
   every container; `Rel` lines with a technology on each.
3. **One table**:

| Container | Technology | Responsibility | Decided in |
|---|---|---|---|
| Order board | React, TypeScript | Lets dispatchers see and assign the daily orders | [ADR-0002](adr/0002-use-react-for-the-order-board.md) |
| Dispatch API | Java 21, Spring Boot | Owns orders, assignments and the stop list | — |
| Order store | PostgreSQL 16 | Keeps orders, assignments and drivers | [ADR-0001](adr/0001-use-postgresql-for-the-order-store.md) |
| Shop importer | Python job, hourly | Pulls new orders from the web shop | not recorded |

`Decided in` is the ADR link the `adr` skill handed back, `—` when the technology was imposed
(see 2 Constraints), or `not recorded` when the user declined. Never a title with no file
behind it.

## Example

What runs inside the dispatch board:

```mermaid
C4Container
  title Containers - Dispatch board
  Person(dispatcher, "Dispatcher", "Plans the daily deliveries")
  Person(driver, "Driver", "Delivers the orders")
  System_Ext(shop, "Web shop", "Takes customer orders")
  System_Ext(sms, "SMS gateway", "Sends text messages")
  Container_Boundary(board, "Dispatch board") {
    Container(web, "Order board", "React, TypeScript", "Lets dispatchers see and assign the daily orders")
    Container(api, "Dispatch API", "Java 21, Spring Boot", "Owns orders, assignments and the stop list")
    ContainerDb(db, "Order store", "PostgreSQL 16", "Keeps orders, assignments and drivers")
    Container(importer, "Shop importer", "Python job, hourly", "Pulls new orders from the web shop")
  }
  Rel(dispatcher, web, "Uses", "HTTPS")
  Rel(driver, api, "Reads the stops of the day", "HTTPS, JSON")
  Rel(web, api, "Calls", "HTTPS, JSON")
  Rel(api, db, "Reads and writes", "JDBC")
  Rel(importer, shop, "Pulls new orders", "HTTPS, REST")
  Rel(importer, db, "Inserts orders", "JDBC")
  Rel(api, sms, "Sends stop notifications", "HTTPS")
  UpdateLayoutConfig($c4ShapeInRow="3", $c4BoundaryInRow="1")
```

## Syntax rules (no renderer here)

- `C4Container` first, optional `title` second. Level 1 elements, then the boundary, then
  relationships, then the layout line.
- `Container(alias, "Label", "Technology", "Description")`, `ContainerDb`, `ContainerQueue`;
  `_Ext` variants only for a container someone else runs.
- `Container_Boundary(alias, "Label") {` on one line, `}` alone on its line.
- `Rel(from, to, "Verb phrase", "Technology")` — four arguments at this level.
- `UpdateLayoutConfig($c4ShapeInRow="3", $c4BoundaryInRow="1")` last when the block has more than
  about six shapes.
- The full rule list is in the topic skill; unsure, `WebFetch` https://mermaid.js.org/syntax/c4.html.

Not here: the modules inside a service (Level 3); machines, clusters, regions, environments (7);
the sequence of calls in a scenario (6); why a technology was chosen (its ADR).
