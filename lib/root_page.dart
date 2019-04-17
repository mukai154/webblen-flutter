import 'package:flutter/material.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'auth_pages/onboarding_page.dart';
import 'auth_pages/login_page.dart';
import 'package:webblen/user_pages/dashboard_page.dart';


class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus {
  notDetermined,
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {

  AuthStatus authStatus = AuthStatus.notDetermined;

  @override
  initState() {
    super.initState();
    BaseAuth().currentUser().then((userId) {
      setState(() {
        authStatus = userId != null ? AuthStatus.signedIn : AuthStatus.notSignedIn;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notDetermined:
        return _buildWaitingScreen();
      case AuthStatus.notSignedIn:
        return new LoginPage();
      case AuthStatus.signedIn:
        return new DashboardPage();
    }
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

}