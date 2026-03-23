---
name: fastify-api
description: Fastify API endpoint olusturma pattern'leri. Route, controller, service, schema. API endpoint yazarken kullan.
---

## Module Olusturma Sirasi
1. Drizzle schema (src/db/schema.ts'e ekle)
2. Migration (npx drizzle-kit generate)
3. Zod schema (src/modules/[name]/[name].schema.ts)
4. Service (src/modules/[name]/[name].service.ts)
5. Controller (src/modules/[name]/[name].controller.ts)
6. Routes (src/modules/[name]/[name].routes.ts)
7. Test (src/modules/[name]/__tests__/)

## Route + Controller
```typescript
// routes.ts
export async function postRoutes(fastify: FastifyInstance) {
  fastify.post('/', { schema: createPostSchema }, createPostHandler);
  fastify.get('/:id', { schema: getPostSchema }, getPostHandler);
}

// controller.ts
export async function createPostHandler(request: FastifyRequest<{Body: CreatePostInput}>, reply: FastifyReply) {
  const post = await postService.create(request.body);
  return reply.status(201).send({ data: post });
}
```

## Service
```typescript
export class PostService {
  async create(input: CreatePostInput): Promise<Post> {
    const [post] = await db.insert(posts).values(input).returning();
    return post;
  }
}
```

## Zod Schema
```typescript
export const createPostSchema = {
  body: z.object({ title: z.string().min(1).max(255), body: z.string() }),
  response: { 201: z.object({ data: postSchema }) },
};
export type CreatePostInput = z.infer<typeof createPostSchema.body>;
```
