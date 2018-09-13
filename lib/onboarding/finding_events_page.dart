import 'package:flutter/material.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/widgets_guide/guide_text.dart';



class FindingEventsPage extends StatelessWidget {


  // ** APP BAR
  final appBar = AppBar(
    elevation: 2.0,
    backgroundColor: Colors.white,
    brightness: Brightness.light,
    title: Text('Finding Events', style: Fonts.dashboardTitleStyle),
    leading: BackButton(color: FlatColors.londonSquare),
  );

  Widget guideHeaderText(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
      child: Text(text, style: Fonts.guideHeaderTextStyle, textAlign: TextAlign.center),
    );
  }


  Widget guideBodyText(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
      child: Text(text, style: Fonts.guideBodyTextStyle, textAlign: TextAlign.center),
    );
  }


  @override
  Widget build(BuildContext context) {
    final body = Container(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(height: 24.0),
          GuideHeaderText("Set Up Interests"),
          SizedBox(height: 16.0),
          GuideBodyText("You will primarily discover the different events and gatherings happening around you depending on what your interested in. So be sure to set them up!"),
          SizedBox(height: 24.0),
          Image.asset('assets/images/guide_dashboard_interests.jpg', height: 200.0, width: 200.0),
          SizedBox(height: 8.0),
          Image.asset('assets/images/guide_interests.jpg', height: 200.0, width: 200.0),
          SizedBox(height: 16.0),
          GuideHeaderText("Checkout the Calendar"),
          SizedBox(height: 16.0),
          GuideBodyText("Within the calendar, any events tagged with one of your interests will be available for you to discover"),
          SizedBox(height: 24.0),
          Image.asset('assets/images/guide_dashboard_calendar.jpg', height: 200.0, width: 200.0),
          SizedBox(height: 8.0),
          Image.asset('assets/images/guide_calendar.jpg', height: 200.0, width: 200.0),
          SizedBox(height: 24.0),
        ],
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }
}