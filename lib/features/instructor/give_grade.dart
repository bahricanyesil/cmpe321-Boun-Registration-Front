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

class GiveGrade extends StatefulWidget {
  const GiveGrade({required this.courseId, required this.studentId, Key? key})
      : super(key: key);
  final String courseId;
  final String studentId;

  @override
  State<GiveGrade> createState() => _UpdateCourseNameState();
}

class _UpdateCourseNameState extends State<GiveGrade> {
  late final DbManagerProvider _dbManagerProvider =
      context.read<DbManagerProvider>();
  late final TextEditingController _gradeController;
  late String instructorUsername;

  @override
  void initState() {
    super.initState();
    _gradeController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    instructorUsername = context
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
            _textWidget('Course ID: ${widget.courseId}'),
            SizedBox(height: context.height * 2),
            _textWidget('Student ID: ${widget.studentId}'),
            SizedBox(height: context.height * 4),
            _textWidget('Enter the Grade: '),
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
                          await NetworkManager.instance.giveGrade(
                              widget.courseId,
                              widget.studentId,
                              instructorUsername,
                              _gradeController.text);
                      await NavigationService.instance.navigateToPageClear(
                          path: NavigationConstants.instructorHome);
                    } on DioError catch (err) {
                      await ErrorDialog.show(context, err);
                    }
                  },
                  child: const Text(
                    'Give Grade',
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

  Widget _textFormField() => TextFormField(
      decoration: InputDecorations().textFormDeco(context, text: 'Grade'),
      controller: _gradeController);

  Widget _textWidget(String text) => Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold),
      );
}
