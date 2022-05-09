import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// Type conversion extensions on [String] class.
extension TypeConversions on String? {
  /// Converts the string to an enum according to the given list of values.
  T? toEnum<T extends Enum>(List<T> values) => values
      .firstWhereOrNull((T e) => e.name.toLowerCase() == this?.toLowerCase());

  /// Converts the string to a color.
  Color? get toColor =>
      this == null ? null : Color(int.parse(this!.replaceFirst('#', '0xff')));
}
