import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'services_show_alert.dart';

class LocationService {

  Map<String, double> currentLocation;
  Location currentUserLocation = new Location();
  bool retrievedLocation = false;
  bool locationPermission = false;

  Future<Map<String, double>>getCurrentLocation(BuildContext context) async {
    Map<String, double> location;
    String error = "";
    try {
      locationPermission = await currentUserLocation.hasPermission();
      location = await currentUserLocation.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Location Permission Denied';
        ShowAlertDialogService().showFailureDialog(context, error, "Please Enable Location Services from App Settings");
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'Webblen Needs Permission to Access Your Location';
        ShowAlertDialogService().showFailureDialog(context, error, "Please Enable Location Services from App Settings");
      }
      location = null;
    }
    return location;
  }
}