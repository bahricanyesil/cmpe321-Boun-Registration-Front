/// Collection of number extensions.
extension NumberExtensions on num {
  /// Determines whether the number is integer.
  bool get isInteger => this is int || this == roundToDouble();

  /// Returns the digit number.
  int get digitNum => toString().length - toString().indexOf('.') - 1;
}
