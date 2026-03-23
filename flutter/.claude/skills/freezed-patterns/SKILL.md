---
name: freezed-patterns
description: Freezed ile immutable model ve union type pattern'leri. Model/entity olusturma ve sealed class icin kullan.
---

## Data Model (DTO with JSON)
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String email,
    @Default('') String avatarUrl,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
```

## Domain Entity (saf, JSON'siz)
```dart
@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
  }) = _User;
}
```

## Union Type (sealed class alternatifi)
```dart
@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(String message) = _Error;
}

// Kullanim:
authState.when(
  initial: () => const SplashScreen(),
  authenticated: (user) => HomeScreen(user: user),
  unauthenticated: () => const LoginScreen(),
  error: (msg) => ErrorScreen(message: msg),
);
```

## Code Gen
```bash
dart run build_runner build --delete-conflicting-outputs
# veya watch mode:
dart run build_runner watch --delete-conflicting-outputs
```
