/// Features:
///
/// Merge a layer of tiled map into component to render as single image.
/// See [ImageBatchCompiler].
///
/// Map each tile to dart class or process function using "Type" parameter as key
/// See [TiledComponent].
///
/// Extract animation from tiles, allows to render maps with animated tiles.
/// Use [TiledComponent] and it's utility functions.
///
/// Merge animated tiles of same type into one big SpriteAnimation component.
/// Use combination of [TiledComponent] and [AnimationBatchCompiler]
///
///

library tiled_utils;

export 'src/animation_batch_compiler.dart';
export 'src/image_batch_compiler.dart';
export 'src/tile_processor.dart';
