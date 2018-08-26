import 'package:flutter/material.dart';

class AlertMessage extends StatelessWidget {

  String alertContent;

  AlertMessage(this.alertContent);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: new Text(alertContent, style: new TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700)),
      actions: <Widget>[
        new FlatButton(onPressed: () { Navigator.pop(context); },
            child: new Text("Ok", style: new TextStyle(fontWeight: FontWeight.w500),),
        )
      ],
    );
  }
}