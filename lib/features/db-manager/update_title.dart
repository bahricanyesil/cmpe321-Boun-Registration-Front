import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/decorations/input_decorations.dart';
import '../../core/extensions/extensions_shelf.dart';
import '../../core/helpers/error_dialog.dart';
import '../../core/managers/navigation/navigation_constants.dart';
import '../../core/managers/navigation/navigation_service.dart';
import '../../core/managers/network/network_manager.dart';
import 'db_manager_provider.dart';

class UpdateTitle extends StatefulWidget {
  const UpdateTitle(
      {required this.instructUsername, required this.oldTitle, Key? key})
      : super(key: key);
  final String instructUsername;
  final String oldTitle;

  @override
  State<UpdateTitle> createState() => _UpdateTitleState();
}

class _UpdateTitleState extends State<UpdateTitle> {
  late final DbManagerProvider _dbManagerProvider =
      context.read<DbManagerProvider>();
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.oldTitle);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white38,
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.width * 2, vertical: context.height * 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _textWidget('Instructor Username: ${widget.instructUsername}'),
              SizedBox(height: context.height * 4),
              _textWidget('Enter Title: '),
              SizedBox(height: context.height * 2),
              _textFormField(),
              Row(
                children: [
                  ElevatedButton(
                    style: _style,
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Back',
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ),
                  SizedBox(width: context.width * 4),
                  ElevatedButton(
                    style: _style,
                    onPressed: () async {
                      try {
                        final Map<String, dynamic> res =
                            await NetworkManager.instance.updateTitle(
                                widget.instructUsername, _titleController.text);
                        await NavigationService.instance.navigateToPageClear(
                            path: NavigationConstants.dbManager,
                            data: {"index": 1});
                      } on DioError catch (err) {
                        await ErrorDialog.show(context, err);
                      }
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );

  ButtonStyle get _style => ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
            vertical: context.height * 1.7, horizontal: context.width * 1)),
        fixedSize:
            MaterialStateProperty.all(Size.fromWidth(context.width * 14)),
      );

  Widget _textFormField() => TextFormField(
      decoration: InputDecorations().textFormDeco(context, text: 'Title'),
      controller: _titleController);

  Widget _textWidget(String text) => Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold),
      );
}
