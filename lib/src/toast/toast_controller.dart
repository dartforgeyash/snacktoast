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
class ToastController {
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

  final OverlayState overlayState;
  final SnackToastConfig config;
  final String message;
  final String? title;
  final SnackToastType type;
  final SnackToastPosition position;
  final Duration? duration;
  final Widget? customIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Widget? customWidget;
  final SnackToastAnimation? animationStyleOverride;
  final dynamic visualStyleOverride;
  final VoidCallback? onDismissed;
  final Color? titleColor;
  final TextStyle? titleStyle;
  final double? minWidth;
  final bool? wrapContent;
  final BoxDecoration? decorationOverride;
  final Color? messageColor;
  final TextStyle? messageStyle;
  final double? fixedHeight;
  final double? fixedWidth;

  late AnimationController _entranceController;
  late AnimationController _iconController;
  late AnimationController _progressController;

  late Animation<double> entranceAnimation;
  late Animation<double> iconAnimation;
  late Animation<double> progressAnimation;

  bool _isDisposed = false;
  final Completer<void> _completer = Completer<void>();

  Future<void> get future => _completer.future;

  SnackToastAnimation get _resolvedAnimation =>
      animationStyleOverride ?? config.resolvedAnimationForPosition(position);

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

  void dismiss() {
    if (_isDisposed) return;
    _progressController.stop();
    _iconController.stop();
    _entranceController.reverse().then((_) {
      if (!_isDisposed) _cleanup();
    });
  }

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
