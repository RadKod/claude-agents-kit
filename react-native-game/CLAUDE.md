# React Native Oyun Projesi

## Tech Stack
- Framework: Expo SDK 55+, React Native 0.83+, TypeScript strict
- Rendering: @shopify/react-native-skia 2.5+
- Game Loop: react-native-reanimated 4.x (useFrameCallback)
- Physics: matter-js 0.20
- Input: react-native-gesture-handler 2.x
- State: Zustand 5.x + Reanimated shared values
- Storage: react-native-mmkv 4.x, expo-sqlite
- Audio: expo-audio

## Mimari Kurallar
- Game loop SADECE worklet icinde calisir
- Frame-level state = shared values (pozisyon, hiz, rotasyon)
- App-level state = Zustand store (skor, level, ayarlar)
- setState ASLA game loop icinde cagrilmaz
- Sprite sheet kullan, tek tek image yukleme
- Skia Canvas ile render, RN View kullanma
- Hedef: 60fps min, 120fps ProMotion
- Offline-first: backend yok, tum veri lokalde

## Komutlar
- `npx expo start` - Dev server
- `npx expo run:ios` - iOS build
- `npx expo run:android` - Android build
- `npx jest --watchAll` - Test
- `npx expo prebuild --clean` - Native rebuild

## Dosya Yapisi
```
src/
  app/              # Expo Router (menu, ayarlar)
  game/
    engine/         # Game loop, ECS manager
    entities/       # Oyun objeleri
    systems/        # Physics, collision, scoring
    renderers/      # Skia rendering
    levels/         # Level tanimlari
    assets/         # Sprite sheets, sounds
  stores/           # Zustand
  hooks/            # useGameLoop, useCollision
  components/ui/    # Menu, HUD, overlay
  utils/            # Math helpers
  constants/        # Game config
```

## Kodlama Standartlari
- TypeScript strict, no any
- Worklet fonksiyonlari 'worklet' directive ile isaretle
- Her system pure function: (entities, dt) => entities
- Magic number yasak, constants/ altinda tanimla
