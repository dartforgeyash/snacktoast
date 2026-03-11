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
/// A widget that hosts the toast's overlay entry and provides a [TickerProvider].
class ToastOverlayHost extends StatefulWidget {
  /// Creates a [ToastOverlayHost].
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

  /// The [OverlayState] where the toast is inserted.
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

  /// Callback triggered when the controller is ready.
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
