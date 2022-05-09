import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/decorations/input_decorations.dart';
import '../../core/extensions/context/context_extensions_shelf.dart';
import '../../core/helpers/error_dialog.dart';
import '../../core/managers/managers_shelf.dart';
import '../../core/managers/navigation/navigation_constants.dart';
import '../db-manager/db_manager_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;
  int _tabIndex = 0;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final DbManagerProvider dbMangerProv = context.read<DbManagerProvider>();

  static const List<String> _userTypes = [
    'Student',
    'Instructor',
    'Database Manager'
  ];

  static const List<String> _dbTableTypes = [
    'Students',
    'Instructors',
    'DatabaseManager'
  ];

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _controller = TabController(vsync: this, length: 3);
    _controller.addListener(() {
      if (_tabIndex != _controller.index && !_controller.indexIsChanging) {
        setState(() {
          _tabIndex = _controller.index;
        });
      }
    });
  }

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
                      _textWidget('Student', 0),
                      _textWidget('Instructor', 1),
                      _textWidget('Database Manager', 2),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                    controller: _controller,
                    children: List<Widget>.generate(3, _tabBarView)),
              )
            ],
          ),
        ),
      );

  Widget _tabBarView(int i) => Padding(
        padding: EdgeInsets.symmetric(vertical: context.height * 10),
        child: Column(
          children: <Widget>[
            Text('WELCOME ${_userTypes[i]}!',
                style: const TextStyle(fontSize: 30, color: Colors.black)),
            SizedBox(height: context.height * 5),
            _textFormField(true),
            _textFormField(false),
            SizedBox(height: context.height * 2),
            ElevatedButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                    vertical: context.height * 2,
                    horizontal: context.width * 1)),
                fixedSize: MaterialStateProperty.all(
                    Size.fromWidth(context.width * 20)),
              ),
              onPressed: () async {
                try {
                  final Map<String, dynamic> res =
                      await NetworkManager.instance.login(
                    username: _usernameController.text,
                    password: _passwordController.text,
                    userType: _dbTableTypes[_tabIndex],
                  );
                  final Map<String, dynamic> map =
                      res['user'] is Map<String, dynamic>
                          ? res['user']
                          : {"username": ''};
                  dbMangerProv.setUsername(map);
                  await NavigationService.instance.navigateToPage(
                      path: _tabIndex == 2
                          ? NavigationConstants.dbManager
                          : (_tabIndex == 1
                              ? NavigationConstants.instructorHome
                              : NavigationConstants.studentHome));
                } on DioError catch (err) {
                  await ErrorDialog.show(context, err);
                }
              },
              child: const Text('Login',
                  style: TextStyle(color: Colors.white, fontSize: 25)),
            )
          ],
        ),
      );

  Widget _textFormField(bool isUsername) {
    final String text = isUsername ? 'Username' : 'Password';
    return TextFormField(
        decoration: InputDecorations().textFormDeco(context,
            text: text,
            icon: isUsername ? Icons.person_outline : Icons.password),
        controller: isUsername ? _usernameController : _passwordController);
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
