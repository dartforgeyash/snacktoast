/// SnackToast — animated notification system.
///
/// Quick start:
/// ```dart
/// import 'package:snacktoast/snacktoast.dart';
///
/// SnackToastKit.configure(const SnackToastConfig(
///   defaultPosition: SnackToastPosition.bottom,
///   visualStyle: SnackToastVisualStyle.gradient,
///   animationStyle: SnackToastAnimation.slideUp,
///   showProgressBar: true,
/// ));
///
/// // Use context-free via navigatorKey (set on MaterialApp):
/// SnackToastKit.success('Saved!');
/// SnackToastKit.error('Network error', visualStyle: SnackToastVisualStyle.minimal);
///
/// // Per-call animation override:
/// SnackToastKit.toast('Hello!', animationStyle: SnackToastAnimation.flipReveal);
/// ```
library;

export 'src/core/snacktoast_animation.dart';
export 'src/core/snacktoast_config.dart';
export 'src/core/snacktoast_position.dart';
export 'src/core/snacktoast_style.dart';
export 'src/core/snacktoast_type.dart';
export 'src/notifier/snacktoast_kit_impl.dart';
export 'src/snackbar/snacktoast_snackbar.dart' show SnackbarParams;
export 'src/toast/toast_widget.dart';

export 'package:flutter/material.dart' show SnackBarAction, SnackBarBehavior;
