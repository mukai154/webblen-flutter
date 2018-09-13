import 'package:flutter/material.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/widgets_guide/guide_text.dart';



class WhatIsImpactPage extends StatelessWidget {


  // ** APP BAR
  final appBar = AppBar(
    elevation: 2.0,
    backgroundColor: Colors.white,
    brightness: Brightness.light,
    title: Text('What is Impact', style: Fonts.dashboardTitleStyle),
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
          GuideHeaderText("Impact"),
          SizedBox(height: 16.0),
          Image.asset('assets/images/lightning.png', height: 140.0, width: 140.0),
          SizedBox(height: 16.0),
          GuideBodyText("Impact is the influence you have on payouts for events. If you have more impact, not only do YOU earn more whenever you attend an event, anyone who attends the same even will earn more as well."),
          SizedBox(height: 8.0),
          GuideBodyText("How Do I Increase My Impact?"),
          SizedBox(height: 16.0),
          GuideBodyText("Impact is increased by doing the following:"),
          SizedBox(height: 8.0),
          GuideBodyText("1. Navigate to Your Wallet for Your Account"),
          SizedBox(height: 8.0),
          Image.asset('assets/images/guide_profile_wallet.jpg', height: 200.0, width: 200.0),
          SizedBox(height: 8.0),
          GuideBodyText('2. Tap "Power Up"'),
          SizedBox(height: 2.0),
          GuideBodyText('**Note: You Need At Least 0.1 Points Available to Power Up'),
          SizedBox(height: 8.0),
          Image.asset('assets/images/guide_wallet_power_up.jpg', height: 200.0, width: 200.0),
          SizedBox(height: 8.0),
          GuideBodyText("3. Finally, Select the Amount You Want to Power Up"),
          SizedBox(height: 8.0),
          Image.asset('assets/images/guide_power_up.jpg', height: 200.0, width: 200.0),
          SizedBox(height: 8.0),
          GuideHeaderText("How Impact is Measured"),
          SizedBox(height: 16.0),
          Image.asset('assets/images/analytics.png', height: 140.0, width: 140.0),
          SizedBox(height: 16.0),
          GuideBodyText("Impact increases your value contribution by 5% of what it's worth."),
          SizedBox(height: 2.0),
          GuideBodyText("For example, if you have 100.00 points worth of impact, your attendance value is multiplied by 5."),
          GuideBodyText("If you have 10, your attendance value is multipled by 0.5."),
          GuideBodyText("Other factors such as the amount of users attending the event still play a factor in size of the payout."),
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