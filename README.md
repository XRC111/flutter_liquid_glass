<div align="center">

# flutter_liquid_glass（初版组件库）

**Flutter 液态玻璃组件库 —— 真实折射、RGB 色散、Fresnel 边缘高光、触摸动态光照**

覆盖 Android API 24 → 35，低端设备自动降级。

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter)](https://flutter.dev/)
[![Pub](https://img.shields.io/badge/pub-0.1.0-orange?style=flat-square)](#安装)

</div>

---

> **仓库状态**：这是初版组件库（API 为 `GlassWidget` + `captureKey`）。后续重写版本请使用
> **[liquid_glass_library](https://github.com/XRC111/liquid_glass_library)**（`LiquidGlassScene` + `LiquidGlassWidget`，五级兼容链、更完整的 API 与示例）。
>
> 本仓库保留作为历史版本，不再更新。

## 特性

- **真实折射**：SDF 圆角矩形 + 中心差分法线 + 圆弧剖面高度场
- **RGB 色散**：三通道以不同偏移量采样，模拟不同波长折射率差异
- **Fresnel 边缘高光**：边缘法线越倾斜反射越强
- **触摸动态光照**：按下时出现跟随手指的暖色光斑
- **自动降级**：按 API 与 `isLowRamDevice` 选档，低端机不崩溃、不 OOM

## 安装

```yaml
dependencies:
  flutter_liquid_glass: ^0.1.0
```

## 使用

**1. 启动时预加载着色器**

```dart
import 'package:flutter_liquid_glass/flutter_liquid_glass.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlassShaderProgram.instance.load();
  runApp(const MyApp());
}
```

**2. 背景包一层 `RepaintBoundary`，再放 `GlassWidget`**

```dart
final bgKey = GlobalKey();

Stack(
  children: [
    // 背景必须包一层 RepaintBoundary，供玻璃捕获
    RepaintBoundary(key: bgKey, child: MyBackground()),
    GlassWidget(
      captureKey: bgKey,
      cornerRadius: 24,
      quality: GlassQuality.full,
      onTap: () {},
      child: const Text(
        'Liquid Glass',
        style: TextStyle(color: Colors.white),
      ),
    ),
  ],
)
```

## 质量分级

| 等级 | 设备 | 后端 | 模糊 | 色散 | 触摸光照 |
| --- | --- | --- | --- | --- | --- |
| `full` | API 29+ | Impeller Vulkan | 1/2 分辨率 | 完整 | 有 |
| `medium` | API 26–28 | Impeller OpenGL ES | 1/4 分辨率 | 简化 | 有 |
| `minimal` | API 24–25 / 低内存 | BackdropFilter 兜底 | 跳过 | 无 | 无 |

## 已知限制

- `captureKey` 方式要求背景在同一个 `RepaintBoundary` 内，多场景复用不便（新版本已改为 `LiquidGlassScene` 统一捕获）
- 仅验证 Android；其他平台未测试
- 大面积铺满时性能下降明显，建议单页 2–3 块玻璃

## License

MIT
