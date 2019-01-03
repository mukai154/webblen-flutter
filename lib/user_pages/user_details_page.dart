import 'package:flutter/material.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:webblen/models/event_post.dart';
import 'package:webblen/widgets_user/user_details_header.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/firebase_services/event_data.dart';
import 'package:webblen/widgets_event/event_row.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen/services_general/services_show_alert.dart';
import 'package:webblen/widgets_common/common_alert.dart';
import 'package:webblen/firebase_services/chat_data.dart';
import 'package:webblen/animations/transition_animations.dart';
import 'chat_page.dart';


class UserDetailsPage extends StatefulWidget {

  final String currentUID;
  final WebblenUser webblenUser;
  UserDetailsPage({this.currentUID, this.webblenUser});

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {

  double compatibilityPercentage = 0.01;
  bool isFriendsWithUser = false;
  String friendRequestStatus = "";
  EventPost lastEventSeen;
  bool isLoading = true;

  void transitionToMessenger(String chatDocKey, String currentProfileUrl, String currentUsername){
    Navigator.push(context,
        SlideFromRightRoute(
            widget: Chat(
                chatDocKey: chatDocKey,
                currentProfilePic: currentProfileUrl,
                peerProfilePic: widget.webblenUser.profile_pic,
                currentUsername: currentUsername,
                peerUsername: widget.webblenUser.username,
                peerUID: widget.webblenUser.uid,
                currentUID: widget.currentUID)
        )
    );
  }

  Widget lastEventView(EventPost event){
    Widget lastEventResult;
    if (event != null){
      lastEventResult = EventRowMin(event);
    } else {
      lastEventResult = Container(
        width: MediaQuery.of(context).size.width,
        color: Color(0xFFF9F9F9),
        child: new Column(
          children: <Widget>[
            SizedBox(height: 50.0),
            new Container(
              height: 85.0,
              width: 85.0,
              child: new Image.asset("assets/images/sleepy.png", fit: BoxFit.scaleDown),
            ),
            SizedBox(height: 16.0),
            new Text("Most Recent Event Unavailable", style: Fonts.noEventsFont, textAlign: TextAlign.center),
          ],
        ),
      );
    }
    return lastEventResult;
  }

  Future<Null> sendFriendRequest() async {
    Navigator.of(context).pop();
    ShowAlertDialogService().showLoadingDialog(context);
    UserDataService().currentUsername(widget.currentUID).then((currentUsername){
      if (currentUsername != null){
        UserDataService().addFriend(widget.currentUID, currentUsername, widget.webblenUser.uid).then((requestStatus){
          Navigator.of(context).pop();
          if (requestStatus == "success"){
            ShowAlertDialogService().showSuccessDialog(context, "Friend Request Sent!",  widget.webblenUser.username + " Will Need to Confirm Your Request");
            friendRequestStatus = "pending";
            setState(() {});
          } else {
            ShowAlertDialogService().showFailureDialog(context, "Request Failed", requestStatus);
          }
        });
      } else {
        ShowAlertDialogService().showFailureDialog(context, "Request Failed", "We're Not Too Sure What Happened... Please Try Again Later");
      }
    });
  }

  Future<Null> removeFriend() async {
    Navigator.of(context).pop();
    ShowAlertDialogService().showLoadingDialog(context);
    UserDataService().currentUsername(widget.currentUID).then((currentUsername){
      if (currentUsername != null){
        UserDataService().removeFriend(widget.currentUID, widget.webblenUser.uid).then((requestStatus){
          Navigator.of(context).pop();
          if (requestStatus == "success"){
            ShowAlertDialogService().showSuccessDialog(context, "Friend Deleted",  "You and @" + widget.webblenUser.username + " are no longer friends");
            friendRequestStatus = "not friends";
            setState(() {});
          } else {
            ShowAlertDialogService().showFailureDialog(context, "Request Failed", requestStatus);
          }
        });
      } else {
        ShowAlertDialogService().showFailureDialog(context, "Request Failed", "We're Not Too Sure What Happened... Please Try Again Later");
      }
    });
  }

  void messageUser() {
    ShowAlertDialogService().showLoadingDialog(context);
    ChatDataService().checkIfChatExists(widget.currentUID, widget.webblenUser.uid).then((exists){
      if (exists){
        String currentUsername;
        String currentProfileUrl;
        UserDataService().findUserByID(widget.currentUID).then((user){
          currentUsername = user.username;
          currentProfileUrl = user.profile_pic;
          ChatDataService().chatWithUser(widget.currentUID, widget.webblenUser.uid).then((chatDocKey){
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            transitionToMessenger(chatDocKey, currentProfileUrl, currentUsername);
          });
        });
      } else {
        String currentUsername;
        String currentProfileUrl;
        UserDataService().findUserByID(widget.currentUID).then((user){
          currentUsername = user.username;
          currentProfileUrl = user.profile_pic;
          ChatDataService().createChat(widget.currentUID, widget.webblenUser.uid, currentUsername, widget.webblenUser.username, currentProfileUrl, widget.webblenUser.profile_pic).then((chatDocKey){
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            transitionToMessenger(chatDocKey, currentProfileUrl, currentUsername);
          });
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    UserDataService().calculateCompatibility(widget.currentUID, widget.webblenUser).then((compatibility){
      compatibilityPercentage = compatibility;
      setState(() {});
    });
    UserDataService().checkFriendStatus(widget.currentUID, widget.webblenUser.uid).then((friendStatus){
      if (friendStatus == "friends"){
        isFriendsWithUser = true;
        friendRequestStatus = friendStatus;
        setState(() {});
      } else {
        friendRequestStatus = friendStatus;
        setState(() {});
      }
    });
    if (widget.webblenUser.eventHistory.length > 0){
      EventPostService().findEventByKey(widget.webblenUser.eventHistory.last).then((event){
        if (event != null){
          lastEventSeen = event;
        }
        isLoading = false;
        setState(() {});
      });
    } else {
      isLoading = false;
      setState(() {});
    }

  }

  @override
  Widget build(BuildContext context) {

    final body = Container(
      child: ListView(
        children: <Widget>[
          SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              BackButton(color: FlatColors.londonSquare),
              IconButton(
                icon: Icon(FontAwesomeIcons.ellipsisH, size: 24.0, color: FlatColors.londonSquare),
                onPressed: () => ShowAlertDialogService()
                    .showAlert(
                    context,
                    UserDetailsOptionsDialog(
                        addFriendAction: () => sendFriendRequest(),
                        friendRequestStatus: friendRequestStatus,
                        blockUserAction: null,
                        hideFromUserAction: null,
                        removeFriendAction: () => removeFriend(),
                        messageUserAction: messageUser,
                    ),
                    true,
                ),
              ),
            ],
          ),
          UserDetailsHeader(
            username: widget.webblenUser.username,
            userPicUrl: widget.webblenUser.profile_pic,
            eventPoints: widget.webblenUser.eventPoints.toStringAsFixed(2),
            eventImpact: widget.webblenUser.impactPoints.toStringAsFixed(2),
            eventHistoryCount: widget.webblenUser.eventHistory.length.toString(),
            commonalityPercentage: compatibilityPercentage,
            viewFriendsAction: null,
            addFriendAction: null,
          ),
          SizedBox(height: 16.0),
          isLoading
            ? CustomCircleProgress(60.0, 60.0, 30.0, 30.0, FlatColors.londonSquare)
            : lastEventView(lastEventSeen),
        ],
      ),
    );

    return Scaffold(
        body: body
    );
  }
}