import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flame_tiled_utils/flame_tiled_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum MapRenderingMode { standard, optimizedOnlyStatic, optimizedWithAnimation }

void main(List<String> args) async {
  final game = TestGame(MapRenderingMode.optimizedWithAnimation);
  runApp(GameWidget(game: game));
}

class TestGame extends FlameGame with KeyboardEvents, ScrollDetector {
  TestGame(this.renderingMode);

  MapRenderingMode renderingMode;

  @override
  Future<void> onLoad() async {
    final tiledComponent =
        await TiledComponent.load('example.tmx', Vector2.all(8));

    if (renderingMode == MapRenderingMode.standard) {
      world.add(tiledComponent);
    } else {
      final imageCompiler = ImageBatchCompiler();
      // Adding separate ground layer
      final ground = imageCompiler.compileMapLayer(
          tileMap: tiledComponent.tileMap, layerNames: ['ground']);
      ground.priority = -1;
      world.add(ground);

      // Adding separate tree layer
      final tree = imageCompiler.compileMapLayer(
          tileMap: tiledComponent.tileMap, layerNames: ['tree']);
      tree.priority = 3;
      world.add(tree);

      if (renderingMode == MapRenderingMode.optimizedOnlyStatic) {
        //Process every tile of layer "water"
        TileProcessor.processTileType(
            tileMap: tiledComponent.tileMap,
            processorByType: <String, TileProcessorFunc>{
              // Working with tiles of "water" type
              'water': ((tile, position, size) async {
                // Reading animation for the tile
                final animation = await tile.getSpriteAnimation();
                // Creating animation object for every found tile.
                // Simple but very expensive approach.
                world.add(SpriteAnimationComponent(
                    animation: animation,
                    position: position,
                    size: Vector2.all(8),
                    priority: 2));
              }),
            },
            layersToLoad: [
              'water',
            ]);
      } else if (renderingMode == MapRenderingMode.optimizedWithAnimation) {
        // Optimal way to work with big number of animated tiles
        // Creating compiler to save all tiles to be merged;
        final animationCompiler = AnimationBatchCompiler();
        await TileProcessor.processTileType(
            tileMap: tiledComponent.tileMap,
            processorByType: <String, TileProcessorFunc>{
              'water': ((tile, position, size) async {
                // saving tile for merge
                return animationCompiler.addTile(position, tile);
              }),
            },
            layersToLoad: [
              'water',
            ]);
        // Compile SpriteAnimation component from list of animated tiles.
        final animatedWater = await animationCompiler.compile();
        animatedWater.priority = 2;
        world.add(animatedWater);
      }
    }

    camera.viewport.add(FpsTextComponent());
    camera.viewport = FixedResolutionViewport(resolution: Vector2(500, 250));
    camera.moveTo(Vector2(0, 500));
    camera.viewfinder.zoom = 1;
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    const speed = 40.0;
    for (final key in keysPressed) {
      if (key == LogicalKeyboardKey.keyW) {
        camera.moveBy(Vector2(0, -5), speed: speed);
      }
      if (key == LogicalKeyboardKey.keyA) {
        camera.moveBy(Vector2(-5, 0), speed: speed);
      }
      if (key == LogicalKeyboardKey.keyS) {
        camera.moveBy(Vector2(0, 5), speed: speed);
      }
      if (key == LogicalKeyboardKey.keyD) {
        camera.moveBy(Vector2(5, 0), speed: speed);
      }
    }

    return KeyEventResult.handled;
  }

  @override
  void onScroll(PointerScrollInfo info) {
    camera.viewfinder.zoom += info.scrollDelta.global.y.sign * 0.08;
    camera.viewfinder.zoom = camera.viewfinder.zoom.clamp(0.05, 5.0);
  }
}
