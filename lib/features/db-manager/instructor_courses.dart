import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/extensions/extensions_shelf.dart';
import '../../core/helpers/error_dialog.dart';
import '../../core/managers/navigation/navigation_constants.dart';
import '../../core/managers/navigation/navigation_service.dart';
import 'db_manager_provider.dart';

class InstructorCourses extends StatefulWidget {
  const InstructorCourses({required this.instructUsername, Key? key})
      : super(key: key);
  final String instructUsername;

  @override
  State<InstructorCourses> createState() => _InstructorCoursesState();
}

class _InstructorCoursesState extends State<InstructorCourses> {
  static const List<String> _courseHeaders = <String>[
    "Course ID",
    "Course Name",
    "Classroom ID",
    "Campus",
    "Time Slot",
    "Grade Average"
  ];
  static const List<String> _courseKeys = <String>[
    "course_ID",
    "name",
    "classroom_ID",
    "campus",
    "time_slot"
  ];
  late final DbManagerProvider _dbManagerProvider =
      context.read<DbManagerProvider>();

  List<Map<String, dynamic>> _list = [];

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white38,
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.width * 2, vertical: context.height * 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: context.height * 5,
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                            vertical: context.height * 1.7,
                            horizontal: context.width * 1)),
                        fixedSize: MaterialStateProperty.all(
                            Size.fromWidth(context.width * 8)),
                      ),
                      child: const Text('Back',
                          style: TextStyle(color: Colors.white, fontSize: 22)),
                    ),
                    const Spacer(),
                    const Expanded(
                      child: Text(
                        'COURSES',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              Expanded(child: _tabBarView()),
            ],
          ),
        ),
      );

  Widget _tabBarView() => Padding(
        padding: EdgeInsets.symmetric(vertical: context.height * 2),
        child: FutureBuilder<void>(
          future: _future(),
          builder: (BuildContext context, AsyncSnapshot snapshot) => Column(
            children: <Widget>[
              Expanded(
                child: DataTable2(
                  columnSpacing: context.width,
                  horizontalMargin: context.width,
              sortAscending: false,
                  columns: List<DataColumn2>.generate(
                    _courseHeaders.length,
                    (int i) => DataColumn2(
                      label: Center(
                        child: Text(
                          _courseHeaders[i],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  rows: List<DataRow>.generate(
                    _list.length,
                    (int i) => DataRow2(
                      cells: List<DataCell>.generate(
                        _courseHeaders.length,
                        (int keyIndex) => DataCell(
                          Center(
                            child: keyIndex == _courseHeaders.length - 1
                                ? ElevatedButton(
                                    onPressed: () => NavigationService.instance
                                        .navigateToPage(
                                            path: NavigationConstants
                                                .gradeAverage,
                                            data: {
                                          "course_ID": _list[i]['course_ID']
                                        }),
                                    child: const Text('See the Grade Average'),
                                  )
                                : Text(
                                    _list[i][_courseKeys[keyIndex]].toString(),
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
        ),
      );

  Future<void> _future() async {
    try {
      _list = await _dbManagerProvider.getCourses(widget.instructUsername);
    } on DioError catch (err) {
      await ErrorDialog.show(context, err);
    }
  }
}
