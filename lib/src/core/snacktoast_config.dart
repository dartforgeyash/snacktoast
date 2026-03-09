import 'package:flutter/material.dart';
import 'snacktoast_animation.dart';
import 'snacktoast_position.dart';
import 'snacktoast_style.dart';
import 'snacktoast_type.dart';

/// Global configuration applied to all notifications unless overridden per-call.
class SnackToastConfig {
  const SnackToastConfig({
    // ── Timing ──────────────────────────────────────────────
    this.defaultDuration = const Duration(seconds: 3),
    this.animationDuration = const Duration(milliseconds: 300),
    // ── Layout ──────────────────────────────────────────────
    this.defaultPosition = SnackToastPosition.bottom,
    this.defaultBorderRadius = 16.0,
    this.defaultElevation = 6.0,
    this.defaultPadding = const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 14.0,
    ),
    this.defaultMargin = const EdgeInsets.symmetric(
      horizontal: 20.0,
      vertical: 48.0,
    ),
    // ── Queue ────────────────────────────────────────────────
    this.maxQueueSize = 5,
    // ── Semantic colors ──────────────────────────────────────
    this.successColor = const Color(0xFF1B8A4A),
    this.errorColor = const Color(0xFFD32F2F),
    this.warningColor = const Color(0xFFE65100),
    this.infoColor = const Color(0xFF0277BD),
    // ── Icon ─────────────────────────────────────────────────
    this.textStyle,
    this.iconSize = 22.0,
    this.showIcon = true,
    // ── Behavioral ───────────────────────────────────────────
    this.dismissOnTap = true,
    this.enableSwipeToDismiss = true,
    // ── Animation ────────────────────────────────────────────
    this.animationStyle, // null = auto-select by position
    this.animateIcon = true,
    // ── Visual ───────────────────────────────────────────────
    this.visualStyle = SnackToastVisualStyle.standard,
    this.showProgressBar = false,
    this.progressBarHeight = 3.0,
    this.glassBlurIntensity = 18.0,
    // ── v2.1.0 Sizing ───────────────────────────────────────
    this.wrapContent = true,
    this.fixedHeight,
    this.fixedWidth,
    this.minWidth,
    // ── v2.1.0 Role Styles ──────────────────────────────────
    this.titleColor,
    this.messageColor,
    this.titleStyle,
    this.messageStyle,
    this.decorationOverride,
  });

  // Timing
  final Duration defaultDuration;
  final Duration animationDuration;

  // Layout
  final SnackToastPosition defaultPosition;
  final double defaultBorderRadius;
  final double defaultElevation;
  final EdgeInsets defaultPadding;
  final EdgeInsets defaultMargin;

  // Queue
  final int maxQueueSize;

  // Colors
  final Color successColor;
  final Color errorColor;
  final Color warningColor;
  final Color infoColor;

  // Icon / text
  final TextStyle? textStyle;
  final double iconSize;
  final bool showIcon;

  // Behavior
  final bool dismissOnTap;
  final bool enableSwipeToDismiss;

  // Animation
  final SnackToastAnimation? animationStyle;
  final bool animateIcon;

  // Visual
  final SnackToastVisualStyle visualStyle;
  final bool showProgressBar;
  final double progressBarHeight;
  final double glassBlurIntensity;

  // Sizing
  final bool wrapContent;
  final double? fixedHeight;
  final double? fixedWidth;
  final double? minWidth;

  // Role Styles
  final Color? titleColor;
  final Color? messageColor;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;
  final BoxDecoration? decorationOverride;

  // ─────────────────────────────────────────────────────────

  Color colorForType(SnackToastType type) => switch (type) {
        SnackToastType.success => successColor,
        SnackToastType.error => errorColor,
        SnackToastType.warning => warningColor,
        SnackToastType.info => infoColor,
        SnackToastType.custom => const Color(0xFF37474F),
      };

  IconData iconForType(SnackToastType type) => switch (type) {
        SnackToastType.success => Icons.check_circle_rounded,
        SnackToastType.error => Icons.error_rounded,
        SnackToastType.warning => Icons.warning_rounded,
        SnackToastType.info => Icons.info_rounded,
        SnackToastType.custom => Icons.notifications_rounded,
      };

  /// Resolves which animation to use, auto-selecting based on position
  /// when [animationStyle] is null.
  SnackToastAnimation resolvedAnimationForPosition(
    SnackToastPosition position,
  ) {
    if (animationStyle != null) return animationStyle!;
    return switch (position) {
      SnackToastPosition.top => SnackToastAnimation.slideDown,
      SnackToastPosition.center => SnackToastAnimation.scaleSpring,
      SnackToastPosition.bottom => SnackToastAnimation.slideUp,
    };
  }

  SnackToastConfig copyWith({
    Duration? defaultDuration,
    Duration? animationDuration,
    SnackToastPosition? defaultPosition,
    double? defaultBorderRadius,
    double? defaultElevation,
    EdgeInsets? defaultPadding,
    EdgeInsets? defaultMargin,
    int? maxQueueSize,
    Color? successColor,
    Color? errorColor,
    Color? warningColor,
    Color? infoColor,
    TextStyle? textStyle,
    double? iconSize,
    bool? showIcon,
    bool? dismissOnTap,
    bool? enableSwipeToDismiss,
    SnackToastAnimation? animationStyle,
    bool? animateIcon,
    SnackToastVisualStyle? visualStyle,
    bool? showProgressBar,
    double? progressBarHeight,
    double? glassBlurIntensity,
    bool? wrapContent,
    double? fixedHeight,
    double? fixedWidth,
    double? minWidth,
    Color? titleColor,
    Color? messageColor,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
    BoxDecoration? decorationOverride,
  }) {
    return SnackToastConfig(
      defaultDuration: defaultDuration ?? this.defaultDuration,
      animationDuration: animationDuration ?? this.animationDuration,
      defaultPosition: defaultPosition ?? this.defaultPosition,
      defaultBorderRadius: defaultBorderRadius ?? this.defaultBorderRadius,
      defaultElevation: defaultElevation ?? this.defaultElevation,
      defaultPadding: defaultPadding ?? this.defaultPadding,
      defaultMargin: defaultMargin ?? this.defaultMargin,
      maxQueueSize: maxQueueSize ?? this.maxQueueSize,
      successColor: successColor ?? this.successColor,
      errorColor: errorColor ?? this.errorColor,
      warningColor: warningColor ?? this.warningColor,
      infoColor: infoColor ?? this.infoColor,
      textStyle: textStyle ?? this.textStyle,
      iconSize: iconSize ?? this.iconSize,
      showIcon: showIcon ?? this.showIcon,
      dismissOnTap: dismissOnTap ?? this.dismissOnTap,
      enableSwipeToDismiss: enableSwipeToDismiss ?? this.enableSwipeToDismiss,
      animationStyle: animationStyle ?? this.animationStyle,
      animateIcon: animateIcon ?? this.animateIcon,
      visualStyle: visualStyle ?? this.visualStyle,
      showProgressBar: showProgressBar ?? this.showProgressBar,
      progressBarHeight: progressBarHeight ?? this.progressBarHeight,
      glassBlurIntensity: glassBlurIntensity ?? this.glassBlurIntensity,
      wrapContent: wrapContent ?? this.wrapContent,
      fixedHeight: fixedHeight ?? this.fixedHeight,
      fixedWidth: fixedWidth ?? this.fixedWidth,
      minWidth: minWidth ?? this.minWidth,
      titleColor: titleColor ?? this.titleColor,
      messageColor: messageColor ?? this.messageColor,
      titleStyle: titleStyle ?? this.titleStyle,
      messageStyle: messageStyle ?? this.messageStyle,
      decorationOverride: decorationOverride ?? this.decorationOverride,
    );
  }
}
