import 'package:flutter/material.dart';
import 'package:webblen/models/webblen_chat_message.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:webblen/widgets_user/user_details_profile_pic.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class SentMessage extends StatelessWidget {

  final WebblenChatMessage chatMessage;

  SentMessage({this.chatMessage});

  Widget textMessage(){
    return Container(
      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [FlatColors.webblenRed, FlatColors.webblenOrange]),
        borderRadius: BorderRadius.circular(24.0),
      ),
      margin: EdgeInsets.only(bottom: 16.0, right: 10.0),
      child: Fonts().textW500(chatMessage.messageContent, 16.0, Colors.white, TextAlign.left),
    );
  }

  Widget textMessageLarge(){
    return Container(
      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      width: 210,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [FlatColors.webblenRed, FlatColors.webblenOrange]),
        borderRadius: BorderRadius.circular(24.0),
      ),
      margin: EdgeInsets.only(bottom: 16.0, right: 10.0),
      child: Fonts().textW500(chatMessage.messageContent, 16.0, Colors.white, TextAlign.left),
    );
  }

  Widget imageMessage(){
    return Container(
      margin: EdgeInsets.only(bottom: 16.0, right: 10.0),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(24.0)),
        clipBehavior: Clip.hardEdge,
        child: CachedNetworkImage(
          imageUrl: chatMessage.messageContent,
          width: 200.0,
          height: 200.0,
          fit: BoxFit.cover,
          placeholder: (context, url) => CustomCircleProgress(20.0, 20.0, 20.0, 20.0, FlatColors.blueGrayLowOpacity),
          errorWidget: (context, url, error) => Icon(FontAwesomeIcons.exclamation),
        ),
      ),
    );
  }

  Widget stickerMessage(){
    return Container(
      margin: EdgeInsets.only(bottom: 16.0, right: 10.0),
      child: new Image.asset('images/${chatMessage.messageContent}.gif', width: 100.0, height: 100.0, fit: BoxFit.cover),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        chatMessage.messageType == "text" ? chatMessage.messageContent.length > 20 ? textMessageLarge() : textMessage()
            : chatMessage.messageType == "image" ? imageMessage()
            : stickerMessage()
      ],
    );
  }

}

class ReceivedMessage extends StatelessWidget {

  final WebblenChatMessage chatMessage;

  ReceivedMessage({this.chatMessage});

  Widget textMessage(){
    return Container(
      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      decoration: BoxDecoration(color: FlatColors.clouds, borderRadius: BorderRadius.circular(24.0)),
      margin: EdgeInsets.only(left: 10.0),
      child: Fonts().textW500(chatMessage.messageContent, 16.0, FlatColors.blackPearl, TextAlign.left),
    );
  }

  Widget textMessageLarge(){
    return Container(
      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      width: 210,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [FlatColors.webblenRed, FlatColors.webblenOrange]),
        borderRadius: BorderRadius.circular(24.0),
      ),
      margin: EdgeInsets.only(bottom: 16.0, right: 10.0),
      child: Fonts().textW500(chatMessage.messageContent, 16.0, Colors.white, TextAlign.left),
    );
  }

  Widget imageMessage(){
    return Container(
      margin: EdgeInsets.only(bottom: 16.0, right: 10.0),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(24.0)),
        clipBehavior: Clip.hardEdge,
        child: CachedNetworkImage(
          imageUrl: chatMessage.messageContent,
          width: 200.0,
          height: 200.0,
          fit: BoxFit.cover,
          placeholder: (context, url) => CustomCircleProgress(20.0, 20.0, 20.0, 20.0, FlatColors.blueGrayLowOpacity),
          errorWidget: (context, url, error) => Icon(FontAwesomeIcons.exclamation),
        ),
      ),
    );
  }

  Widget stickerMessage(){
    return Container(
      margin: EdgeInsets.only(bottom: 16.0, right: 10.0),
      child: new Image.asset('images/${chatMessage.messageContent}.gif', width: 100.0, height: 100.0, fit: BoxFit.cover),
    );
  }

  @override
  Widget build(BuildContext context) {
    return chatMessage.messageType == "text" ? chatMessage.messageContent.length > 20 ? textMessageLarge() : textMessage()
        : chatMessage.messageType == "image" ? imageMessage()
        : chatMessage.messageType == "initial" ? Container() : stickerMessage();
  }

}

class SenderPic extends StatelessWidget {

  final String userProfilePicUrl;

  SenderPic({this.userProfilePicUrl});

  Widget userPic(){
    return UserDetailsProfilePic(userPicUrl: userProfilePicUrl, size: 32.0);
  }

  @override
  Widget build(BuildContext context) {
    return userPic();
  }

}