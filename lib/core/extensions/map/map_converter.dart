import 'dart:convert';

/// Collection of map converter extensions.
extension MapConverter on Map<String, dynamic> {
  /// Converts a map to the form that both keys and values are string.
  Map<String, String> stringValued({String prefix = ''}) {
    final Map<String, String> convertedMap = <String, String>{};
    for (final String key in keys) {
      final dynamic value = this[key];
      final String localKey =
          (prefix == '' ? key : '${prefix}_$key').toLowerCase();
      if (value is Map<String, dynamic>) {
        final Map<String, String> subMap = value.stringValued(prefix: localKey);
        convertedMap.addAll(subMap);
      } else if (value is List) {
        convertedMap[localKey] = jsonEncode(value);
        // if (value.isNotEmpty && value[0] is Map<String, dynamic>) {
        //   for (final Map<String, dynamic> el in value) {
        //     convertedMap[
        //             '${localKey}_${el['value'].toString().toLowerCase()}'] =
        //         el['label'];
        //   }
        // } else if (value.isNotEmpty && value[0] is String) {
        //   for (int i = 0; i < value.length; i++) {
        //     convertedMap['${localKey}_$i'] = value[i];
        //   }
        // } else {
        //   convertedMap[localKey] = value.toString();
        // }
      } else {
        convertedMap[localKey] = value.toString();
      }
    }
    return convertedMap;
  }
}
