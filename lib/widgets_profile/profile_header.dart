import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/widgets_user/stats_event_history_count.dart';
import 'package:webblen/widgets_user/stats_impact.dart';
import 'package:webblen/widgets_user/stats_user_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen/services_general/service_page_transitions.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:webblen/widgets_user/user_details_profile_pic.dart';

class ProfileHeader extends StatelessWidget {

  static String tag = 'profile-header';

  final String userImagePath;
  final String username;
  final double eventPoints;
  final double impact;
  final List eventHistory;
  final bool canMakeRewards;
  final VoidCallback accountOptionsAction;
  final bool isLoading;

  ProfileHeader({this.isLoading, this.userImagePath, this.username, this.eventPoints, this.impact, this.eventHistory, this.canMakeRewards, this.accountOptionsAction});

  @override
  Widget build(BuildContext context) {

    return new Container(
      height: 290.0,
      child: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildButtonRow(context),
              SizedBox(height: 16.0),
              isLoading
                ? CustomCircleProgress(110.0, 110.0, 30.0, 30.0, FlatColors.londonSquare)
                : _buildAvatar(),
              SizedBox(height: 10.0),
              _buildUsername(),
              SizedBox(height: 8.0),
              _buildAccountVal()
            ],
          ),
        ],
      ),
    );
  }

  /// The avatar consists of the profile image, the users name and location
  Widget _buildAvatar() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Hero(
          tag: 'user-profile-pic-dashboard',
          child: UserDetailsProfilePic(userPicUrl: userImagePath, size: 110.0),
        ),
      ],
    );
  }

  Widget _buildButtonRow(BuildContext context){
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            BackButton(color: FlatColors.londonSquare),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SizedBox(width: 8.0),
            canMakeRewards
                ? IconButton(
              icon: Icon(FontAwesomeIcons.trophy, size: 20.0, color: FlatColors.vibrantYellow),
              onPressed: () { PageTransitionService(context: context).transitionToCreateRewardPage();},
            )
                : Container(),
            IconButton(
              icon: Icon(FontAwesomeIcons.cog, size: 24.0, color: FlatColors.londonSquare),
              onPressed: accountOptionsAction,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildUsername() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Text("@" + username, style: new TextStyle(fontWeight: FontWeight.w700, fontSize: 24.0)),
      ],
    );
  }

  Widget _buildAccountVal() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        StatsUserPoints(userPoints: eventPoints.toStringAsFixed(2), textColor: FlatColors.londonSquare, textSize: 14.0, iconSize: 24.0, onTap: null, darkLogo: false,),
        new Container(width: 18.0,),
        StatsImpact(impactPoints: "x1.25", textColor: FlatColors.londonSquare, textSize: 14.0, iconSize: 24.0, onTap: null),
        new Container(width: 18.0,),
        StatsEventHistoryCount(eventHistoryCount: eventHistory.length.toString(), textColor: FlatColors.londonSquare, textSize: 14.0, iconSize: 24.0, onTap: null),
      ],
    );
  }

}