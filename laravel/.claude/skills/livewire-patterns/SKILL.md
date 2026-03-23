---
name: livewire-patterns
description: Livewire component pattern'leri. Form, tablo, modal, arama. Livewire component yazarken kullan.
---

## Form Component
```php
class EditProfile extends Component
{
    #[Validate('required|string|max:255')]
    public string $name = '';

    #[Validate('required|email')]
    public string $email = '';

    public function mount(): void
    {
        $this->name = auth()->user()->name;
        $this->email = auth()->user()->email;
    }

    public function save(): void
    {
        $validated = $this->validate();
        auth()->user()->update($validated);
        $this->dispatch('profile-updated');
    }

    public function render(): View
    {
        return view('livewire.edit-profile');
    }
}
```

## Arama + Debounce
```html
<input wire:model.live.debounce.300ms="search" placeholder="Ara..." />
```

## Lazy Loading
```php
#[Lazy]
class HeavyTable extends Component { ... }
```

```html
<livewire:heavy-table lazy />
```
