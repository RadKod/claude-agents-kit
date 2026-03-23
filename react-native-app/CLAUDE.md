# React Native Uygulama Projesi

## Tech Stack
- Framework: Expo SDK 55+, React Native 0.83+, TypeScript strict
- Navigation: Expo Router v7 (file-based)
- State: Zustand 5.x (client) + TanStack Query 5.x (server)
- Styling: NativeWind v4 (Tailwind CSS)
- Animation: react-native-reanimated 4.x
- Storage: react-native-mmkv 4.x
- Forms: react-hook-form + zod
- HTTP: axios veya ky
- Testing: Jest + RNTL, Maestro (E2E)

## Komutlar
- `npx expo start` - Dev server
- `npx expo run:ios` - iOS build
- `npx expo run:android` - Android build
- `npx jest --watchAll` - Test
- `npx expo lint` - Lint

## Dosya Yapisi
```
src/
  app/                    # Expo Router routes
    _layout.tsx           # Root layout (providers)
    (tabs)/               # Tab navigation
    (auth)/               # Auth grubu
  components/
    ui/                   # Button, Input, Card
    features/             # Feature-specific
  hooks/                  # Custom hooks
  stores/                 # Zustand stores
  services/
    api/                  # API client, endpoints
    queries/              # TanStack Query hooks
  utils/                  # Helpers
  types/                  # Shared types
  constants/              # App-wide constants
```

## Kodlama Standartlari
- TypeScript strict, no any
- NativeWind className, StyleSheet sadece dinamik stiller icin
- Component props icin interface, union icin type
- Her component kendi dosyasinda, index.ts ile barrel export
- Platform-specific: .ios.tsx, .android.tsx
- Accessibility: her interaktif elemente label
