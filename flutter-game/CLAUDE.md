# Flutter Oyun Projesi (Flame Engine)

## Tech Stack
- Framework: Flutter 3.41+, Dart 3.11+
- Game Engine: Flame 1.x (Flame Component System)
- Physics: Forge2D (flame_forge2d) - Box2D port
- Audio: flame_audio (AudioPlayers uzerine)
- Rendering: Impeller (Flutter varsayilan GPU renderer)
- State (oyun disi): Riverpod 2.5+ (menu, ayarlar, skor)
- Storage: SharedPreferences (ayarlar), Hive (save game, leaderboard)
- Sprite Tools: flame_texturepacker, flame_fire_atlas
- Animasyon: flame_rive (Rive), SpriteAnimation (sprite sheet)
- Tiled Maps: flame_tiled (level tasarimi icin)
- Particles: Flame built-in ParticleSystemComponent
- Linting: flame_lint

## Mimari Kurallar
- FlameGame extends ederek ana oyun sinifi olustur
- Flame Component System (FCS) kullan: her sey Component
- World + CameraComponent yapisi (Flame 1.x standard)
- Component lifecycle: onLoad -> onMount -> update -> render -> onRemove
- Game logic update() icinde, UI render() icinde
- Oyun state'i Component icerisinde, Flutter state (menu/skor) Riverpod'da
- Offline-first: backend yok, tum veri lokalde
- Asset'ler assets/ altinda, Flame otomatik yukler
- Sprite sheet: TexturePacker ile olustur, flame_texturepacker ile yukle
- Level design: Tiled Map Editor ile, flame_tiled ile yukle

## Komutlar
- `flutter run` - Debug
- `flutter run --profile` - Profiling (gercek cihazda)
- `flutter test` - Test
- `dart run build_runner build --delete-conflicting-outputs` - Code gen
- `flutter build apk --release` - Android
- `flutter build ios --release` - iOS

## Dosya Yapisi
```
lib/
  main.dart                  # Entry point, GameWidget + ProviderScope
  app/
    router.dart              # GoRouter (menu navigasyonu)
    theme.dart               # ThemeData
  game/
    my_game.dart             # FlameGame extends (ana oyun sinifi)
    components/
      player.dart            # Player component
      enemies/               # Dusman tipleri
      projectiles/           # Mermi/obje
      pickups/               # Toplanabilir objeler
      environment/           # Platform, duvar, zemin
      hud/                   # HudComponent (skor, can, overlay)
      effects/               # Particle, patlama, animasyon efekt
    systems/                 # Oyun sistemleri (spawner, wave, score)
    levels/                  # Level tanimlari / Tiled haritalar
    utils/                   # Oyun helper'lari (collision, math)
    config/                  # Oyun sabitleri, difficulty settings
  screens/                   # Flutter ekranlari (menu, pause, gameover)
  stores/                    # Riverpod (game settings, high score, save)
  models/                    # Freezed model (SaveData, GameConfig)
assets/
  images/                    # Sprite sheet, texture atlas
  audio/                     # SFX + BGM
  tiles/                     # Tiled map dosyalari (.tmx)
```

## Kodlama Standartlari
- snake_case dosya, UpperCamelCase class
- Her Component kendi dosyasinda
- Component boyutu: max 200 satir, parcala
- update(dt) icinde allocation yapma (GC baskisi)
- Vector2 recycle et, her frame new Vector2 YASAK
- onLoad() async asset yukleme, constructor'da degil
- HasGameRef mixin ile game referansi al
- CollisionCallbacks mixin ile collision handle et
- priority ile render sirasi yonet (z-index)
- debugMode = true ile hitbox goruntule (dev)
