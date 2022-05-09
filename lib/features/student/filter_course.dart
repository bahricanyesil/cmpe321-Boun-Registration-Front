import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/decorations/input_decorations.dart';
import '../../core/extensions/extensions_shelf.dart';
import '../../core/helpers/error_dialog.dart';
import '../../core/managers/network/network_manager.dart';
import '../db-manager/db_manager_provider.dart';

class FilterCourse extends StatefulWidget {
  const FilterCourse({Key? key}) : super(key: key);

  @override
  State<FilterCourse> createState() => _FilterCourseState();
}

class _FilterCourseState extends State<FilterCourse>
    with SingleTickerProviderStateMixin {
  late final DbManagerProvider _dbManagerProvider =
      context.read<DbManagerProvider>();
  late final TextEditingController _departmentIdController;
  late final TextEditingController _campusController;
  late final TextEditingController _minCreditsController;
  late final TextEditingController _maxCreditsController;

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

  List<Map<String, dynamic>> _list = [];
  late String _studentId;

  @override
  void initState() {
    super.initState();
    _departmentIdController = TextEditingController();
    _campusController = TextEditingController();
    _minCreditsController = TextEditingController();
    _maxCreditsController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _studentId = context.select<DbManagerProvider, String>(
        (DbManagerProvider p) => p.studentId);
    return Scaffold(
      backgroundColor: Colors.white38,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: context.width * 2, vertical: context.height * 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
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
            ),
            SizedBox(height: context.height * 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  decoration: InputDecorations()
                      .textFormDeco(context, text: 'Department ID'),
                  controller: _departmentIdController,
                ),
                TextFormField(
                  decoration:
                      InputDecorations().textFormDeco(context, text: 'Campus'),
                  controller: _campusController,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  decoration: InputDecorations()
                      .textFormDeco(context, text: 'Min Credits'),
                  controller: _minCreditsController,
                ),
                TextFormField(
                  decoration: InputDecorations()
                      .textFormDeco(context, text: 'Max Credits'),
                  controller: _maxCreditsController,
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _filter,
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                    vertical: context.height * 1.7,
                    horizontal: context.width * 1)),
                fixedSize: MaterialStateProperty.all(
                    Size.fromWidth(context.width * 8)),
              ),
              child: const Text('Filter',
                  style: TextStyle(color: Colors.white, fontSize: 22)),
            ),
            Expanded(child: _tabBarView),
          ],
        ),
      ),
    );
  }

  Widget get _tabBarView {
    const List<String> headers = _courseHeaders;
    const List<String> keys = _courseKeys;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.height * 1),
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
                  child: keyIndex == headers.length - 1
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
                                      requestOptions: RequestOptions(path: '')),
                                  errorMessage: res['resultMessage'] ?? '',
                                  isError: false);
                            } on DioError catch (err) {
                              await ErrorDialog.show(context, err);
                            }
                          },
                          child: const Text(
                            'Enroll',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 16),
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
    );
  }

  Future<void> _filter() async {
    try {
      _list = await _dbManagerProvider.filterCourse(
          _departmentIdController.text,
          _campusController.text,
          _minCreditsController.text,
          _maxCreditsController.text);
      setState(() {});
    } on DioError catch (err) {
      await ErrorDialog.show(context, err);
    }
  }
}
