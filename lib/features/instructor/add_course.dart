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

class AddCourse extends StatefulWidget {
  const AddCourse({Key? key}) : super(key: key);

  @override
  State<AddCourse> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddCourse> {
  late final TextEditingController _courseIdController;
  late final TextEditingController _nameController;
  late final TextEditingController _creditsController;
  late final TextEditingController _classroomIdController;
  late final TextEditingController _timeSlotController;
  late final TextEditingController _quotaController;
  late String instructorUsername;
  late String departmentId;

  @override
  void initState() {
    super.initState();
    _courseIdController = TextEditingController();
    _nameController = TextEditingController();
    _creditsController = TextEditingController();
    _classroomIdController = TextEditingController();
    _timeSlotController = TextEditingController();
    _quotaController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    instructorUsername = context
        .select<DbManagerProvider, String>((DbManagerProvider p) => p.username);
    departmentId = context.select<DbManagerProvider, String>(
        (DbManagerProvider p) => p.departmentId);
    return Scaffold(
      backgroundColor: Colors.white38,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: context.width * 2, vertical: context.height * 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _textFormField('Course ID', _courseIdController),
            _textFormField('Course Name', _nameController),
            _textFormField('Credits', _creditsController),
            _textFormField('Classroom ID', _classroomIdController),
            _textFormField('Time Slot', _timeSlotController),
            _textFormField('Quota', _quotaController),
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
                      await NetworkManager.instance.addCourse(
                        classroomId: _classroomIdController.text,
                        courseId: _courseIdController.text,
                        credits: _creditsController.text,
                        name: _nameController.text,
                        quota: _quotaController.text,
                        timeSlot: _timeSlotController.text,
                        instructorUsername: instructorUsername,
                        departmentId: departmentId,
                      );
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
