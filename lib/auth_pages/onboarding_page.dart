import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:webblen/styles/fonts.dart';

class OnboardingPage extends StatefulWidget {

  @override
  _OnboardingPageState createState() => new _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {

  SwiperController swiperController = new SwiperController();
  void transitionToLoginPage () => Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);

  static Widget onboardingPage1 () {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Fonts().textW700('Welcome to Webblen', 24.0, Colors.white, TextAlign.center),
          SizedBox(height: 8.0),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Fonts().textW400('Welcome to Webblen', 16.0, Colors.white, TextAlign.center),
          ),
          SizedBox(height: 16.0),
          Image.asset('assets/images/city.png', height: 150.0, width: 150.0),
        ],
      ),
    );
  }
  static Widget onboardingPage2 () {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Fonts().textW700('Welcome to Webblen', 24.0, Colors.white, TextAlign.center),
          //Text("Be Invloved", style: Fonts.onboardingHeaderTextStyleWhite, textAlign: TextAlign.center),
          SizedBox(height: 8.0),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Fonts().textW700('Welcome to Webblen', 24.0, Colors.white, TextAlign.center),
            //Text("Know About the Different Events Happening Around You According to Your Interests and Location", style: Fonts.onboardingSubHeaderTextStyleWhite, textAlign: TextAlign.center),
          ),
          SizedBox(height: 16.0),
          Image.asset('assets/images/hands.png', height: 150.0, width: 150.0),
        ],
      ),
    );
  }
  static Widget onboardingPage3 () {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Fonts().textW700('Welcome to Webblen', 24.0, Colors.white, TextAlign.center),
          //Text("Connect with Others", style: Fonts.onboardingHeaderTextStyleWhite, textAlign: TextAlign.center),
          SizedBox(height: 8.0),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Fonts().textW700('Welcome to Webblen', 24.0, Colors.white, TextAlign.center),
            //Text("Meet and Connect With Others That Have Similar Interests as Your Own", style: Fonts.onboardingSubHeaderTextStyleWhite, textAlign: TextAlign.center),
          ),
          SizedBox(height: 16.0),
          Image.asset('assets/images/team.png', height: 150.0, width: 150.0),
        ],
      ),
    );
  }
  static Widget onboardingPage4 () {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Fonts().textW700('Welcome to Webblen', 24.0, Colors.white, TextAlign.center),
          //Text("Earn Rewards", style: Fonts.onboardingHeaderTextStyleWhite, textAlign: TextAlign.center),
          SizedBox(height: 8.0),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Fonts().textW700('Welcome to Webblen', 24.0, Colors.white, TextAlign.center),
            //Text("Earn Points to Rank Up or Redeem them for Various Rewards", style: Fonts.onboardingSubHeaderTextStyleWhite, textAlign: TextAlign.center),
          ),
          SizedBox(height: 16.0),
          Image.asset('assets/images/rewards.png', height: 150.0, width: 150.0),
        ],
      ),
    );
  }
  static Widget onboardingPage5 () {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Fonts().textW700('Welcome to Webblen', 24.0, Colors.white, TextAlign.center),
          //Text("Get Started!", style: Fonts.onboardingHeaderTextStyleWhite, textAlign: TextAlign.center),
          SizedBox(height: 8.0),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Fonts().textW700('Welcome to Webblen', 24.0, Colors.white, TextAlign.center),
            //Text("What are You Waiting for? Get Involved, Earn Rewards, and Watch Your Community Grow!", style: Fonts.onboardingSubHeaderTextStyleWhite, textAlign: TextAlign.center),
          ),
          SizedBox(height: 16.0),
          Image.asset('assets/images/phone_city.png', height: 150.0, width: 150.0),
        ],
      ),
    );
  }

  List<Widget> onboardingPages = [onboardingPage1(), onboardingPage2(), onboardingPage3(), onboardingPage4(), onboardingPage5()];

  Widget loginPageBtn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Material(
        elevation: 5.0,
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.0),
        child: InkWell(
          onTap: () {transitionToLoginPage();},
          child: Container(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Fonts().textW500('Get Started', 24.0, Colors.black54, TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    swiperController.startAutoplay();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(image: new AssetImage('assets/images/burning_orange.jpg'), fit: BoxFit.fill,),
          ),
          padding: EdgeInsets.symmetric(vertical: 32.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: new Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return onboardingPages[index];
                  },
                  controller: swiperController,
                  itemCount: 5,
                  containerHeight: MediaQuery.of(context).size.height * 0.70,
                  viewportFraction: 1.0,
                  scale: 0.9,
                  autoplay: true,
                  autoplayDisableOnInteraction: false,
                  autoplayDelay: 5000,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: loginPageBtn(),
              )
            ],
          )
      ),
    );
  }
}