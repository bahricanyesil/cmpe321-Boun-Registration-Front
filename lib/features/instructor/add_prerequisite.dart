import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/decorations/input_decorations.dart';
import '../../core/extensions/extensions_shelf.dart';
import '../../core/helpers/error_dialog.dart';
import '../../core/managers/navigation/navigation_constants.dart';
import '../../core/managers/navigation/navigation_service.dart';
import '../../core/managers/network/network_manager.dart';
import '../db-manager/db_manager_provider.dart';

class AddPrerequisite extends StatefulWidget {
  const AddPrerequisite({required this.courseId, Key? key}) : super(key: key);
  final String courseId;

  @override
  State<AddPrerequisite> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddPrerequisite> {
  late final TextEditingController _courseIdController;
  late String username;

  @override
  void initState() {
    super.initState();
    _courseIdController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    username = context
        .select<DbManagerProvider, String>((DbManagerProvider p) => p.username);
    return Scaffold(
      backgroundColor: Colors.white38,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: context.width * 2, vertical: context.height * 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Course ID: ${widget.courseId}',
                style: const TextStyle(color: Colors.black, fontSize: 16)),
            SizedBox(height: context.height * 4),
            _textFormField('Prerequisite Course ID', _courseIdController),
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
                      await NetworkManager.instance.addPrerequisite(
                          _courseIdController.text, widget.courseId, username);
                      await NavigationService.instance.navigateToPageClear(
                          path: NavigationConstants.instructorHome);
                    } on DioError catch (err) {
                      await ErrorDialog.show(context, err);
                    }
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  ButtonStyle get _style => ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
            vertical: context.height * 1.7, horizontal: context.width * 1)),
        fixedSize:
            MaterialStateProperty.all(Size.fromWidth(context.width * 14)),
      );

  Widget _textFormField(String text, TextEditingController controller) =>
      Padding(
        padding: EdgeInsets.only(bottom: context.height),
        child: TextFormField(
          decoration: InputDecorations().textFormDeco(context, text: text),
          controller: controller,
        ),
      );
}
