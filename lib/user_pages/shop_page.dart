import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/widgets_reward/reward_row.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/models/webblen_reward.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/firebase_services/reward_data.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:webblen/widgets_reward/reward_purchase.dart';
import 'package:webblen/widgets_common/common_alert.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';


class ShopPage extends StatefulWidget {

  final String uid;
  final double lat;
  final double lon;
  ShopPage(this.uid, this.lat, this.lon);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {

  List<WebblenReward> availableRewards;
  List currentUserRewards;
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
            purchaseAction: () => purchaseRewardDialog(reward),
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

  Future<bool> purchaseSuccessDialog(String messageA, String messageB){
    setState(() {
      purchaseIsLoading = false;
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

  Future<bool> purchaseFailedDialog(String messageA, String messageB){
    setState(() {
      purchaseIsLoading = false;
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

  void purchaseReward(WebblenReward reward) async{
    setState(() {
      purchaseIsLoading = true;
    });
    RewardDataService().purchaseReward(widget.uid, reward.rewardKey, reward.rewardCost).then((e){
      if (e.isNotEmpty){
        purchaseFailedDialog("Purchase Failed", e);
      } else {
        purchaseSuccessDialog("Reward Purchased!", "You can find ${reward.rewardProviderName}'s reward in your wallet");
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserDataService().currentUserRewards(widget.uid).then((userRewards){
      setState(() {
        currentUserRewards = userRewards;
      });
      RewardDataService().findEventsNearLocation(widget.lat, widget.lon).then((rewards){
        setState(() {
          availableRewards = rewards;
          if (availableRewards.isEmpty){
            availableRewards = null;
          }
          isLoading = false;
        });
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    // ** APP BAR
    final appBar = AppBar(
      elevation: 2.0,
      backgroundColor: FlatColors.lightCarribeanGreen,
      title: Text('Shop', style: new TextStyle(fontSize: 20.0,
          fontWeight: FontWeight.w600,
          color: Colors.white)),
      leading: BackButton(color: Colors.white),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: StreamBuilder(
              stream: Firestore.instance.collection("users").document(widget.uid).snapshots(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) return Text("Loading...");
                var userData = userSnapshot.data;
                double availablePoints = userData["eventPoints"] * 1.00;
                return new Row(
                  children: <Widget>[
                    Icon(Icons.account_balance_wallet, size: 20.0,
                        color: Colors.white),
                    SizedBox(width: 8.0),
                    Text(availablePoints.toStringAsFixed(2), style: Fonts.appBarWalletTextStyle),
                  ],
                );
              }
          ),
        )
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: new Container(
        child: availableRewards == null
            ? buildNoRewards("desert", "No Rewards Available Nearby")
            : buildRewardsList(availableRewards),
      ),
    );
  }


  Widget buildRewardsList(List<WebblenReward> rewardsList)  {
    return new Container(
      width: MediaQuery.of(context).size.width,
      child: new ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) => new RewardRow(rewardsList[index], () => showRewardPurchaseDialog(context, rewardsList[index])),
          itemCount: rewardsList.length,
          padding: new EdgeInsets.symmetric(vertical: 8.0)
      ),
    );
  }

  Widget buildNoRewards(String imageName, String message)  {
    return new Container(
      width: MediaQuery.of(context).size.width,
      child: new Column /*or Column*/(
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
              : new Text(message, style: Fonts.noEventsFont, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}