import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/styles/gradients.dart';
import 'package:webblen/widgets_shop/reward_row.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/models/webblen_reward.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/styles/fonts.dart';


class ShopPage extends StatefulWidget {

  final String uid;
  ShopPage(this.uid);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {

  List<WebblenReward> availableRewards;
  
  @override
  Widget build(BuildContext context) {

    // ** APP BAR
    final appBar = AppBar(
      elevation: 2.0,
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      title: Text('Shop', style: new TextStyle(fontSize: 20.0,
          fontWeight: FontWeight.w600,
          color: FlatColors.blackPearl)),
      leading: BackButton(color: FlatColors.londonSquare),
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
                        color: FlatColors.londonSquare),
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
      decoration: new BoxDecoration(
        gradient: Gradients.twinkleBlue(),
      ),
      child: new ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) => new RewardRow(rewardsList[index], null),
          itemCount: rewardsList.length,
          padding: new EdgeInsets.symmetric(vertical: 8.0)
      ),
    );
  }

  Widget buildNoRewards(String imageName, String message)  {
    return new Container(
      width: MediaQuery.of(context).size.width,
      decoration: new BoxDecoration(
        gradient: Gradients.twinkleBlue(),
      ),
      child: new Column /*or Column*/(
        children: <Widget>[
          SizedBox(height: 160.0),
          new Container(
            height: 85.0,
            width: 85.0,
            child: new Image.asset("assets/images/$imageName.png", fit: BoxFit.scaleDown),
          ),
          SizedBox(height: 16.0),
          new Text(message, style: Fonts.noEventsFont, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}