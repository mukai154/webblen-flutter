import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/styles/fonts.dart';

class AlertMessage extends StatelessWidget {

  final String alertContent;

  AlertMessage(this.alertContent);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: new Text(alertContent, style: new TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
      actions: <Widget>[
        new FlatButton(onPressed: () { Navigator.pop(context); },
            child: new Text("Ok", style: new TextStyle(fontWeight: FontWeight.w500),),
        )
      ],
    );
  }
}

class UnavailableMessage extends StatelessWidget {

  final String messageHeader;
  final String messageA;
  final String messageB;

  UnavailableMessage({this.messageHeader, this.messageA, this.messageB});


  @override
  Widget build(BuildContext context) {

    final content = Container(
      height: 160.0,
      child: Column(
        children: <Widget>[
          new Text(messageHeader, style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: FlatColors.blackPearl), textAlign: TextAlign.center),
          SizedBox(height: 8.0),
          new Text(messageA, style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: FlatColors.londonSquare), textAlign: TextAlign.center),
          SizedBox(height: 16.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              color: FlatColors.electronBlue,
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: new Text(messageB, style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: FlatColors.clouds), textAlign: TextAlign.center)
              ),
            ),
          ),
        ],
      ),
    );

    return AlertDialog(
      title: Container(
        child: Column(
          children: <Widget>[
            Image.asset("assets/images/warning.png", height: 50.0, width: 50.0),
          ],
        ),
      ),
      content: content,
      actions: <Widget>[
        new FlatButton(onPressed: () { Navigator.pop(context); },
          child: new Text("Dismiss", style: new TextStyle(fontWeight: FontWeight.w500),),
        )
      ],
    );
  }
}

class UpdateAvailableDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:Container(
        child: Column(
          children: <Widget>[
            Image.asset("assets/images/warning.png", height: 45.0, width: 45.0),
            SizedBox(height: 8.0),
            Text("Update Required", style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
          ],
        ),
      ),
      content: new Text("Please Update Your Current Version of Webblen to Continue", style: Fonts.alertDialogBody, textAlign: TextAlign.center),
      actions: <Widget>[
        new FlatButton(
          child: new Text("Ok", style: Fonts.alertDialogAction),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class SuccessDialog extends StatelessWidget {
  final String messageA;
  final String messageB;
  SuccessDialog({this.messageA, this.messageB});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:Container(
        child: Column(
          children: <Widget>[
            Image.asset("assets/images/checked.png", height: 45.0, width: 45.0),
            SizedBox(height: 8.0),
            Text(messageA, style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
          ],
        ),
      ),
      content: new Text(messageB, style: Fonts.alertDialogBody, textAlign: TextAlign.center),
      actions: <Widget>[
        new FlatButton(
          child: new Text("Ok", style: Fonts.alertDialogAction),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class ActionMessage extends StatelessWidget {

  final String messageHeader;
  final String messageA;
  final VoidCallback callback;

  ActionMessage({this.messageHeader, this.messageA, this.callback});


  @override
  Widget build(BuildContext context) {

    final content = Container(
      height: 80.0,
      child: Column(
        children: <Widget>[
          new Text(messageHeader, style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: FlatColors.blackPearl), textAlign: TextAlign.center),
        ],
      ),
    );

    return AlertDialog(
      title: Container(
        child: Column(
          children: <Widget>[
            Image.asset("assets/images/check_in.png", height: 60.0, width: 60.0),
          ],
        ),
      ),
      content: content,
      actions: <Widget>[
        new FlatButton(onPressed: () { Navigator.pop(context); },
          child: new Text("Cancel", style: new TextStyle(fontWeight: FontWeight.w500)),
        ),
        new FlatButton(onPressed: () { callback(); },
          child: new Text("Confirm", style: new TextStyle(fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}

