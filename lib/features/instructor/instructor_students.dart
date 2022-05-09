import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/extensions/extensions_shelf.dart';
import '../../core/helpers/error_dialog.dart';
import '../../core/managers/navigation/navigation_constants.dart';
import '../../core/managers/navigation/navigation_service.dart';
import '../db-manager/db_manager_provider.dart';

class InstructorStudents extends StatefulWidget {
  const InstructorStudents({required this.courseId, Key? key})
      : super(key: key);
  final String courseId;

  @override
  State<InstructorStudents> createState() => InstructorStudentsState();
}

class InstructorStudentsState extends State<InstructorStudents> {
  static const List<String> _studentHeaders = <String>[
    "Username",
    "Student ID",
    "Email",
    "Name",
    "Surname",
    "Give Grade"
  ];
  static const List<String> _studentKeys = <String>[
    "username",
    "student_ID",
    "email",
    "name",
    "surname"
  ];
  late final DbManagerProvider _dbManagerProvider =
      context.read<DbManagerProvider>();

  late String instructorUsername;
  List<Map<String, dynamic>> _list = [];

  @override
  Widget build(BuildContext context) {
    instructorUsername = context
        .select<DbManagerProvider, String>((DbManagerProvider p) => p.username);
    return Scaffold(
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
                      'STUDENTS WHO ADDED THE COURSE',
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
  }

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
                    _studentHeaders.length,
                    (int i) => DataColumn2(
                      label: Center(
                        child: Text(
                          _studentHeaders[i],
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
                        _studentHeaders.length,
                        (int keyIndex) => DataCell(
                          Center(
                            child: keyIndex == _studentHeaders.length - 1
                                ? ElevatedButton(
                                    onPressed: () {
                                      NavigationService.instance.navigateToPage(
                                          path: NavigationConstants.giveGrade,
                                          data: {
                                            "course_ID": widget.courseId,
                                            "student_ID": _list[i]
                                                ['student_ID'],
                                          });
                                    },
                                    child: const Text('Give Grade'),
                                  )
                                : Text(
                                    _list[i][_studentKeys[keyIndex]].toString(),
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
      _list = await _dbManagerProvider.getInstructorStudents(
          instructorUsername, widget.courseId);
    } on DioError catch (err) {
      await ErrorDialog.show(context, err);
    }
  }
}
