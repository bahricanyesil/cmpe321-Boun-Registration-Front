import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/extensions/extensions_shelf.dart';
import '../../core/helpers/error_dialog.dart';
import '../../core/managers/navigation/navigation_constants.dart';
import '../../core/managers/navigation/navigation_service.dart';
import '../../core/managers/network/network_manager.dart';
import 'db_manager_provider.dart';

class DbManagerHome extends StatefulWidget {
  const DbManagerHome({required this.index, Key? key}) : super(key: key);
  final int index;

  @override
  State<DbManagerHome> createState() => _DbManagerHomeState();
}

class _DbManagerHomeState extends State<DbManagerHome>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;
  int _tabIndex = 0;
  late final DbManagerProvider _dbManagerProvider =
      context.read<DbManagerProvider>();

  static const List<String> _userTypes = [
    'Students',
    'Instructors',
  ];
  static const List<String> _instructorHeaders = <String>[
    "Username",
    "Name",
    "Surname",
    "Email",
    "Department Name",
    "Department ID",
    "Title",
    "Courses",
    "Update Title",
  ];
  static const List<String> _instructorKeys = <String>[
    "username",
    "name",
    "surname",
    "email",
    "department_name",
    "department_ID",
    "title"
  ];
  static const List<String> _studentHeaders = <String>[
    "Username",
    "Name",
    "Surname",
    "Email",
    "Department Name",
    "Department ID",
    "Completed Credits",
    "GPA",
    "Grades",
    "Delete Student"
  ];
  static const List<String> _studentKeys = <String>[
    "username",
    "name",
    "surname",
    "email",
    "department_name",
    "department_ID",
    "completed_credits",
    "gpa"
  ];

  List<Map<String, dynamic>> _list = [];

  @override
  void initState() {
    super.initState();
    _tabIndex = widget.index;
    _controller =
        TabController(vsync: this, length: 2, initialIndex: widget.index);
    _future().then((_) => setState(() {}));
    _controller.addListener(() async {
      if (_tabIndex != _controller.index && !_controller.indexIsChanging) {
        _tabIndex = _controller.index;
        await _future();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white38,
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.width * 2, vertical: context.height * 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => NavigationService.instance
                      .navigateToPageClear(path: NavigationConstants.login),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                        vertical: context.height * 1.7,
                        horizontal: context.width * 1)),
                    fixedSize: MaterialStateProperty.all(
                        Size.fromWidth(context.width * 8)),
                  ),
                  child: const Text('Logout',
                      style: TextStyle(color: Colors.white, fontSize: 22)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: context.height),
                height: context.height * 5,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0),
                    border: const Border(
                        bottom: BorderSide(color: Colors.grey, width: 0.8)),
                  ),
                  child: TabBar(
                    indicatorColor: Colors.blue,
                    indicatorWeight: 3,
                    padding: EdgeInsets.zero,
                    controller: _controller,
                    labelPadding: EdgeInsets.zero,
                    tabs: <Widget>[
                      _textWidget('Students', 0),
                      _textWidget('Instructors', 1),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                    controller: _controller,
                    children: List<Widget>.generate(2, _tabBarView)),
              )
            ],
          ),
        ),
      );

  Widget _tabBarView(int i) {
    final List<String> headerTexts =
        _tabIndex == 0 ? _studentHeaders : _instructorHeaders;
    final List<String> keys = _tabIndex == 0 ? _studentKeys : _instructorKeys;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.height * 3),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: context.height * 2),
            child: ElevatedButton(
              onPressed: () {
                NavigationService.instance.navigateToPage(
                    path: NavigationConstants.addStudent,
                    data: {"user_type": _userTypes[_tabIndex]});
              },
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                      horizontal: context.width * 1.2,
                      vertical: context.height * 2))),
              child: Text(
                '+   Add New ${_tabIndex == 0 ? 'Student' : 'Instructor'}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Expanded(
            child: DataTable2(
              columnSpacing: context.width,
              horizontalMargin: context.width,
              sortAscending: false,
              columns: List<DataColumn2>.generate(
                headerTexts.length,
                (int i) => DataColumn2(
                  label: Center(
                    child: Text(
                      headerTexts[i],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              rows: List<DataRow2>.generate(
                _list.length,
                (int i) => DataRow2(
                  cells: List<DataCell>.generate(
                    headerTexts.length,
                    (int keyIndex) {
                      final bool isDelete =
                          _tabIndex == 0 && headerTexts.length - 1 == keyIndex;
                      return DataCell(
                        Center(
                          child: keyIndex == headerTexts.length - 1 ||
                                  keyIndex == headerTexts.length - 2
                              ? ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: isDelete
                                          ? MaterialStateProperty.all(
                                              Colors.red)
                                          : null),
                                  onPressed: () async {
                                    if (isDelete) {
                                      try {
                                        await NetworkManager.instance
                                            .deleteStudent(
                                                _list[i]["student_ID"]);
                                        _dbManagerProvider.students.removeAt(i);
                                        setState(() {});
                                      } on DioError catch (err) {
                                        await ErrorDialog.show(context, err);
                                      }
                                    } else {
                                      await NavigationService.instance
                                          .navigateToPage(
                                        path: _tabIndex == 0
                                            ? NavigationConstants.studentGrades
                                            : keyIndex == headerTexts.length - 2
                                                ? NavigationConstants
                                                    .instructorCourses
                                                : NavigationConstants
                                                    .updateTitle,
                                        data: {
                                          if (_tabIndex == 0)
                                            "student_ID": _list[i]["student_ID"]
                                          else
                                            "instructor_username": _list[i]
                                                ["username"],
                                          if (_tabIndex == 1 &&
                                              keyIndex ==
                                                  headerTexts.length - 1)
                                            'old_title': _list[i]["title"],
                                        },
                                      );
                                    }
                                  },
                                  child: Text(keyIndex ==
                                              headerTexts.length - 1 &&
                                          _tabIndex == 1
                                      ? 'Update Title'
                                      : (isDelete
                                          ? 'Delete Student'
                                          : 'See the ${headerTexts[keyIndex]}')),
                                )
                              : Text(
                                  _list[i][keys[keyIndex]].toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textWidget(String text, int i) => Container(
        height: context.height * 5,
        padding: EdgeInsets.zero,
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
              color: i == _tabIndex ? Colors.blue : Colors.black,
              fontSize: i == _tabIndex ? 20 : 18,
              fontWeight: i == _tabIndex ? FontWeight.w800 : FontWeight.w400),
        ),
      );

  Future<void> _future() async {
    try {
      if (_tabIndex == 0) {
        _list = await _dbManagerProvider.getStudents();
      } else {
        _list = await _dbManagerProvider.getInstructors();
      }
    } on DioError catch (err) {
      await ErrorDialog.show(context, err);
    }
  }
}
