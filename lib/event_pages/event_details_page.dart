import 'package:flutter/material.dart';
import 'package:webblen/widgets_event/event_details_special_guests_scroller.dart';
import 'package:webblen/models/event_post.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:webblen/widgets_event/event_details_header.dart';
import 'package:webblen/widgets_event/event_details_photos_scroller.dart';
import 'package:webblen/widgets_event/event_details_info.dart';
import 'package:webblen/widgets_common/common_appbar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:webblen/utils/open_url.dart';
import 'package:webblen/widgets_dashboard/dashboard_tile.dart';
import 'package:webblen/widgets_event/event_details_tile.dart';
import 'package:webblen/widgets_common/common_alert.dart';



class EventDetailsPage extends StatelessWidget {

  final EventPost eventPost;
  EventDetailsPage({this.eventPost});


  Future<bool> showEventInfoDialog(BuildContext context, String infoType) {
    Widget infoDialog;
    if (infoType == "description"){
      infoDialog = DescriptionEventInfoDialog(description: eventPost.description);
    } else if (infoType == "date & time"){
      infoDialog = DateTimeEventInfoDialog(date: eventPost.startDate, startTime: eventPost.startTime, endTime: eventPost.endTime);
    } else if (infoType == "additional info"){
      infoDialog = AdditionalEventInfoDialog(estimatedTurnout: eventPost.estimatedTurnout, eventCost: eventPost.costToAttend);
    }
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return infoDialog;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WebblenAppBar().basicAppBar("Event Details"),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView(
            children: [
              EventDetailsHeader(eventPost: eventPost),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: EventDetailsInfo(eventPost: eventPost),
              ),
  //            PhotoScroller(movie.photoUrls),
  //            SizedBox(height: 20.0),
              //EventDetailsSpecialGuestsScroller(actors),
              StaggeredGridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
                children: <Widget>[
                  DashboardTile(
                    child: EventDetailsTile(detailType: "description"),
                    onTap: () => showEventInfoDialog(context, "description"),
                  ),
                  DashboardTile(
                    child: EventDetailsTile(detailType: "date & time"),
                    onTap: () => showEventInfoDialog(context, "date & time"),
                  ),
                  DashboardTile(
                    child: EventDetailsTile(detailType: "address"),
                    onTap: () => OpenUrl().openMaps(context, eventPost.lat.toString(), eventPost.lon.toString()),
                  ),
                  DashboardTile(
                    child: EventDetailsTile(detailType: "additional info"),
                    onTap: () => showEventInfoDialog(context, "additional info"),
                  ),
                ],
                staggeredTiles: [
                  StaggeredTile.extent(1, 120.0),
                  StaggeredTile.extent(1, 120.0),
                  StaggeredTile.extent(1, 120.0),
                  StaggeredTile.extent(1, 120.0),
                ],
              ),
              SizedBox(height: 50.0),
            ],
          ),
        ),
      );
  }
}