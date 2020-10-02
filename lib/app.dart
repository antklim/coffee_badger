import 'package:coffee_badger/ratio/screen.dart';
import 'package:flutter/material.dart';

// TODO: make HomePage() as home.
// TODO: add menu/tabs to switch between home page and ratio.

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Badger',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RatioScreen(),
      // initialRoute: '/ratio',
      // onGenerateRoute: _getRoute,
    );
  }

  // Route<dynamic> _getRoute(RouteSettings settings) {
  //   if (settings.name != '/ratio') {
  //     return null;
  //   }

  //   return MaterialPageRoute<void>(
  //     settings: settings,
  //     builder: (BuildContext context) => RatioPage(),
  //     fullscreenDialog: true,
  //   );
  // }
}
