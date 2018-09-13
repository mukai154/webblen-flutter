import 'package:flutter/material.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/styles/gradients.dart';
import 'package:webblen/custom_widgets/user_row.dart';
import 'package:webblen/styles/fonts.dart';


class UserRanksPage extends StatefulWidget {

  static String tag = "template-page";

  final List<WebblenUser> users;
  UserRanksPage({this.users});

  @override
  _UserRanksPageState createState() => _UserRanksPageState();
}

class _UserRanksPageState extends State<UserRanksPage> {
  
  @override
  Widget build(BuildContext context) {

    // ** APP BAR
    final appBar = AppBar (
      elevation: 2.0,
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      title: Text('Users Nearby', style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: FlatColors.blackPearl)),
      leading: BackButton(color: FlatColors.londonSquare),
    );

    return Scaffold(
      appBar: appBar,
      body: new Container(
        color: FlatColors.twinkleBlue,
        child: widget.users == null
              ? buildNoUsers("sleepy", "No Nearby Users Found")
              : buildUserList(widget.users),
      ),
    );
  }

  Widget buildUserList(List<WebblenUser> userList)  {
    return new Container(
      width: MediaQuery.of(context).size.width,
      decoration: new BoxDecoration(
        gradient: Gradients.twinkleBlue(),
      ),
      child: new ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) => new UserRow(userList[index]),
          itemCount: userList.length,
          padding: new EdgeInsets.symmetric(vertical: 8.0)
      ),
    );
  }

  Widget buildNoUsers(String imageName, String message)  {
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