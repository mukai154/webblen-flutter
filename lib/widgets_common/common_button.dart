import 'package:flutter/material.dart';
import 'package:webblen/styles/fonts.dart';

class CustomColorButton extends StatelessWidget {

  final String text;
  final double height;
  final double width;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  CustomColorButton({this.text, this.height, this.width, this.onPressed, this.backgroundColor, this.textColor});
  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Material(
        elevation: 2.0,
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(25.0),
          onTap: onPressed,
          child: Container(
            height: height,
            width: width ,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Fonts().textW600(text, MediaQuery.of(context).size.width * 0.038, textColor, TextAlign.center),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NewEventFormButton extends StatelessWidget {

  final String label;
  final Color labelColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  NewEventFormButton(this.label, this.labelColor, this.backgroundColor, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Material(
        elevation: 5.0,
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25.0),
        child: InkWell(
          onTap: () { onTap(); },
          child: Container(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(label, style: TextStyle(color: labelColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FlatBackButton extends StatelessWidget {

  final String label;
  final Color labelColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  FlatBackButton(this.label, this.labelColor, this.backgroundColor, this.onTap);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: FlatButton(
        onPressed: (){ onTap(); },
        color: Colors.transparent,
        child: Text(label, style: TextStyle(color: labelColor, fontWeight: FontWeight.w400)),
      ),
    );
  }
}