import 'package:provider/single_child_widget.dart';

import '../../features/db-manager/db_manager_provider.dart';
import 'providers_shelf.dart';

/// Provides the list of providers will be used across the app.
class ProviderList {
  /// Singleton instance of [ProviderList].
  factory ProviderList() => _instance;
  ProviderList._();
  static final ProviderList _instance = ProviderList._();

  /// List of providers will be used for main [MultiProvider] class.
  static final List<SingleChildWidget> providers = <SingleChildWidget>[
    ..._viewModels,
    ..._functional,
  ];

  static final List<SingleChildWidget> _viewModels = <SingleChildWidget>[
    ChangeNotifierProvider<DbManagerProvider>(
      create: (_) => DbManagerProvider(),
    ),
  ];

  static final List<SingleChildWidget> _functional = <SingleChildWidget>[];
}
