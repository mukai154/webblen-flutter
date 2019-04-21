import 'package:flutter/material.dart';
import 'package:webblen/utils/open_url.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen/utils/image_caching.dart';
import 'dart:io';
import 'package:webblen/models/webblen_user.dart';
import 'package:webblen/utils/create_notification.dart';
import 'package:webblen/utils/device_calendar.dart';
import 'package:webblen/widgets_icons/icon_bubble.dart';
import 'package:webblen/widgets_common/common_appbar.dart';
import 'package:webblen/utils/payment_calc.dart';
import 'package:webblen/widgets_common/common_button.dart';
import 'package:webblen/firebase_services/event_data.dart';
import 'package:webblen/services_general/service_page_transitions.dart';
import 'package:webblen/widgets_data_streams/stream_event_details.dart';
import 'package:webblen/models/event.dart';
import 'package:intl/intl.dart';

class EventDetailsPage extends StatefulWidget {

  final Event event;
  final WebblenUser currentUser;
  final bool eventIsLive;
  EventDetailsPage({this.event, this.currentUser, this.eventIsLive});
  
  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  
  File eventImage;


  Widget eventCaption(){
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Fonts().textW700('Details', 24.0, FlatColors.darkGray, TextAlign.left),
          Fonts().textW400(widget.event.description, 18.0, FlatColors.lightAmericanGray, TextAlign.left),
        ],
      ),
    );
  }

  Widget eventDate(){
    DateFormat formatter = DateFormat('E d, y h:mma');
    return Row(
      children: <Widget>[
        Column(
          children: <Widget>[
            Icon(FontAwesomeIcons.calendar, size: 24.0, color: FlatColors.darkGray),
          ],
        ),
        SizedBox(width: 4.0),
        Column(
          children: <Widget>[
            SizedBox(height: 4.0),
            Fonts().textW500('${formatter.format(DateTime.fromMillisecondsSinceEpoch(widget.event.startDateInMilliseconds))}', 18.0, FlatColors.darkGray, TextAlign.left),
          ],
        ),
      ],
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ImageCachingService().getCachedImage(widget.event.imageURL).then((imageFile){
      if (imageFile != null){
        eventImage = imageFile;
        setState(() {});
      }
    });
    EventDataService().updateEstimatedTurnout(widget.event.eventKey);
    if (widget.currentUser.notifySuggestedEvents){
      if (widget.event.startDateInMilliseconds != null){
        CreateNotification().intializeNotificationSettings();
        CreateNotification().createTimedNotification(
            0,
            widget.event.startDateInMilliseconds - 1800000,
            "Event Happening Soon!",
            "The Event: ${widget.event.title} starts in 30 minutes! Be sure to check in to get paid!",
            widget.event.eventKey
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {


    Widget eventView(){
      double estimatedPayout = (widget.event.eventPayout.toDouble() * 0.05);
      double potentialEarnings = widget.event.attendees.length == 0 ? 0.00 : estimatedPayout/widget.event.attendees.length.toDouble();
      return ListView(
        children: <Widget>[
          Container(
            height: 300.0,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                eventImage == null
                    ? Image.network(widget.event.imageURL, fit: BoxFit.cover, height: 300.0, width: MediaQuery.of(context).size.width)
                    : Image.file(eventImage, fit: BoxFit.cover, height: 300.0, width: MediaQuery.of(context).size.width),
//                widget.event.author == "@" + widget.currentUser.username || widget.currentUser.isCommunityBuilder
//                    ? Align(
//                  alignment: Alignment(1, 1),
//                  child: CustomColorIconButton(
//                    icon: Icon(FontAwesomeIcons.edit, size: 18.0, color: FlatColors.darkGray,),
//                    backgroundColor: Colors.white,
//                    height: 40.0,
//                    width: 40.0,
//                    onPressed: () => PageTransitionService(context: context, currentUser: widget.currentUser, event: widget.event, eventIsLive: widget.eventIsLive).transitionToEventEditPage(),
//                  ),
//                )
//                    : Container()
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0, top: 8.0),
            child: Row(
              children: <Widget>[
                Material(
                  borderRadius: BorderRadius.circular(18.0),
                  color: Colors.black12,
                  child: Padding(
                      padding: EdgeInsets.all(6.0),
                      child: widget.eventIsLive
                          ? Fonts().textW700('Payout Pool: \$${estimatedPayout.toStringAsFixed(2)}', 14.0, Colors.black54, TextAlign.center)
                          : Fonts().textW700('Estimated Payout: \$${PaymentCalc().getEventValueEstimate(widget.event.estimatedTurnout).toStringAsFixed(2)}', 14.0, Colors.black54, TextAlign.center)
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0, top: 8.0),
            child: Row(
              children: <Widget>[
                Material(
                  borderRadius: BorderRadius.circular(18.0),
                  color: FlatColors.greenTeal,
                  child: Padding(
                    padding: EdgeInsets.all(6.0),
                    child: widget.eventIsLive
                        ? Fonts().textW700('Your Potential Earnings: \$${potentialEarnings.toStringAsFixed(2)}', 14.0, Colors.white, TextAlign.center)
                        : Fonts().textW700('Your Potential Earnings: \$${PaymentCalc().getPotentialEarnings(widget.event.estimatedTurnout).toStringAsFixed(2)}', 14.0, Colors.white, TextAlign.center),
                  ),
                ),
              ],
            ),
          ),
          StreamEventDetails(
            currentUser: widget.currentUser,
            detailType: 'caption',
            eventKey: widget.event.eventKey,
            placeholderWidget: eventCaption(),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0, top: 24.0),
            child: widget.eventIsLive
                ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CustomColorButton(
                  text: widget.event.attendees.isNotEmpty ? 'View Attendees' : 'No One Has Check in Here...',
                  textColor: FlatColors.darkGray,
                  backgroundColor: Colors.white,
                  onPressed: widget.event.attendees.isNotEmpty
                      ? () => PageTransitionService(context: context, userIDs: widget.event.attendees, currentUser: widget.currentUser).transitionToEventAttendeesPage()
                      : null,
                  height: 45.0,
                  width: widget.event.attendees.isNotEmpty ? 200.0 : 300,
                  vPadding: 0.0,
                  hPadding: 0.0,
                ),
              ],
            )
                : StreamEventDetails(
                    currentUser: widget.currentUser,
                    detailType: 'date',
                    eventKey: widget.event.eventKey,
                    placeholderWidget: eventDate(),
                )
          ),
          widget.eventIsLive
              ? Container()
              : Padding(
            padding: EdgeInsets.only(left: 16.0, top: 2.0),
            child: InkWell(
              onTap: () => DeviceCalendar().addEventToCalendar(context, widget.event),
              child: Fonts().textW500(' Add to Calendar', 14.0, FlatColors.webblenDarkBlue, TextAlign.left),
            ),
          ),
          widget.eventIsLive
              ? Container()
              : Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.directions, size: 24.0, color: FlatColors.darkGray),
                  ],
                ),
                SizedBox(width: 4.0),
                Column(
                  children: <Widget>[
                    SizedBox(height: 4.0),
                    Fonts().textW400('${widget.event.address.replaceAll(', USA', '')}', 16.0, FlatColors.darkGray, TextAlign.left),
                  ],
                ),
              ],
            ),
          ),
          widget.eventIsLive
              ? Container()
              : Padding(
            padding: EdgeInsets.only(left: 16.0, top: 2.0),
            child: InkWell(
              onTap: () => OpenUrl().openMaps(context, widget.event.location['geopoint'].latitiude.toString(), widget.event.location['geopoint'].longitude.toString()),
              child: Fonts().textW500(' View in Maps', 14.0, FlatColors.webblenDarkBlue, TextAlign.left),
            ),
          ),
          widget.event.fbSite.isNotEmpty || widget.event.twitterSite.isNotEmpty || widget.event.website.isNotEmpty
              ? Padding(
            padding: EdgeInsets.only(left: 16.0, top: 24.0),
            child: Fonts().textW700('Additional Info', 18.0, FlatColors.darkGray, TextAlign.left),
          )
              : Container(),
          Padding(
            padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                widget.event.fbSite.isNotEmpty
                    ? GestureDetector(
                  onTap: () => OpenUrl().launchInWebViewOrVC(context, widget.event.fbSite),
                  child: IconBubble(
                    icon: Icon(FontAwesomeIcons.facebookF, size: 20.0, color: Colors.white),
                    color: FlatColors.darkGray,
                    size: 35.0,
                  ),
                )
                    : Container(),
                widget.event.fbSite.isNotEmpty ? SizedBox(width: 16.0) : Container(),
                widget.event.twitterSite.isNotEmpty
                    ? GestureDetector(
                  onTap: () => OpenUrl().launchInWebViewOrVC(context, widget.event.twitterSite),
                  child: IconBubble(
                    icon: Icon(FontAwesomeIcons.twitter, size: 18.0, color: Colors.white),
                    color: FlatColors.darkGray,
                    size: 35.0,
                  ),
                )
                    : Container(),
                widget.event.twitterSite.isNotEmpty ? SizedBox(width: 16.0) : Container(),
                widget.event.website.isNotEmpty
                    ? GestureDetector(
                  onTap: () => OpenUrl().launchInWebViewOrVC(context, widget.event.website),
                  child: IconBubble(
                    icon: Icon(FontAwesomeIcons.link, size: 18.0, color: Colors.white),
                    color: FlatColors.darkGray,
                    size: 35.0,
                  ),
                ) : Container(),
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: WebblenAppBar().actionAppBar(
          widget.event.title,
          Container()
//          IconButton(
//            icon: Icon(FontAwesomeIcons.paperPlane, size: 24.0, color: FlatColors.darkGray),
//            onPressed: null,
//          ),
      ),
      body: eventView(),
    );
  }
}

