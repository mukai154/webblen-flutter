import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:location/location.dart';
import 'package:webblen/widgets_common/common_alert.dart';

class MapPage extends StatefulWidget {

  static String tag = "map-page";

  final BaseAuth auth;
  MapPage({this.auth});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  //Mapping
  Map<String, double> _startLocation;
  Map<String, double> _currentLocation;
  StreamSubscription<Map<String, double>> _locationSubscription;
//  Location _location = new Location();
  String error;

  // ** APP BAR
  final appBar = Hero(
    tag: 'map-green',
    child: new AppBar (
      elevation: 0.0,
      backgroundColor: FlatColors.greenTeal,
      title: Text('Map', style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.white)),
      leading: BackButton(color: Colors.white),
    ),
  );

  //Map
  Future<bool> invalidAlert(BuildContext context, String message) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) { return AlertMessage(message); });
  }


  @override
  void initState() {
    super.initState();
//    initPlatformState();

//    _locationSubscription =
//        _location.onLocationChanged.listen((Map<String,double> result) {
//          setState(() {
//            _currentLocation = result;
//          });
//        });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
//  initPlatformState() async {
//    Map<String, double> location;
//    // Platform messages may fail, so we use a try/catch PlatformException.
//    try {
//      location = await _location.getLocation();
//      error = null;
//    } on PlatformException catch (e) {
//      if (e.code == 'PERMISSION_DENIED') {
//        invalidAlert(context, "Unable to Access Location");
//      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
//        error = 'Permission denied - please ask the user to enable it from the app settings';
//      }
//      location = null;
//    }
//    setState(() {
//      _startLocation = location;
//    });
//
//  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: new Column(
          children: <Widget>[
            appBar,
            new Flexible(
              child: Column(),
            )
          ],
        ),
    );
  }
}