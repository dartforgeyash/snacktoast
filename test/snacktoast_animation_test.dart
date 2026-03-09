import 'package:flutter/animation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snacktoast/snacktoast.dart';

void main() {
  group('SnackToastAnimationResolver', () {
    test('exhaustive coverage of all 18 variants', () {
      expect(SnackToastAnimation.values.length, 18);
    });

    test('resolvedEntranceDuration scales correctly', () {
      const base = Duration(milliseconds: 300);

      // Physics/Spring (1.8x)
      expect(
        SnackToastAnimation.scaleSpring
            .resolvedEntranceDuration(base)
            .inMilliseconds,
        greaterThan(500),
      );

      // Bounce (1.5x)
      expect(
        SnackToastAnimation.bounceUp
            .resolvedEntranceDuration(base)
            .inMilliseconds,
        450,
      );

      // FadeDrop (1.4x)
      expect(
        SnackToastAnimation.fadeDrop
            .resolvedEntranceDuration(base)
            .inMilliseconds,
        420,
      );

      // Standard (1.0x)
      expect(
        SnackToastAnimation.slideUp
            .resolvedEntranceDuration(base)
            .inMilliseconds,
        300,
      );
    });

    test('hasVerticalSlide flags are correct', () {
      expect(SnackToastAnimation.slideUp.hasVerticalSlide, isTrue);
      expect(SnackToastAnimation.fadeDrop.hasVerticalSlide, isTrue);
      expect(SnackToastAnimation.topLeftSweep.hasVerticalSlide, isTrue);
      expect(SnackToastAnimation.slideLeft.hasVerticalSlide, isFalse);
      expect(SnackToastAnimation.centerPop.hasVerticalSlide, isFalse);
    });

    test('hasHorizontalSlide flags are correct', () {
      expect(SnackToastAnimation.slideLeft.hasHorizontalSlide, isTrue);
      expect(SnackToastAnimation.slideFromRight.hasHorizontalSlide, isTrue);
      expect(SnackToastAnimation.topRightSweep.hasHorizontalSlide, isTrue);
      expect(SnackToastAnimation.slideUp.hasHorizontalSlide, isFalse);
      expect(SnackToastAnimation.centerPop.hasHorizontalSlide, isFalse);
    });

    test('requiresRadialLayer is true only for radialExpansion', () {
      expect(SnackToastAnimation.radialExpansion.requiresRadialLayer, isTrue);
      expect(SnackToastAnimation.centerPop.requiresRadialLayer, isFalse);
    });

    test('requiresBlurFilter is true only for centerPop', () {
      expect(SnackToastAnimation.centerPop.requiresBlurFilter, isTrue);
      expect(SnackToastAnimation.radialExpansion.requiresBlurFilter, isFalse);
    });

    test('entrance and exit curves are defined for all', () {
      for (final anim in SnackToastAnimation.values) {
        expect(anim.entranceCurve, isA<Curve>());
        expect(anim.exitCurve, isA<Curve>());
      }
    });
  });
}
