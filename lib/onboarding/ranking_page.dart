import 'package:flutter/material.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/widgets_guide/guide_text.dart';



class RankingPage extends StatelessWidget {


  // ** APP BAR
  final appBar = AppBar(
    elevation: 2.0,
    backgroundColor: Colors.white,
    brightness: Brightness.light,
    title: Text('Our Mission', style: Fonts.dashboardTitleStyle),
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
          GuideHeaderText("A Community Building Platform"),
          SizedBox(height: 16.0),
          Image.asset('assets/images/hands.png', height: 140.0, width: 140.0),
          SizedBox(height: 16.0),
          GuideBodyText("Webblen is a platform that builds communities. With the growth and advancement of technology, we've been able to reap incredible benefits ranging from improved health to the ability to be entertained on a whim."),
          SizedBox(height: 8.0),
          GuideBodyText("Unfortunately, this does come with a price..."),
          SizedBox(height: 24.0),
          GuideHeaderText("The Sacrifice of our Social Life"),
          SizedBox(height: 16.0),
          Image.asset('assets/images/chained_phone.png', height: 140.0, width: 140.0),
          SizedBox(height: 16.0),
          GuideBodyText("Our access to technology has allowed for us to connect with each other in ways we would not have percevied imaginable a few decades ago. From the birth of cell phones and the internet to the birth of email and social media, we've improved how easy it is for us to communicate with each other."),
          SizedBox(height: 8.0),
          GuideBodyText("The ironic part?"),
          SizedBox(height: 8.0),
          GuideBodyText("We have been using technology in many cases to replace social behavior as opposed to supplementing it. Because of the decreased quality we have to those around us, we've seen an increase in feelings of boredom, detachment, loneliness, and depression. This is where Webblen comes in."),
          SizedBox(height: 16.0),
          GuideHeaderText("Improving Societal Health & Connections with Each Other"),
          SizedBox(height: 16.0),
          Image.asset('assets/images/friendship.png', height: 140.0, width: 140.0),
          SizedBox(height: 16.0),
          GuideBodyText("We create solutions to improve community and individual health, growth, and involvement. We thank you for using our platform to become more involved in the community and we hope you share our mission. As you become more involved, we hope you connect with your commmunity in new and unique ways. It's important that you do, not only for yourself, but for those around you as well."),
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