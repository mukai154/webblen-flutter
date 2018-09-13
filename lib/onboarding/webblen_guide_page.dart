import 'package:flutter/material.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/animations/transition_animations.dart';
import 'what_is_webblen_page.dart';
import 'what_is_impact_page.dart';
import 'checking_in_page.dart';
import 'finding_events_page.dart';
import 'what_are_points_page.dart';



class WebblenGuidePage extends StatelessWidget {

  // ** APP BAR
  final appBar = AppBar(
    elevation: 2.0,
    backgroundColor: Colors.white,
    brightness: Brightness.light,
    title: Text('Guide', style: Fonts.dashboardTitleStyle),
    leading: BackButton(color: FlatColors.londonSquare),
  );

  Widget guideHeaderText(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 0.0),
      child: Text(text, style: Fonts.boldBodyTextStyle),
    );
  }


  Widget whatIsWebblenButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.0, 0.0, 0.0, 8.0),
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        child: InkWell(
          onTap: () =>  Navigator.push(context, SlideFromRightRoute(widget: WhatIsWebblenPage())),
          child: Container(
            height: 35.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("Our Mission", style: Fonts.bodyTextStyleBlue),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget findingEventsButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.0, 4.0, 0.0, 0.0),
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        child: InkWell(
          onTap: () =>  Navigator.push(context, SlideFromRightRoute(widget: FindingEventsPage())),
          child: Container(
            height: 35.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("Finding Events", style: Fonts.bodyTextStyleBlue),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget checkingInButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.0, 0.0, 0.0, 8.0),
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        child: InkWell(
          onTap: () =>  Navigator.push(context, SlideFromRightRoute(widget: CheckingInPage())),
          child: Container(
            height: 35.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("Checking In", style: Fonts.bodyTextStyleBlue),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget rankButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.0, 4.0, 0.0, 0.0),
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        child: InkWell(
          onTap: null,
          child: Container(
            height: 35.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("Ranking (coming soon)", style: Fonts.bodyTextStyleGray),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget achievementsButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.0, 4.0, 0.0, 8.0),
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        child: InkWell(
          onTap: null,
          child: Container(
            height: 30.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("Acheivements (coming soon)", style: Fonts.bodyTextStyleGray),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget whatArePointsButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.0, 4.0, 0.0, 0.0),
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        child: InkWell(
          onTap: () =>  Navigator.push(context, SlideFromRightRoute(widget: WhatArePointsPage())),
          child: Container(
            height: 35.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("What are Points?", style: Fonts.bodyTextStyleBlue),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget whatIsImpactButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.0, 4.0, 0.0, 0.0),
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        child: InkWell(
          onTap: () =>  Navigator.push(context, SlideFromRightRoute(widget: WhatIsImpactPage())),
          child: Container(
            height: 35.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('What is "Impact"?', style: Fonts.bodyTextStyleBlue),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget shopButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.0, 4.0, 0.0, 0.0),
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        child: InkWell(
          onTap: null,
          child: Container(
            height: 35.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("Shop (coming soon)", style: Fonts.bodyTextStyleGray),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final body = Container(
      child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(height: 24.0),
              guideHeaderText("About Webblen"),
              whatIsWebblenButton(context),
              guideHeaderText("Events"),
              findingEventsButton(context),
              checkingInButton(context),
              guideHeaderText("Account"),
              rankButton(context),
              achievementsButton(context),
              guideHeaderText("Rewards"),
              whatArePointsButton(context),
              whatIsImpactButton(context),
              shopButton(context)
            ],
          ),
    );

    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }
}