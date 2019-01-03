import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/styles/fonts.dart';


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
          borderRadius: BorderRadius.circular(25.0),
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

  final String text;
  final double height;
  final double width;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  CustomColorButton(this.text, this.height, this.width, this.onPressed, this.backgroundColor, this.textColor);
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

class SmallActionButton extends StatelessWidget {

  final String text;
  final VoidCallback onPressed;

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

class CustomAlertFlatButton extends StatelessWidget {

  final String label;
  final Color labelColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  CustomAlertFlatButton(this.label, this.labelColor, this.backgroundColor, this.onTap);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
        child: new InkWell(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          onTap: onTap,
          child: new Container(
            width: 200.0,
            height: 30.0,
            child: new Center(child: Text(label, style: TextStyle(color: labelColor, fontWeight: FontWeight.w600))),
          ),
        ),
      ),
    );
  }
}

class CustomAlertFlatButtonLarge extends StatelessWidget {

  final String label;
  final Color labelColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  CustomAlertFlatButtonLarge(this.label, this.labelColor, this.backgroundColor, this.onTap);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
        child: new InkWell(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          onTap: onTap,
          child: new Container(
            width: 200.0,
            height: 30.0,
            child: new Center(child: Text(label, style: TextStyle(fontSize: 18.0, color: labelColor, fontWeight: FontWeight.w600))),
          ),
        ),
      ),
    );
  }
}

class CustomAlertSmallFlatButton extends StatelessWidget {

  final String label;
  final Color labelColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  CustomAlertSmallFlatButton(this.label, this.labelColor, this.backgroundColor, this.onTap);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
        child: new InkWell(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          onTap: onTap,
          child: new Container(
            width: 100.0,
            height: 30.0,
            child: new Center(child: Text(label, style: TextStyle(color: labelColor, fontWeight: FontWeight.w600))),
          ),
        ),
      ),
    );
  }
}

class CustomAlertColorButton extends StatelessWidget {

  final String text;
  final double height;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Color highlightColor;

  CustomAlertColorButton(this.text, this.height, this.onPressed, this.backgroundColor, this.highlightColor, this.textColor);


  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        elevation: 2.0,
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(25.0),
          splashColor: highlightColor,
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