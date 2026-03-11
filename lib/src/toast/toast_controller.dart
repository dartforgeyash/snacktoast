import 'dart:async';

import 'package:flutter/material.dart';
import '../core/snacktoast_animation.dart';
import '../core/snacktoast_config.dart';
import '../core/snacktoast_position.dart';
import '../core/snacktoast_type.dart';
import 'toast_widget.dart';

/// Manages the full lifecycle of a single toast with three coordinated
/// animation phases.
///
/// ## Bug fix — swipe dismiss (v2.2)
///
/// `onDismiss` is now **always** passed as `dismiss` to [ToastWidget],
/// regardless of `config.dismissOnTap`. Previously it was passed as
/// `config.dismissOnTap ? dismiss : null`, which silently made swipe
/// dismiss a no-op when `dismissOnTap: false` — requiring two swipes.
///
/// [ToastWidget] now gates tap vs. swipe usage internally via config flags.
/// Manages the full lifecycle of a single toast with coordinated animation phases.
class ToastController {
  /// Creates a [ToastController].
  ToastController({
    required this.overlayState,
    required this.config,
    required this.message,
    required this.type,
    required this.position,
    this.title,
    this.duration,
    this.customIcon,
    this.backgroundColor,
    this.foregroundColor,
    this.customWidget,
    this.animationStyleOverride,
    this.visualStyleOverride,
    this.onDismissed,
    this.titleColor,
    this.titleStyle,
    this.minWidth,
    this.wrapContent,
    this.decorationOverride,
    this.messageColor,
    this.messageStyle,
    this.fixedHeight,
    this.fixedWidth,
  });

  /// The [OverlayState] where the toast is displayed.
  final OverlayState overlayState;

  /// The global configuration.
  final SnackToastConfig config;

  /// The main message text.
  final String message;

  /// Optional title text.
  final String? title;

  /// The semantic type of the toast.
  final SnackToastType type;

  /// The screen position.
  final SnackToastPosition position;

  /// How long the toast should be displayed.
  final Duration? duration;

  /// Optional custom icon widget.
  final Widget? customIcon;

  /// Optional background color override.
  final Color? backgroundColor;

  /// Optional foreground color override.
  final Color? foregroundColor;

  /// Optional custom widget to replace the entire toast content.
  final Widget? customWidget;

  /// Optional animation style override.
  final SnackToastAnimation? animationStyleOverride;

  /// Optional visual style override.
  final dynamic visualStyleOverride;

  /// Callback triggered when the toast is dismissed.
  final VoidCallback? onDismissed;

  /// Optional title color override.
  final Color? titleColor;

  /// Optional title text style override.
  final TextStyle? titleStyle;

  /// Optional minimum width override.
  final double? minWidth;

  /// Optional wrap content override.
  final bool? wrapContent;

  /// Optional decoration override for the toast card.
  final BoxDecoration? decorationOverride;

  /// Optional message color override.
  final Color? messageColor;

  /// Optional message text style override.
  final TextStyle? messageStyle;

  /// Optional fixed height override.
  final double? fixedHeight;

  /// Optional fixed width override.
  final double? fixedWidth;

  /// Animation for the entrance and exit phase.
  late Animation<double> entranceAnimation;

  /// Animation for the icon micro-animation phase.
  late Animation<double> iconAnimation;

  /// Animation for the progress bar countdown phase.
  late Animation<double> progressAnimation;

  late AnimationController _entranceController;
  late AnimationController _iconController;
  late AnimationController _progressController;

  bool _isDisposed = false;
  final Completer<void> _completer = Completer<void>();

  /// Returns a future that completes when the toast is fully dismissed and disposed.
  Future<void> get future => _completer.future;

  SnackToastAnimation get _resolvedAnimation =>
      animationStyleOverride ?? config.resolvedAnimationForPosition(position);

  /// Starts the entrance animation and timer.
  void show(TickerProvider vsync) {
    final animStyle = _resolvedAnimation;
    final holdDuration = duration ?? config.defaultDuration;

    _entranceController = AnimationController(
      vsync: vsync,
      duration: animStyle.resolvedEntranceDuration(config.animationDuration),
      reverseDuration: config.animationDuration,
    );
    _iconController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 650),
    );
    _progressController = AnimationController(
      vsync: vsync,
      duration: holdDuration,
    );

    entranceAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: animStyle.entranceCurve,
      reverseCurve: animStyle.exitCurve,
    );
    iconAnimation = CurvedAnimation(
      parent: _iconController,
      curve: Curves.elasticOut,
    );
    progressAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_progressController);

    _entranceController.forward().then((_) {
      if (_isDisposed) return;
      _progressController.forward().then((_) {
        if (_isDisposed) return;
        dismiss();
      });
    });

    if (config.animateIcon) {
      Future<void>.delayed(const Duration(milliseconds: 50), () {
        if (!_isDisposed) _iconController.forward();
      });
    } else {
      _iconController.value = 1.0;
    }
  }

  /// Builds the toast widget tree.
  Widget buildWidget() {
    return Positioned.fill(
      child: Align(
        alignment: _resolvedAlignment,
        child: ToastWidget(
          message: message,
          title: title,
          type: type,
          config: config,
          position: position,
          entranceAnimation: entranceAnimation,
          iconAnimation: iconAnimation,
          progressAnimation: progressAnimation,
          animationStyle: _resolvedAnimation,
          visualStyleOverride: visualStyleOverride,
          customIcon: customIcon,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          customWidget: customWidget,
          // BUG FIX: always pass dismiss — NOT gated by config.dismissOnTap.
          // ToastWidget gates tap via config.dismissOnTap internally.
          // ToastWidget gates swipe via config.enableSwipeToDismiss internally.
          onDismiss: dismiss,
          titleColor: titleColor,
          titleStyle: titleStyle,
          minWidth: minWidth,
          wrapContent: wrapContent,
          decorationOverride: decorationOverride,
          messageColor: messageColor,
          messageStyle: messageStyle,
          fixedHeight: fixedHeight,
          fixedWidth: fixedWidth,
        ),
      ),
    );
  }

  AlignmentGeometry get _resolvedAlignment {
    switch (_resolvedAnimation) {
      case SnackToastAnimation.topLeftSweep:
      case SnackToastAnimation.topRightSweep:
        return Alignment.topCenter;
      case SnackToastAnimation.bottomLeftSweep:
      case SnackToastAnimation.bottomRightSweep:
        return Alignment.bottomCenter;
      default:
        break;
    }
    return switch (position) {
      SnackToastPosition.top => Alignment.topCenter,
      SnackToastPosition.center => Alignment.center,
      SnackToastPosition.bottom => Alignment.bottomCenter,
    };
  }

  /// Triggers the exit animation.
  void dismiss() {
    if (_isDisposed) return;
    _progressController.stop();
    _iconController.stop();
    _entranceController.reverse().then((_) {
      if (!_isDisposed) _cleanup();
    });
  }

  /// Disposes of all controllers and completes the future.
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    _progressController.dispose();
    _iconController.dispose();
    _entranceController.dispose();
    if (!_completer.isCompleted) _completer.complete();
  }

  void _cleanup() {
    dispose();
    onDismissed?.call();
  }
}
