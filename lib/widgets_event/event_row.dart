import 'package:flutter/material.dart';
import 'package:webblen/firebase_services/event_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:webblen/utils/image_caching.dart';
import 'package:webblen/styles/fonts.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:webblen/utils/payment_calc.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/models/event.dart';


class ComEventRow extends StatefulWidget {

  final Event event;
  final VoidCallback eventPostAction;
  ComEventRow({this.event, this.eventPostAction});

  @override
  _ComEventRowState createState() => _ComEventRowState();
}

class _ComEventRowState extends State<ComEventRow> {

  bool loadingEvent = true;
  File cachedEventImage;

  @override
  void initState() {
    super.initState();
    ImageCachingService().getCachedImage(widget.event.imageURL).then((file){
      if (this.mounted){
        cachedEventImage = file;
        loadingEvent = false;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    DateFormat formatter = DateFormat("MMM d, YYYY");
    DateTime eventStartDateTime = widget.event.startDateInMilliseconds == null ? null : DateTime.fromMillisecondsSinceEpoch(widget.event.startDateInMilliseconds);
    DateTime eventEndDateTime = widget.event.endDateInMilliseconds == null ? null : DateTime.fromMillisecondsSinceEpoch(widget.event.endDateInMilliseconds);

    Widget _eventDate(){
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            widget.event.endDateInMilliseconds == null
                ? Container()
                : Fonts().textW500(formatter.format(eventStartDateTime), 14.0, Colors.white, TextAlign.start),
//            Fonts().textW400(EventPostService().eventStartDateMonth(widget.eventPost) + " " + EventPostService().eventStartDateDay(widget.eventPost) + ", " + EventPostService().eventStartDateYear(widget.eventPost), 14.0, Colors.white, TextAlign.start),
//            Fonts().textW400(widget.eventPost.startTime + " - " + widget.eventPost.endTime, 14.0, Colors.white, TextAlign.start),
          ]
      );
    }


    final eventCardContent = Container(
      //margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.4),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Fonts().textW700(widget.event.title, 20.0, Colors.white, TextAlign.left),
                  //Text("@" + eventPost.author, style: subHeaderTextStyle),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.5),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 12.0, top: 8.0, right: 12.0, bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _eventDate(),
                  Material(
                    borderRadius: BorderRadius.circular(18.0),
                    color: FlatColors.greenTeal,
                    child: Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Fonts().textW700('Estimated Payout Pool: \$${PaymentCalc().getEventValueEstimate(widget.event.estimatedTurnout).toStringAsFixed(2)}', 12.0, Colors.white, TextAlign.center)
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );

    final eventCard = loadingEvent
        ? Center(child: CustomCircleProgress(20.0, 20.0, 20.0, 20.0, Colors.black38))
        : Hero(
      tag: widget.event.eventKey,
      child: Container(
        height: 350.0,
        margin: EdgeInsets.fromLTRB(8.0, 6.0, 8.0, 8.0),
        child: eventCardContent,
        decoration: BoxDecoration(
          image: cachedEventImage == null
              ? DecorationImage(image: CachedNetworkImageProvider(widget.event.imageURL), fit: BoxFit.cover)
              : DecorationImage(image: FileImage(cachedEventImage), fit: BoxFit.cover),
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
      ),
    );



    return GestureDetector(
      onTap: widget.eventPostAction,
      child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0,
          ),
          child: Stack(
            children: <Widget>[
              eventCard,
              //eventCreatorPicContainer,
            ],
          )
      ),
    );
  }

}