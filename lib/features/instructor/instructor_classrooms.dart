import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/extensions/extensions_shelf.dart';
import '../../core/helpers/error_dialog.dart';
import '../db-manager/db_manager_provider.dart';

class InstructorClassrooms extends StatefulWidget {
  const InstructorClassrooms({required this.timeSlot, Key? key})
      : super(key: key);
  final int timeSlot;

  @override
  State<InstructorClassrooms> createState() => InstructorClassroomsState();
}

class InstructorClassroomsState extends State<InstructorClassrooms> {
  static const List<String> _classroomHeaders = <String>[
    "Classroom ID",
    "Campus",
    "Classroom Capacity"
  ];
  static const List<String> _classroomKeys = <String>[
    "classroom_ID",
    "campus",
    "classroom_capacity",
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
                        'AVAILABLE CLASSROOMS',
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
                    _classroomHeaders.length,
                    (int i) => DataColumn2(
                      label: Center(
                        child: Text(
                          _classroomHeaders[i],
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
                        _classroomHeaders.length,
                        (int keyIndex) => DataCell(
                          Center(
                            child: Text(
                              _list[i][_classroomKeys[keyIndex]].toString(),
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
      _list = await _dbManagerProvider.getInstructorClassrooms(widget.timeSlot);
    } on DioError catch (err) {
      await ErrorDialog.show(context, err);
    }
  }
}
