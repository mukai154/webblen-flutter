import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';


class SpeedDialMenu extends StatelessWidget {

  final String fbSite;
  final String twitterSite;
  final String website;

  SpeedDialMenu(this.fbSite, this.twitterSite, this.website);


  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      child: Icon(Icons.add),
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      visible: true,
      curve: Curves.bounceIn,
      children: [
        fbSite != "" ?
        SpeedDialChild(
          child: Icon(Icons.accessibility, color: Colors.white),
          backgroundColor: Colors.deepOrange,
          onTap: () => print('FIRST CHILD'),
          label: 'First',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
        ) : null,
        twitterSite != "" ?
        SpeedDialChild(
          child: Icon(Icons.brush, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () => print('SECOND CHILD'),
          label: 'Second',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
        ) : null,
        website != "" ?
        SpeedDialChild(
          child: Icon(Icons.keyboard_voice, color: Colors.white),
          backgroundColor: Colors.blue,
          onTap: () => print('THIRD CHILD'),
          label: 'Third',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
        ) : null,
      ],
    );
  }
}