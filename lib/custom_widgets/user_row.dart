import 'package:flutter/material.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/widgets_common/common_button.dart';
import 'package:webblen/widgets_user_stats/stats_event_history_count.dart';
import 'package:webblen/widgets_user_stats/stats_impact.dart';
import 'package:webblen/widgets_user_stats/stats_user_points.dart';
import 'package:webblen/widgets_user_details/user_details_profile_pic.dart';

class UserRow extends StatelessWidget {

  final WebblenUser user;
  final VoidCallback transitionToUserDetails;
  final TextStyle headerTextStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0, color: FlatColors.lightAmericanGray);
  final TextStyle subHeaderTextStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0, color: FlatColors.londonSquare);
  final TextStyle bodyTextStyle =  TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: FlatColors.blackPearl);

  UserRow({this.user, this.transitionToUserDetails});

  @override
  Widget build(BuildContext context) {

    final userPic = UserDetailsProfilePic(userPicUrl: user.profile_pic, size: 80.0);

    final userPicContainer = new Container(
      margin: new EdgeInsets.symmetric(vertical: 0.0),
      alignment: FractionalOffset.topLeft,
      child: userPic,
    );

    final userCardContent = new Container(
      margin: new EdgeInsets.fromLTRB(64.0, 6.0, 14.0, 6.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(height: 8.0),
          user.username == null ? new Text("", style: headerTextStyle)
          :new Text("@" + user.username, style: headerTextStyle),
          SizedBox(height: 16.0),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StatsUserPoints(user.eventPoints.toStringAsFixed(2)),
              new Container(width: 18.0,),
              StatsImpact(user.impactPoints.toStringAsFixed(2)),
              new Container(width: 18.0,),
              StatsEventHistoryCount(user.eventHistory.length.toString()),
              new Container(width: 4.0,)
            ],
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );

    final userCard = new Container(
      height: 100.0,
      margin: new EdgeInsets.fromLTRB(24.0, 6.0, 8.0, 8.0),
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


    return new GestureDetector(
      onTap: transitionToUserDetails,
      child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 16.0,
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
  final TextStyle headerTextStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0, color: FlatColors.lightAmericanGray);
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
              :new Text("@" + user.username, style: headerTextStyle),
          SizedBox(height: 12.0),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StatsUserPointsMin(user.eventPoints.toStringAsFixed(2)),
              new Container(width: 8.0,),
              StatsImpactMin(user.impactPoints.toStringAsFixed(2)),
              new Container(width: 8.0,),
              StatsEventHistoryCountMin(user.eventHistory.length.toString()),
              new Container(width: 4.0,)
            ],
          ),
          SizedBox(height: 8.0),
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
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
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
              CustomColorButton("Confirm", 40.0, MediaQuery.of(context).size.width * 0.25, confirmRequest, FlatColors.lightCarribeanGreen, Colors.white),
              CustomColorButton("Deny", 40.0, MediaQuery.of(context).size.width * 0.25, denyRequest, Colors.red, Colors.white),
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