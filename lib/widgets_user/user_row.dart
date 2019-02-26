import 'package:flutter/material.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/widgets_common/common_button.dart';
import 'stats_event_history_count.dart';
import 'stats_impact.dart';
import 'stats_user_points.dart';
import 'user_details_profile_pic.dart';
import 'user_details_badges.dart';
import 'package:webblen/widgets_user/user_details_profile_pic.dart';

class UserRow extends StatelessWidget {

  final WebblenUser user;
  final VoidCallback transitionToUserDetails;
  final VoidCallback showUserOptions;
  final bool isFriendsWithUser;
  final TextStyle headerTextStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0, color: FlatColors.lightAmericanGray);
  final TextStyle subHeaderTextStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0, color: FlatColors.londonSquare);
  final TextStyle bodyTextStyle =  TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: FlatColors.blackPearl);

  UserRow({this.user, this.transitionToUserDetails, this.showUserOptions, this.isFriendsWithUser});

  @override
  Widget build(BuildContext context) {

    final userPic = UserDetailsProfilePic(userPicUrl: user.profile_pic, size: 80.0);

    final userPicContainer = new Container(
      margin: new EdgeInsets.symmetric(vertical: 0.0),
      alignment: FractionalOffset.topLeft,
      child: userPic,
    );

    final communityBuilderBadge = new Container(
      child: user.isCommunityBuilder ? UserDetailsBadge(badgeType: "communityBuilder", size: 20.0) : Container(),
    );

    final friendBadge = new Container(
      child: isFriendsWithUser ? UserDetailsBadge(badgeType: "friend", size: 20.0) : Container(),
    );


    final userCardContent = new Container(
      padding: new EdgeInsets.only(left: 85.0, top: 8.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(height: 8.0),
          Row(
            children: <Widget>[
              user.username == null
                  ? Text("", style: headerTextStyle)
                  : Fonts().textW700("@${user.username}", 20.0, FlatColors.darkGray, TextAlign.left),
              friendBadge,
              communityBuilderBadge,
            ],
          ),
          SizedBox(height: 8.0),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              StatsUserPoints(userPoints: user.eventPoints.toStringAsFixed(2), textColor: FlatColors.darkGray, textSize: 14.0, iconSize: 24.0, onTap: null, darkLogo: true),
              new Container(width: 18.0,),
              StatsImpact(impactPoints: "x1.25", textColor: FlatColors.darkGray, textSize: 14.0, iconSize: 18.0, onTap: null),//StatsImpact(user.impactPoints.toStringAsFixed(2)),
              new Container(width: 18.0,),
              StatsEventHistoryCount(eventHistoryCount: user.eventHistory.length.toString(), textSize: 14.0, textColor: FlatColors.darkGray, iconSize: 18.0, onTap: null),
              new Container(width: 4.0,)
            ],
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );

    final userCard = new Container(
      height: 90.0,
      child: userCardContent,
    );

    return new InkWell(
      onTap: transitionToUserDetails,
      //onLongPress: null,
      child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 4.0,
            horizontal: 16.0,
          ),
          child: new Stack(
            children: <Widget>[
              userCard,
              userPicContainer,
            ],
          )
      ),
    );
  }

}

class UserRowMin extends StatelessWidget {

  final WebblenUser user;
  final VoidCallback transitionToUserDetails;
  final TextStyle headerTextStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0, color: FlatColors.lightAmericanGray);
  final TextStyle subHeaderTextStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0, color: FlatColors.londonSquare);
  final TextStyle bodyTextStyle =  TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: FlatColors.blackPearl);

  UserRowMin({this.user, this.transitionToUserDetails});

  @override
  Widget build(BuildContext context) {

    final userPic = UserDetailsProfilePic(userPicUrl: user.profile_pic, size: 60.0);

    final userPicContainer = new Container(
      margin: new EdgeInsets.symmetric(vertical: 0.0),
      alignment: FractionalOffset.topLeft,
      child: userPic,
    );

    final userCardContent = new Container(
      margin: new EdgeInsets.fromLTRB(40.0, 6.0, 14.0, 6.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(height: 8.0),
          user.username == null ? new Text("", style: headerTextStyle)
              : Fonts().textW600(" @" + user.username, 20.0, FlatColors.darkGray, TextAlign.left),
          SizedBox(height: 8.0),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              StatsUserPoints(userPoints: user.eventPoints.toStringAsFixed(2), textColor: FlatColors.darkGray, textSize: 14.0, iconSize: 24.0, onTap: null, darkLogo: true),
              new Container(width: 18.0,),
              StatsImpact(impactPoints: "x1.25", textColor: FlatColors.darkGray, textSize: 14.0, iconSize: 18.0, onTap: null),
              new Container(width: 18.0,),
              StatsEventHistoryCount(eventHistoryCount: user.eventHistory.length.toString(), textColor: FlatColors.darkGray, textSize: 14.0, iconSize: 18.0, onTap: null),
            ],
          ),
        ],
      ),
    );

    final userCard = new Container(
      height: 100.0,
      margin: new EdgeInsets.fromLTRB(24.0, 6.0, 0.0, 8.0),
      child: userCardContent,
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 3.0,
            offset: new Offset(0.0, 3.0),
          ),
        ],
      ),

    );


    return new GestureDetector(
      onTap: transitionToUserDetails,
      child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 4.0,
          ),
          child: new Stack(
            children: <Widget>[
              userCard,
              userPicContainer,
            ],
          )
      ),
    );

  }
}

class UserRowFriendRequest extends StatelessWidget {

  final WebblenUser user;
  final VoidCallback transitionToUserDetails;
  final VoidCallback confirmRequest;
  final VoidCallback denyRequest;
  final TextStyle headerTextStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0, color: FlatColors.lightAmericanGray);
  final TextStyle subHeaderTextStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0, color: FlatColors.londonSquare);
  final TextStyle bodyTextStyle =  TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: FlatColors.blackPearl);

  UserRowFriendRequest({this.user, this.transitionToUserDetails, this.confirmRequest, this.denyRequest});

  @override
  Widget build(BuildContext context) {

    final userPic = UserDetailsProfilePic(userPicUrl: user.profile_pic, size: 60.0);

    final userPicContainer = GestureDetector(
      onTap: transitionToUserDetails,
      child: Container(
        margin: new EdgeInsets.symmetric(vertical: 0.0),
        alignment: FractionalOffset.topLeft,
        child: userPic,
      ),
    );

    final userCardContent = new Container(
      margin: new EdgeInsets.fromLTRB(40.0, 6.0, 14.0, 0.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(height: 8.0),
          user.username == null ? new Text("", style: headerTextStyle)
              :new Text("@" + user.username, style: headerTextStyle),
          SizedBox(height: 8.0),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomColorButton(
                    text: "Confirm",
                    textColor: Colors.white,
                    backgroundColor: FlatColors.darkMountainGreen,
                    height: 45.0,
                    width: 200.0,
                    onPressed: () => confirmRequest
                  ),
              CustomColorButton(
                    text: "Deny",
                    textColor: FlatColors.londonSquare,
                    backgroundColor: Colors.white,
                    height: 45.0,
                    width: 200.0,
                    onPressed: () => denyRequest
                  ),
            ],
          ),
        ],
      ),
    );

    final userCard = new Container(
      height: 110.0,
      margin: new EdgeInsets.fromLTRB(24.0, 6.0, 0.0, 8.0),
      child: userCardContent,
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),

    );


    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 8.0,
      ),
      child: new Stack(
        children: <Widget>[
          userCard,
          userPicContainer,
        ],
      ),
    );
  }
}