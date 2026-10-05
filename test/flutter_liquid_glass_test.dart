import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_liquid_glass/flutter_liquid_glass.dart';

void main() {
  group('resolveQuality', () {
    test('API 29+ uses full quality', () {
      expect(resolveQuality(sdkInt: 29), GlassQuality.full);
      expect(resolveQuality(sdkInt: 35), GlassQuality.full);
    });

    test('API 26-28 uses medium quality', () {
      expect(resolveQuality(sdkInt: 26), GlassQuality.medium);
      expect(resolveQuality(sdkInt: 28), GlassQuality.medium);
    });

    test('API 24-25 uses minimal quality', () {
      expect(resolveQuality(sdkInt: 24), GlassQuality.minimal);
      expect(resolveQuality(sdkInt: 25), GlassQuality.minimal);
    });

    test('low RAM always uses minimal even on high API', () {
      expect(resolveQuality(sdkInt: 35, isLowRam: true), GlassQuality.minimal);
    });
  });

  group('GlassQuality', () {
    test('shader values are ordered', () {
      expect(GlassQuality.full.shaderValue, 0);
      expect(GlassQuality.medium.shaderValue, 1);
      expect(GlassQuality.minimal.shaderValue, 2);
    });

    test('minimal disables expensive effects', () {
      expect(GlassQuality.minimal.enableBlur, false);
      expect(GlassQuality.minimal.blurRadius, 0);
    });
  });
}
