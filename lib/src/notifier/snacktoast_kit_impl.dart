import 'dart:async';

import 'package:flutter/material.dart';
import '../core/snacktoast_animation.dart';
import '../core/snacktoast_config.dart';
import '../core/snacktoast_position.dart';
import '../core/snacktoast_queue.dart';
import '../core/snacktoast_style.dart';
import '../core/snacktoast_type.dart';
import '../snackbar/snacktoast_snackbar.dart';
import '../toast/toast_controller.dart';
import '../toast/toast_overlay_entry.dart';

/// Primary static facade for the snacktoast package.
class SnackToastKit {
  SnackToastKit._();

  static SnackToastConfig _config = const SnackToastConfig();
  static SnackToastQueue _queue =
      SnackToastQueue(maxSize: _config.maxQueueSize);

  /// Global key for [NavigatorState] to enable context-free toasts.
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Global key for [ScaffoldMessengerState] to enable context-free snackbars.
  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static final List<ToastController> _activeToasts = [];

  /// Resets the global configuration, queue, and keys to their initial state.
  /// Useful for testing.
  static void reset() {
    _config = const SnackToastConfig();
    _queue = SnackToastQueue(maxSize: _config.maxQueueSize);
    navigatorKey = GlobalKey<NavigatorState>();
    scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
    _activeToasts.clear();
  }

  /// Configures the global settings for all notifications.
  static void configure(SnackToastConfig config) {
    _config = config;
    _queue = SnackToastQueue(maxSize: config.maxQueueSize);
  }

  /// Returns the current global configuration.
  static SnackToastConfig get config => _config;

  /// Shows a toast notification.
  ///
  /// [message] is the body text of the toast.
  /// [context] is optional if [navigatorKey] is attached to [MaterialApp].
  /// [title] is an optional header text.
  /// [type] defines the semantic style (success, error, etc.).
  /// [position] defaults to [SnackToastConfig.defaultPosition].
  /// [duration] defaults to [SnackToastConfig.defaultDuration].
  /// [queued] if true (default), wait for previous toasts to dismiss.
  static void toast(
    String message, {
    BuildContext? context,
    String? title,
    SnackToastType type = SnackToastType.info,
    SnackToastPosition? position,
    Duration? duration,
    Widget? customIcon,
    Color? backgroundColor,
    Color? foregroundColor,
    Widget? customWidget,
    SnackToastAnimation? animationStyle,
    SnackToastVisualStyle? visualStyle,
    VoidCallback? onDismissed,
    bool queued = true,
    Color? titleColor,
    TextStyle? titleStyle,
    Color? messageColor,
    TextStyle? messageStyle,
    double? minWidth,
    bool? wrapContent,
    BoxDecoration? decorationOverride,
    double? fixedHeight,
    double? fixedWidth,
  }) {
    final overlayState = _resolveOverlayState(context);
    if (overlayState == null) {
      assert(false, '[snacktoast] Cannot find OverlayState.');
      return;
    }

    Future<void> task() => _showToastInternal(
          overlayState: overlayState,
          message: message,
          title: title,
          type: type,
          position: position ?? _config.defaultPosition,
          duration: duration,
          customIcon: customIcon,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          customWidget: customWidget,
          animationStyleOverride: animationStyle,
          visualStyleOverride: visualStyle,
          onDismissed: onDismissed,
          titleColor: titleColor,
          titleStyle: titleStyle,
          messageColor: messageColor,
          messageStyle: messageStyle,
          minWidth: minWidth,
          wrapContent: wrapContent,
          decorationOverride: decorationOverride,
          fixedHeight: fixedHeight,
          fixedWidth: fixedWidth,
        );

    if (queued) {
      _queue.enqueue(task);
    } else {
      task();
    }
  }

  static Future<void> _showToastInternal({
    required OverlayState overlayState,
    required String message,
    required SnackToastType type,
    required SnackToastPosition position,
    String? title,
    Duration? duration,
    Widget? customIcon,
    Color? backgroundColor,
    Color? foregroundColor,
    Widget? customWidget,
    SnackToastAnimation? animationStyleOverride,
    SnackToastVisualStyle? visualStyleOverride,
    VoidCallback? onDismissed,
    Color? titleColor,
    TextStyle? titleStyle,
    Color? messageColor,
    TextStyle? messageStyle,
    double? minWidth,
    bool? wrapContent,
    BoxDecoration? decorationOverride,
    double? fixedHeight,
    double? fixedWidth,
  }) {
    final completer = _HostCompleter();
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => ToastOverlayHost(
        overlayState: overlayState,
        config: _config,
        message: message,
        title: title,
        type: type,
        position: position,
        duration: duration,
        customIcon: customIcon,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        customWidget: customWidget,
        animationStyleOverride: animationStyleOverride,
        visualStyleOverride: visualStyleOverride,
        titleColor: titleColor,
        titleStyle: titleStyle,
        messageColor: messageColor,
        messageStyle: messageStyle,
        minWidth: minWidth,
        wrapContent: wrapContent,
        decorationOverride: decorationOverride,
        fixedHeight: fixedHeight,
        fixedWidth: fixedWidth,
        onReady: (controller) {
          _activeToasts.add(controller);
          completer.controller = controller;
        },
        onDismissed: () {
          entry.remove();
          _activeToasts.removeWhere((c) => c == completer.controller);
          onDismissed?.call();
          completer.complete();
        },
      ),
    );

