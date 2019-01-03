import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventDetailsTile extends StatelessWidget {

  final String detailType;
  EventDetailsTile({this.detailType});

  Widget buildDetailButton(String detailType){
    Icon icon;
    String detail;
    Color buttonIconColor = FlatColors.blueGray;
    if (detailType == "description"){
      icon = Icon(FontAwesomeIcons.alignLeft, size: 40.0, color: buttonIconColor);
      detail = "Additional Info";
    } else if (detailType == "date & time"){
      icon = Icon(FontAwesomeIcons.clock, size: 40.0, color: FlatColors.electronBlue);
      detail = "Date & Time";
    } else if (detailType == "address"){
      icon = Icon(FontAwesomeIcons.directions, size: 40.0, color: FlatColors.vibrantYellow);
      detail = "Address";
    } else if (detailType == "additional info"){
      icon = Icon(FontAwesomeIcons.wallet, size: 35.0, color: FlatColors.darkMountainGreen);
      detail = "Payout";
    }

    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Material(
              color: Colors.transparent,
                child: Column(
                  children: <Widget>[
                    icon,
                    SizedBox(height: 8.0),
                    Text(detail, style: Fonts.fontBold14),
                  ],
                )
            ),
          ]
      );
  }

  @override
  Widget build(BuildContext context) {
    return buildDetailButton(detailType);
  }
}