import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import '../core/snacktoast_animation.dart';
import '../core/snacktoast_config.dart';
import '../core/snacktoast_position.dart';
import '../core/snacktoast_style.dart';
import '../core/snacktoast_type.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Constants
// ─────────────────────────────────────────────────────────────────────────────

const double _kRippleMaxRadius = 160.0;
const double _kCenterPopBlurSigma = 8.0;
const double _kEdgeSlideDistance = 290.0;
const double _kCornerSweepX = 180.0;
const double _kCornerSweepY = 16.0;

// ─────────────────────────────────────────────────────────────────────────────
// ToastWidget
// ─────────────────────────────────────────────────────────────────────────────

class ToastWidget extends StatefulWidget {
  const ToastWidget({
    super.key,
    required this.message,
    required this.type,
    required this.config,
    required this.position,
    required this.entranceAnimation,
    required this.iconAnimation,
    required this.progressAnimation,
    required this.animationStyle,
    this.title,
    this.customIcon,
    this.backgroundColor,
    this.foregroundColor,
    this.customWidget,
    this.visualStyleOverride,
    this.onDismiss,
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

  final String message;
  final String? title;
  final SnackToastType type;
  final SnackToastConfig config;
  final SnackToastPosition position;
  final Animation<double> entranceAnimation;
  final Animation<double> iconAnimation;
  final Animation<double> progressAnimation;
  final SnackToastAnimation animationStyle;
  final Widget? customIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Widget? customWidget;
  final dynamic visualStyleOverride;
  final VoidCallback? onDismiss;
  final Color? titleColor;
  final TextStyle? titleStyle;
  final double? minWidth;
  final bool? wrapContent;
  final BoxDecoration? decorationOverride;
  final Color? messageColor;
  final TextStyle? messageStyle;
  final double? fixedHeight;
  final double? fixedWidth;

  @override
  State<ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget> {
  final _swipeOffset = ValueNotifier<double>(0.0);

  SnackToastVisualStyle get _visualStyle =>
      (widget.visualStyleOverride as SnackToastVisualStyle?) ??
      widget.config.visualStyle;

  Color get _typeColor =>
      widget.backgroundColor ?? widget.config.colorForType(widget.type);

  Color get _foreground {
    if (widget.foregroundColor != null) return widget.foregroundColor!;
    return switch (_visualStyle) {
      SnackToastVisualStyle.minimal => const Color(0xFF1A1A2E),
      SnackToastVisualStyle.outlined => _typeColor,
      _ => Colors.white,
    };
  }

  Color get _iconColor => switch (_visualStyle) {
        SnackToastVisualStyle.minimal => _typeColor,
        SnackToastVisualStyle.outlined => _typeColor,
        _ => Colors.white,
      };

  @override
  void dispose() {
    _swipeOffset.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails d) {
    _swipeOffset.value += d.delta.dx;
  }

  void _onHorizontalDragEnd(DragEndDetails d) {
    final velocity = d.velocity.pixelsPerSecond.dx.abs();
    if (_swipeOffset.value.abs() > 72 || velocity > 450) {
      widget.onDismiss?.call();
    } else {
      _swipeOffset.value = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([widget.entranceAnimation, _swipeOffset]),
      builder: (context, _) {
        final t = widget.entranceAnimation.value;
        final swipe = _swipeOffset.value;
        Widget card = _buildCard();

        if (swipe != 0.0) {
          final swipeOpacity = (1.0 - swipe.abs() / 220).clamp(0.0, 1.0);
          card = Transform.translate(
            offset: Offset(swipe, 0),
            child: Opacity(opacity: swipeOpacity, child: card),
          );
        }

        return _applyEntranceTransform(card, t);
      },
    );
  }

  Widget _applyEntranceTransform(Widget child, double t) {
    final clamped = t.clamp(0.0, 1.0);
    return switch (widget.animationStyle) {
      SnackToastAnimation.slideUp => Transform.translate(
          offset: Offset(0, 64 * (1 - t)),
          child: Opacity(opacity: clamped, child: child),
        ),
      SnackToastAnimation.slideDown => Transform.translate(
          offset: Offset(0, -64 * (1 - t)),
          child: Opacity(opacity: clamped, child: child),
        ),
      SnackToastAnimation.slideLeft => Transform.translate(
          offset: Offset(90 * (1 - t), 0),
          child: Opacity(opacity: clamped, child: child),
        ),
      SnackToastAnimation.slideRight => Transform.translate(
          offset: Offset(-90 * (1 - t), 0),
          child: Opacity(opacity: clamped, child: child),
        ),
      SnackToastAnimation.fade => Opacity(opacity: clamped, child: child),
      SnackToastAnimation.scaleSpring => Transform.scale(
          scale: (0.82 + 0.18 * t).clamp(0.0, 1.1),
          child: Opacity(opacity: clamped, child: child),
        ),
      SnackToastAnimation.bounceUp => Transform.translate(
          offset: Offset(0, 80 * (1 - t)),
          child: Opacity(opacity: clamped, child: child),
        ),
      SnackToastAnimation.flipReveal => _applyFlipReveal(child, t),
      SnackToastAnimation.fadeDrop => _applyFadeDrop(child, t),
      SnackToastAnimation.fadeRise => _applyFadeRise(child, t),
      SnackToastAnimation.centerPop => _applyCenterPop(child, t),
      SnackToastAnimation.radialExpansion => _applyRadialExpansion(child, t),
      SnackToastAnimation.slideFromLeft => Transform.translate(
          offset: Offset(-_kEdgeSlideDistance * (1 - t), 0),
          child: Opacity(opacity: clamped, child: child),
        ),
      SnackToastAnimation.slideFromRight => Transform.translate(
          offset: Offset(_kEdgeSlideDistance * (1 - t), 0),
          child: Opacity(opacity: clamped, child: child),
        ),
      SnackToastAnimation.topLeftSweep => Transform.translate(
          offset: Offset(-_kCornerSweepX * (1 - t), -_kCornerSweepY * (1 - t)),
          child: Opacity(opacity: clamped, child: child),
        ),
      SnackToastAnimation.topRightSweep => Transform.translate(
          offset: Offset(_kCornerSweepX * (1 - t), -_kCornerSweepY * (1 - t)),
          child: Opacity(opacity: clamped, child: child),
        ),
      SnackToastAnimation.bottomLeftSweep => Transform.translate(
          offset: Offset(-_kCornerSweepX * (1 - t), _kCornerSweepY * (1 - t)),
          child: Opacity(opacity: clamped, child: child),
        ),
      SnackToastAnimation.bottomRightSweep => Transform.translate(
          offset: Offset(_kCornerSweepX * (1 - t), _kCornerSweepY * (1 - t)),
          child: Opacity(opacity: clamped, child: child),
        ),
    };
  }

  Widget _applyFadeDrop(Widget child, double t) {
    final clamped = t.clamp(0.0, 1.0);
    final scale = 0.95 + 0.05 * clamped;
    final yOffset = -40.0 * (1 - t);
    return Transform.translate(
      offset: Offset(0, yOffset),
      child: Transform.scale(
        scale: scale.clamp(0.0, 1.05),
        child: Opacity(opacity: clamped, child: child),
      ),
    );
  }

  Widget _applyFadeRise(Widget child, double t) {
    final clamped = t.clamp(0.0, 1.0);
    final scale = 0.90 + 0.10 * clamped;
    final yOffset = 40.0 * (1 - t);
    return Transform.translate(
      offset: Offset(0, yOffset),
      child: Transform.scale(
        scale: scale.clamp(0.0, 1.05),
        child: Opacity(opacity: clamped, child: child),
      ),
    );
  }

  Widget _applyCenterPop(Widget child, double t) {
    final clamped = t.clamp(0.0, 1.0);
    final scale = 0.70 + 0.30 * clamped;
    final blurSigma = (_kCenterPopBlurSigma * (1 - clamped)).clamp(0.0, 12.0);
    Widget result = Transform.scale(
      scale: scale.clamp(0.0, 1.05),
      child: Opacity(opacity: clamped, child: child),
    );
    if (blurSigma > 0.05) {
      result = ImageFiltered(
        imageFilter: ui.ImageFilter.blur(
            sigmaX: blurSigma, sigmaY: blurSigma, tileMode: TileMode.decal),
        child: result,
      );
    }
    return result;
  }

  Widget _applyFlipReveal(Widget child, double t) {
    final angle = (1 - t.clamp(0.0, 1.0)) * (math.pi / 2);
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.0012)
        ..rotateX(-angle),
      child: Opacity(opacity: t.clamp(0.0, 1.0), child: child),
    );
  }

  Widget _applyRadialExpansion(Widget child, double t) {
    final clamped = t.clamp(0.0, 1.0);
    final scale = (0.60 + 0.40 * clamped).clamp(0.0, 1.05);
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        CustomPaint(
          painter: _RadialRipplePainter(progress: clamped, color: _typeColor),
          child: const SizedBox(
              width: _kRippleMaxRadius * 2, height: _kRippleMaxRadius * 2),
        ),
        Transform.scale(
            scale: scale, child: Opacity(opacity: clamped, child: child)),
      ],
    );
  }

  Widget _buildCard() {
    if (widget.customWidget != null) {
      return Container(
          margin: widget.config.defaultMargin, child: widget.customWidget);
    }
    final radius = BorderRadius.circular(widget.config.defaultBorderRadius);
    final wrap = widget.wrapContent ?? widget.config.wrapContent;

    return GestureDetector(
      onTap: widget.config.dismissOnTap ? widget.onDismiss : null,
      onHorizontalDragUpdate:
          widget.config.enableSwipeToDismiss ? _onHorizontalDragUpdate : null,
      onHorizontalDragEnd:
          widget.config.enableSwipeToDismiss ? _onHorizontalDragEnd : null,
      child: Container(
        margin: widget.config.defaultMargin,
        constraints: BoxConstraints(
          minWidth: widget.minWidth ?? widget.config.minWidth ?? 0.0,
        ),
        child: SizedBox(
          height:
              wrap ? null : (widget.fixedHeight ?? widget.config.fixedHeight),
          width: wrap
              ? null
              : (widget.fixedWidth ??
                  widget.config.fixedWidth ??
                  double.infinity),
          child: widget.decorationOverride != null
              ? Container(
                  decoration: widget.decorationOverride,
                  child: _buildBody(radius))
              : _buildVisualStyle(radius),
        ),
      ),
    );
  }

  Widget _buildVisualStyle(BorderRadius radius) => switch (_visualStyle) {
        SnackToastVisualStyle.standard => _buildStandard(radius),
        SnackToastVisualStyle.glass => _buildGlass(radius),
        SnackToastVisualStyle.gradient => _buildGradient(radius),
        SnackToastVisualStyle.minimal => _buildMinimal(radius),
        SnackToastVisualStyle.outlined => _buildOutlined(radius),
      };

  Widget _buildStandard(BorderRadius radius) {
    final base = _typeColor;
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [base, _darken(base, 0.12)]),
        boxShadow: [
          BoxShadow(
              color: base.withValues(alpha: 0.38),
              blurRadius: 24,
              offset: const Offset(0, 8)),
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: _buildBody(radius),
    );
  }

  Widget _buildGlass(BorderRadius radius) {
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
            sigmaX: widget.config.glassBlurIntensity,
            sigmaY: widget.config.glassBlurIntensity),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: radius,
            color: _typeColor.withValues(alpha: 0.22),
            border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
            boxShadow: [
              BoxShadow(
                  color: _typeColor.withValues(alpha: 0.20),
                  blurRadius: 20,
                  offset: const Offset(0, 6))
            ],
          ),
          child: _buildBody(radius),
        ),
      ),
    );
  }

  Widget _buildGradient(BorderRadius radius) {
    final c0 = _typeColor;
    final c1 = _shiftHue(c0, 18);
    final c2 = _darken(c0, 0.18);
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [c0, c1, c2],
            stops: const [0.0, 0.5, 1.0]),
        boxShadow: [
          BoxShadow(
              color: c0.withValues(alpha: 0.45),
              blurRadius: 28,
              offset: const Offset(0, 10))
        ],
      ),
      child: _buildBody(radius),
    );
  }

  Widget _buildMinimal(BorderRadius radius) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        color: Colors.white,
        border: Border(left: BorderSide(color: _typeColor, width: 4.5)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.09),
              blurRadius: 16,
              offset: const Offset(0, 4))
        ],
      ),
      child: _buildBody(radius),
    );
  }

  Widget _buildOutlined(BorderRadius radius) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        color: Colors.white.withValues(alpha: 0.06),
        border: Border.all(color: _typeColor, width: 1.5),
        boxShadow: [
          BoxShadow(
              color: _typeColor.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 4))
        ],
      ),
      child: _buildBody(radius),
    );
  }

  Widget _buildBody(BorderRadius radius) {
    final wrap = widget.wrapContent ?? widget.config.wrapContent;
    return ClipRRect(
      borderRadius: radius,
      child: Column(
        mainAxisSize: wrap ? MainAxisSize.min : MainAxisSize.max,
        children: [
          Padding(
            padding: widget.config.defaultPadding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.config.showIcon) ...[
                  _buildAnimatedIcon(),
                  const SizedBox(width: 12)
                ],
                Flexible(child: _buildTextContent()),
              ],
            ),
          ),
          if (widget.config.showProgressBar) _buildProgressBar(radius),
        ],
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    final icon = widget.customIcon ??
        Icon(widget.config.iconForType(widget.type),
            color: _iconColor, size: widget.config.iconSize);
    return AnimatedBuilder(
      animation: widget.iconAnimation,
      builder: (context, child) {
        final scale =
            (0.30 + 0.70 * widget.iconAnimation.value).clamp(0.0, 1.25);
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        width: widget.config.iconSize + 16,
        height: widget.config.iconSize + 16,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: _iconColor.withValues(alpha: 0.18)),
        child: Center(child: icon),
      ),
    );
  }

  Widget _buildTextContent() {
    final fg = _foreground;
    final hasTitle = widget.title != null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasTitle) ...[
          Text(
            widget.title!,
            style: (widget.titleStyle ??
                    widget.config.titleStyle ??
                    widget.config.textStyle ??
                    const TextStyle())
                .copyWith(
              color: widget.titleColor ?? widget.config.titleColor ?? fg,
              fontWeight: FontWeight.w700,
              fontSize: 14,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 3),
        ],
        Text(
          widget.message,
          style: (widget.messageStyle ??
                  widget.config.messageStyle ??
                  widget.config.textStyle ??
                  const TextStyle())
              .copyWith(
            color: widget.messageColor ??
                widget.config.messageColor ??
                fg.withValues(alpha: hasTitle ? 0.88 : 1.0),
            fontSize: 13.5,
            height: 1.35,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(BorderRadius radius) {
    final barColor = _foreground.withValues(alpha: 0.40);
    return AnimatedBuilder(
      animation: widget.progressAnimation,
      builder: (context, _) {
        return SizedBox(
          height: widget.config.progressBarHeight,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final fillWidth = constraints.maxWidth *
                  widget.progressAnimation.value.clamp(0.0, 1.0);
              return Stack(
                children: [
                  Container(
                      width: constraints.maxWidth,
                      height: widget.config.progressBarHeight,
                      color: barColor.withValues(alpha: 0.18)),
                  Container(
                    width: fillWidth,
                    height: widget.config.progressBarHeight,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(
                            widget.config.progressBarHeight / 2),
                        bottomRight: Radius.circular(
                            widget.config.progressBarHeight / 2),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  Color _shiftHue(Color color, double degrees) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withHue((hsl.hue + degrees) % 360).toColor();
  }
}

class _RadialRipplePainter extends CustomPainter {
  _RadialRipplePainter({required this.progress, required this.color});
  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0 || progress >= 1.0) return;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = _kRippleMaxRadius * progress;
    final alpha = (0.35 * (1.0 - progress)).clamp(0.0, 1.0);
    final strokeWidth =
        (22.0 * (1 - progress) + 4.0 * progress).clamp(2.0, 24.0);
    final glowPaint = Paint()
      ..color = color.withValues(alpha: alpha * 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18.0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 1.8;
    canvas.drawCircle(center, radius, glowPaint);
    final ringPaint = Paint()
      ..shader = RadialGradient(colors: [
        color.withValues(alpha: alpha),
        color.withValues(alpha: 0.0)
      ], stops: const [
        0.75,
        1.0
      ]).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, ringPaint);
  }

  @override
  bool shouldRepaint(_RadialRipplePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
