---
name: flame-physics
description: Forge2D fizik entegrasyonu. Rigid body, collision, joint, gravity. Fizik tabanli oyun mekanigi icin kullan.
---

## Forge2D Setup
```yaml
# pubspec.yaml
dependencies:
  flame_forge2d: ^0.18.0
```

## Forge2D Game
```dart
class MyPhysicsGame extends Forge2DGame {
  MyPhysicsGame() : super(gravity: Vector2(0, 10)); // asagi cekim

  @override
  Future<void> onLoad() async {
    world.add(Player());
    world.add(Ground());
    world.add(Wall(position: Vector2(-20, 0), size: Vector2(1, 40)));
  }
}
```

## Dynamic Body (hareket eden obje)
```dart
class Player extends BodyComponent with ContactCallbacks {
  @override
  Body createBody() {
    final shape = CircleShape()..radius = 1.0;
    final fixtureDef = FixtureDef(shape)
      ..density = 1.0
      ..friction = 0.3
      ..restitution = 0.5; // ziplama

    final bodyDef = BodyDef(
      type: BodyType.dynamic,
      position: Vector2(0, -10),
      userData: this,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  void jump() {
    body.applyLinearImpulse(Vector2(0, -50));
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Enemy) { /* hasar al */ }
  }
}
```

## Static Body (duvar, zemin)
```dart
class Ground extends BodyComponent {
  @override
  Body createBody() {
    final shape = EdgeShape()..set(Vector2(-50, 10), Vector2(50, 10));
    final fixtureDef = FixtureDef(shape)..friction = 0.5;
    final bodyDef = BodyDef(type: BodyType.static);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
```
