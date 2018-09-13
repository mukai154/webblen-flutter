import 'package:flutter/material.dart';
import 'auth_pages/login_page.dart';
import 'user_pages/dashboard_page.dart';
import 'package:webblen/user_pages/setup_page.dart';
import 'new_event_paging/new_event_paging_view.dart';
import 'onboarding/onboarding_paging.dart';
import 'package:flutter/services.dart';
import 'root_page.dart';
import 'styles/flat_colors.dart';
import 'dart:async';

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
        primaryColor: FlatColors.darkGray,
        accentColor: FlatColors.londonSquare,
      ),
      home: SplashScreen(),
      routes: <String, WidgetBuilder> {
        '/root': (BuildContext context) => new RootPage(),
        '/dashboard' : (BuildContext context) => new DashboardPage(),
        '/new_event' : (BuildContext context) => new NewEventPage(),
        '/login' : (BuildContext context) => new LoginPage(),
        '/setup' : (BuildContext context) => new SetupPage(),
        '/onboarding' : (BuildContext context) => new OnboardingPaging(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/root');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {

    // **WEBBLEN LOGO
    final logo = Hero(
      tag: 'image',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 100.0,
        child: Image.asset('assets/images/webblen_logo.png'),
      ),
    );

    return Scaffold(
      body: new Stack(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(image: new AssetImage('assets/images/sunkist_gradient.png'), fit: BoxFit.cover),
            ),
          ),
          new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                logo,
              ],
            ),
          ),
        ],
      ),
    );
  }
}


