import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/widgets_wallet/wallet_head.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'power_up_page.dart';
import 'package:webblen/animations/transition_animations.dart';
import 'dart:async';


class WalletPage extends StatefulWidget {


  final String uid;
  final double totalPoints;
  WalletPage({this.uid, this.totalPoints});

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {

  void transitionToPowerUpPage () =>  Navigator.push(context, SlideFromRightRoute(widget: PowerUpPage(uid: widget.uid, totalPoints: widget.totalPoints)));


  bool isPoweringUp = false;
  double powerUpAmount = 0.10;

  // ** APP BAR
  final appBar =  AppBar (
    elevation: 2.0,
    backgroundColor: Colors.white,
    brightness: Brightness.light,
    title: Text('My Wallet', style: Fonts.dashboardTitleStyle),
    leading: BackButton(color: FlatColors.londonSquare),
  );

  Future<bool> powerUpAlert(BuildContext context) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(
              child: Column(
                children: <Widget>[
                  Image.asset("assets/images/power_up.png", height: 45.0, width: 45.0),
                  SizedBox(height: 8.0),
                  Text("Power Up?", style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                ],
              ),
            ),
            content: new Text("Converting your points into impact increases the value of your attencance and the amount of points you earn from future events", style: Fonts.alertDialogBody, textAlign: TextAlign.center),
            actions: <Widget>[
              Column(
                children: <Widget>[
                  new FlatButton(
                    child: new Text("No", style: Fonts.alertDialogAction),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  new FlatButton(
                    child: new Text("Yes", style: Fonts.alertDialogAction),
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        isPoweringUp = true;
                        print(powerUpAmount);
                      });
                    },
                  ),
                ],
              ),
              
            ],
          );
        });
  }

  Widget _buildNoRewards(String imageName, String message)  {
    return new Container(
      width: MediaQuery.of(context).size.width,
      child: new Column /*or Column*/(
        children: <Widget>[
          new Container(
            height: 85.0,
            width: 85.0,
            child: new Image.asset("assets/images/$imageName.png", fit: BoxFit.scaleDown),
          ),
          SizedBox(height: 16.0),
          new Text(message, style: Fonts.noEventsFont, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: appBar,
      body: StreamBuilder(
          stream: Firestore.instance.collection("users").document(widget.uid).snapshots(),
          builder: (context, userSnapshot) {
            if (!userSnapshot.hasData) return Text("Loading...");
            var userData = userSnapshot.data;
            return new ListView(
              padding: const EdgeInsets.all(0.0),
              children: <Widget>[
                WalletHead(
                  eventPoints: userData["eventPoints"] * 1.00,
                  impactPoints: userData["impactPoints"] * 1.00,
                  powerUpAction: ()  {transitionToPowerUpPage();},
                ),
                SizedBox(height: 32.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text("Rewards", style: Fonts.walletSubHeadTextStyleDark),
                ),
                SizedBox(height: 100.0),
                _buildNoRewards("embarrassed", "You Currently Have No Rewards"),
              ],
            );
          }
      ),
    );
  }
}