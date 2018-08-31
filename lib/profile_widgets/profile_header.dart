import 'package:flutter/material.dart';
import 'package:webblen/profile_widgets/profile_fonts.dart';
import 'package:webblen/styles/flat_colors.dart';


class ProfileHeader extends StatelessWidget {

  static String tag = 'profile-header';

  final NetworkImage userImage;
  final String username;
  final int eventPoints;

  ProfileHeader({this.userImage, this.username, this.eventPoints});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery
        .of(context)
        .padding
        .top;

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
              _buildBackButtonRow(),
              _buildAvatar(),
              SizedBox(height: 10.0),
              _buildUsername(),
              SizedBox(height: 2.0),
              _buildAccountVal()
            ],
          ),
        ],
      ),
    );
  }

  /// The avatar consists of the profile image, the users name and location
  Widget _buildAvatar() {
    final mainTextStyle = new TextStyle(fontFamily: ProfileFontNames.TimeBurner,
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 20.0);
    final subTextStyle = new TextStyle(
        fontFamily: ProfileFontNames.TimeBurner,
        fontSize: 16.0,
        color: Colors.white70,
        fontWeight: FontWeight.w700);

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

  Widget _buildBackButtonRow(){
    return new Row(
      children: <Widget>[
        SizedBox(width: 8.0),
        BackButton(color: FlatColors.londonSquare),
      ],
    );
  }

//  Widget _buildStats() {
//    return new Row(
//      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//      crossAxisAlignment: CrossAxisAlignment.center,
//      children: <Widget>[
//        _buildInvolvementStat("Events Created", "10"),
//        _buildVerticalDivider(),
//        _buildInvolvementStat("Events Attended", "10"),
//      ],
//    );
//  }

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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Text("Score: $eventPoints", style: new TextStyle(fontSize: 14.0, color: FlatColors.lightAmericanGray)),
      ],
    );
  }

  Widget _buildInvolvementStat(String title, String value) {
    final titleStyle = new TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: Colors.black54);
    final valueStyle = new TextStyle(
        fontSize: 16.0,
        color: Colors.blueGrey);
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Text(title, style: titleStyle),
        new Text(value, style: valueStyle),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return new Container(
      height: 30.0,
      width: 1.0,
      color: Colors.white30,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
    );
  }
}
