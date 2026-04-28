# Changelog

All notable changes to this project will be documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [0.0.3] — 2026-04-28

### Fixed
- **Snackbar text underline** — Removed unwanted underline decoration
  appearing on title and message text in all `SnackToastKit.snackbar()`
  calls. Flutter's `SnackBar` injects a `DefaultTextStyle` with
  `TextDecoration.underline` into its content subtree; both text styles
  in `_SnackBarContent` now explicitly set `decoration: TextDecoration.none`
  to override it. Toast notifications are unaffected.

---

## [0.0.2] — 2026-03-11

This release focuses on improving documentation and cleaning up the package presentation for a better user experience and higher pub.dev score.

### Changed
- Improved overall package documentation score by adding comprehensive dartdoc comments to all public API elements (classes, methods, fields, and enums).
- Removed **Testing** and **Architecture** sections from `README.md` to streamline the documentation.
- Ensured 100% of the public API is documented.

---

## [0.0.1] — 2026-03-09

Initial release of **SnackToastKit**.

This release introduces a customizable toast and snackbar system for Flutter featuring modern animations, configurable visual styles, swipe gestures, progress indicators, and a queue-based display system.

### Added

#### Core System

* `SnackToastKit` static API providing:

  * `toast()` for overlay toasts
  * `snackbar()` for `ScaffoldMessenger` snackbars
  * convenience helpers: `success()`, `error()`, `warning()`, `info()`

* `SnackToastConfig` immutable global configuration with `copyWith()` support.

* `SnackToastType` enum
  `success | error | warning | info | custom`

* `SnackToastPosition` enum
  `top | center | bottom`

#### Animation System

* `SnackToastAnimation` enum supporting multiple entrance animations:

  * `slideUp`
  * `slideDown`
  * `slideLeft`
  * `slideRight`
  * `fade`
  * `scaleSpring`
  * `bounceUp`
  * `flipReveal`

* `SnackToastAnimationResolver` extension providing:

  * `entranceCurve`
  * `exitCurve`
  * `resolvedEntranceDuration(Duration)`

* Automatic animation selection based on toast position when no animation style is specified.

#### Visual Style System

* `SnackToastVisualStyle` enum providing multiple rendering modes:

  * `standard` — elevated card with layered shadows
  * `glass` — frosted blur card using `BackdropFilter`
  * `gradient` — rich multi-stop gradient background
  * `minimal` — clean white card with accent bar
  * `outlined` — transparent card with glowing border

#### Gesture Interaction

* Swipe-to-dismiss support for toast notifications.
* Configurable dismiss threshold using distance or velocity.
* Smooth snap-back animation when dismissal conditions are not met.

#### Progress Indicator

* Optional animated progress bar showing toast duration.
* Automatically drains over the toast lifetime.
* Configurable height and visibility.

#### Icon Micro-Animation

* Elastic entrance animation for toast icons.
* Staggered animation timing for more natural UI feedback.

#### Queue System

* `SnackToastQueue` FIFO queue ensuring sequential toast display.
* Configurable `maxQueueSize` to prevent excessive stacking.

#### Overlay Architecture

* `ToastOverlayHost` widget providing `TickerProvider` for toast animations.
* `ToastController` managing toast lifecycle, animations, and dismissal.

#### Snackbar Integration

* `SnackToastSnackbar` wrapper around `ScaffoldMessenger`.
* Supports consistent styling between toast and snackbar components.

#### Global Key Support

* `SnackToastKit.navigatorKey`
* `SnackToastKit.scaffoldMessengerKey`

Allows displaying notifications without requiring a `BuildContext`.

#### Developer Utilities

* `SnackToastKit.reset()` for clearing configuration and queues during tests.
* `SnackToastKit.dismissAll()` to programmatically remove active toasts.

---

This release establishes the base architecture and public API for **SnackToastKit**, enabling flexible toast and snackbar notifications across Flutter applications.
