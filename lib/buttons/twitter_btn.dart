import 'package:flutter/material.dart';

class TwitterBtn extends StatelessWidget {

  final String buttonText = "Login with Twitter";
  final double buttonHeight = 50.0;
  final colorTwitter = Color.fromRGBO(29, 161, 242, 1.0);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      child: Material(
        elevation: 5.0,
        color: colorTwitter,
        borderRadius: BorderRadius.circular(25.0),
        child: InkWell(
          onTap: null,
          child: Container(
            height: buttonHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(buttonText, style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}