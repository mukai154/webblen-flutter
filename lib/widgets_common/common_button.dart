import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';


class PrimaryButton extends StatelessWidget {

  final String text;
  final double height;
  final VoidCallback onPressed;

  PrimaryButton(this.text, this.height, this.onPressed);


  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Material(
        elevation: 5.0,
        color: FlatColors.goodNight,
        borderRadius: BorderRadius.circular(25.0),
        child: InkWell(
          onTap: () { onPressed(); },
          child: Container(
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(text, style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomColorButton extends StatelessWidget {

  String text;
  double height;
  VoidCallback onPressed;
  Color backgroundColor;
  Color textColor;

  CustomColorButton(this.text, this.height, this.onPressed, this.backgroundColor, this.textColor);


  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Material(
        elevation: 2.0,
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25.0),
        child: InkWell(
          onTap: () { onPressed(); },
          child: Container(
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(text, style: TextStyle(color: textColor)),
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

class SmallActionButton extends StatelessWidget {

  String text;
  VoidCallback onPressed;

  SmallActionButton(this.text, this.onPressed);


  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(25.0),
        shadowColor: Colors.black54,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 250.0,
          height: 45.0,
          onPressed: (){onPressed();},
          color: FlatColors.goodNight,
          child: Text(text, style: TextStyle(color: Colors.white)
          ),
        ),
      ),
    );
  }
}

class FlatBackButton extends StatelessWidget {

  String label;
  Color labelColor;
  Color backgroundColor;
  VoidCallback onTap;

  FlatBackButton(this.label, this.labelColor, this.backgroundColor, this.onTap);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
        child: FlatButton(
          onPressed: (){ onTap(); },
          color: backgroundColor,
          child: Text(label, style: TextStyle(color: labelColor, fontWeight: FontWeight.w200)),
        ),
    );
  }
}