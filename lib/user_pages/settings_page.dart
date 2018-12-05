import 'package:flutter/material.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'package:webblen/styles/gradients.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:webblen/widgets_common/common_button.dart';
import 'package:webblen/animations/transition_animations.dart';
import 'dart:async';
import 'package:webblen/onboarding/webblen_guide_page.dart';

final settingsScaffoldKey = new GlobalKey<ScaffoldState>();

class SettingsPage extends StatefulWidget {

  static String tag = "settings-page";

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  void transitionToRootPage () => Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  void transitionToOnboarding () => Navigator.of(context).pushNamedAndRemoveUntil('/onboarding', (Route<dynamic> route) => false);
  void transitionToGuidePage () =>  Navigator.push(context, SlideFromRightRoute(widget: WebblenGuidePage()));

  Future<Null> _signOut() async {
    ScaffoldState scaffold = settingsScaffoldKey.currentState;
    await FacebookLogin().logOut();
    BaseAuth().signOut().then((uid){
      if (uid == null){
        transitionToRootPage();
      } else {
        scaffold.showSnackBar(new SnackBar(
          content: new Text("Invalid Username or Passowrd"),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 800),
        ));
      }
    });
  }

  // ** APP BAR
  final appBar =  AppBar (
    elevation: 2.0,
    backgroundColor: Colors.white,
    brightness: Brightness.light,
    title: Text('Settings', style: Fonts.dashboardTitleStyle),
    leading: BackButton(color: FlatColors.londonSquare),
  );

//  Widget _buildBlockedUsersButton(){
//    return CustomColorButton('Blocked Users', 50.0, null, Colors.white, FlatColors.blackPearl);
//  }


  @override
  Widget build(BuildContext context) {

    final guideButton = CustomColorButton('Guide', 50.0, MediaQuery.of(context).size.width * 0.8, () => transitionToGuidePage(), Colors.white, FlatColors.darkGray);
    final logoutButton =  CustomColorButton('Logout', 50.0, MediaQuery.of(context).size.width * 0.8, () => _signOut(), Colors.redAccent, Colors.white);

    final body = Container(
      width: MediaQuery.of(context).size.width,
      decoration: new BoxDecoration(
        gradient: Gradients.cloudyGradient(),
      ),
      child: Column(
        children: <Widget>[
          appBar,
          new ListView(
            shrinkWrap: true,
            children: <Widget>[
              // _buildBlockedUsersButton(),
              guideButton,
              logoutButton,
            ],
          ),
        ],
      ),
    );

    return Scaffold(
      key: settingsScaffoldKey,
      body: body,
    );
  }
}