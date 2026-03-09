import 'package:flutter/animation.dart';

/// Entrance and exit motion style for a toast / snackbar notification.
///
/// Grouped by motion family:
///
/// **Directional — vertical** (spatial origin along the Y axis)
/// [fadeDrop], [fadeRise], [slideUp], [slideDown]
///
/// **Directional — horizontal** (spatial origin along the X axis)
/// [slideLeft], [slideRight], [slideFromLeft], [slideFromRight]
///
/// **Corner sweeps** (diagonal origin → center rest position)
/// [topLeftSweep], [topRightSweep], [bottomLeftSweep], [bottomRightSweep]
///
/// **Physics / organic**
/// [scaleSpring], [bounceUp]
///
/// **Ambient / atmospheric**
/// [fade], [centerPop], [flipReveal], [radialExpansion]
///
/// ## Position auto-selection
/// When [SnackToastConfig.animationStyle] is `null`, the position determines
/// the animation automatically (see `resolvedAnimationForPosition` on config):
/// - bottom → [slideUp]
/// - top → [slideDown]
/// - center → [scaleSpring]
enum SnackToastAnimation {
  // ── v1 styles (preserved) ────────────────────────────────────────────────

  /// Translates up from below the resting position with opacity.
  /// Recommended for [SnackToastPosition.bottom].
  slideUp,

  /// Translates down from above the resting position with opacity.
  /// Recommended for [SnackToastPosition.top].
  slideDown,

  /// Slides in from the right screen edge with opacity fade.
  slideLeft,

  /// Slides in from the left screen edge with opacity fade.
  slideRight,

  /// Pure opacity transition — minimal, non-disruptive ambient style.
  fade,

  /// Scales from 82% with elastic spring overshoot. Feels alive and tactile.
  /// Best for [SnackToastPosition.center] confirmations.
  scaleSpring,

  /// Translates upward with a physics-based `Curves.bounceOut` landing.
  /// Best for positive success notifications.
  bounceUp,

  /// 3D perspective flip on the horizontal axis via `Matrix4.rotateX`.
  /// Creates a premium card-reveal entrance.
  flipReveal,

  // ── v2 styles (new) ──────────────────────────────────────────────────────

  /// Drops from slightly above (y = -40px) with scale (0.95→1.0) and
  /// a soft bounce overshoot on landing.
  /// Designed for [SnackToastPosition.top] positioned toasts.
  fadeDrop,

  /// Rises from slightly below (y = +40px) with scale (0.90→1.0).
  /// The upward sibling of [fadeDrop].
  /// Designed for [SnackToastPosition.bottom] positioned toasts.
  fadeRise,

  /// Scales from 70% with simultaneous blur-to-sharp focus transition.
  /// The card starts blurry (sigma ≈ 8) and sharpens as it scales in.
  /// Designed for [SnackToastPosition.center] toasts.
  centerPop,

  /// Slides in from fully off the left screen edge with an elastic overshoot
  /// and settle. Opacity fades in simultaneously.
  slideFromLeft,

  /// Slides in from fully off the right screen edge with opacity fade.
  /// Mirror of [slideFromLeft].
  slideFromRight,

  /// Originates at the top-left corner and sweeps diagonally toward the
  /// top-center rest position.
  topLeftSweep,

  /// Originates at the top-right corner and sweeps diagonally toward the
  /// top-center rest position.
  topRightSweep,

  /// Originates at the bottom-left corner and sweeps diagonally toward the
  /// bottom-center rest position.
  bottomLeftSweep,

  /// Originates at the bottom-right corner and sweeps toward the
  /// bottom-center rest position with a bounce on arrival.
  bottomRightSweep,

  /// Expands from the screen center with an expanding radial ring that fades
  /// as the card scales in (0.60→1.0). Creates depth and spatial anchoring.
  /// Designed for [SnackToastPosition.center] toasts.
  radialExpansion,
}

// ─────────────────────────────────────────────────────────────────────────────
// Curve resolver
// ─────────────────────────────────────────────────────────────────────────────

/// Resolves motion parameters for each [SnackToastAnimation] variant.
extension SnackToastAnimationResolver on SnackToastAnimation {
  // ── Entrance curves ───────────────────────────────────────────────────────

