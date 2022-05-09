import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'core/managers/navigation/navigation_constants.dart';
import 'core/managers/navigation/navigation_route.dart';
import 'core/managers/navigation/navigation_service.dart';
import 'core/providers/providers_shelf.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  InitialApp.usePathUrlStrategy();
  runApp(const _BeforeApp());
}

class _BeforeApp extends StatefulWidget {
  const _BeforeApp({Key? key}) : super(key: key);

  @override
  State<_BeforeApp> createState() => _BeforeAppState();
}

class _BeforeAppState extends State<_BeforeApp> {
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: ProviderList.providers,
        child: const InitialApp(appName: 'BOUN Registration'),
      );
}

/// Material app widget of the app.
class InitialApp extends StatelessWidget {
  /// Default constructor for [InitialApp] widget.
  const InitialApp({required this.appName, Key? key}) : super(key: key);

  /// Name of the app.
  final String appName;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: NavigationRoute.instance.generateRoute,
        navigatorKey: NavigationService.instance.navigatorKey,
        initialRoute: NavigationConstants.login,
      );

  /// Sets the path url strategy.
  static void usePathUrlStrategy() => setUrlStrategy(PathUrlStrategy());
}
