import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// -
mixin ErrorDialog {
  ///-
  static Future<void> show(BuildContext context, DioError error,
      {String? errorMessage, bool isError = true}) async {
    final Map<String, dynamic> map = errorMessage == null
        ? (error.response?.data is Map<String, dynamic>
            ? error.response?.data
            : {})
        : {"resultMessage": errorMessage};
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog(
        title: Text(isError ? 'ERROR!' : 'SUCCESS!',
            style: const TextStyle(color: Colors.red, fontSize: 2)),
        content: SingleChildScrollView(
          child: Text(map['resultMessage'] ?? 'Error occurred',
              style: const TextStyle(color: Colors.black, fontSize: 16)),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
