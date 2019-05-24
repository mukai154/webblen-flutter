import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:intl/intl.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:webblen/utils/payment_calc.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/models/event.dart';




class ComEventRow extends StatelessWidget {

  final Event event;
  final VoidCallback eventPostAction;
  ComEventRow({this.event, this.eventPostAction});



  @override
  Widget build(BuildContext context) {

    DateFormat formatter = DateFormat("MMM d    h:mma");
    int currentDateTime = DateTime.now().millisecondsSinceEpoch;
    String startDateTime = event.startDateInMilliseconds == null ? null : formatter.format(DateTime.fromMillisecondsSinceEpoch(event.startDateInMilliseconds));
    DateTime eventEndDateTime = event.endDateInMilliseconds == null ? null : DateTime.fromMillisecondsSinceEpoch(event.endDateInMilliseconds);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTap: eventPostAction,
        child: Container(
          height: 350,
          width: 275,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              boxShadow: ([
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 1.8,
                  spreadRadius: 0.5,
                  offset: Offset(0.0, 3.0),
                ),
              ])
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 8.0, top: 8.0, right: 4.0),
                child: Fonts().textW800(event.title, 18.0, FlatColors.darkGray, TextAlign.start),
              ),
              Container(
                height: 280,
                child: CachedNetworkImage(
                  imageUrl: event.imageURL,
                  placeholder: (context, url) => Center(child: CustomLinearProgress(progressBarColor: FlatColors.webblenRed)),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                  fit: BoxFit.contain,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start ,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 8.0, top: 4.0, bottom: 8.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(8.0),
                          color: FlatColors.greenTeal,
                          child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: currentDateTime < event.endDateInMilliseconds
                                  ? Fonts().textW700('Estimated Payout Pool: \$${PaymentCalc().getEventValueEstimate(event.estimatedTurnout).toStringAsFixed(2)}', 12.0, Colors.white, TextAlign.center)
                                  : Fonts().textW700('Payout Pool: \$${(event.eventPayout * 0.05).toStringAsFixed(2)}', 12.0, Colors.white, TextAlign.center)

                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      event.startDateInMilliseconds == null
                          ? Container()
                          : Padding(
                        padding: EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
                        child: Fonts().textW500(startDateTime, 14.0, FlatColors.darkGray, TextAlign.start),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}


class ComRecurringEventRow extends StatelessWidget {

  final Event event;
  final VoidCallback eventPostAction;
  ComRecurringEventRow({this.event, this.eventPostAction});


  @override
  Widget build(BuildContext context) {

    DateFormat formatter = DateFormat("MMM d    h:mma");
    String startDateTime = event.startDateInMilliseconds == null ? null : formatter.format(DateTime.fromMillisecondsSinceEpoch(event.startDateInMilliseconds));
    DateTime eventEndDateTime = event.endDateInMilliseconds == null ? null : DateTime.fromMillisecondsSinceEpoch(event.endDateInMilliseconds);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: GestureDetector(
        onTap: eventPostAction,
        child: Container(
          width: 250,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              boxShadow: ([
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 1.8,
                  spreadRadius: 0.5,
                  offset: Offset(0.0, 3.0),
                ),
              ])
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10.0, top: 8.0, right: 4.0),
                child: Fonts().textW800(event.title, 18.0, FlatColors.darkGray, TextAlign.left),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start ,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 8.0, top: 4.0, bottom: 8.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(8.0),
                          color: FlatColors.casandoraYellow,
                          child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Fonts().textW700('Average Payout Pool: \$${PaymentCalc().getEventValueEstimate(event.estimatedTurnout).toStringAsFixed(2)}', 12.0, Colors.white, TextAlign.center)
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      event.startDateInMilliseconds == null
                          ? Container()
                          : Padding(
                        padding: EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
                        child: Fonts().textW500(startDateTime, 14.0, FlatColors.darkGray, TextAlign.start),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}