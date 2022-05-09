import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/extensions/extensions_shelf.dart';
import '../../core/helpers/error_dialog.dart';
import '../../core/managers/navigation/navigation_constants.dart';
import '../../core/managers/navigation/navigation_service.dart';
import '../../core/managers/network/network_manager.dart';
import '../db-manager/db_manager_provider.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({required this.index, Key? key}) : super(key: key);
  final int index;

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;
  int _tabIndex = 0;
  late final DbManagerProvider _dbManagerProvider =
      context.read<DbManagerProvider>();

  static const List<String> _courseTypes = [
    'All Courses',
    'Current&Past Courses',
  ];

  static const List<String> _courseHeaders = <String>[
    "Course ID",
    "Course Name",
    "Instructor Surname",
    "Department ID",
    "Department Name",
    "Credits",
    "Classroom ID",
    "Time Slot",
    "Quota",
    "Prerequisite List",
    "Enroll"
  ];

  static const List<String> _courseKeys = <String>[
    "course_ID",
    "name",
    "surname",
    "department_ID",
    "department_name",
    "credits",
    "classroom_ID",
    "time_slot",
    "quota",
    "prerequisites",
  ];

  static const List<String> _studentCoursesHeaders = <String>[
    "Course ID",
    "Course Name",
    "Grade"
  ];

  static const List<String> _studentCoursesKeys = <String>[
    "course_ID",
    "name",
    "grade",
  ];

  List<Map<String, dynamic>> _list = [];
  late String _studentId;

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
  Widget build(BuildContext context) {
    _studentId = context.select<DbManagerProvider, String>(
        (DbManagerProvider p) => p.studentId);
    return Scaffold(
      backgroundColor: Colors.white38,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: context.width * 2, vertical: context.height * 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => NavigationService.instance
                      .navigateToPage(path: NavigationConstants.searchCourse),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                        vertical: context.height * 1.7,
                        horizontal: context.width * 1)),
                    fixedSize: MaterialStateProperty.all(
                        Size.fromWidth(context.width * 15)),
                  ),
                  child: const Text('Search a Course',
                      style: TextStyle(color: Colors.white, fontSize: 22)),
                ),
                SizedBox(width: context.width * 2),
                ElevatedButton(
                  onPressed: () => NavigationService.instance
                      .navigateToPage(path: NavigationConstants.filterCourse),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                        vertical: context.height * 1.7,
                        horizontal: context.width * 1)),
                    fixedSize: MaterialStateProperty.all(
                        Size.fromWidth(context.width * 15)),
                  ),
                  child: const Text('Filter a Course',
                      style: TextStyle(color: Colors.white, fontSize: 22)),
                ),
                const Spacer(),
                ElevatedButton(
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
              ],
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
                    _textWidget(_courseTypes[0], 0),
                    _textWidget(_courseTypes[1], 1),
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
  }

  Widget _tabBarView(int i) {
    final List<String> headers =
        _tabIndex == 0 ? _courseHeaders : _studentCoursesHeaders;
    final List<String> keys =
        _tabIndex == 0 ? _courseKeys : _studentCoursesKeys;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.height * 3),
      child: Column(
        children: <Widget>[
          Expanded(
            child: DataTable2(
              columnSpacing: context.width,
              horizontalMargin: context.width,
              sortAscending: false,
              columns: List<DataColumn2>.generate(
                headers.length,
                (int i) => DataColumn2(
                  label: Center(
                    child: Text(
                      headers[i],
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
                    headers.length,
                    (int keyIndex) => DataCell(
                      Center(
                        child: keyIndex == headers.length - 1 && _tabIndex == 0
                            ? ElevatedButton(
                                onPressed: () async {
                                  try {
                                    final Map<String, dynamic> res =
                                        await NetworkManager.instance.enroll(
                                            _studentId, _list[i]['course_ID']);
                                    // ignore: use_build_context_synchronously
                                    await ErrorDialog.show(
                                        context,
                                        DioError(
                                            requestOptions:
                                                RequestOptions(path: '')),
                                        errorMessage:
                                            res['resultMessage'] ?? '',
                                        isError: false);
                                  } on DioError catch (err) {
                                    await ErrorDialog.show(context, err);
                                  }
                                },
                                child: const Text(
                                  'Enroll',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              )
                            : Text(
                                _list[i][keys[keyIndex]].toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _future() async {
    try {
      if (_tabIndex == 0) {
        _list = await _dbManagerProvider.getAllCourses();
      } else {
        _list = await _dbManagerProvider.getStudentCourses(_studentId);
      }
    } on DioError catch (err) {
      await ErrorDialog.show(context, err);
    }
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
}
