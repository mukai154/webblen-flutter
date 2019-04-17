import 'package:flutter/material.dart';
import 'auth_pages/login_page.dart';
import 'user_pages/dashboard_page.dart';
import 'package:webblen/user_pages/setup_page.dart';
import 'new_event_paging/new_event_paging_view.dart';
import 'package:flutter/services.dart';
import 'root_page.dart';
import 'styles/flat_colors.dart';


void main() => runApp(new WebblenApp());

class WebblenApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Webblen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: FlatColors.webblenRed,
        accentColor: FlatColors.darkGray,
      ),
      home: RootPage(),
      routes: <String, WidgetBuilder> {
        '/root': (BuildContext context) => new RootPage(),
        '/dashboard' : (BuildContext context) => new DashboardPage(),
        '/new_event' : (BuildContext context) => new NewEventPage(),
        '/login' : (BuildContext context) => new LoginPage(),
        '/setup' : (BuildContext context) => new SetupPage(),
      },
    );
  }
}

