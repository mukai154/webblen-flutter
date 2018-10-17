import 'package:flutter/material.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/widgets_common/common_logo.dart';
import 'package:webblen/styles/flat_colors.dart';

class OnboardingPaging extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new _OnboardingPagingState();
  }
}

class _OnboardingPagingState extends State<OnboardingPaging> {

  PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = new PageController();
  }

  @override
  Widget build(BuildContext context) {

    final logo = Logo(50.0);

    final onboardingPage1 = Container(
      color: FlatColors.casandoraYellow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Welcome to Webblen", style: Fonts.onboardingHeaderTextStyleWhite, textAlign: TextAlign.center),
          SizedBox(height: 8.0),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text("The World's First Incentivized Community Building Platform", style: Fonts.onboardingSubHeaderTextStyleWhite, textAlign: TextAlign.center),
          ),
          SizedBox(height: 16.0),
          Image.asset('assets/images/city.png', height: 200.0, width: 200.0),
        ],
      ),
    );

    final onboardingPage2 = Container(
      color: FlatColors.casandoraYellow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Be Invloved", style: Fonts.onboardingHeaderTextStyleWhite, textAlign: TextAlign.center),
          SizedBox(height: 8.0),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text("Know About the Different Events Happening Around You According to Your Interests and Location", style: Fonts.onboardingSubHeaderTextStyleWhite, textAlign: TextAlign.center),
          ),
          SizedBox(height: 16.0),
          Image.asset('assets/images/hands.png', height: 200.0, width: 200.0),
        ],
      ),
    );

    final onboardingPage3 = Container(
      color: FlatColors.casandoraYellow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Connect with Others", style: Fonts.onboardingHeaderTextStyleWhite, textAlign: TextAlign.center),
          SizedBox(height: 8.0),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text("Meet and Connect With Others That Have Similar Interests as Your Own", style: Fonts.onboardingSubHeaderTextStyleWhite, textAlign: TextAlign.center),
          ),
          SizedBox(height: 16.0),
          Image.asset('assets/images/team.png', height: 200.0, width: 200.0),
        ],
      ),
    );

    final onboardingPage4 = Container(
      color: FlatColors.casandoraYellow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Compete", style: Fonts.onboardingHeaderTextStyleWhite, textAlign: TextAlign.center),
          SizedBox(height: 8.0),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text("Complete Community Challenges and Rank Up", style: Fonts.onboardingSubHeaderTextStyleWhite, textAlign: TextAlign.center),
          ),
          SizedBox(height: 16.0),
          Image.asset('assets/images/trophy.png', height: 200.0, width: 200.0),
        ],
      ),
    );

    final onboardingPage5 = Container(
      color: FlatColors.casandoraYellow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Earn Rewards", style: Fonts.onboardingHeaderTextStyleWhite, textAlign: TextAlign.center),
          SizedBox(height: 8.0),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text("Earn Points to Rank Up or Redeem them for Various Rewards", style: Fonts.onboardingSubHeaderTextStyleWhite, textAlign: TextAlign.center),
          ),
          SizedBox(height: 16.0),
          Image.asset('assets/images/rewards.png', height: 200.0, width: 200.0),
        ],
      ),
    );

    final onboardingPage6 = Container(
      color: FlatColors.casandoraYellow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Let's Get Started!", style: Fonts.onboardingHeaderTextStyleWhite, textAlign: TextAlign.center),
          SizedBox(height: 8.0),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text("What are You Waiting for? Get Involved, Earn Rewards, and Watch Your Community Grow!", style: Fonts.onboardingSubHeaderTextStyleWhite, textAlign: TextAlign.center),
          ),
          SizedBox(height: 16.0),
          Image.asset('assets/images/phone_city.png'),
        ],
      ),
    );


    return new Scaffold(
      body: new PageView(
          controller: pageController,
          children: [
            onboardingPage1,
            onboardingPage2,
            onboardingPage3,
            onboardingPage4,
            onboardingPage5,
            onboardingPage6
          ]
      ),
    );
  }
}