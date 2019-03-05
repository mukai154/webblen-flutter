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
import 'package:webblen/firebase_services/transaction_data.dart';
import 'package:card_settings/card_settings.dart';
import 'package:webblen/widgets_common/common_appbar.dart';
import 'package:webblen/widgets_common/common_button.dart';
import 'package:webblen/widgets_reward/reward_card.dart';
import 'package:webblen/widgets_reward/reward_purchase.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:webblen/services_general/service_page_transitions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webblen/services_general/services_show_alert.dart';
import 'package:webblen/models/webblen_user.dart';


class WalletPage extends StatefulWidget {

  final WebblenUser currentUser;
  WalletPage({this.currentUser});

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {

  List<WebblenReward> walletRewards = [];
  GlobalKey<FormState> paymentFormKey = new GlobalKey<FormState>();
  String formDepositName;
  WebblenReward redeemingReward;


  void transitionToPowerUpPage(double totalPoints){
    Navigator.push(context, SlideFromRightRoute(widget: PowerUpPage(currentUser: widget.currentUser)));
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
          );
        });
  }

  redeemSuccessDialog(String header, String body){
    Navigator.pop(context);
    ShowAlertDialogService().showSuccessDialog(context, header, body);
  }

  redeemFailedDialog(String header, String body){
    Navigator.pop(context);
    ShowAlertDialogService().showFailureDialog(context, header, body);
  }

  void redeemReward(WebblenReward reward) async {
    Navigator.of(context).pop();
    setState(() {
      redeemingReward = reward;
    });
    if (reward.rewardUrl.isEmpty){
      PageTransitionService(context: context, reward: redeemingReward, currentUser: widget.currentUser).transitionToRewardPayoutPage();
    } else if (await canLaunch(reward.rewardUrl)) {
      await launch(reward.rewardUrl);
    } else {
      redeemFailedDialog("Could Not Open Url", "Please Check Your Internet Connection");
    }
  }

  validatePaymentForm(){
    final form = paymentFormKey.currentState;
    form.save();
    ShowAlertDialogService().showLoadingDialog(context);
    if (formDepositName.isNotEmpty){
      TransactionDataService().submitTransaction(widget.currentUser.uid, null, redeemingReward.rewardType, formDepositName, redeemingReward.rewardDescription).then((error){
        if (error.isEmpty){
          redeemSuccessDialog("Payment Now Processing", "Please Allow 2-3 Days for Your Payment to be Deposited into Your Account");
        } else {
          redeemFailedDialog("Payment Failed", "There was an issue processing your payment, please try again");
        }
      });
    } else {
      redeemFailedDialog("Payment Failed", "There was an issue processing your payment, please try again");
    }
  }




  Widget buildWalletRewards(){
    if (walletRewards.isNotEmpty){
      return rewardsList(walletRewards);
    } else {
      return noRewardsList();
    }
  }

  Widget rewardsList(List<WebblenReward> walletRewards)  {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.5,
      child: new GridView.count(
        crossAxisCount: 2,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
        children: new List<Widget>.generate(walletRewards.length, (index) {
          return GridTile(
            child: RewardCard(
              walletRewards[index],
                  () => redeemRewardDialog(walletRewards[index]),
              true
            ),
          );
        }),
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
    super.initState();
    //ShowAlertDialogService().showLoadingDialog(context);
    UserDataService().updateWalletNotifications(widget.currentUser.uid);
    widget.currentUser.rewards.forEach((reward){
      String rewardID = reward.toString();
      RewardDataService().findRewardByID(rewardID).then((userReward){
        if (userReward != null){
          walletRewards.add(userReward);
          if (reward == widget.currentUser.rewards.last){
            setState(() {});
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: WebblenAppBar().basicAppBar("Wallet"),
      body: StreamBuilder(
          stream: Firestore.instance.collection("users").document(widget.currentUser.uid).snapshots(),
          builder: (context, userSnapshot) {
            if (!userSnapshot.hasData) return Text("Loading...");
            var userData = userSnapshot.data;
            return new ListView(
              children: <Widget>[
                SizedBox(height: 8.0),
                WalletHead(
                  eventPoints: userData["eventPoints"] * 1.00,
                  impactPoints: userData["impactPoints"] * 1.00,
                  powerUpAction: () => transitionToPowerUpPage(userData["eventPoints"] * 1.00),
                ),
                SizedBox(height: 16.0),
                Container(
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Fonts().textW700("Rewards", 24.0, FlatColors.darkGray, TextAlign.left)
                    ),
                    buildWalletRewards(),
                  ],
                  ),
                ),
              ],
            );
          }
      ),
    );
  }
}