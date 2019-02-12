import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/widgets_reward/reward_row.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/models/webblen_reward.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/firebase_services/reward_data.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:webblen/widgets_reward/reward_purchase.dart';
import 'package:webblen/services_general/services_show_alert.dart';
import 'package:webblen/services_general/service_page_transitions.dart';

class ShopPage extends StatefulWidget {

  final String uid;
  final double lat;
  final double lon;
  ShopPage(this.uid, this.lat, this.lon);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {

  List<WebblenReward> availableRewards = [];
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
    super.initState();
    UserDataService().currentUserRewards(widget.uid).then((userRewards){
      setState(() {
        currentUserRewards = userRewards;
      });
      RewardDataService().findEventsNearLocation(widget.lat, widget.lon).then((rewards){
          availableRewards = rewards;
          if (availableRewards.isNotEmpty){
            RewardDataService().deleteExpiredRewards(availableRewards).then((validRewards){
              availableRewards = validRewards;
            });
          }
          setState(() {
            isLoading = false;
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
      title: Text('Shop', style: Fonts.dashboardTitleStyle),
      leading: BackButton(color: FlatColors.londonSquare),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: StreamBuilder(
              stream: Firestore.instance.collection("users").document(widget.uid).snapshots(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) return Text("Loading...");
                var userData = userSnapshot.data;
                double availablePoints = userData["eventPoints"] * 1.00;
                return Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Material(
                    elevation: 1.5,
                    borderRadius: BorderRadius.circular(16.0),
                    child: InkWell(
                      onTap: () => PageTransitionService(context: context, uid: userData['uid'], userPoints: availablePoints).transitionToWalletPage(),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.account_balance_wallet, size: 20.0,
                                color: FlatColors.lightCarribeanGreen),
                            SizedBox(width: 8.0),
                            Text(availablePoints.toStringAsFixed(2), style: Fonts.appBarWalletTextStyle),
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
      body: new Container(
        child: availableRewards.isEmpty
            ? buildNoRewards("desert", "No Rewards Available Nearby")
            : buildRewardsList(availableRewards),
      ),
    );
  }


  Widget buildRewardsList(List<WebblenReward> rewardsList)  {
    return new Container(
      width: MediaQuery.of(context).size.width,
      child: new GridView.count(
        crossAxisCount: 2,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
        children: new List<Widget>.generate(rewardsList.length, (index) {
          return GridTile(
              child: new InkResponse(
                onTap: null,//() => rewardClicked(index),
                child: new Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: new BoxDecoration(
                      image: DecorationImage(image: CachedNetworkImageProvider(rewardsList[index].rewardImagePath), fit: BoxFit.cover),
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: new BorderRadius.circular(16.0),
                      boxShadow: <BoxShadow>[
                        new BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10.0,
                          offset: new Offset(0.0, 10.0),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin:  EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), bottomRight: Radius.circular(16.0)),
                            color: FlatColors.webblenRed,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Image.asset('assets/images/webblen_logo_small.png', height: 24.0, width: 24.0, fit: BoxFit.contain),
                                SizedBox(width: 4.0),
                                Fonts().textW500(rewardsList[index].rewardCost.toStringAsFixed(2), 14.0, FlatColors.darkGray, TextAlign.left),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: FractionalOffset.bottomCenter,
                                end: FractionalOffset.topCenter,
                                colors: <Color>[
                                  FlatColors.blackPearl,
                                  Colors.transparent,
                                ]
                            ),
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Fonts().textW500(rewardsList[index].rewardProviderName, 14.0, FlatColors.iosOffWhite, TextAlign.left),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                ),
              )
          );
        }),
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