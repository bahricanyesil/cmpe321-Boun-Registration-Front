import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/extensions/extensions_shelf.dart';
import '../../core/helpers/error_dialog.dart';
import 'db_manager_provider.dart';

class GradeAverage extends StatefulWidget {
  const GradeAverage({required this.courseId, Key? key}) : super(key: key);
  final String courseId;

  @override
  State<GradeAverage> createState() => _GradeAverageState();
}

class _GradeAverageState extends State<GradeAverage> {
  static const List<String> _gradeHeaders = <String>[
    "Course ID",
    "Course Name",
    "Grade Average"
  ];
  static const List<String> _gradeKeys = <String>[
    "course_ID",
    "name",
    "average_grade"
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
                        'GRADE AVERAGES',
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
                    _gradeHeaders.length,
                    (int i) => DataColumn2(
                      label: Center(
                        child: Text(
                          _gradeHeaders[i],
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
                        _gradeHeaders.length,
                        (int keyIndex) => DataCell(
                          Center(
                            child: Text(
                              _list[i][_gradeKeys[keyIndex]].toString(),
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
      _list = await _dbManagerProvider.getGradeAverage(widget.courseId);
      print(_list);
    } on DioError catch (err) {
      await ErrorDialog.show(context, err);
    }
  }
}
