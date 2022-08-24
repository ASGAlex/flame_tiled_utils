import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:tiled/tiled.dart';

/// Utility class to compile multiple tiles into one image.
/// Usage example:
///
/// ```dart
/// final mapComponent = await TiledComponent.load('map.tmx', Vector2.all(16));
/// final imageCompiler = ImageBatchCompiler();
/// final ground = await imageCompiler.compileMapLayer(tileMap: mapComponent.tileMap, layerNames: ['ground']);
/// ground.priority = RenderPriority.ground.priority;
/// add(ground);
/// ```
class ImageBatchCompiler {
  Future<PositionComponent> compileMapLayer(
      {required RenderableTiledMap tileMap, List<String>? layerNames}) async {
    layerNames ??= [];
    _unlistedLayers(tileMap, layerNames).forEach((element) {
      element.visible = false;
    });
    for (var rl in tileMap.renderableLayers) {
      rl.refreshCache();
    }

    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    tileMap.render(canvas);
    final picture = recorder.endRecording();

    _unlistedLayers(tileMap, layerNames).forEach((element) {
      element.visible = true;
    });
    for (var rl in tileMap.renderableLayers) {
      rl.refreshCache();
    }

    final image = await picture.toImage(
        tileMap.map.width * tileMap.map.tileWidth,
        tileMap.map.height * tileMap.map.tileHeight);

    return _ImageComponent(image);
  }

  static List<Layer> _unlistedLayers(
      RenderableTiledMap tileMap, List<String> layerNames) {
    final unlisted = <Layer>[];
    for (final layer in tileMap.map.layers) {
      if (!layerNames.contains(layer.name)) {
        unlisted.add(layer);
      }
    }
    return unlisted;
  }
}

class _ImageComponent extends PositionComponent {
  _ImageComponent(this.image);

  final Image image;

  @override
  void render(Canvas canvas) {
    canvas.drawImage(image, const Offset(0, 0), Paint());
  }
}
