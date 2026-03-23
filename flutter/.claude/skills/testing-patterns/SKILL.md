---
name: flutter-testing
description: Flutter test pattern'leri. ViewModel test, widget test, repository mock. Test yazarken kullan.
---

## ViewModel Test (Riverpod)
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;
  late ProviderContainer container;

  setUp(() {
    mockRepo = MockAuthRepository();
    container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(mockRepo)],
    );
  });

  tearDown(() => container.dispose());

  test('login basarili olunca user doner', () async {
    final user = UserModel(id: '1', name: 'Test', email: 'test@test.com');
    when(() => mockRepo.login(any(), any())).thenAnswer((_) async => user);

    final vm = container.read(authViewModelProvider.notifier);
    await vm.login('test@test.com', '123456');

    final state = container.read(authViewModelProvider);
    expect(state.value, user);
  });

  test('login basarisiz olunca error state doner', () async {
    when(() => mockRepo.login(any(), any())).thenThrow(Exception('Hata'));

    final vm = container.read(authViewModelProvider.notifier);
    await vm.login('test@test.com', 'wrong');

    final state = container.read(authViewModelProvider);
    expect(state.hasError, true);
  });
}
```

## Widget Test
```dart
testWidgets('login butonu tiklayinca form submit eder', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [authViewModelProvider.overrideWith(() => FakeAuthVM())],
      child: const MaterialApp(home: LoginScreen()),
    ),
  );

  await tester.enterText(find.byType(TextField).first, 'test@test.com');
  await tester.enterText(find.byType(TextField).last, '123456');
  await tester.tap(find.text('Giris Yap'));
  await tester.pumpAndSettle();

  // Assert
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```
