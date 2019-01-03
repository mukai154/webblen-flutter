import 'package:flutter/material.dart';
import 'user_details_profile_pic.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:webblen/styles/fonts.dart';
import 'stats_event_history_count.dart';
import 'stats_impact.dart';
import 'stats_user_points.dart';

class UserDetailsHeader extends StatelessWidget {

  final String username;
  final String userPicUrl;
  final String eventPoints;
  final String eventImpact;
  final String eventHistoryCount;
  final double commonalityPercentage;
  final VoidCallback addFriendAction;
  final VoidCallback viewFriendsAction;

  UserDetailsHeader({this.username, this.userPicUrl, this.eventPoints, this.eventImpact, this.eventHistoryCount, this.commonalityPercentage, this.addFriendAction, this.viewFriendsAction});

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                    child: UserDetailsProfilePic(userPicUrl: userPicUrl, size: 90.0),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 16.0, 0.0, 0.0),
                        child: Text("@" + username, style: Fonts.userDetailsLargeBold),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                        child: new LinearPercentIndicator(
                          width: MediaQuery.of(context).size.width * 0.56,
                          animation: true,
                          lineHeight: 16.0,
                          animationDuration: 1000,
                          percent: commonalityPercentage,
                          center: commonalityPercentage < 0.5
                                  ? Text((commonalityPercentage * 100).toStringAsFixed(0) + "%", style: Fonts.userDetailsCommonalityStyleDark)
                                  : Text((commonalityPercentage * 100).toStringAsFixed(0) + "%", style: Fonts.userDetailsCommonalityStyleLight),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor: Colors.greenAccent,
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StatsUserPointsLarge(eventPoints),
              new Container(width: 28.0,),
              StatsImpactLarge(eventImpact),
              new Container(width: 28.0,),
              StatsEventHistoryCountLarge(eventHistoryCount),
              new Container(width: 4.0,)
            ],
          ),
        ],
      ),
    );
  }
}