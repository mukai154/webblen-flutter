import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/widgets_wallet/wallet_head.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'power_up_page.dart';
import 'package:webblen/animations/transition_animations.dart';
import 'dart:async';
import 'package:webblen/firebase_services/reward_data.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:webblen/models/webblen_reward.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:webblen/widgets_reward/reward_wallet_row.dart';
import 'package:webblen/widgets_common/common_alert.dart';
import 'package:webblen/widgets_reward/reward_purchase.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:url_launcher/url_launcher.dart';


class WalletPage extends StatefulWidget {


  final String uid;
  final double totalPoints;
  WalletPage({this.uid, this.totalPoints});

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {

  bool isPoweringUp = false;
  double powerUpAmount = 0.10;
  List userRewards;
  bool isLoading = true;
  bool loadingRedemption = false;
  List<WebblenReward> walletRewards = [];

  // ** APP BAR
  final appBar =  AppBar (
    elevation: 2.0,
    backgroundColor: Colors.white,
    brightness: Brightness.light,
    title: Text('My Wallet', style: Fonts.dashboardTitleStyle),
    leading: BackButton(color: FlatColors.londonSquare),
  );

  void transitionToPowerUpPage(){
    Navigator.push(context, SlideFromRightRoute(widget: PowerUpPage(uid: widget.uid, totalPoints: widget.totalPoints)));
  }

  Future<bool> powerUpAlert(BuildContext context) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(
              child: Column(
                children: <Widget>[
                  Image.asset("assets/images/power_up.png", height: 45.0, width: 45.0),
                  SizedBox(height: 8.0),
                  Text("Power Up?", style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                ],
              ),
            ),
            content: new Text("Converting your points into impact increases the value of your attencance and the amount of points you earn from future events", style: Fonts.alertDialogBody, textAlign: TextAlign.center),
            actions: <Widget>[
              Column(
                children: <Widget>[
                  new FlatButton(
                    child: new Text("No", style: Fonts.alertDialogAction),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  new FlatButton(
                    child: new Text("Yes", style: Fonts.alertDialogAction),
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        isPoweringUp = true;
                        print(powerUpAmount);
                      });
                    },
                  ),
                ],
              ),
              
            ],
          );
        });
  }

  Future<bool> showRewardDialog(BuildContext context, WebblenReward reward) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return RewardWalletDialog(
            rewardTitle: reward.rewardProviderName,
            rewardDescription: reward.rewardDescription,
            rewardImageURL: reward.rewardImagePath,
            rewardCost: reward.rewardCost.toStringAsFixed(2),
            redeemAction: () => redeemRewardDialog(reward),
            dismissAction: () => dismissPurchaseDialog(context),
          );
        });
  }

  void dismissPurchaseDialog(BuildContext context){
    Navigator.pop(context);
  }

  Future<bool> redeemRewardDialog(WebblenReward reward) {
    Navigator.pop(context);
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return RewardRedemptionDialog(
              rewardTitle: reward.rewardProviderName,
              rewardDescription: reward.rewardDescription,
              rewardImageURL: reward.rewardImagePath,
              rewardCost: reward.rewardCost.toStringAsFixed(2) ,
              confirmAction: () => redeemReward(reward),
              cancelAction: () => dismissPurchaseDialog(context),
              loadingRedemption: loadingRedemption
          );
        });
  }

  Future<bool> redeemSuccessDialog(String messageA, String messageB){
    setState(() {
      loadingRedemption = false;
    });
    Navigator.pop(context);
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return SuccessDialog(
              messageA: messageA,
              messageB: messageB
          );
        });
  }

  Future<bool> redeemFailedDialog(String messageA, String messageB){
    setState(() {
      loadingRedemption = false;
    });
    Navigator.pop(context);
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return UnavailableMessage(
              messageHeader: "There was an issue",
              messageA: messageA,
              messageB: messageB
          );
        });
  }

  void redeemReward(WebblenReward reward) async{
    setState(() {
      loadingRedemption = true;
    });
    if (await canLaunch(reward.rewardUrl)) {
      await launch(reward.rewardUrl);
      setState(() {
        loadingRedemption = false;
      });
    } else {
      setState(() {
        loadingRedemption = false;
      });
      redeemFailedDialog("Could Not Open Url", "Please Check Your Internet Connection");
    }
  }


  Widget buildWalletRewards(){
    if (isLoading){
      return Container(
        child: CustomCircleProgress(45.0, 45.0, 45.0, 45.0, FlatColors.londonSquare),
      );
    } else if (walletRewards.isNotEmpty){
      return rewardsList(walletRewards);
    } else {
      return noRewardsList();
    }
  }

  Widget rewardsList(List<WebblenReward> rewards)  {
    return Container(
      child: new Swiper(
        itemBuilder: (context, index) => WalletRewardRow(rewards[index], () => showRewardDialog(context, rewards[index])),
        itemCount: rewards.length,
        itemWidth: MediaQuery.of(context).size.width,
        itemHeight: MediaQuery.of(context).size.height * 0.25,
        layout: SwiperLayout.STACK,
      ),
    );
  }

  Widget noRewardsList()  {
    return new Container(
      width: MediaQuery.of(context).size.width,
      child: new Column /*or Column*/(
        children: <Widget>[
          new Container(
            height: 85.0,
            width: 85.0,
            child: new Image.asset("assets/images/embarrassed.png", fit: BoxFit.scaleDown),
          ),
          SizedBox(height: 16.0),
          new Text("You Currently Have No Rewards", style: Fonts.noEventsFont, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserDataService().currentUserRewards(widget.uid).then((rewards){
      setState(() {
        userRewards = rewards;
      });
      userRewards.forEach((reward){
        String rewardID = reward.toString();
        RewardDataService().findRewardByID(rewardID).then((reward){
          if (reward != null){
            walletRewards.add(reward);
          }
          isLoading = false;
          setState(() {});
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: appBar,
      body: StreamBuilder(
          stream: Firestore.instance.collection("users").document(widget.uid).snapshots(),
          builder: (context, userSnapshot) {
            if (!userSnapshot.hasData) return Text("Loading...");
            var userData = userSnapshot.data;
            List rewards = userData["rewards"];
            return new ListView(
              padding: const EdgeInsets.all(0.0),
              children: <Widget>[
                WalletHead(
                  eventPoints: userData["eventPoints"] * 1.00,
                  impactPoints: userData["impactPoints"] * 1.00,
                  powerUpAction: () => transitionToPowerUpPage(),
                ),
                SizedBox(height: 32.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text("Rewards", style: Fonts.walletSubHeadTextStyleDark),
                ),
                SizedBox(height: 100.0),
                buildWalletRewards(),
              ],
            );
          }
      ),
    );
  }
}