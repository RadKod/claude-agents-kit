---
name: flame-components
description: Flame Component pattern'leri. Player, enemy, projectile, environment, HUD olusturma. Yeni oyun component'i yazarken kullan.
---

## Player Component
```dart
class Player extends SpriteAnimationComponent
    with HasGameRef<MyGame>, CollisionCallbacks, KeyboardHandler {

  Player() : super(size: Vector2(64, 64), anchor: Anchor.center);

  final _velocity = Vector2.zero();
  static const speed = 200.0;
  int health = 3;

  @override
  Future<void> onLoad() async {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('player_run.png'),
      SpriteAnimationData.sequenced(
        amount: 8, stepTime: 0.1,
        textureSize: Vector2(32, 32),
      ),
    );
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.add(_velocity * speed * dt);
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    if (other is Enemy) {
      health--;
      if (health <= 0) game.gameOver();
    }
    if (other is Pickup) {
      other.collect();
    }
  }

  void move(Vector2 direction) {
    _velocity.setFrom(direction);
  }
}
```

## Enemy Component
```dart
class Enemy extends SpriteComponent
    with HasGameRef<MyGame>, CollisionCallbacks {

  final double speed;
  Enemy({required Vector2 position, this.speed = 80})
      : super(position: position, size: Vector2(48, 48), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('enemy.png');
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Basit AI: player'a dogru git
    final player = game.world.children.query<Player>().firstOrNull;
    if (player != null) {
      final direction = (player.position - position)..normalize();
      position.add(direction * speed * dt);
    }
  }
}
```

## HUD Component
```dart
class GameHud extends PositionComponent with HasGameRef<MyGame> {
  late TextComponent _scoreText;
  late TextComponent _healthText;

  @override
  Future<void> onLoad() async {
    _scoreText = TextComponent(
      text: 'Score: 0',
      textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 24)),
      position: Vector2(20, 20),
    );
    _healthText = TextComponent(
      text: 'HP: 3',
      textRenderer: TextPaint(style: const TextStyle(color: Colors.red, fontSize: 24)),
      position: Vector2(20, 50),
    );
    addAll([_scoreText, _healthText]);
  }

  void updateScore(int score) => _scoreText.text = 'Score: $score';
  void updateHealth(int hp) => _healthText.text = 'HP: $hp';
}
```

## Particle Effect
```dart
void spawnExplosion(Vector2 position) {
  parent?.add(
    ParticleSystemComponent(
      position: position,
      particle: Particle.generate(
        count: 20,
        lifespan: 0.5,
        generator: (i) => AcceleratedParticle(
          speed: Vector2(random.nextDouble() * 200 - 100, random.nextDouble() * 200 - 100),
          acceleration: Vector2(0, 200),
          child: CircleParticle(radius: 3, paint: Paint()..color = Colors.orange),
        ),
      ),
    ),
  );
}
```
