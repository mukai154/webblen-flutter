import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'common_custom_alert.dart';
import 'package:webblen/styles/fonts.dart';
import 'common_button.dart'
    '';

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

    return new CustomAlertDialog(
      content: new Container(
        width: 260.0,
        height: 200.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius:
          new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // dialog top
            Container(
                child: Column(
                  children: <Widget>[
                    Image.asset("assets/images/warning.png", height: 45.0, width: 45.0),
                    SizedBox(height: 8.0),
                    Text(messageA, style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                  ],
                )
            ),
            // dialog centre
            SizedBox(height: 16.0),
            Container(
              child: Column(
                children: <Widget>[
                  new Text(messageB, style: Fonts.alertDialogBody, textAlign: TextAlign.center),
                ],
              ),
            ),
            SizedBox(height: 14.0),
            // dialog bottom
            Container(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 12.0),
                  CustomAlertFlatButton("Ok", FlatColors.londonSquare, Colors.transparent, () => Navigator.pop(context)),
                ],
              ),
            ),
          ],
        ),
      ),
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
    return new CustomAlertDialog(
      content: new Container(
        width: 260.0,
        height: 230.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius:
          new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // dialog top
            Container(
              child: Column(
                children: <Widget>[
                  Image.asset("assets/images/checked.png", height: 45.0, width: 45.0),
                  SizedBox(height: 8.0),
                  Text(messageA, style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                ],
              )
            ),
            // dialog centre
            SizedBox(height: 16.0),
            Container(
              child: Column(
                children: <Widget>[
                  new Text(messageB, style: Fonts.alertDialogBody, textAlign: TextAlign.center),
                ],
              ),
            ),
            SizedBox(height: 14.0),
            // ),
            // dialog bottom
            Container(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 12.0),
                  CustomAlertFlatButton("Ok", FlatColors.londonSquare, Colors.transparent, () => Navigator.pop(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoDialog extends StatelessWidget {
  final String messageA;
  final String messageB;
  InfoDialog({this.messageA, this.messageB});

  @override
  Widget build(BuildContext context) {
    return new CustomAlertDialog(
      content: new Container(
        width: 260.0,
        height: 230.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius:
          new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // dialog top
            Container(
                child: Column(
                  children: <Widget>[
                    Image.asset("assets/images/question.png", height: 45.0, width: 45.0),
                    SizedBox(height: 8.0),
                    Text(messageA, style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                  ],
                )
            ),
            // dialog centre
            SizedBox(height: 16.0),
            Container(
              child: Column(
                children: <Widget>[
                  new Text(messageB, style: Fonts.alertDialogBody, textAlign: TextAlign.center),
                ],
              ),
            ),
            SizedBox(height: 14.0),
            // ),
            // dialog bottom
            Container(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 12.0),
                  CustomAlertFlatButton("Ok", FlatColors.londonSquare, Colors.transparent, () => Navigator.pop(context)),
                ],
              ),
            ),
          ],
        ),
      ),
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

