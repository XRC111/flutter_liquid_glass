# flutter_liquid_glass

一个 Flutter **液态玻璃（Liquid Glass）**组件库，提供真实折射、RGB 色散、Fresnel 边缘高光与触摸动态光照，覆盖 **Android API 24（Android 7.0）到 API 35（Android 15）**，并在低端设备上自动降级。

## 特性

- **真实折射**：SDF 圆角矩形 + 中心差分法线 + 圆弧剖面高度场，玻璃下方内容随透镜曲率偏移。
- **RGB 色散**：RGB 三通道以不同偏移量采样，模拟不同波长光的折射率差异。
- **Fresnel 边缘高光**：边缘法线越倾斜反射越强，形成自然玻璃边缘光。
- **触摸动态光照**：按下时出现跟随手指的暖色光斑。
- **自动降级**：按 API 级别与 `isLowRamDevice` 选择质量等级，低端机不崩溃、不 OOM。

## 质量分级

| 等级 | 设备 | 渲染后端 | 模糊 | 色散 | 触摸光照 |
|------|------|----------|------|------|---------|
| `full` | API 29+ | Impeller Vulkan | 1/2 分辨率 | 完整 | 有 |
| `medium` | API 26–28 | Impeller OpenGL ES | 1/4 分辨率 | 简化 | 有 |
| `minimal` | API 24–25 / 低内存 | `BackdropFilter` 兜底 | 跳过 | 无 | 无 |

## 安装

```yaml
dependencies:
  flutter_liquid_glass: ^0.1.0
```

## 使用

**1. 启动时预加载着色器：**

```dart
import 'package:flutter_liquid_glass/flutter_liquid_glass.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlassShaderProgram.instance.load();
  runApp(const MyApp());
}
```

**2. 用 `RepaintBoundary` 包裹背景，再放置 `GlassWidget`：**

```dart
final bgKey = GlobalKey();

Stack(
  children: [
    // 背景必须包一层 RepaintBoundary，供玻璃捕获
    RepaintBoundary(key: bgKey, child: MyBackground()),
    // 液态玻璃
    GlassWidget(
      captureKey: bgKey,
      cornerRadius: 24,
      quality: GlassQuality.full,
      onTap: () {},
      child: const Text('Liquid Glass',
          style: TextStyle(color: Colors.white)),
    ),
  ],
)
```

**3. 自动检测设备质量（需自行通过平台通道读取 API 级别）：**

```dart
final quality = resolveQuality(sdkInt: sdkInt, isLowRam: isLowRam);
```

## API

| 成员 | 说明 |
|------|------|
| `GlassWidget` | 液态玻璃组件，捕获背景并用 GPU 着色器渲染 |
| `GlassShaderProgram.instance.load()` | 预加载并缓存着色器（app 启动时调用一次） |
| `GlassQuality` | 质量分级枚举（full / medium / minimal） |
| `resolveQuality()` | 根据 API 级别和低内存状态推断质量 |

## 平台配置

- 建议 `minSdkVersion 24`，`targetSdkVersion 35`。
- `AndroidManifest.xml` 中设置 `io.flutter.embedding.android.EnableImpeller=true`。
- 着色器在构建期由 Flutter 自动交叉编译到 Vulkan / OpenGL ES；OpenGL ES 后端的纹理 Y 轴翻转已在着色器内处理。

## 示例

完整可运行示例（含首页、TabBar、卡片列表三个演示）见仓库
[liquid_glass_flutter](https://github.com/XRC111/liquid_glass_flutter)，
其 Release 页提供可直接安装的 APK。

## License

MIT
