import 'package:flutter/material.dart';
import 'package:flutter_app/screens/inventory_list_screen.dart';
import 'package:flutter_app/store/models/models.dart';
import 'package:flutter_app/store/reducers/app_reducer.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:logging/logging.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_thunk/redux_thunk.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  final logger = new Logger('Redux Logger');

  logger.onRecord.where((record) => record.loggerName == logger.name).listen(
      (loggingMiddlewareRecord) => print(loggingMiddlewareRecord.toString()));

  final reduxLoggingMiddleware = LoggingMiddleware(
    logger: logger,
    formatter: LoggingMiddleware.multiLineFormatter,
  );

  AppState initialState;

  initialState = AppState(
    inventory:
        InventoryState(allIds: [], byId: {}, fetching: false, sending: false),
  );

  final store = Store<AppState>(appReducer,
      initialState: initialState,
      middleware: [thunkMiddleware, reduxLoggingMiddleware]);

  print('Initial state: ${store.state}');

  runApp(StoreProvider(store: store, child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, InventoryState>(
      converter: (Store<AppState> store) => store.state.inventory,
      builder: (BuildContext context, InventoryState inventory) {
        return MaterialApp(
          title: 'Inventory App',
          theme: ThemeData(
              primaryColor: Color.fromRGBO(98, 0, 238, 1),
              accentColor: Color.fromRGBO(98, 0, 238, 1)),
          initialRoute: '/',
          routes: {
            '/': (BuildContext context) => InventoryListScreen(routeObserver)
          },
        );
      },
    );
  }
}
