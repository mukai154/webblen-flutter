import 'package:flutter/material.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/widgets_common/common_button.dart';
import 'stats_event_history_count.dart';
import 'stats_impact.dart';
import 'stats_user_points.dart';
import 'user_details_profile_pic.dart';
import 'package:webblen/widgets_icons/icon_bubble.dart';
import 'user_details_badges.dart';
import 'package:webblen/widgets_user/user_details_profile_pic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      child: user.isCommunityBuilder ? UserDetailsBadge(badgeType: "communityBuilder", size: 18.0) : Container(),
    );

    final friendBadge = new Container(
      child: isFriendsWithUser ? UserDetailsBadge(badgeType: "friend", size: 16.0) : Container(),
    );


    final userCardContent = new Container(
      padding: new EdgeInsets.only(left: 85.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              user.username == null
                  ? Text("", style: headerTextStyle)
                  : Fonts().textW700("@${user.username}", 22.0, FlatColors.darkGray, TextAlign.left),
              friendBadge,
              communityBuilderBadge,
            ],
          ),
          SizedBox(height: 2.0),
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Container(width: 2.0,),
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

    final userPic = UserDetailsProfilePic(userPicUrl: user.profile_pic, size: 95.0);

    final userCard = new Container(
      child: Column(
        children: <Widget>[
          userPic,
          user.username == null ? new Text("", style: headerTextStyle)
              : Fonts().textW700(" @" + user.username, 16.0, FlatColors.darkGray, TextAlign.center),
        ],
      ),
    );

    return new GestureDetector(
      onTap: transitionToUserDetails,
      child: userCard
    );

  }
}



class UserRowInvite extends StatelessWidget {

  final WebblenUser user;
  final VoidCallback onTap;
  final bool didInvite;

  UserRowInvite({this.user, this.onTap, this.didInvite});

  @override
  Widget build(BuildContext context) {

    final userPic = didInvite
        ? IconBubble(
            icon: Icon(FontAwesomeIcons.check, color: Colors.white, size: 18.0),
            size: 60.0,
            color: FlatColors.darkMountainGreen,
          )
        : UserDetailsProfilePic(userPicUrl: user.profile_pic, size: 60.0);

    final userCard = Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 4.0),
      padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0, right: 16.0),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              userPic
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              user.username == null ? new Container()
                  : Fonts().textW700(" @" + user.username, 20.0, FlatColors.darkGray, TextAlign.left),
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(width: 6.0,),
                  StatsImpact(impactPoints: "x1.25", textColor: FlatColors.darkGray, textSize: 14.0, iconSize: 16.0, onTap: null),
                  Container(width: 24.0,),
                  StatsEventHistoryCount(eventHistoryCount: user.eventHistory.length.toString(), textColor: FlatColors.darkGray, textSize: 14.0, iconSize: 16.0, onTap: null),
                ],
              ),
            ],
          ),
        ],
      ),
    );


    return new GestureDetector(
      onTap: onTap,
      child: userCard
    );

  }
}