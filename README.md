# SnackToast

A modern, production-grade Flutter notification library providing fully animated toasts and snackbars with **8 motion styles**, **5 visual styles**, swipe-to-dismiss, icon micro-animations, and a progress bar countdown — all through a clean, developer-friendly API.

[![pub version](https://img.shields.io/pub/v/snacktoast.svg)](https://pub.dev/packages/snacktoast)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-blue.svg)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## Table of Contents

- [Features](#features)
- [Preview](#preview)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
  - [SnackToastConfig Reference](#snacktoastconfig-reference)
- [Toast API](#toast-api)
  - [Convenience Methods](#convenience-methods)
  - [Full Parameter Reference](#toast-full-parameter-reference)
- [Snackbar API](#snackbar-api)
  - [Convenience Methods](#snackbar-convenience-methods)
  - [Full Parameter Reference](#snackbar-full-parameter-reference)
- [Animation Styles](#animation-styles)
- [Visual Styles](#visual-styles)
- [Swipe to Dismiss](#swipe-to-dismiss)
- [Progress Bar](#progress-bar)
- [Custom Widgets](#custom-widgets)
- [Queue System](#queue-system)
- [Context-Free Usage](#context-free-usage)
- [Migration Guide](#migration-guide)
- [License](#license)

---

## Features

- 🎬 **18 animation styles** — slide (6 directions), fade, fade-drop, fade-rise, center-pop, scale-spring, bounce, flip reveal, 4 corner sweeps, radial ripple
- 🎨 **5 visual styles** — standard, frosted glass, gradient, minimal, outlined
- 🖱 **Swipe to dismiss** — horizontal gesture with progressive opacity feedback
- ⚡ **Icon micro-animation** — elastic bounce staggered 50ms after entrance
- ⏱ **Progress bar** — animated countdown tied directly to the hold duration
- 🔁 **Queue system** — FIFO sequential display, configurable max size
- 📍 **3 positions** — top, center, bottom (auto-selects animation if not set)
- 🧩 **Custom widgets** — full content override per notification
- 🔑 **Context-free API** — works from BLoC, service, or any non-widget layer
- ✅ **Backward compatible** — all new parameters are optional

---

## Preview

| Style | Animation | Description |
|-------|-----------|-------------|
| `standard` | `slideUp` / `fadeRise` | Opaque card with layered shadow and gradient overlay |
| `glass` | `centerPop` | Frosted blur card, focuses in from blurry to sharp |
| `gradient` | `bounceUp` / `bottomRightSweep` | Rich multi-stop gradient, high visual impact |
| `minimal` | `fadeDrop` / `topLeftSweep` | White card with left-side type-color accent bar |
| `outlined` | `radialExpansion` / `flipReveal` | Transparent card; radial ring expands on entry |

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  snacktoast: ^2.0.0
```

Then run:

```bash
flutter pub get
```

Import in your Dart files:

```dart
import 'package:snacktoast/snacktoast.dart';
```

---

## Quick Start

### 1. Attach keys to `MaterialApp`

For context-free usage (calling from BLoC, services, or anywhere without a `BuildContext`), attach the provided global keys:

```dart
MaterialApp(
  navigatorKey: SnackToastKit.navigatorKey,
  scaffoldMessengerKey: SnackToastKit.scaffoldMessengerKey,
  home: const MyHomePage(),
);
```

### 2. Configure globally (optional)

Call once before `runApp`, or anywhere before the first notification:

```dart
void main() {
  SnackToastKit.configure(
    const SnackToastConfig(
      defaultPosition: SnackToastPosition.bottom,
      visualStyle: SnackToastVisualStyle.standard,
      animationStyle: SnackToastAnimation.slideUp,
      showProgressBar: true,
      enableSwipeToDismiss: true,
    ),
  );
  runApp(const MyApp());
}
```

### 3. Show notifications

```dart
// Convenience methods (context-free via navigatorKey)
SnackToastKit.success('Profile saved!');
SnackToastKit.error('Something went wrong');
SnackToastKit.warning('Low storage space');
SnackToastKit.info('Update available');

// Snackbars (context-free via scaffoldMessengerKey)
SnackToastKit.snackbarSuccess('Upload complete!');
SnackToastKit.snackbarError('Connection lost');
```

---

## Configuration

### `SnackToastConfig` Reference

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `defaultDuration` | `Duration` | `3s` | How long each toast is visible |
| `animationDuration` | `Duration` | `300ms` | Entrance/exit transition length |
| `defaultPosition` | `SnackToastPosition` | `.bottom` | Default screen position |
| `defaultBorderRadius` | `double` | `16.0` | Card corner radius |
| `defaultElevation` | `double` | `6.0` | Shadow depth |
| `defaultPadding` | `EdgeInsets` | `h:16 v:14` | Internal card padding |
| `defaultMargin` | `EdgeInsets` | `h:20 v:48` | Margin from screen edges |
| `maxQueueSize` | `int` | `5` | Max simultaneous queue entries |
| `successColor` | `Color` | `0xFF1B8A4A` | Semantic color for `.success` |
| `errorColor` | `Color` | `0xFFD32F2F` | Semantic color for `.error` |
| `warningColor` | `Color` | `0xFFE65100` | Semantic color for `.warning` |
| `infoColor` | `Color` | `0xFF0277BD` | Semantic color for `.info` |
| `iconSize` | `double` | `22.0` | Size of the type icon |
| `showIcon` | `bool` | `true` | Show/hide the type icon |
| `textStyle` | `TextStyle?` | `null` | Base text style for messages |
| `dismissOnTap` | `bool` | `true` | Tap anywhere on toast to dismiss |
| `enableSwipeToDismiss` | `bool` | `true` | Horizontal swipe gesture |
| `animationStyle` | `SnackToastAnimation?` | `null` | Global animation; `null` = auto by position |
| `animateIcon` | `bool` | `true` | Enable icon elastic micro-animation |
| `visualStyle` | `SnackToastVisualStyle` | `.standard` | Global visual rendering style |
| `showProgressBar` | `bool` | `false` | Animated countdown bar at card bottom |
| `progressBarHeight` | `double` | `3.0` | Height in logical pixels |
| `glassBlurIntensity` | `double` | `18.0` | Blur sigma for `.glass` style |

`SnackToastConfig` is immutable. Use `copyWith()` to derive variants:

```dart
final darkConfig = SnackToastKit.config.copyWith(
  visualStyle: SnackToastVisualStyle.glass,
  glassBlurIntensity: 24.0,
);
```

---

## Toast API

Toasts display via Flutter's `Overlay` system — no `Scaffold` required.

### Convenience Methods

```dart
SnackToastKit.success('Saved!');
SnackToastKit.error('Failed to save');
SnackToastKit.warning('Disk almost full');
SnackToastKit.info('Syncing in background');
```

All convenience methods accept optional `context`, `title`, and `visualStyle`:

```dart
SnackToastKit.success(
  'Payment confirmed',
  title: 'Transaction Complete',
  visualStyle: SnackToastVisualStyle.gradient,
);
```

### Toast Full Parameter Reference

```dart
SnackToastKit.toast(
  'Your message here',

  // Content
  title: 'Optional title',
  type: SnackToastType.success,       // success | error | warning | info | custom

  // Layout & position
  context: context,                   // optional; falls back to navigatorKey
  position: SnackToastPosition.top,   // top | center | bottom

  // Duration
  duration: const Duration(seconds: 5),

  // Motion
  animationStyle: SnackToastAnimation.flipReveal,

  // Visual
  visualStyle: SnackToastVisualStyle.glass,
  backgroundColor: const Color(0xFF6200EE),
  foregroundColor: Colors.white,

  // Icon
  customIcon: const Icon(Icons.rocket_launch_rounded, color: Colors.white),

  // Full widget override (replaces entire card)
  customWidget: MyCustomToastCard(),

  // Queue behavior
  queued: true,                       // false = skip queue, display immediately

  // Lifecycle
  onDismissed: () => print('Toast gone'),
);
```

### Position-based Auto Animation

When `animationStyle` is not set (globally or per-call), the position determines the animation automatically:

| Position | Auto Animation |
|----------|---------------|
| `top` | `slideDown` |
| `center` | `scaleSpring` |
| `bottom` | `slideUp` |

---

## Snackbar API

Snackbars use Flutter's `ScaffoldMessenger` system. They respect Material Design snackbar behavior and can be placed inside or outside the widget tree.

### Snackbar Convenience Methods

```dart
SnackToastKit.snackbarSuccess('Upload complete!');
SnackToastKit.snackbarError('Connection lost');
SnackToastKit.snackbarWarning('Storage almost full');
SnackToastKit.snackbarInfo('New version available');
```

### Snackbar Full Parameter Reference

```dart
SnackToastKit.snackbar(
  'File deleted permanently.',

  // Content
  title: 'Deleted',
  type: SnackToastType.warning,

  // Display
  context: context,                          // optional; falls back to scaffoldMessengerKey
  behavior: SnackBarBehavior.floating,       // floating | fixed

  // Duration
  duration: const Duration(seconds: 4),

  // Visual
  visualStyle: SnackToastVisualStyle.minimal,
  backgroundColor: Colors.black87,
  foregroundColor: Colors.white,

  // Action button
  action: SnackBarAction(
    label: 'UNDO',
    textColor: Colors.yellowAccent,
    onPressed: () => SnackToastKit.success('Restored!'),
  ),
);
```

---

## Animation Styles

`SnackToastAnimation` controls entrance and exit motion. Set globally in `SnackToastConfig` or override per-call. 18 styles total across 5 motion families.

### Vertical origin

| Value | Motion | Entrance Curve | Duration | Best For |
|-------|--------|---------------|---------|----------|
| `slideUp` | +64px Y → 0, fade | `easeOutCubic` | 1× | Bottom toasts |
| `slideDown` | -64px Y → 0, fade | `easeOutCubic` | 1× | Top toasts |
| `fadeDrop` | -40px Y → 0, scale 0.95→1 | `easeOutBack` | **1.4×** | Top toasts, soft landing |
| `fadeRise` | +40px Y → 0, scale 0.90→1 | `easeOutCubic` | 1× | Bottom toasts, smooth |
| `bounceUp` | +80px Y → 0, physics bounce | `bounceOut` | **1.5×** | Positive feedback |

### Horizontal edge slides

| Value | Motion | Entrance Curve | Best For |
|-------|--------|---------------|----------|
| `slideLeft` | +90px X → 0, fade | `easeOutQuart` | Notification panel style |
| `slideRight` | -90px X → 0, fade | `easeOutQuart` | RTL layouts |
| `slideFromLeft` | -290px X → 0, overshoot | `easeOutBack` | Full off-screen entry from left |
| `slideFromRight` | +290px X → 0, overshoot | `easeOutBack` | Full off-screen entry from right |

### Corner-to-center sweeps

The corner is the animation **origin** only — all four styles rest at `topCenter` or `bottomCenter`. `ToastController` overrides the rest alignment automatically, so you only need to set the animation style.

| Value | Origin | X + Y offset | Bounce |
|-------|--------|-------------|--------|
| `topLeftSweep` | Top-left | (-180px, -16px) → 0 | No |
| `topRightSweep` | Top-right | (+180px, -16px) → 0 | No |
| `bottomLeftSweep` | Bottom-left | (-180px, +16px) → 0 | No |
| `bottomRightSweep` | Bottom-right | (+180px, +16px) → 0 | **Yes — `easeOutBack`, 1.3×** |

### Physics / spring

| Value | Motion | Entrance Curve | Duration |
|-------|--------|---------------|---------|
| `scaleSpring` | Scale 0.82→1, elastic overshoot | `elasticOut` | **1.8×** |

### Atmospheric

| Value | Motion | Special Effect |
|-------|--------|---------------|
| `fade` | Opacity 0→1 | Minimal, non-disruptive ambient style |
| `centerPop` | Scale 0.70→1 | `ImageFiltered` blur sigma 8→0 (focus-in sharpening) |
| `flipReveal` | 3D `Matrix4.rotateX` 90°→0° | Perspective depth — premium card reveal |
| `radialExpansion` | Scale 0.60→1 | `CustomPainter` expanding ring, fades as card appears |

> **Duration auto-scaling:** Physics and atmospheric animations automatically extend
> their entrance `AnimationController` duration. Exit always uses the configured
> `animationDuration` for a snappy dismiss regardless of entrance style.

```dart
// Global default
SnackToastKit.configure(
  const SnackToastConfig(animationStyle: SnackToastAnimation.fadeRise),
);

// Per-call override
SnackToastKit.toast('Achievement unlocked!',
  animationStyle: SnackToastAnimation.radialExpansion,
  visualStyle: SnackToastVisualStyle.gradient,
  type: SnackToastType.success,
  position: SnackToastPosition.center,
);

// Corner sweep — set animationStyle, position handles rest alignment
SnackToastKit.info('Syncing',
  animationStyle: SnackToastAnimation.topRightSweep,
  position: SnackToastPosition.top,
);

// Focus-in blur pop
SnackToastKit.warning('Session expiring in 60s',
  animationStyle: SnackToastAnimation.centerPop,
  position: SnackToastPosition.center,
);
```

---

## Visual Styles

`SnackToastVisualStyle` controls how the card is rendered. Set globally or override per-notification.

### `standard`
Opaque card using the semantic type color with a subtle two-tone gradient, layered box shadows, and a colored glow. The default — works on all backgrounds.

### `glass`
Frosted glass using `BackdropFilter` blur. The background shows through with a translucent tint. Blur intensity is controlled by `glassBlurIntensity`.

> **Note:** `glass` requires content beneath the overlay. It has no effect on a plain white background.

### `gradient`
Rich three-stop linear gradient from the type color through a hue-shifted variant to a darkened tone. High visual impact — ideal for critical errors or celebrations.

### `minimal`
White card with a 4.5px left-side accent bar in the type color. Foreground text is dark. Clean and readable — ideal for information-dense messages.

### `outlined`
Transparent card with a 1.5px type-color border stroke and a soft color glow. Non-obtrusive for ambient or secondary feedback.

```dart
// Example: glass toast from a BLoC event
SnackToastKit.toast(
  'Biometric authentication enabled',
  type: SnackToastType.success,
  visualStyle: SnackToastVisualStyle.glass,
  animationStyle: SnackToastAnimation.scaleSpring,
  position: SnackToastPosition.center,
);
```

---

## Swipe to Dismiss

Enabled by default via `enableSwipeToDismiss: true` in config. Users swipe horizontally to dismiss any toast before its timer expires.

The gesture provides progressive opacity feedback as the swipe distance grows, then either snaps back (insufficient distance/velocity) or triggers dismiss:

- Dismiss threshold: **72px horizontal offset** or **450px/s velocity**
- Below threshold: card snaps back to origin

Disable globally or per-config:

```dart
SnackToastKit.configure(
  const SnackToastConfig(enableSwipeToDismiss: false),
);
```

---

## Progress Bar

A thin animated bar at the bottom of the card that drains from full width to zero over the toast's visible duration. Powered by a dedicated `AnimationController` — completely independent from entrance/exit animation.

```dart
SnackToastKit.configure(
  const SnackToastConfig(
    showProgressBar: true,
    progressBarHeight: 4.0,   // default: 3.0
  ),
);
```

The bar color derives from the foreground color at 40% opacity against a 18% opacity track — legible across all five visual styles.

---

## Custom Widgets

### Custom icon

Replace the type icon while keeping the standard card layout:

```dart
SnackToastKit.toast(
  'Firmware update available',
  type: SnackToastType.info,
  customIcon: const Icon(Icons.system_update_rounded, color: Colors.white, size: 22),
);
```

### Full content override

Replace the entire card with any widget:

```dart
SnackToastKit.toast(
  '',
  customWidget: Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.deepPurple,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: const [
        Icon(Icons.star_rounded, color: Colors.amber),
        SizedBox(width: 12),
        Text('You reached level 10!',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    ),
  ),
);
```

> When `customWidget` is provided, all styling, padding, animation, and icon configuration from `SnackToastConfig` is bypassed for that notification. The entrance/exit animation still applies.

---

## Queue System

Toasts are queued by default — each waits for the previous to fully exit before appearing. This prevents visual stacking and keeps notifications readable.

```dart
// Queued (default) — displays one after another
SnackToastKit.success('Step 1 complete');
SnackToastKit.success('Step 2 complete');
SnackToastKit.success('Step 3 complete');

// Unqueued — displays immediately regardless of active toast
SnackToastKit.toast('Critical error!',
  type: SnackToastType.error,
  queued: false,
);
```

The queue silently drops new entries when `maxQueueSize` is reached (default: 5), preventing unbounded memory growth in high-frequency notification scenarios.

### Dismiss all

```dart
SnackToastKit.dismissAll(); // Dismisses visible toasts + clears pending queue
```

---

## Context-Free Usage

Attach both keys to `MaterialApp` once:

```dart
MaterialApp(
  navigatorKey: SnackToastKit.navigatorKey,
  scaffoldMessengerKey: SnackToastKit.scaffoldMessengerKey,
  // ...
);
```

Then call from anywhere — BLoC, Cubit, service class, repository, or isolate callback:

```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      try {
        await _authRepository.login(event.email, event.password);
        emit(AuthAuthenticated());
        SnackToastKit.success('Welcome back!');         // no context needed
      } on NetworkException {
        emit(AuthFailure());
        SnackToastKit.error('Check your connection');
      }
    });
  }
}
```

---

## Migration Guide

### From v1.x to v2.x

All existing call sites are fully backward compatible — no changes required to compile.

New parameters are additive and optional. The only breaking change is internal: `ToastOverlayHost` now uses `TickerProviderStateMixin` instead of `SingleTickerProviderStateMixin`. This only affects consumers who subclass or directly instantiate `ToastOverlayHost`, which is not part of the public API.

```dart
// v1 — still works unchanged
SnackToastKit.success('Hello');
SnackToastKit.snackbar('Error', type: SnackToastType.error);

// v2 — new opt-in capabilities
SnackToastKit.success('Hello',
  visualStyle: SnackToastVisualStyle.gradient,
);

SnackToastKit.configure(const SnackToastConfig(
  animationStyle: SnackToastAnimation.bounceUp,
  showProgressBar: true,
  enableSwipeToDismiss: true,
));
```

---

## License

```
MIT License

Copyright (c) 2025 SnackToast Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```