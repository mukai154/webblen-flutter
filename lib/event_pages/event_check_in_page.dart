import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/models/event_post.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen/services_general/service_page_transitions.dart';
import 'package:webblen/services_general/services_show_alert.dart';
import 'package:webblen/services_general/services_location.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:webblen/widgets_data_streams/stream_nearby_events.dart';
import 'package:webblen/widgets_common/common_appbar.dart';


class EventCheckInPage extends StatefulWidget {

  final WebblenUser currentUser;
  EventCheckInPage({this.currentUser});

  @override
  _EventCheckInPageState createState() => _EventCheckInPageState();
}

class _EventCheckInPageState extends State<EventCheckInPage> {

  List<EventPost> nearbyEventsList = [];
  bool isLoading = true;
  double currentLat;
  double currentLon;
  final ScrollController scrollController = new ScrollController();



  @override
  void initState() {
    super.initState();
    LocationService().streamCurrentLocation(context).then((result){
      if (this.mounted){
        if (result != null){
          currentLat = result.latitude;
          currentLon = result.longitude;
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WebblenAppBar().actionAppBar(
        'Check In',
        IconButton(
          onPressed:() => PageTransitionService(context: context, uid: widget.currentUser.uid).transitionToNewFlashEventPage(),
          icon: Icon(FontAwesomeIcons.plusSquare, size: 24.0, color: FlatColors.darkGray),
        ),
      ),
      body: StreamNearbyEvents(
        currentUser: widget.currentUser,
        currentLat: currentLat == null ? widget.currentUser.userLat : currentLat,
        currentLon: currentLon == null ? widget.currentUser.userLon : currentLon,
        createFlashEventAction: () => PageTransitionService(context: context, uid: widget.currentUser.uid).transitionToNewFlashEventPage(),
          scrollController: scrollController,
      ),
    );
  }

}