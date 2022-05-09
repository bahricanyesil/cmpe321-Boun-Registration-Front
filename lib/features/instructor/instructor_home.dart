import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/extensions/extensions_shelf.dart';
import '../../core/helpers/error_dialog.dart';
import '../../core/managers/navigation/navigation_constants.dart';
import '../../core/managers/navigation/navigation_service.dart';
import '../db-manager/db_manager_provider.dart';

class InstructorHome extends StatefulWidget {
  const InstructorHome({required this.index, Key? key}) : super(key: key);
  final int index;

  @override
  State<InstructorHome> createState() => _InstructorHomeState();
}

class _InstructorHomeState extends State<InstructorHome>
    with SingleTickerProviderStateMixin {
  late final DbManagerProvider _dbManagerProvider =
      context.read<DbManagerProvider>();

  static const List<String> _coursesHeaders = <String>[
    "Course ID",
    "Course Name",
    "Classroom ID",
    "Time Slot",
    "Quota",
    "Prerequisite List",
    "Add Prerequisite",
    "Update Course Name"
  ];
  static const List<String> _coursesKeys = <String>[
    "course_ID",
    "name",
    "classroom_ID",
    "time_slot",
    "quota",
    "prerequisites"
  ];

  List<Map<String, dynamic>> _list = [];
  late String instructorUsername;

  @override
  Widget build(BuildContext context) {
    instructorUsername = context
        .select<DbManagerProvider, String>((DbManagerProvider p) => p.username);
    return Scaffold(
      backgroundColor: Colors.white38,
      body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.width * 2, vertical: context.height * 4),
          child: _tabBarView()),
    );
  }

  Widget _tabBarView() => FutureBuilder<void>(
        future: _future(),
        builder: (BuildContext context, AsyncSnapshot snapshot) => Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: context.height * 2),
              child: Row(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      NavigationService.instance
                          .navigateToPage(path: NavigationConstants.addCourse);
                    },
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                            horizontal: context.width * 1.2,
                            vertical: context.height * 2))),
                    child: const Text(
                      '+   Add New Course',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
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
                  SizedBox(width: context.width * 2),
                  ElevatedButton(
                    onPressed: _selectTimeSlot,
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                            horizontal: context.width * 1.2,
                            vertical: context.height * 2))),
                    child: const Text(
                      'List Classrooms',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: DataTable2(
                columnSpacing: context.width,
                horizontalMargin: context.width,
                sortAscending: false,
                columns: List<DataColumn2>.generate(
                  _coursesHeaders.length,
                  (int i) => DataColumn2(
                    label: Center(
                      child: Text(
                        _coursesHeaders[i],
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
                    onTap: () {
                      NavigationService.instance.navigateToPage(
                          path: NavigationConstants.instructorStudents,
                          data: {"course_ID": _list[i]['course_ID']});
                    },
                    cells: List<DataCell>.generate(
                      _coursesHeaders.length,
                      (int keyIndex) => DataCell(
                        Center(
                          child: keyIndex == _coursesHeaders.length - 1 ||
                                  keyIndex == _coursesHeaders.length - 2
                              ? ElevatedButton(
                                  onPressed: () {
                                    NavigationService.instance.navigateToPage(
                                        path: keyIndex ==
                                                _coursesHeaders.length - 2
                                            ? NavigationConstants
                                                .addPrerequisite
                                            : NavigationConstants
                                                .updateCourseName,
                                        data: {
                                          "course_ID": _list[i]['course_ID'],
                                          "old_name": _list[i]['name'],
                                        });
                                  },
                                  child: Text(
                                      keyIndex == _coursesHeaders.length - 1
                                          ? 'Update the Course Name'
                                          : 'Add a Prerequisite'),
                                )
                              : Text(
                                  _list[i][_coursesKeys[keyIndex]].toString(),
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

  Future<void> _selectTimeSlot() async {
    final int? timeSlot = await showDialog<int>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: const Text('Select a time slot',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
        children: List<SimpleDialogOption>.generate(
          10,
          (int i) => SimpleDialogOption(
            child: Text(
              (i + 1).toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            onPressed: () => Navigator.of(context).pop(i + 1),
          ),
        ),
      ),
    );
    if (timeSlot == null) {
      // ignore: use_build_context_synchronously
      await ErrorDialog.show(
          context, DioError(requestOptions: RequestOptions(path: '')),
          errorMessage: 'Please select a time slot.');
    } else {
      await NavigationService.instance.navigateToPage(
          path: NavigationConstants.instructorClassrooms,
          data: {"time_slot": timeSlot});
    }
  }

  Future<void> _future() async {
    try {
      _list = await _dbManagerProvider.getInstructorCourses(instructorUsername);
    } on DioError catch (err) {
      await ErrorDialog.show(context, err);
    }
  }
}
