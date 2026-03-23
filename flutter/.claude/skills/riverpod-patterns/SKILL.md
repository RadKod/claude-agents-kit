---
name: riverpod-patterns
description: Riverpod provider pattern'leri. AsyncNotifier, code gen, family, select. Riverpod provider yazarken kullan.
---

## Provider with Code Generation (recommended)
```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_provider.g.dart';

// Simple provider (auto-disposed by default)
@riverpod
Future<User> currentUser(Ref ref) async {
  final repo = ref.watch(userRepositoryProvider);
  return repo.getCurrentUser();
}

// Notifier (state management with methods)
@riverpod
class UserController extends _$UserController {
  @override
  Future<User> build() async {
    final repo = ref.watch(userRepositoryProvider);
    return repo.getCurrentUser();
  }

  Future<void> updateName(String name) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
      ref.read(userRepositoryProvider).updateName(name)
    );
  }
}

// Family provider (parameterized)
@riverpod
Future<Product> productDetail(Ref ref, String productId) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getById(productId);
}
```

## Repository Provider
```dart
@riverpod
UserRepository userRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return UserRepositoryImpl(dio);
}
```

## Widget'ta Kullanim
```dart
class UserScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      data: (user) => Text(user.name),
      loading: () => const CircularProgressIndicator(),
      error: (e, st) => ErrorWidget(e, onRetry: () => ref.invalidate(currentUserProvider)),
    );
  }
}
```

## Granular Rebuild (select)
```dart
// Sadece name degistiginde rebuild
final name = ref.watch(userControllerProvider.select((s) => s.value?.name));
```

## Side Effects (listen)
```dart
ref.listen(userControllerProvider, (prev, next) {
  next.whenOrNull(
    error: (e, _) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'))),
  );
});
```
