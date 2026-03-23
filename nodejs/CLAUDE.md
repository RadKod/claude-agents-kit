# Node.js Backend Projesi

## Tech Stack
- Runtime: Node.js 22 LTS
- Framework: Fastify v5
- Language: TypeScript strict (ESM)
- ORM: Drizzle ORM
- Database: PostgreSQL
- Auth: Better Auth v1.5+
- Validation: Zod
- Testing: Vitest + Supertest
- API docs: @fastify/swagger

## Komutlar
- `npm run dev` - Dev server (tsx watch)
- `npm run build` - TypeScript compile
- `npm run test` - Vitest
- `npm run test:coverage` - Coverage
- `npx drizzle-kit generate` - Migration olustur
- `npx drizzle-kit migrate` - Migration calistir
- `npx drizzle-kit studio` - DB GUI

## Mimari Kurallar
- Controller: sadece HTTP (request parse, response format)
- Service: business logic
- Repository (opsiyonel): complex query'ler icin
- Validation: Zod schema, controller girisinde
- Error handling: merkezi error handler, custom AppError class
- Config: environment variable'lar Zod ile validate edilmeli
- Logging: Pino (Fastify built-in)
- ESM: "type": "module" package.json'da

## Dosya Yapisi
```
src/
  modules/
    auth/
      auth.controller.ts
      auth.service.ts
      auth.schema.ts    # Zod schemas
      auth.routes.ts
    users/
    posts/
  common/
    config/             # Validated env config
    errors/             # Custom error classes
    middleware/          # Auth, rate-limit, cors
    plugins/            # Fastify plugins
    utils/              # Helpers
  db/
    schema.ts           # Drizzle schema
    migrations/         # SQL migrations
    index.ts            # DB connection
  app.ts                # Fastify instance
  server.ts             # Entry point
```

## Kodlama Standartlari
- TypeScript strict, noUncheckedIndexedAccess
- Async/await, callback YASAK
- Interface: service/repository contract icin
- Type: Zod infer ile request/response tipleri
- Error: throw new AppError('msg', statusCode)
- Response: { data, meta? } envelope pattern
