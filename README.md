## Features

1. Merge a layer of tiled map into component to render as single image. It allows to improve
   performance on large maps
2. Map each tile to dart class or process function using "Type" parameter as key
3. Extract animation from tiles, allows to render maps with animated tiles.
4. Merge animated tiles of same type into one big SpriteAnimation component. It allows to improve
   performance for large animated fields.

## Usage

### Merging statical layers

Instead of rendering tiled map as usual: 
```dart
final mapComponent = await TiledComponent.load('map.tmx', Vector2.all(16));
world.add(mapComponent);
```
convert it into special component: 

```dart
final mapComponent = await TiledComponent.load('map.tmx', Vector2.all(16));
final imageCompiler = ImageBatchCompiler();
final ground = imageCompiler.compileMapLayer(tileMap: mapComponent.tileMap, layerNames: ['ground']);
ground.priority = RenderPriority.ground.priority;
world.add(ground);
```

The `layerNames` variable allows you to specify layers to convert. It is useful when different map
layers should have different priorities.

### Map tiles to components

If you need to process each tile individually - use `TileProcessor`:

```dart
final mapComponent = await TiledComponent.load('map.tmx', Vector2.all(16));
TileProcessor.processTileType(
  tileMap: mapComponent.tileMap,
  processorByType: <String, TileProcessorFunc>{
    'water': ((tile, position, size) {
      /// Create here a new object, save tile data or process it
      /// a way your game logics need
    }),
  },
  layersToLoad: [
  'water',
]);
```

The first parameter of `TileProcessorFunc` is instance of `TileProcessor` class.

### Extracting tile data

Use instance of `TileProcessor` inside of `TileProcessorFunc` to access all necessary data:

- `tile.getSprite()` to get `Sprite` object of the tile
- `tile.getSpriteAnimation()` to get `SpriteAnimation` object of the tile. It brings tiled support
  of animated map - missing but strongly required feature
- `tile.getCollisionRect()` allows to load `RectangleHitbox`, if collision rect was specified in
  Tiled editor. The library only supports rectangular shapes.  

### Rendering large fields of animated tiles

It is cheaper to merge multiple small animated tiles into big one, then render each tile with same animation.
This could be achieved by combining `TileProcessor.processTileType` and `AnimationBatchCompiler`: 

```dart
final mapComponent = await TiledComponent.load('map.tmx', Vector2.all(16));
final animationCompiler = AnimationBatchCompiler();
TileProcessor.processTileType(
        tileMap: tiledComponent.tileMap,
        processorByType: <String, TileProcessorFunc>{
          'water': ((tile, position, size) {
            animationCompiler.addTile(position, tile);
          }),
        },
        layersToLoad: [
          'water',
        ]);
final animatedWater = await animationCompiler.compile();
animatedWater.priority = RenderPriority.water.priority;
world.add(animatedWater);
```

