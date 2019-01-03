import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/models/webblen_reward.dart';

class WalletRewardRow extends StatelessWidget {

  final WebblenReward reward;
  final VoidCallback onClickAction;
  final TextStyle headerTextStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0, color: FlatColors.blackPearl);
  final TextStyle subHeaderTextStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0, color: FlatColors.londonSquare);
  final TextStyle bodyTextStyle =  TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: FlatColors.blackPearl);
  final TextStyle statTextStyle =  TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: FlatColors.lightAmericanGray);

  WalletRewardRow(this.reward, this.onClickAction);

  @override
  Widget build(BuildContext context) {


    final rewardProviderPic = ClipRRect(
      borderRadius: BorderRadius.circular(30.0),
      child: FadeInImage.assetNetwork(placeholder: "assets/gifs/loading.gif", image: reward.rewardImagePath, width: 60.0),
    );


    final rewardProviderPicContainer = new Container(
      margin: new EdgeInsets.symmetric(vertical: 0.0),
      alignment: FractionalOffset.topLeft,
      child: rewardProviderPic,
    );


    Widget rewardExpirationStats() {
      return new Row(
          children: <Widget>[
            new Text("Expires: " + reward.expirationDate, style: statTextStyle),
          ]
      );
    }


    final rewardCardContent = new Container(
      margin: new EdgeInsets.fromLTRB(45.0, 6.0, 14.0, 6.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(height: 4.0),
          new Text(reward.rewardProviderName, style: headerTextStyle),
          new Container(height: 8.0),
          new Text(reward.rewardDescription, style: bodyTextStyle,
            maxLines: 3,
          ),
          SizedBox(height: 14.0),
          new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              rewardExpirationStats()
            ],
          ),
        ],
      ),
    );

    final rewardCard = new Container(
//      height: eventPost.pathToImage == "" ? 185.0 : 440.0,
      margin: new EdgeInsets.fromLTRB(24.0, 6.0, 8.0, 8.0),
      child: rewardCardContent,
      decoration: new BoxDecoration(
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
    );


    return new GestureDetector(
      onTap: onClickAction,
      child: new Container(
          margin: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          child: new Stack(
            children: <Widget>[
              rewardCard,
              rewardProviderPicContainer,
            ],
          )
      ),
    );
  }

}