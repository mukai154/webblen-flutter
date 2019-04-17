import 'package:flutter/material.dart';
import 'package:webblen/models/event_post.dart';
import 'package:webblen/firebase_services/event_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:webblen/utils/image_caching.dart';
import 'package:webblen/styles/fonts.dart';
import 'dart:io';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:webblen/utils/payment_calc.dart';
import 'package:webblen/styles/flat_colors.dart';


class EventRow extends StatefulWidget {

  final EventPost eventPost;
  final VoidCallback eventPostAction;
  EventRow({this.eventPost, this.eventPostAction});

  @override
  _EventRowState createState() => _EventRowState();
}

class _EventRowState extends State<EventRow> {

  bool loadingEvent = true;
  File cachedEventImage;

  @override
  void initState() {
    super.initState();
    ImageCachingService().getCachedImage(widget.eventPost.pathToImage).then((file){
      if (this.mounted){
        cachedEventImage = file;
        loadingEvent = false;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget _eventDate(){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Fonts().textW500(EventPostService().eventStartDateWeekDay(widget.eventPost), 14.0, Colors.white, TextAlign.start),
            Fonts().textW400(EventPostService().eventStartDateMonth(widget.eventPost) + " " + EventPostService().eventStartDateDay(widget.eventPost) + ", " + EventPostService().eventStartDateYear(widget.eventPost), 14.0, Colors.white, TextAlign.start),
            Fonts().textW400(widget.eventPost.startTime + " - " + widget.eventPost.endTime, 14.0, Colors.white, TextAlign.start),
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
                  Fonts().textW700(widget.eventPost.title, 20.0, Colors.white, TextAlign.left),
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
                        child: Fonts().textW700('Estimated Payout Pool: \$${PaymentCalc().getEventValueEstimate(widget.eventPost.estimatedTurnout).toStringAsFixed(2)}', 12.0, Colors.white, TextAlign.center)
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
        tag: widget.eventPost.eventKey,
        child: Container(
          height: 350.0,
          margin: EdgeInsets.fromLTRB(8.0, 6.0, 8.0, 8.0),
          child: eventCardContent,
          decoration: BoxDecoration(
            image: cachedEventImage == null
                ? DecorationImage(image: CachedNetworkImageProvider(widget.eventPost.pathToImage), fit: BoxFit.cover)
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