    overlayState.insert(entry);
    return completer.future;
  }

  /// Shows a snackbar notification via [ScaffoldMessenger].
  ///
  /// [message] is the body text of the snackbar.
  /// [context] is optional if [scaffoldMessengerKey] is attached to [MaterialApp].
  /// [type] defines the semantic style.
  static void snackbar(
    String message, {
    BuildContext? context,
    String? title,
    SnackToastType type = SnackToastType.info,
    Duration? duration,
    SnackBarAction? action,
    Color? backgroundColor,
    Color? foregroundColor,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    SnackToastVisualStyle? visualStyle,
    Color? titleColor,
    TextStyle? titleStyle,
    Color? messageColor,
    TextStyle? messageStyle,
    double? minWidth,
    bool? wrapContent,
    BoxDecoration? decorationOverride,
    double? fixedHeight,
    double? fixedWidth,
  }) {
    final params = SnackbarParams(
      message: message,
      title: title,
      type: type,
      config: _config,
      duration: duration,
      action: action,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      behavior: behavior,
      visualStyleOverride: visualStyle,
      titleColor: titleColor,
      titleStyleOverride: titleStyle,
      messageColorOverride: messageColor,
      messageStyleOverride: messageStyle,
      minWidthOverride: minWidth,
      wrapContentOverride: wrapContent,
      decorationOverride: decorationOverride,
      fixedHeightOverride: fixedHeight,
      fixedWidthOverride: fixedWidth,
    );

    if (context != null) {
      SnackToastSnackbar.showWithContext(context, params);
    } else {
      SnackToastSnackbar.showWithKey(scaffoldMessengerKey, params);
    }
  }

  // ── Convenience ──────────────────────────────────────────────────────────

  /// Shows a success toast notification.
  static void success(String message,
          {BuildContext? context,
          String? title,
          SnackToastVisualStyle? visualStyle,
          SnackToastAnimation? animationStyle}) =>
      toast(message,
          context: context,
          title: title,
          type: SnackToastType.success,
          visualStyle: visualStyle,
          animationStyle: animationStyle);

  /// Shows an error toast notification.
  static void error(String message,
          {BuildContext? context,
          String? title,
          SnackToastVisualStyle? visualStyle,
          SnackToastAnimation? animationStyle}) =>
      toast(message,
          context: context,
          title: title,
          type: SnackToastType.error,
          visualStyle: visualStyle,
          animationStyle: animationStyle);

  /// Shows a warning toast notification.
  static void warning(String message,
          {BuildContext? context,
          String? title,
          SnackToastVisualStyle? visualStyle,
          SnackToastAnimation? animationStyle}) =>
      toast(message,
          context: context,
          title: title,
          type: SnackToastType.warning,
          visualStyle: visualStyle,
          animationStyle: animationStyle);

  /// Shows an info toast notification.
  static void info(String message,
          {BuildContext? context,
          String? title,
          SnackToastVisualStyle? visualStyle,
          SnackToastAnimation? animationStyle}) =>
      toast(message,
          context: context,
          title: title,
          type: SnackToastType.info,
          visualStyle: visualStyle,
          animationStyle: animationStyle);

  /// Shows a success snackbar.
  static void snackbarSuccess(String message,
          {BuildContext? context, String? title}) =>
      snackbar(message,
          context: context, title: title, type: SnackToastType.success);

  /// Shows an error snackbar.
  static void snackbarError(String message,
          {BuildContext? context, String? title}) =>
      snackbar(message,
          context: context, title: title, type: SnackToastType.error);

  /// Shows a warning snackbar.
  static void snackbarWarning(String message,
          {BuildContext? context, String? title}) =>
      snackbar(message,
          context: context, title: title, type: SnackToastType.warning);

  /// Shows an info snackbar.
  static void snackbarInfo(String message,
          {BuildContext? context, String? title}) =>
      snackbar(message,
          context: context, title: title, type: SnackToastType.info);

  /// Dismisses all visible toasts and clears the pending queue.
  static void dismissAll() {
    for (final controller in List<ToastController>.from(_activeToasts)) {
      controller.dismiss();
    }
    _queue.clear();
  }

  static OverlayState? _resolveOverlayState(BuildContext? context) {
    if (context != null) return Overlay.of(context);
    return navigatorKey.currentState?.overlay;
  }
}

class _HostCompleter {
  ToastController? controller;
  final _completer = Completer<void>();
  Future<void> get future => _completer.future;
  void complete() {
    if (!_completer.isCompleted) _completer.complete();
  }
}
