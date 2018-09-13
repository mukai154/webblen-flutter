import 'package:flutter/material.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/widgets_guide/guide_text.dart';



class CheckingInPage extends StatelessWidget {


  // ** APP BAR
  final appBar = AppBar(
    elevation: 2.0,
    backgroundColor: Colors.white,
    brightness: Brightness.light,
    title: Text('Checking In', style: Fonts.dashboardTitleStyle),
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
          GuideHeaderText('What is "Checking In?'),
          SizedBox(height: 16.0),
          Image.asset('assets/images/smiley_check_in.png', height: 140.0, width: 140.0),
          SizedBox(height: 16.0),
          GuideBodyText("Checking in is how you let the platform which even you are attending. If you have checked into an event, after it is over, user's are rewarded points according to the users who attended as well as how many"),
          SizedBox(height: 24.0),
          GuideHeaderText("How to Check In"),
          SizedBox(height: 16.0),
          GuideBodyText("1. Tap the Landmarker From Your Home Dashboard"),
          SizedBox(height: 8.0),
          Image.asset('assets/images/guide_dashboard_check_in.jpg', height: 200.0, width: 200.0),
          SizedBox(height: 16.0),
          GuideBodyText('2. Tap the Event Near You That You Are Attending'),
          SizedBox(height: 8.0),
          Image.asset('assets/images/guide_check_in.jpg', height: 200.0, width: 200.0),
          SizedBox(height: 16.0),
          Image.asset('assets/images/guide_check_in_available.jpg', height: 200.0, width: 200.0),
          SizedBox(height: 16.0),
          GuideBodyText('**Note: You Can Only Check Into an Event Once Every 2 Hours'),
          SizedBox(height: 8.0),
          Image.asset('assets/images/guide_check_in_unavailable.jpg', height: 200.0, width: 200.0),
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