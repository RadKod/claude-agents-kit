# Flutter Projesi

## Tech Stack
- Framework: Flutter 3.41+, Dart 3.11+
- Rendering: Impeller (varsayilan, Skia kullanma)
- State Management: Riverpod 2.5+ (code generation ile)
- Routing: GoRouter 14+ (veya auto_route)
- HTTP: Dio 5.x
- Local Storage: SharedPreferences (basit), Hive/Isar (karmasik)
- DI: Riverpod (ayri DI paketi gereksiz)
- Serialization: freezed + json_serializable (code gen)
- Testing: flutter_test + mocktail + patrol (E2E)
- Linting: very_good_analysis (veya flutter_lints)
- CI/CD: Codemagic veya GitHub Actions + Fastlane

## Komutlar
- `flutter run` - Debug calistir
- `flutter run --release` - Release build
- `flutter test` - Testler
- `flutter test --coverage` - Coverage
- `dart run build_runner build --delete-conflicting-outputs` - Code gen
- `dart run build_runner watch` - Code gen (watch mode)
- `dart fix --apply` - Otomatik fix
- `flutter analyze` - Lint
- `flutter build apk --release` - Android APK
- `flutter build ios --release` - iOS build

## Mimari: Feature-First Clean Architecture + Riverpod
```
lib/
  app/
    app.dart               # MaterialApp/CupertinoApp
    router.dart             # GoRouter config
    theme.dart              # ThemeData (Material 3)
  core/
    constants/              # App-wide sabitler
    errors/                 # Failure, AppException sinifi
    extensions/             # Dart extension methods
    network/                # Dio client, interceptors
    storage/                # Local storage wrapper
    utils/                  # Genel helper'lar
    widgets/                # Paylasilan widget'lar (AppButton, AppTextField)
  features/
    auth/
      data/
        datasources/        # Remote/local data source
        models/             # DTO'lar (freezed + json_serializable)
        repositories/       # Repository implementasyonu
      domain/
        entities/           # Saf Dart siniflari (UI'dan bagimsiz)
        repositories/       # Abstract repository (interface)
      presentation/
        providers/          # Riverpod provider'lar
        screens/            # Ekranlar
        widgets/            # Feature-specific widget'lar
    home/
      ...
    settings/
      ...
  l10n/                     # Localization (ARB dosyalari)
  main.dart                 # Entry point, ProviderScope
```

## Kodlama Standartlari
- Dart strict mode: analysis_options.yaml'da very_good_analysis
- const constructor DAIMA kullan (IDE uyarisi actir)
- Widget agaci: kucuk, okunabilir parcalara bol (extract widget)
- StatelessWidget tercih et, StatefulWidget sadece lifecycle gerektiginde
- setState ASLA kullanma (Riverpod ile yonet)
- SizedBox tercih et, bos Container kullanma
- String concatenation yerine string interpolation: '$name merhaba'
- Immutable model: freezed ile
- Async: Future/Stream, callback YASAK
- Naming: UpperCamelCase class, lowerCamelCase variable, snake_case dosya
- Feature-first klasor yapisi: feature ekle/cikar kolay olmali
- Her feature kendi data/domain/presentation katmanina sahip
- Provider dosyasi: feature/presentation/providers/ altinda
- God widget YASAK: 200+ satir widget parcalanmali

## Riverpod Kurallari
- @riverpod annotation kullan (code gen)
- AsyncNotifier tercih et (FutureProvider + StateNotifier yerine)
- ref.watch() build icinde, ref.read() callback icinde
- ref.listen() side effect icin (snackbar, navigation)
- autoDispose varsayilan, keepAlive sadece gerektiginde
- Provider'lar feature/presentation/providers/ altinda
- Family provider: dinamik parametreler icin (userId, productId)
- select() ile granular rebuild: ref.watch(provider.select((s) => s.name))

## Performance Kurallari
- Impeller aktif (varsayilan, kapatma)
- const widget DAIMA
- ListView.builder buyuk listeler icin (Column + SingleChildScrollView YASAK)
- RepaintBoundary agir animasyonlarda
- Image.asset/Image.network ile cacheWidth/cacheHeight
- Profiling: flutter run --profile ile gercek cihazda test
- isolate: agir hesaplama icin compute() kullan
