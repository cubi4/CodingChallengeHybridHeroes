import 'package:flutter/material.dart';
import 'package:flutter_app/screens/inventory_list_screen.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory App',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(98, 0, 238, 1),
        accentColor: Color.fromRGBO(98, 0, 238, 1)
      ),
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => InventoryListScreen(routeObserver)
      },
    );
  }
}

