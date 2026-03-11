import 'package:flutter/material.dart';
import 'snacktoast_animation.dart';
import 'snacktoast_position.dart';
import 'snacktoast_style.dart';
import 'snacktoast_type.dart';

/// Global configuration applied to all notifications unless overridden per-call.
class SnackToastConfig {
  /// Creates a global configuration for SnackToast notifications.
  const SnackToastConfig({
    // ── Timing ──────────────────────────────────────────────
    /// The default duration for which a notification is displayed.
    this.defaultDuration = const Duration(seconds: 3),

    /// The duration of entrance and exit animations.
    this.animationDuration = const Duration(milliseconds: 300),
    // ── Layout ──────────────────────────────────────────────
    /// The default position on the screen where notifications appear.
    this.defaultPosition = SnackToastPosition.bottom,

    /// The default border radius for notification cards.
    this.defaultBorderRadius = 16.0,

    /// The default elevation (shadow depth) for notification cards.
    this.defaultElevation = 6.0,

    /// The default internal padding for notification cards.
    this.defaultPadding = const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 14.0,
    ),

    /// The default margin from screen edges.
    this.defaultMargin = const EdgeInsets.symmetric(
      horizontal: 20.0,
      vertical: 48.0,
    ),
    // ── Queue ────────────────────────────────────────────────
    /// The maximum number of notifications allowed in the queue.
    this.maxQueueSize = 5,
    // ── Semantic colors ──────────────────────────────────────
    /// Color used for success notifications.
    this.successColor = const Color(0xFF1B8A4A),

    /// Color used for error notifications.
    this.errorColor = const Color(0xFFD32F2F),

    /// Color used for warning notifications.
    this.warningColor = const Color(0xFFE65100),

    /// Color used for info notifications.
    this.infoColor = const Color(0xFF0277BD),
    // ── Icon ─────────────────────────────────────────────────
    /// Base text style for notification messages.
    this.textStyle,

    /// Size of the icons in the notification.
    this.iconSize = 22.0,

    /// Whether to show the semantic icon.
    this.showIcon = true,
    // ── Behavioral ───────────────────────────────────────────
    /// Whether the notification should be dismissed when tapped.
    this.dismissOnTap = true,

    /// Whether horizontal swipe-to-dismiss is enabled.
    this.enableSwipeToDismiss = true,
    // ── Animation ────────────────────────────────────────────
    /// Global animation style. If null, automatically selects based on position.
    this.animationStyle, // null = auto-select by position
    /// Whether to enable the icon's elastic micro-animation.
    this.animateIcon = true,
    // ── Visual ───────────────────────────────────────────────
    /// The visual rendering style (standard, glass, gradient, etc.).
    this.visualStyle = SnackToastVisualStyle.standard,

    /// Whether to show an animated progress bar countdown.
    this.showProgressBar = false,

    /// Height of the progress bar in logical pixels.
    this.progressBarHeight = 3.0,

    /// Blur intensity for the frosted glass visual style.
    this.glassBlurIntensity = 18.0,
    // ── v2.1.0 Sizing ───────────────────────────────────────
    /// Whether the card should wrap its content width.
    this.wrapContent = true,

    /// Optional fixed height for the notification.
    this.fixedHeight,

    /// Optional fixed width for the notification.
    this.fixedWidth,

    /// Optional minimum width for the notification.
    this.minWidth,
    // ── v2.1.0 Role Styles ──────────────────────────────────
    /// Optional color for the title text.
    this.titleColor,

    /// Optional color for the message text.
    this.messageColor,

    /// Optional text style for the title.
    this.titleStyle,

    /// Optional text style for the message.
    this.messageStyle,

    /// Optional custom decoration for the entire card.
    this.decorationOverride,
  });

  // Timing
  /// The default duration for which a notification is displayed.
  final Duration defaultDuration;

  /// The duration of entrance and exit animations.
  final Duration animationDuration;

  /// The default position on the screen where notifications appear.
  final SnackToastPosition defaultPosition;

  /// The default border radius for notification cards.
  final double defaultBorderRadius;

  /// The default elevation (shadow depth) for notification cards.
  final double defaultElevation;

  /// The default internal padding for notification cards.
  final EdgeInsets defaultPadding;

  /// The default margin from screen edges.
  final EdgeInsets defaultMargin;

  /// The maximum number of notifications allowed in the queue.
  final int maxQueueSize;

  /// Color used for success notifications.
  final Color successColor;

  /// Color used for error notifications.
  final Color errorColor;

  /// Color used for warning notifications.
  final Color warningColor;

  /// Color used for info notifications.
  final Color infoColor;

  /// Base text style for notification messages.
  final TextStyle? textStyle;

  /// Size of the icons in the notification.
  final double iconSize;

  /// Whether to show the semantic icon.
  final bool showIcon;

  /// Whether the notification should be dismissed when tapped.
  final bool dismissOnTap;

  /// Whether horizontal swipe-to-dismiss is enabled.
  final bool enableSwipeToDismiss;

  /// Global animation style. If null, automatically selects based on position.
  final SnackToastAnimation? animationStyle;

  /// Whether to enable the icon's elastic micro-animation.
  final bool animateIcon;

  /// The visual rendering style (standard, glass, gradient, etc.).
  final SnackToastVisualStyle visualStyle;

  /// Whether to show an animated progress bar countdown.
  final bool showProgressBar;

  /// Height of the progress bar in logical pixels.
  final double progressBarHeight;

  /// Blur intensity for the frosted glass visual style.
  final double glassBlurIntensity;

  /// Whether the card should wrap its content width.
  final bool wrapContent;

  /// Optional fixed height for the notification.
  final double? fixedHeight;

  /// Optional fixed width for the notification.
  final double? fixedWidth;

  /// Optional minimum width for the notification.
  final double? minWidth;

  /// Optional color for the title text.
  final Color? titleColor;

  /// Optional color for the message text.
  final Color? messageColor;

  /// Optional text style for the title.
  final TextStyle? titleStyle;

  /// Optional text style for the message.
  final TextStyle? messageStyle;

  /// Optional custom decoration for the entire card.
  final BoxDecoration? decorationOverride;

  // ─────────────────────────────────────────────────────────

  /// Returns the color associated with a given [type] based on this configuration.
  Color colorForType(SnackToastType type) => switch (type) {
        SnackToastType.success => successColor,
        SnackToastType.error => errorColor,
        SnackToastType.warning => warningColor,
        SnackToastType.info => infoColor,
        SnackToastType.custom => const Color(0xFF37474F),
      };

  /// Returns the default icon for a given [type].
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

  /// Creates a copy of this configuration with the given fields replaced by new values.
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
