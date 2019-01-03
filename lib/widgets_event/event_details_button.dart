import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen/styles/flat_colors.dart';

class EventDetailButton extends StatelessWidget {

  final String detailType;
  final VoidCallback onClick;
  EventDetailButton({this.detailType, this.onClick});

  Widget buildDetailButton(String detailType){
    Icon icon;
    Color buttonIconColor = FlatColors.blueGray;
    if (detailType == "description"){
      icon = Icon(FontAwesomeIcons.alignLeft, color: buttonIconColor);
    } else if (detailType == "date & time"){
      icon = Icon(FontAwesomeIcons.calendar, color: buttonIconColor);
    } else if (detailType == "address"){
      icon = Icon(FontAwesomeIcons.map, color: buttonIconColor);
    } else if (detailType == "additional info"){
      icon = Icon(FontAwesomeIcons.wallet, color: buttonIconColor);
    }

    return Material(
      elevation: 4.0,
      shape: CircleBorder(),
      color: Colors.white,
      child: Ink(
        width: 60.0,
        height: 60.0,
        child:
        InkWell(
          onTap: null,
          child: icon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildDetailButton(detailType);
  }
}