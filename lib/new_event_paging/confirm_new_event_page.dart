import 'package:flutter/material.dart';
import 'package:webblen/models/event_post.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/styles/fonts.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen/widgets_common/common_button.dart';
import 'package:webblen/firebase_services/event_data.dart';
import 'package:webblen/services_general/services_show_alert.dart';
import 'package:webblen/services_general/service_page_transitions.dart';

class ConfirmEventPage extends StatefulWidget {

  final EventPost newEvent;
  final File newEventImage;
  ConfirmEventPage({this.newEvent, this.newEventImage});

  @override
  _ConfirmEventPageState createState() => _ConfirmEventPageState();
}

class _ConfirmEventPageState extends State<ConfirmEventPage> {

  submitEvent(){
    ShowAlertDialogService().showLoadingDialog(context);
    EventPostService().uploadEvent(widget.newEventImage, widget.newEvent, '').then((error){
      if (error.isEmpty){
        Navigator.of(context).pop();
        ShowAlertDialogService().showActionSuccessDialog(
            context,
            'Event Submitted!',
            'Interested Users Nearby Will Be Notified',
            () => PageTransitionService(context: context).returnToRootPage()
        );
      } else {
        Navigator.of(context).pop();
        ShowAlertDialogService().showFailureDialog(context, 'Event Submission Failed', 'There was an issue submitting your event. Please try again');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 500.0,
            backgroundColor: FlatColors.exodusPurple,
            flexibleSpace: FlexibleSpaceBar(
              background: SizedBox.expand(
                child: Image.file(widget.newEventImage, fit: BoxFit.cover)
              ),
            ),
            elevation: 3.0,
            forceElevated: true,
            pinned: false,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
                <Widget>[
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 16.0, bottom: 32.0),
                      child: Fonts().textW700(widget.newEvent.title, 24.0, FlatColors.darkGray, TextAlign.center),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Fonts().textW700('Details', 24.0, FlatColors.darkGray, TextAlign.left),
                        SizedBox(height: 8.0),
                        Fonts().textW500(widget.newEvent.caption, 16.0, FlatColors.lightAmericanGray, TextAlign.left),
                        SizedBox(height: 8.0),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(FontAwesomeIcons.calendar, size: 24.0, color: FlatColors.darkGray),
                        SizedBox(width: 4.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 10.0),
                            Fonts().textW500('${widget.newEvent.startDate} | ${widget.newEvent.startTime}', 14.0, FlatColors.darkGray, TextAlign.left),
                            SizedBox(height: 4.0),
                            InkWell(
                              onTap: () => print('tapped'),
                              child: Fonts().textW500('Add to Calendar', 12.0, FlatColors.webblenDarkBlue, TextAlign.left),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(FontAwesomeIcons.directions, size: 24.0, color: FlatColors.darkGray),
                        SizedBox(width: 4.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 12.0),
                            Fonts().textW500('${widget.newEvent.address.replaceAll(', USA', '')}', 14.0, FlatColors.darkGray, TextAlign.left),
                            SizedBox(height: 4.0),
                            InkWell(
                              onTap: () => print('tapped'),
                              child: Fonts().textW500('View in Maps', 12.0, FlatColors.webblenDarkBlue, TextAlign.left),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.0),
                  CustomColorButton(
                    text: 'Submit',
                    textColor: FlatColors.darkGray,
                    width: 90.0,
                    onPressed: () => submitEvent(),
                  )
                ]
            ),
          ),
        ],
      ),
    );
  }
}