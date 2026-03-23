---
name: clean-arch-patterns
description: Flutter Clean Architecture katman pattern'leri. Repository, datasource, entity, model. Yeni feature olusturma veya mimari soru icin kullan.
---

## Yeni Feature Olusturma Sirasi
1. `lib/features/[name]/domain/entities/` - Entity (freezed, saf Dart)
2. `lib/features/[name]/domain/repositories/` - Abstract repository
3. `lib/features/[name]/data/models/` - Model (freezed + json_serializable)
4. `lib/features/[name]/data/datasources/` - Remote/local datasource
5. `lib/features/[name]/data/repositories/` - Repository impl
6. `lib/features/[name]/presentation/providers/` - Riverpod provider
7. `lib/features/[name]/presentation/screens/` - Ekran
8. `lib/features/[name]/presentation/widgets/` - Widget
9. `dart run build_runner build --delete-conflicting-outputs`
10. Test yaz

## Katman Kurallari
- Domain: SADECE Dart, Flutter import YASAK. Entity + abstract repo.
- Data: Model (DTO), datasource, repo implementasyonu. Dio, Hive vs burada.
- Presentation: Provider, screen, widget. Riverpod burada.
- Core: Paylasilan (network, storage, error, widget). Feature'lar arasi kopru.

## Abstract Repository
```dart
abstract class UserRepository {
  Future<User> getById(String id);
  Future<List<User>> getAll();
  Future<void> create(User user);
  Future<void> update(User user);
  Future<void> delete(String id);
}
```

## Repository Implementation
```dart
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remote;
  final UserLocalDataSource _local;

  UserRepositoryImpl(this._remote, this._local);

  @override
  Future<User> getById(String id) async {
    try {
      final model = await _remote.getUser(id);
      await _local.cacheUser(model);
      return model.toEntity();
    } catch (e) {
      final cached = await _local.getCachedUser(id);
      if (cached != null) return cached.toEntity();
      rethrow;
    }
  }
}
```

## Model -> Entity Donusumu
```dart
extension UserModelX on UserModel {
  User toEntity() => User(id: id, name: name, email: email);
}

extension UserX on User {
  UserModel toModel() => UserModel(id: id, name: name, email: email);
}
```
