---
name: laravel-api
description: Laravel API endpoint olusturma pattern'leri. Controller, FormRequest, Resource, Route, Test. API endpoint yazarken kullan.
---

## Endpoint Olusturma Sirasi
1. Migration + Model (php artisan make:model Post -m)
2. Factory (php artisan make:factory PostFactory)
3. FormRequest (php artisan make:request StorePostRequest)
4. Resource (php artisan make:resource PostResource)
5. Controller (php artisan make:controller Api/PostController --api)
6. Policy (php artisan make:policy PostPolicy --model=Post)
7. Route (routes/api.php)
8. Feature Test

## Controller Template
```php
class PostController extends Controller
{
    public function store(StorePostRequest $request): PostResource
    {
        $post = (new CreatePostAction)->execute($request->validated());
        return new PostResource($post);
    }
}
```

## FormRequest Template
```php
class StorePostRequest extends FormRequest
{
    public function authorize(): bool { return $this->user()->can('create', Post::class); }
    public function rules(): array { return ['title' => ['required', 'string', 'max:255'], 'body' => ['required', 'string']]; }
}
```
