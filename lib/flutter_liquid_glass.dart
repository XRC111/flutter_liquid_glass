/// Flutter Liquid Glass —— 液态玻璃效果库。
///
/// 提供真实折射、RGB 色散、Fresnel 边缘高光、触摸动态光照，
/// 并按设备 API 级别与内存状态自动降级（覆盖 Android API 24-35）。
///
/// 快速上手：
/// ```dart
/// import 'package:flutter_liquid_glass/flutter_liquid_glass.dart';
///
/// await GlassShaderProgram.instance.load();
///
/// final bgKey = GlobalKey();
/// // 背景包一层 RepaintBoundary(key: bgKey)
/// GlassWidget(captureKey: bgKey, cornerRadius: 24, child: Text('玻璃'));
/// ```
library flutter_liquid_glass;

export 'src/glass_quality.dart' show GlassQuality;
export 'src/glass_shader_program.dart'
    show GlassShaderProgram, resolveQuality;
export 'src/liquid_glass_widget.dart' show GlassWidget;
