/// Utility extensions for [String] class.
extension StringUtilExtensions on String {
  /// To use correct ellipsis behavior on text overflows.
  String get useCorrectEllipsis => replaceAll('', '\u200B');

  /// Returns the icon asset path for the given name.
  String get iconPng => 'assets/images/icons/$this.png';

  /// Returns hyphenated text.
  String get hyphenate => split('').join('\u00ad');

  /// Capitalizes the string.
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${toLowerCase().substring(1)}';

  /// Capitalizes the all words in a string.
  String get capitalizeAllWords => split(' ').map((String word) {
        if (word.isEmpty) return this;
        final String leftText =
            (word.length > 1) ? word.substring(1, word.length) : '';
        return word[0].toUpperCase() + leftText;
      }).join(' ');
}

/// Utility functions on nullable strings.
extension NullableStringUtility on String? {
  /// Compares two strings by ignoring case differences.
  bool compareWithoutCase(String? otherString) {
    if (otherString == null || this == null) return false;
    return otherString.toLowerCase() == this!.toLowerCase();
  }
}
