/// Visual rendering style for toast notifications.
///
/// Controls background treatment, elevation, and border.
/// All styles respect the semantic type color for icons and accents.
enum SnackToastVisualStyle {
  /// Opaque card with semantic color, depth shadow, and subtle gradient overlay.
  standard,

  /// Frosted glass card via BackdropFilter blur.
  /// Lets the background show through while maintaining readability.
  glass,

  /// Rich linear gradient from semantic color to a deeper tone.
  /// High visual impact — ideal for critical notifications.
  gradient,

  /// White card with a thick left-side type-color accent bar.
  /// Clean and professional for info-heavy messages.
  minimal,

  /// Transparent card with a type-color border stroke.
  /// Non-obtrusive for secondary feedback.
  outlined,
}
