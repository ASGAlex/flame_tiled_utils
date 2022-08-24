# example of flame_tiled_utils usage

Project intended to be launched on desktop platforms. Use scroll to change zoom; Use WASD to move
camera

Change `MapRenderingMode` parameter of `TestGame` to compare Flame performance in different modes:

- `MapRenderingMode.standard` - rendering the map by pure flame_tiled functionality. Low FPS, no
  animations.
- `MapRenderingMode.optimizedOnlyStatic` - rendering with optimized static layers but non-optimized
  animated layer. Dramatically low FPS, totally unusable.
- `MapRenderingMode.optimizedWithAnimation` - fully optimized map rendering, average 60 FPS on
  desktop.