  /// The easing curve applied to the entrance `AnimationController`.
  Curve get entranceCurve => switch (this) {
        // Physics
        SnackToastAnimation.scaleSpring => Curves.elasticOut,
        SnackToastAnimation.bounceUp => Curves.bounceOut,
        SnackToastAnimation.fadeDrop => Curves.easeOutBack,
        SnackToastAnimation.fadeRise => Curves.easeOutCubic,

        // Atmospheric
        SnackToastAnimation.centerPop => Curves.easeOutExpo,
        SnackToastAnimation.radialExpansion => Curves.easeOutQuart,
        SnackToastAnimation.flipReveal => Curves.easeOutBack,

        // Horizontal edges — tight fast exit from edge
        SnackToastAnimation.slideFromLeft => Curves.easeOutBack,
        SnackToastAnimation.slideFromRight => Curves.easeOutBack,
        SnackToastAnimation.slideLeft => Curves.easeOutQuart,
        SnackToastAnimation.slideRight => Curves.easeOutQuart,

        // Corner sweeps — smooth natural arc
        SnackToastAnimation.topLeftSweep => Curves.easeOutCubic,
        SnackToastAnimation.topRightSweep => Curves.easeOutCubic,
        SnackToastAnimation.bottomLeftSweep => Curves.easeOutCubic,
        SnackToastAnimation.bottomRightSweep => Curves.easeOutBack,
        _ => Curves.easeOutCubic,
      };

  // ── Exit curves ───────────────────────────────────────────────────────────

  /// The easing curve applied during toast exit/dismiss (reverse animation).
  Curve get exitCurve => switch (this) {
        SnackToastAnimation.scaleSpring => Curves.easeInBack,
        SnackToastAnimation.fadeDrop => Curves.easeInCubic,
        SnackToastAnimation.fadeRise => Curves.easeInCubic,
        SnackToastAnimation.flipReveal => Curves.easeIn,
        SnackToastAnimation.centerPop => Curves.easeInExpo,
        SnackToastAnimation.radialExpansion => Curves.easeInQuart,
        SnackToastAnimation.slideFromLeft => Curves.easeInCubic,
        SnackToastAnimation.slideFromRight => Curves.easeInCubic,
        SnackToastAnimation.topLeftSweep => Curves.easeInCubic,
        SnackToastAnimation.topRightSweep => Curves.easeInCubic,
        SnackToastAnimation.bottomLeftSweep => Curves.easeInCubic,
        SnackToastAnimation.bottomRightSweep => Curves.easeInCubic,
        _ => Curves.easeInCubic,
      };

  // ── Duration scaling ──────────────────────────────────────────────────────

  /// Physics and atmospheric animations require a longer entrance duration
  /// to fully express their spring, bounce, or radial arc.
  ///
  /// Returns the configured [animationDuration] scaled by a multiplier,
  /// clamped to a usable range.
  Duration resolvedEntranceDuration(Duration configured) {
    final ms = configured.inMilliseconds;
    return switch (this) {
      // Spring/elastic — needs full arc expression
      SnackToastAnimation.scaleSpring => Duration(
          milliseconds: (ms * 1.8).round().clamp(420, 800),
        ),
      // Bounce landing — needs time to settle
      SnackToastAnimation.bounceUp => Duration(
          milliseconds: (ms * 1.5).round().clamp(360, 700),
        ),
      // fadeDrop bounce overshoot
      SnackToastAnimation.fadeDrop => Duration(
          milliseconds: (ms * 1.4).round().clamp(340, 650),
        ),
      // Radial ripple expands over a slightly longer arc
      SnackToastAnimation.radialExpansion => Duration(
          milliseconds: (ms * 1.35).round().clamp(330, 620),
        ),
      // bottomRightSweep has a bounce — needs extra time
      SnackToastAnimation.bottomRightSweep => Duration(
          milliseconds: (ms * 1.3).round().clamp(320, 600),
        ),
      // All others use configured duration as-is
      _ => configured,
    };
  }

  // ── Semantic metadata ─────────────────────────────────────────────────────

  /// Whether this animation applies a non-trivial Y-axis offset.
  bool get hasVerticalSlide => switch (this) {
        SnackToastAnimation.slideUp => true,
        SnackToastAnimation.slideDown => true,
        SnackToastAnimation.fadeDrop => true,
        SnackToastAnimation.fadeRise => true,
        SnackToastAnimation.bounceUp => true,
        SnackToastAnimation.topLeftSweep => true,
        SnackToastAnimation.topRightSweep => true,
        SnackToastAnimation.bottomLeftSweep => true,
        SnackToastAnimation.bottomRightSweep => true,
        _ => false,
      };

  /// Whether this animation applies a non-trivial X-axis offset.
  bool get hasHorizontalSlide => switch (this) {
        SnackToastAnimation.slideLeft => true,
        SnackToastAnimation.slideRight => true,
        SnackToastAnimation.slideFromLeft => true,
        SnackToastAnimation.slideFromRight => true,
        SnackToastAnimation.topLeftSweep => true,
        SnackToastAnimation.topRightSweep => true,
        SnackToastAnimation.bottomLeftSweep => true,
        SnackToastAnimation.bottomRightSweep => true,
        _ => false,
      };

  /// Whether this animation requires a radial paint layer beneath the card.
  bool get requiresRadialLayer => this == SnackToastAnimation.radialExpansion;

  /// Whether this animation applies a blur filter to the card content.
  bool get requiresBlurFilter => this == SnackToastAnimation.centerPop;
}
