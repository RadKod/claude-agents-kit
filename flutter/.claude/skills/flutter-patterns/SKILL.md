---
name: flutter-mvvm-patterns
description: Flutter MVVM pattern'leri. Screen, ViewModel, Repository, freezed model, go_router. Feature implement ederken kullan.
---

## Feature Scaffold (MVVM)

### 1. Model (freezed)
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String email,
    String? avatarUrl,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
```

### 2. Repository
```dart
class AuthRepository {
  AuthRepository(this._apiClient, this._localStorage);
  final ApiClient _apiClient;
  final LocalStorage _localStorage;

  Future<UserModel> login(String email, String password) async {
    final response = await _apiClient.login(email, password);
    await _localStorage.saveToken(response.token);
    return response.user;
  }
}

// Riverpod provider
@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(ref.watch(apiClientProvider), ref.watch(localStorageProvider));
}
```

### 3. ViewModel (AsyncNotifier)
```dart
@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  FutureOr<UserModel?> build() => null;

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
      ref.read(authRepositoryProvider).login(email, password),
    );
  }
}
```

### 4. View (Screen)
```dart
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    ref.listen(authViewModelProvider, (_, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) context.go('/home');
        },
        error: (e, _) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString()))),
      );
    });

    return Scaffold(
      body: authState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : LoginForm(
              onSubmit: (email, password) =>
                  ref.read(authViewModelProvider.notifier).login(email, password),
            ),
    );
  }
}
```

## go_router Setup
```dart
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
      ShellRoute(
        builder: (_, __, child) => ScaffoldWithNavBar(child: child),
        routes: [
          GoRoute(path: '/feed', builder: (_, __) => const FeedScreen()),
          GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
        ],
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = ref.read(authStateProvider) != null;
      if (!isLoggedIn && state.matchedLocation != '/login') return '/login';
      return null;
    },
  );
});
```

## Dio + Retrofit API Client
```dart
@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio) = _ApiClient;

  @POST('/auth/login')
  Future<LoginResponse> login(@Body() LoginRequest request);

  @GET('/users/{id}')
  Future<UserModel> getUser(@Path('id') String id);
}

@riverpod
ApiClient apiClient(Ref ref) {
  final dio = Dio(BaseOptions(baseUrl: Env.apiBaseUrl))
    ..interceptors.addAll([
      AuthInterceptor(ref),
      LogInterceptor(requestBody: true, responseBody: true),
    ]);
  return ApiClient(dio);
}
```
