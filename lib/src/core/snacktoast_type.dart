/// Semantic type of a notification.
/// Controls default icon, color, and accessibility label.
enum SnackToastType {
  /// Indicates a successful operation.
  success,

  /// Indicates an error or failure.
  error,

  /// Indicates a warning or potential issue.
  warning,

  /// Indicates general information.
  info,

  /// A custom type with user-defined styling.
  custom,
}
