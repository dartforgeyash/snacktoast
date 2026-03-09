import 'package:flutter/material.dart';
import '../core/snacktoast_config.dart';
import '../core/snacktoast_style.dart';
import '../core/snacktoast_type.dart';

class SnackbarParams {
  const SnackbarParams({
    required this.message,
    required this.type,
    required this.config,
    this.title,
    this.duration,
    this.action,
    this.backgroundColor,
    this.foregroundColor,
    this.behavior = SnackBarBehavior.floating,
    this.visualStyleOverride,
    this.titleColor,
    this.titleStyleOverride,
    this.messageColorOverride,
    this.messageStyleOverride,
    this.minWidthOverride,
    this.wrapContentOverride,
    this.decorationOverride,
    this.fixedHeightOverride,
    this.fixedWidthOverride,
  });

  final String message;
  final String? title;
  final SnackToastType type;
  final SnackToastConfig config;
  final Duration? duration;
  final SnackBarAction? action;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final SnackBarBehavior behavior;
  final SnackToastVisualStyle? visualStyleOverride;
  final Color? titleColor;
  final TextStyle? titleStyleOverride;
  final Color? messageColorOverride;
  final TextStyle? messageStyleOverride;
  final double? minWidthOverride;
  final bool? wrapContentOverride;
  final BoxDecoration? decorationOverride;
  final double? fixedHeightOverride;
  final double? fixedWidthOverride;
}

class SnackToastSnackbar {
  const SnackToastSnackbar._();

  static void showWithContext(BuildContext context, SnackbarParams params) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(_buildSnackBar(params));
  }

  static void showWithKey(
      GlobalKey<ScaffoldMessengerState> key, SnackbarParams params) {
    key.currentState
      ?..clearSnackBars()
      ..showSnackBar(_buildSnackBar(params));
  }

  static SnackBar buildSnackBar(SnackbarParams p) => _buildSnackBar(p);

  static SnackBar _buildSnackBar(SnackbarParams p) {
    final typeColor = p.backgroundColor ?? p.config.colorForType(p.type);
    final style = p.visualStyleOverride ?? p.config.visualStyle;
    final radius = p.config.defaultBorderRadius;

    final Color bg;
    final Color fg;

    switch (style) {
      case SnackToastVisualStyle.minimal:
        bg = Colors.white;
        fg = const Color(0xFF1A1A2E);
      case SnackToastVisualStyle.outlined:
        bg = Colors.white.withValues(alpha: 0.06);
        fg = typeColor;
      default:
        bg = typeColor;
        fg = p.foregroundColor ?? Colors.white;
    }

    final wrap = p.wrapContentOverride ?? p.config.wrapContent;

    return SnackBar(
      duration: p.duration ?? p.config.defaultDuration,
      backgroundColor: bg,
      behavior: p.behavior,
      margin: p.behavior == SnackBarBehavior.floating
          ? p.config.defaultMargin
          : null,
      shape: p.behavior == SnackBarBehavior.floating
          ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius))
          : null,
      elevation: p.config.defaultElevation,
      action: p.action,
      padding: EdgeInsets.zero,
      content: Container(
        constraints: BoxConstraints(
          minWidth: p.minWidthOverride ?? p.config.minWidth ?? 0.0,
        ),
        child: SizedBox(
          height: wrap ? null : (p.fixedHeightOverride ?? p.config.fixedHeight),
          width: wrap
              ? null
              : (p.fixedWidthOverride ??
                  p.config.fixedWidth ??
                  double.infinity),
          child: p.decorationOverride != null
              ? Container(
                  decoration: p.decorationOverride,
                  child: _SnackBarContent(
                      params: p, typeColor: typeColor, fg: fg, style: style),
                )
              : _SnackBarContent(
                  params: p, typeColor: typeColor, fg: fg, style: style),
        ),
      ),
    );
  }
}

class _SnackBarContent extends StatelessWidget {
  const _SnackBarContent({
    required this.params,
    required this.typeColor,
    required this.fg,
    required this.style,
  });

  final SnackbarParams params;
  final Color typeColor;
  final Color fg;
  final SnackToastVisualStyle style;

  Color get _iconColor => switch (style) {
        SnackToastVisualStyle.minimal => typeColor,
        SnackToastVisualStyle.outlined => typeColor,
        _ => Colors.white,
      };

  @override
  Widget build(BuildContext context) {
    final config = params.config;
    final wrap = params.wrapContentOverride ?? config.wrapContent;
    final leftBar = style == SnackToastVisualStyle.minimal
        ? Container(width: 4.5, color: typeColor)
        : null;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (leftBar != null) leftBar,
          Expanded(
            child: Padding(
              padding: config.defaultPadding,
              child: Row(
                children: [
                  if (config.showIcon) ...[
                    Container(
                      width: config.iconSize + 14,
                      height: config.iconSize + 14,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _iconColor.withValues(alpha: 0.18)),
                      child: Center(
                        child: Icon(config.iconForType(params.type),
                            color: _iconColor, size: config.iconSize),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Flexible(
                    child: Column(
                      mainAxisSize: wrap ? MainAxisSize.min : MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (params.title != null) ...[
                          Text(
                            params.title!,
                            style: (params.titleStyleOverride ??
                                    config.titleStyle ??
                                    config.textStyle ??
                                    const TextStyle())
                                .copyWith(
                              color:
                                  params.titleColor ?? config.titleColor ?? fg,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              letterSpacing: 0.1,
                            ),
                          ),
                          const SizedBox(height: 3),
                        ],
                        Text(
                          params.message,
                          style: (params.messageStyleOverride ??
                                  config.messageStyle ??
                                  config.textStyle ??
                                  const TextStyle())
                              .copyWith(
                            color: params.messageColorOverride ??
                                config.messageColor ??
                                fg.withValues(
                                    alpha: params.title != null ? 0.88 : 1.0),
                            fontSize: 13.5,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
