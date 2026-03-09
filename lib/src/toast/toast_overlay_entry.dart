import 'package:flutter/material.dart';
import '../core/snacktoast_animation.dart';
import '../core/snacktoast_config.dart';
import '../core/snacktoast_position.dart';
import '../core/snacktoast_type.dart';
import 'toast_controller.dart';

/// Inserted into the Overlay solely to provide a [TickerProvider]
/// (via [TickerProviderStateMixin]) to [ToastController].
///
/// Changed from [SingleTickerProviderStateMixin] to [TickerProviderStateMixin]
/// because [ToastController] now manages three [AnimationController]s.
class ToastOverlayHost extends StatefulWidget {
  const ToastOverlayHost({
    super.key,
    required this.overlayState,
    required this.config,
    required this.message,
    required this.type,
    required this.position,
    required this.onReady,
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
  final void Function(ToastController controller) onReady;

  @override
  State<ToastOverlayHost> createState() => _ToastOverlayHostState();
}

class _ToastOverlayHostState extends State<ToastOverlayHost>
    // ← TickerProviderStateMixin supports multiple AnimationControllers
    with
        TickerProviderStateMixin {
  late final ToastController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ToastController(
      overlayState: widget.overlayState,
      config: widget.config,
      message: widget.message,
      title: widget.title,
      type: widget.type,
      position: widget.position,
      duration: widget.duration,
      customIcon: widget.customIcon,
      backgroundColor: widget.backgroundColor,
      foregroundColor: widget.foregroundColor,
      customWidget: widget.customWidget,
      animationStyleOverride: widget.animationStyleOverride,
      visualStyleOverride: widget.visualStyleOverride,
      onDismissed: widget.onDismissed,
      titleColor: widget.titleColor,
      titleStyle: widget.titleStyle,
      minWidth: widget.minWidth,
      wrapContent: widget.wrapContent,
      decorationOverride: widget.decorationOverride,
      messageColor: widget.messageColor,
      messageStyle: widget.messageStyle,
      fixedHeight: widget.fixedHeight,
      fixedWidth: widget.fixedWidth,
    );
    widget.onReady(_controller);
    _controller.show(this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _controller.buildWidget();
}
