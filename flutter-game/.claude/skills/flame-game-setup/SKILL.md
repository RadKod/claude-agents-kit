---
name: flame-game-setup
description: FlameGame sinifi kurulumu, World/Camera yapisi, overlay, asset yukleme. Yeni oyun baslangici veya game sinifi duzenleme icin kullan.
---

## Ana Game Sinifi
```dart
class MyGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {

  late final World gameWorld;
  late final CameraComponent cam;
  int score = 0;
  bool isGameOver = false;

  @override
  Future<void> onLoad() async {
    // Asset'leri onceden yukle
    await images.loadAll([
      'player_run.png', 'enemy.png', 'tileset.png',
    ]);

    gameWorld = World();
    cam = CameraComponent(world: gameWorld)
      ..viewfinder.anchor = Anchor.center;

    addAll([gameWorld, cam]);

    // Level yukle
    gameWorld.add(Level(levelData: LevelConfig.level1));
  }

  void gameOver() {
    isGameOver = true;
    pauseEngine();
    overlays.add('GameOver');
  }

  void restart() {
    isGameOver = false;
    score = 0;
    gameWorld.removeAll(gameWorld.children);
    gameWorld.add(Level(levelData: LevelConfig.level1));
    overlays.remove('GameOver');
    resumeEngine();
  }
}
```

## main.dart + GameWidget + Overlay
```dart
void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: GameWidget<MyGame>.controlled(
          gameFactory: MyGame.new,
          overlayBuilderMap: {
            'Pause': (context, game) => PauseMenu(game: game),
            'GameOver': (context, game) => GameOverScreen(game: game),
            'MainMenu': (context, game) => MainMenu(game: game),
          },
          initialActiveOverlays: const ['MainMenu'],
        ),
      ),
    ),
  );
}
```

## Asset Preloading
```dart
@override
Future<void> onLoad() async {
  // Images
  await images.loadAll(['player.png', 'enemy.png', 'bg.png']);

  // Audio (flame_audio)
  FlameAudio.bgm.initialize();
  await FlameAudio.audioCache.loadAll(['jump.wav', 'hit.wav', 'bgm.mp3']);
}

// Kullanim:
FlameAudio.play('jump.wav');
FlameAudio.bgm.play('bgm.mp3', volume: 0.5);
```

## Tiled Map Yuklemek
```dart
class Level extends World {
  final String mapFile;
  Level({required this.mapFile});

  @override
  Future<void> onLoad() async {
    final map = await TiledComponent.load(mapFile, Vector2.all(16));
    add(map);

    // Object layer'dan entity'leri spawn et
    final spawnLayer = map.tileMap.getLayer<ObjectGroup>('Spawns');
    for (final obj in spawnLayer?.objects ?? []) {
      switch (obj.class_) {
        case 'Player': add(Player(position: Vector2(obj.x, obj.y)));
        case 'Enemy': add(Enemy(position: Vector2(obj.x, obj.y)));
      }
    }
  }
}
```
