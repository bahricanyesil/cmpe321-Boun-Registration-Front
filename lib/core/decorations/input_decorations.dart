import 'package:flutter/material.dart';

import '../extensions/context/responsiveness_extensions.dart';

class InputDecorations {
  InputDecoration textFormDeco(BuildContext context,
          {required String text, IconData? icon}) =>
      InputDecoration(
          hoverColor: Theme.of(context).primaryColorLight.withOpacity(.1),
          hintText: text,
          labelText: text,
          errorMaxLines: 1,
          errorStyle: const TextStyle(height: 0, color: Colors.transparent),
          prefixIcon: icon == null
              ? null
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.width * .5),
                  child: Icon(icon)),
          prefixIconConstraints: BoxConstraints.loose(
              Size.fromHeight(context.responsiveSize * 10)),
          filled: true,
          contentPadding: EdgeInsets.symmetric(
              horizontal: context.width * 1, vertical: context.height * 2),
          isDense: true,
          disabledBorder: _border(Colors.blueGrey[100]),
          enabledBorder: _border(Colors.blueGrey[300]),
          errorBorder: _border(Colors.red),
          focusedBorder: _border(Colors.blueGrey[300], width: 1.1),
          focusedErrorBorder: _border(Colors.red, width: 1.1),
          constraints: BoxConstraints.tight(
              Size(context.width * 45, context.height * 8)));

  OutlineInputBorder _border(Color? color, {double? width}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color ?? Colors.black, width: width ?? 1),
      );
}
