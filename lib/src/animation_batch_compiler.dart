import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';

import 'tile_processor.dart';

/// Utility class to merge multiple animated components into one big component
/// Usage example:
/// ```dart
/// final mapComponent = await TiledComponent.load('map.tmx', Vector2.all(16));
/// final animationCompiler = AnimationBatchCompiler();
/// TileProcessor.processTileType(
///         tileMap: tiledComponent.tileMap,
///         processorByType: <String, TileProcessorFunc>{
///           'water': ((tile, position, size) {
///             animationCompiler.addTile(position, tile);
///           }),
///         },
///         layersToLoad: [
///           'water',
///         ]);
/// final animatedWater = await animationCompiler.compile();
/// animatedWater.priority = RenderPriority.water.priority;
/// add(animatedWater);
/// ```
class AnimationBatchCompiler {
  SpriteAnimation? animation;
  bool _loading = false;

  List<Vector2> positions = [];
  final Completer _completer = Completer();

  Future addTile(Vector2 position, TileProcessor tileProcessor) async {
    if (animation == null && _loading == false) {
      _loading = true;
      animation = await tileProcessor.getSpriteAnimation();
      if (animation == null) {
        _loading = false;
      } else {
        _completer.complete();
      }
    }
    positions.add(position);
  }

  Future<SpriteAnimationComponent> compile() async {
    await _completer.future;
    final anim = animation;
    if (anim == null) {
      throw "Can't compile while animation is not loaded!";
    }

    List<Sprite> newSprites = [];

    while (anim.currentIndex < anim.frames.length) {
      final sprite = anim.getSprite();
      final composition = ImageComposition();
      for (final pos in positions) {
        composition.add(sprite.image, pos, source: sprite.src);
      }
      final composedImage = await composition.compose();
      newSprites.add(Sprite(composedImage));
      anim.currentIndex++;
    }
    final spriteAnimation = SpriteAnimation.variableSpriteList(newSprites,
        stepTimes: anim.getVariableStepTimes());
    return SpriteAnimationComponent(
        animation: spriteAnimation,
        position: Vector2.all(0),
        size: newSprites.first.image.size);
  }
}

extension _VariableStepTimes on SpriteAnimation {
  List<double> getVariableStepTimes() {
    final times = <double>[];
    for (final frame in frames) {
      times.add(frame.stepTime);
    }
    return times;
  }
}
