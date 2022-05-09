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

class AddUser extends StatefulWidget {
  const AddUser({required this.userType, Key? key}) : super(key: key);
  final String userType;

  @override
  State<AddUser> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddUser> {
  late final DbManagerProvider _dbManagerProvider =
      context.read<DbManagerProvider>();
  late final TextEditingController _studentIdController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _nameController;
  late final TextEditingController _surnameController;
  late final TextEditingController _emailController;
  late final TextEditingController _departmentIdController;
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _studentIdController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _emailController = TextEditingController();
    _departmentIdController = TextEditingController();
    _titleController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final bool isStudent = widget.userType == 'Students';
    return Scaffold(
      backgroundColor: Colors.white38,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: context.width * 2, vertical: context.height * 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _textFormField(isStudent ? 'Student ID' : 'Title',
                isStudent ? _studentIdController : _titleController),
            _textFormField('Username', _usernameController),
            _textFormField('Password', _passwordController),
            _textFormField('Name', _nameController),
            _textFormField('Surname', _surnameController),
            _textFormField('Email', _emailController),
            _textFormField('Department ID', _departmentIdController),
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
                      final Map<String, dynamic> res = isStudent
                          ? await NetworkManager.instance.addStudent(
                              username: _usernameController.text,
                              departmentId: _departmentIdController.text,
                              email: _emailController.text,
                              name: _nameController.text,
                              password: _passwordController.text,
                              studentId: _studentIdController.text,
                              surname: _surnameController.text,
                            )
                          : await NetworkManager.instance.addInstructor(
                              username: _usernameController.text,
                              departmentId: _departmentIdController.text,
                              email: _emailController.text,
                              name: _nameController.text,
                              password: _passwordController.text,
                              title: _titleController.text,
                              surname: _surnameController.text,
                            );
                      await NavigationService.instance.navigateToPageClear(
                          path: NavigationConstants.dbManager,
                          data: {"index": isStudent ? 0 : 1});
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
