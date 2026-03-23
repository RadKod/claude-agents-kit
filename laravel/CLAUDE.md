# Laravel Full-Stack Projesi

## Tech Stack
- Framework: Laravel 12.x, PHP 8.3+
- Frontend: Livewire 3/4 + Alpine.js + Blade
- Styling: Tailwind CSS 4.x
- Database: PostgreSQL (veya MySQL)
- Cache/Queue: Redis
- Auth: Laravel Sanctum
- Testing: Pest v4
- Admin: Filament (opsiyonel)

## Komutlar
- `php artisan serve` - Dev server
- `php artisan test --parallel` - Testler
- `php artisan migrate` - Migration
- `php artisan make:model Xxx -mfcr` - Model + migration + factory + controller + resource
- `npm run dev` - Vite dev server (Tailwind)
- `php artisan queue:work` - Queue worker
- `./vendor/bin/pint` - Code style fix (PSR-12)

## Mimari Kurallar
- Validation: DAIMA Form Request, controller'da validate() YASAK
- Authorization: Policy kullan, controller'da manual check YASAK
- Business logic: Action class'larda (app/Actions/)
- Query: Eloquent scope kullan, raw SQL YASAK
- Relationship: DAIMA eager load (with()), N+1 yasak
- Response: API icin Resource class, Blade icin compact()
- Queue: Agir isler ShouldQueue implement etmeli
- Event/Listener: Domain event'leri loose coupling icin

## Dosya Yapisi (Laravel 12 slim)
```
app/
  Actions/              # Business logic (tek sorumluluk)
  Http/
    Controllers/        # Thin controller, sadece HTTP
    Requests/           # Form Request validation
    Resources/          # API response transformation
    Middleware/          # Custom middleware
  Models/               # Eloquent models
  Policies/             # Authorization
  Services/             # External service wrappers
  Livewire/             # Livewire components
resources/
  views/
    components/         # Blade components
    livewire/           # Livewire views
    layouts/            # Layout templates
tests/
  Feature/              # HTTP/integration tests
  Unit/                 # Pure logic tests
```

## Kodlama Standartlari
- PSR-12 (Laravel Pint)
- Strict types: declare(strict_types=1) her dosyada
- Return types zorunlu
- PHPDoc sadece karmasik tipler icin (array shapes vs)
- Livewire: wire:model.blur (lazy), wire:model.live sadece arama icin
- Alpine.js: frontend-only logic (toggle, dropdown)
