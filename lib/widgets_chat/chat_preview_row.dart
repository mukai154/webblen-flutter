import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/widgets_user/user_details_profile_pic.dart';
import 'package:webblen/utils/time_calc.dart';

class ChatRowPreview extends StatelessWidget {

  final String chattingWith;
  final String userProfilePic;
  final VoidCallback transitionToChat;
  final String lastMessageSent;
  final String lastMessageSentBy;
  final String lastMessageType;
  final String dateSent;
  final bool seenByUser;
  final TextStyle headerTextStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0, color: FlatColors.lightAmericanGray);
  final TextStyle subHeaderTextStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0, color: FlatColors.londonSquare);
  final TextStyle bodyTextStyle =  TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: FlatColors.blackPearl);

  ChatRowPreview({this.chattingWith, this.seenByUser, this.userProfilePic, this.transitionToChat, this.lastMessageSent, this.lastMessageSentBy, this.lastMessageType, this.dateSent});

  @override
  Widget build(BuildContext context) {

    final userPic = UserDetailsProfilePic(userPicUrl: userProfilePic, size: 60.0);

    final userPicContainer = new Container(
      child: userPic,
    );

    final userCardContent = new Container(
      padding: EdgeInsets.only(left: 55.0, top: 12.0, right: 14.0, bottom: 8.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Fonts().textW700("@" + chattingWith, 18.0, seenByUser ? FlatColors.blackPearl : Colors.white, TextAlign.left),
          SizedBox(height: 4.0),
          lastMessageType == "text" ? Fonts().textW500(lastMessageSentBy + lastMessageSent, 14.0, seenByUser ? FlatColors.lightAmericanGray : Colors.white, TextAlign.left)
            : lastMessageType == "image" ? Fonts().textW500(lastMessageSentBy + "Sent an Image", MediaQuery.of(context).size.width * 0.035, seenByUser ? FlatColors.lightAmericanGray : Colors.white, TextAlign.left)
            :  Fonts().textW500(lastMessageSentBy + "Sent a Video", MediaQuery.of(context).size.width * 0.035, seenByUser ? FlatColors.blackPearl : Colors.white, TextAlign.left),
          SizedBox(height: 8.0),
          new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Fonts().textW500(TimeCalc().getPastTimeFromMilliseconds(dateSent), 12.0, seenByUser ? FlatColors.londonSquare : Colors.white, TextAlign.right),
              new Container(width: 4.0,)
            ],
          ),
        ],
      ),
    );

    final userCard = new Container(
      //height: 85.0,
      margin: new EdgeInsets.fromLTRB(12.0, 8.0, 0.0, 4.0),
      child: userCardContent,
      decoration: new BoxDecoration(
        gradient: LinearGradient(
            colors: seenByUser ? [Colors.white, Colors.white] : [FlatColors.webblenDarkBlue, FlatColors.webblenLightBlue]
        ),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0)),
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
      onTap: transitionToChat,
      child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 8.0,
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