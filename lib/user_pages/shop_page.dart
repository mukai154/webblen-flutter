import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/widgets_reward/reward_card.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/models/webblen_reward.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/firebase_services/reward_data.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:webblen/widgets_reward/reward_purchase.dart';
import 'package:webblen/services_general/services_show_alert.dart';
import 'package:webblen/services_general/service_page_transitions.dart';
import 'package:webblen/models/webblen_user.dart';

class ShopPage extends StatefulWidget {

  final WebblenUser currentUser;
  ShopPage({this.currentUser});

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {

  List<WebblenReward> availableRewards = [];
  List<WebblenReward> tier1Rewards = [];
  List<WebblenReward> tier2Rewards = [];
  List<WebblenReward> tier3Rewards = [];
  List<WebblenReward> charityRewards = [];
  bool isLoading = true;
  bool purchaseIsLoading = false;

  Future<bool> showRewardPurchaseDialog(BuildContext context, WebblenReward reward) {

    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return RewardInfoDialog(
            rewardTitle: reward.rewardProviderName,
            rewardDescription: reward.rewardDescription,
            rewardImageURL: reward.rewardImagePath,
            rewardCost: reward.rewardCost.toStringAsFixed(2),
            purchaseAction: () {
              reward.rewardCategory == "charity"
                  ? showCharityDialog(context)
                  : purchaseRewardDialog(reward);
            },
            dismissAction: () => dismissPurchaseDialog(context),
          );
        });
  }

  void dismissPurchaseDialog(BuildContext context){
    Navigator.pop(context);
  }

  Future<bool> purchaseRewardDialog(WebblenReward reward) {
    Navigator.pop(context);
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return RewardConfirmPurchaseDialog(
              rewardTitle: reward.rewardProviderName,
              rewardDescription: reward.rewardDescription,
              rewardImageURL: reward.rewardImagePath,
              rewardCost: reward.rewardCost.toStringAsFixed(2) ,
              confirmAction: () => purchaseReward(reward),
              cancelAction: () => dismissPurchaseDialog(context),
              purchaseIsLoading: purchaseIsLoading
          );
        });
  }

  showCharityDialog(BuildContext context){

  }

  purchaseSuccessDialog(String header, String body){
    setState(() {
      purchaseIsLoading = false;
    });
    Navigator.pop(context);
    ShowAlertDialogService().showSuccessDialog(context, header, body);
  }

  purchaseFailedDialog(String header, String body){
    setState(() {
      purchaseIsLoading = false;
    });
    Navigator.pop(context);
    ShowAlertDialogService().showFailureDialog(context, header, body);
  }

  void purchaseReward(WebblenReward reward) async{
    setState(() {
      purchaseIsLoading = true;
    });
    RewardDataService().purchaseReward(widget.currentUser.uid, reward.rewardKey, reward.rewardCost).then((e){
      if (e.isNotEmpty){
        purchaseFailedDialog("Purchase Failed", e);
      } else {
        purchaseSuccessDialog("Reward Purchased!", "Your Reward is Now in Your Wallet");
      }
    });
  }

  @override
  void initState() {
    super.initState();
//      RewardDataService().findEventsNearLocation(widget.lat, widget.lon).then((rewards){
//          availableRewards = rewards;
//          if (availableRewards.isNotEmpty){
//            RewardDataService().deleteExpiredRewards(availableRewards).then((validRewards){
//              availableRewards = validRewards;
//            });
//          }
//          setState(() {
//            isLoading = false;
//          });
//      });

      RewardDataService().findTierRewards('tier1').then((tier1){
        tier1Rewards = tier1;
        RewardDataService().findTierRewards('tier2').then((tier2){
          tier2Rewards = tier2;
          RewardDataService().findTierRewards('tier3').then((tier3){
            tier3Rewards = tier3;
            RewardDataService().findCharityRewards().then((charity){
              charityRewards = charity;
              setState(() {
                isLoading = false;
              });
            });
          });
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    // ** APP BAR
    final appBar = AppBar(
      elevation: 0.5,
      brightness: Brightness.light,
      backgroundColor: Color(0xFFF9F9F9),
      title: Fonts().textW800('Shop', 24.0, FlatColors.darkGray, TextAlign.center),
      //Text('Shop', style: Fonts.dashboardTitleStyle),
      leading: BackButton(color: FlatColors.londonSquare),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: StreamBuilder(
              stream: Firestore.instance.collection("users").document(widget.currentUser.uid).snapshots(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) return Text("Loading...");
                var userData = userSnapshot.data;
                double availablePoints = userData["eventPoints"] * 1.00;
                return Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Material(
                    elevation: 0,
                    borderRadius: BorderRadius.circular(16.0),
                    child: InkWell(
                      onTap: () => PageTransitionService(context: context, currentUser: widget.currentUser).transitionToWalletPage(),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Image.asset('assets/images/webblen_coin_small_dark.png', height: 24.0, width: 24.0, fit: BoxFit.contain),
                            SizedBox(width: 4.0),
                            Fonts().textW500(availablePoints.toStringAsFixed(2), 16.0, FlatColors.darkGray, TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
          ),
        )
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 24.0),
              child: Fonts().textW700("Quick Rewards", 24.0, FlatColors.darkGray, TextAlign.center),
            ),
            isLoading
                ? CustomCircleProgress(60.0, 60.0, 30.0, 30.0, FlatColors.londonSquare)
                : buildRewardsList(tier1Rewards),
            Padding(
              padding: EdgeInsets.only(top: 24.0),
              child: Fonts().textW700("Standard Rewards", 24.0, FlatColors.darkGray, TextAlign.center),
            ),
            isLoading
                ? CustomCircleProgress(60.0, 60.0, 30.0, 30.0, FlatColors.londonSquare)
                : buildRewardsList(tier2Rewards),

          ],
        ),
      ),
    );
  }


  Widget buildRewardsList(List<WebblenReward> rewardsList)  {
    return new Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.55,
      child: new GridView.count(
        crossAxisCount: 2,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
        children: new List<Widget>.generate(rewardsList.length, (index) {
          return GridTile(
              child: RewardCard(
                rewardsList[index],
                () => showRewardPurchaseDialog(context, rewardsList[index]),
                false
              ),
          );
        }),
      ),
    );
  }

  Widget buildNoRewards(String imageName, String message)  {
    return new Container(
      width: MediaQuery.of(context).size.width,
      child: new Column (
        children: <Widget>[
          SizedBox(height: 160.0),
          new Container(
            height: 85.0,
            width: 85.0,
            child: isLoading
                ? CustomCircleProgress(60.0, 60.0, 30.0, 30.0, FlatColors.londonSquare)
                : new Image.asset("assets/images/$imageName.png", fit: BoxFit.scaleDown),
          ),
          SizedBox(height: 16.0),
          isLoading
              ? Container()
              : Fonts().textW800('No Rewards Available', 24.0, FlatColors.darkGray, TextAlign.center),//new Text(message, style: Fonts.noEventsFont, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}