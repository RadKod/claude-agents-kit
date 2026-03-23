---
name: rn-game-patterns
description: React Native oyun pattern'leri. Game loop, ECS, collision, sprite, audio. Oyun mekanigi implement ederken kullan.
---

## Game Loop (Reanimated worklet)
```typescript
useFrameCallback((frameInfo) => {
  'worklet';
  const dt = frameInfo.timeSincePreviousFrame ?? 16.67;
  Matter.Engine.update(engine, dt);
  // shared values guncelle -> Skia otomatik render
});
```

## Entity Interface
```typescript
interface GameEntity {
  id: string;
  body: Matter.Body;
  posX: SharedValue<number>;
  posY: SharedValue<number>;
  rotation: SharedValue<number>;
  type: 'player' | 'enemy' | 'projectile' | 'platform';
  active: SharedValue<boolean>;
}
```

## Collision
```typescript
Matter.Events.on(engine, 'collisionStart', (event) => {
  event.pairs.forEach(({ bodyA, bodyB }) => {
    handleCollision(entityMap.get(bodyA.id), entityMap.get(bodyB.id));
  });
});
```

## Zustand + MMKV Persistence
```typescript
export const useGameStore = create<GameStore>()(
  persist(
    (set, get) => ({
      highScore: 0,
      setHighScore: (s) => set({ highScore: Math.max(s, get().highScore) }),
    }),
    { name: 'game-store', storage: createJSONStorage(() => mmkvStorage) }
  )
);
```
