import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/widgets_wallet/wallet_head.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:webblen/widgets_common/common_button.dart';
import 'dart:async';


class PowerUpPage extends StatefulWidget {


  final double totalPoints;
  final String uid;
  PowerUpPage({this.uid, this.totalPoints});

  @override
  _PowerUpPageState createState() => _PowerUpPageState();
}

class _PowerUpPageState extends State<PowerUpPage> {

  bool isPoweringUp = false;
  double powerUpAmount = 0.10;

  // ** APP BAR
  final appBar =  AppBar (
    elevation: 2.0,
    backgroundColor: Colors.white,
    brightness: Brightness.light,
    title: Text('Power Up', style: Fonts.dashboardTitleStyle),
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
                  Text("Increase Impact by ${powerUpAmount.toStringAsFixed(2)}?", style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                ],
              ),
            ),
            content: new Text("Converting your points into impact increases the value of your attencance and the amount of points you earn from future events", style: Fonts.alertDialogBody, textAlign: TextAlign.center),
            actions: <Widget>[
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
                      powerUp();
                    });
                  },
              ),
            ],
          );
        });
  }

  Future<bool> successAlert(BuildContext context) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(
              child: Column(
                children: <Widget>[
                  Image.asset("assets/images/checked.png", height: 45.0, width: 45.0),
                  SizedBox(height: 8.0),
                  Text("Powered Up!", style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                ],
              ),
            ),
            content: new Text("Your Impact has Increased by ${powerUpAmount.toStringAsFixed(2)}", style: Fonts.alertDialogBody, textAlign: TextAlign.center),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Ok", style: Fonts.alertDialogAction),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<Null> powerUp(){
    UserDataService().powerUpPoints(widget.uid, powerUpAmount).then((val){
      successAlert(context);
    });
  }

  Widget _buildPowerSlider(){
    return Slider(
      inactiveColor: FlatColors.londonSquare,
      activeColor: FlatColors.lightCarribeanGreen,
      value: widget.totalPoints < 0.1 ? 0.0 : powerUpAmount,
      min: widget.totalPoints < 0.1 ? 0.0 : 0.1,
      max: widget.totalPoints < 0.1 ? 0.0 : widget.totalPoints,
      //divisions: 39,
      label: widget.totalPoints < 0.1 ? 'Not Enough Points for Power Up': '${powerUpAmount.toStringAsFixed(2)}',
      onChanged: (double value) {
        setState(() {
          powerUpAmount = value;
        });
      },
    );
  }

  Widget _buildBody(){
    return new Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: new Column /*or Column*/(
        children: <Widget>[
          SizedBox(height: 80.0),
          widget.totalPoints < 0.1 ? Text("Not Enough Points for Power Up", style: Fonts.bodyTextStyleGray)
              : Text("Points Available: ${widget.totalPoints.toStringAsFixed(2)}", style: Fonts.bodyTextStyleGray),
          SizedBox(height: 16.0),
          Text("Power Up Total: ${powerUpAmount.toStringAsFixed(2)}", style: Fonts.bodyTextStyleGray),
          SizedBox(height: 16.0),
          new Container(
            height: 85.0,
            width: 85.0,
            child: isPoweringUp ? CustomCircleProgress(60.0, 60.0, 30.0, 30.0, FlatColors.londonSquare)
             : new Image.asset("assets/images/power_up.png", height: 100.0, width: 100.0),
          ),
          SizedBox(height: 16.0),
          _buildPowerSlider(),
          SizedBox(height: 16.0),
          CustomColorButton("Power UP", 50.0, () => powerUpAlert(context), FlatColors.lightCarribeanGreen, Colors.white),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: appBar,
      body: _buildBody()
    );
  }
}