import 'package:flutter/material.dart';
import 'package:webblen/widgets_profile/profile_fonts.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/widgets_user_stats/stats_event_history_count.dart';
import 'package:webblen/widgets_user_stats/stats_impact.dart';
import 'package:webblen/widgets_user_stats/stats_user_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen/services_general/service_page_transitions.dart';

class ProfileHeader extends StatelessWidget {

  static String tag = 'profile-header';

  final NetworkImage userImage;
  final String username;
  final double eventPoints;
  final double impact;
  final List eventHistory;
  final bool canMakeRewards;

  ProfileHeader({this.userImage, this.username, this.eventPoints, this.impact, this.eventHistory, this.canMakeRewards});

  @override
  Widget build(BuildContext context) {
    const headerHeight = 210.0;

    return new Container(
      height: headerHeight,
      child: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 15.0),
              _buildBackButtonRow(context),
              _buildAvatar(),
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
          tag: 'user-profile-pic',
          child: Container(
              child: new CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: userImage,
              ),
              width: 90.0,
              height: 90.0,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  new BoxShadow(spreadRadius: 1.0,
                      blurRadius: 0.7,
                      offset: new Offset(0.0, 1.0),
                      color: FlatColors.londonSquare),
                ]
              ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackButtonRow(BuildContext context){
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 8.0),
            BackButton(color: FlatColors.londonSquare),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SizedBox(width: 8.0),
            canMakeRewards
                ? IconButton(
                  icon: Icon(FontAwesomeIcons.trophy, size: 20.0, color: FlatColors.vibrantYellow),
                  onPressed: () { PageTransitionService(context: context).transitionToCreateRewardPage();},
                )
                : Container(),
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
        new Text("@" + username, style: new TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),),
      ],
    );
  }

  Widget _buildAccountVal() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        StatsUserPoints(eventPoints.toStringAsFixed(2)),
        new Container(width: 24.0,),
        StatsImpact(impact.toStringAsFixed(2)),
        new Container(width: 24.0,),
        StatsEventHistoryCount(eventHistory.length.toString()),
      ],
    );
  }

}
