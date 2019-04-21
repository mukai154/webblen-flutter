import 'package:flutter/material.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:webblen/models/event.dart';
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
import 'package:webblen/firebase_services/firebase_notification_services.dart';
import 'package:webblen/widgets_common/common_appbar.dart';


class UserDetailsPage extends StatefulWidget {

  final WebblenUser currentUser;
  final WebblenUser webblenUser;
  UserDetailsPage({this.currentUser, this.webblenUser});

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> with SingleTickerProviderStateMixin{

  TabController _tabController;
  ScrollController _scrollController;
  double compatibilityPercentage = 0.01;
  bool isFriendsWithUser = false;
  String friendRequestStatus = "";
  bool isLoading = true;

  void transitionToMessenger(String chatDocKey, String currentProfileUrl, String currentUsername){
    Navigator.push(context,
        SlideFromRightRoute(
            widget: Chat(
              currentUser: widget.currentUser,
              chatDocKey: chatDocKey,
              peerProfilePic: widget.webblenUser.profile_pic,
              peerUsername: widget.webblenUser.username,
              peerUID: widget.webblenUser.uid,
            ),
        )
    );
  }

  Widget lastEventView(Event event){
    Widget lastEventResult;
    if (event != null){
      lastEventResult = ComEventRow(event: event, eventPostAction: null);
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
            Fonts().textW800('fix', 24.0, FlatColors.darkGray, TextAlign.center),
            //new Text("Most Recent Event Unavailable", style: Fonts.noEventsFont, textAlign: TextAlign.center),
          ],
        ),
      );
    }
    return lastEventResult;
  }

  Future<Null> deleteFriendConfirmation() async {
    Navigator.of(context).pop();
    ShowAlertDialogService().showConfirmationDialog(
        context,
        "Are You Sure You Want to no longer be friends with @${widget.webblenUser.username}?",
        "Remove Friend",
            () => removeFriend(),
            () => Navigator.of(context).pop()
    );
  }

  Future<Null> sendFriendRequest() async {
    Navigator.of(context).pop();
    ShowAlertDialogService().showLoadingDialog(context);
    UserDataService().addFriend(widget.currentUser.uid, widget.currentUser.username, widget.webblenUser.uid).then((requestStatus){
      Navigator.of(context).pop();
      if (requestStatus == "success"){
        ShowAlertDialogService().showSuccessDialog(context, "Friend Request Sent!",  "@" + widget.webblenUser.username + " Will Need to Confirm Your Request");
        friendRequestStatus = "pending";
        setState(() {});
      } else {
        ShowAlertDialogService().showFailureDialog(context, "Request Failed", requestStatus);
      }
    });
  }

  Future<Null> removeFriend() async {
    Navigator.of(context).pop();
    ShowAlertDialogService().showLoadingDialog(context);
    UserDataService().removeFriend(widget.currentUser.uid, widget.webblenUser.uid).then((requestStatus){
      Navigator.of(context).pop();
      if (requestStatus == null){
        ShowAlertDialogService().showSuccessDialog(context, "Friend Deleted",  "You and @" + widget.webblenUser.username + " are no longer friends");
        friendRequestStatus = "not friends";
        setState(() {});
      } else {
        ShowAlertDialogService().showFailureDialog(context, "Request Failed", requestStatus);
      }
    });
  }

  confirmFriendRequest() async {
    Navigator.of(context).pop();
    ShowAlertDialogService().showLoadingDialog(context);
    UserDataService().confirmFriend(widget.currentUser.uid, widget.webblenUser.uid).then((status){
      if (status == "success" || status == null){
        FirebaseNotificationsService().deleteFriendRequestByID(widget.currentUser.uid, widget.webblenUser.uid);
        friendRequestStatus = "friends";
        setState(() {});
        Navigator.of(context).pop();
        ShowAlertDialogService().showSuccessDialog(context, "Friend Added!", "You and @" + widget.webblenUser.username + " are now friends");
      } else {
        Navigator.of(context).pop();
        ShowAlertDialogService().showFailureDialog(context, "There was an Issue!", "Please Try Again Later");
      }
    });
  }

  denyFriendRequest() async {
    Navigator.of(context).pop();
    ShowAlertDialogService().showLoadingDialog(context);
    UserDataService().denyFriend(widget.currentUser.uid, widget.webblenUser.uid).then((status){
      if (status == "success"){
        FirebaseNotificationsService().deleteFriendRequestByID(widget.currentUser.uid, widget.webblenUser.uid);
        friendRequestStatus = "not friends";
        setState(() {});
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pop();
        ShowAlertDialogService().showFailureDialog(context, "There was an Issue!", "Please Try Again Later");
      }
    });
  }

  void messageUser() {
    ShowAlertDialogService().showLoadingDialog(context);
    ChatDataService().checkIfChatExists(widget.currentUser.uid, widget.webblenUser.uid).then((exists){
      if (exists){
        String currentUsername;
        String currentProfileUrl;
        UserDataService().findUserByID(widget.currentUser.uid).then((user){
          currentUsername = user.username;
          currentProfileUrl = user.profile_pic;
          ChatDataService().chatWithUser(widget.currentUser.uid, widget.webblenUser.uid).then((chatDocKey){
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            transitionToMessenger(chatDocKey, currentProfileUrl, currentUsername);
          });
        });
      } else {
        String currentUsername;
        String currentProfileUrl;
        UserDataService().findUserByID(widget.currentUser.uid).then((user){
          currentUsername = user.username;
          currentProfileUrl = user.profile_pic;
          ChatDataService().createChat(widget.currentUser.uid, widget.webblenUser.uid, currentUsername, widget.webblenUser.username, currentProfileUrl, widget.webblenUser.profile_pic).then((chatDocKey){
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
    _tabController = new TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    UserDataService().calculateCompatibility(widget.currentUser.uid, widget.webblenUser).then((compatibility){
      compatibilityPercentage = compatibility;
      UserDataService().checkFriendStatus(widget.currentUser.uid, widget.webblenUser.uid).then((friendStatus){
        friendRequestStatus = friendStatus;
        if (friendStatus == "friends"){
          isFriendsWithUser = true;
        }
        if (widget.webblenUser.eventHistory.length > 0){
          EventDataService().findEventByKey(widget.webblenUser.eventHistory.last).then((event){
            if (event != null){
              event = event;
            }
            isLoading = false;
            setState(() {});
          });
        } else {
          isLoading = false;
          setState(() {});
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _scrollController.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled){
          return <Widget>[
            SliverAppBar(
              title: Fonts().textW800(widget.currentUser.username, 24.0, Colors.white, TextAlign.center),
              pinned: true,
              floating: true,
              snap: false,
              actions: <Widget>[
                IconButton(
                  icon: Icon(FontAwesomeIcons.ellipsisH, size: 24.0, color: Colors.white),
                  onPressed: () => ShowAlertDialogService()
                      .showAlert(
                    context,
                    UserDetailsOptionsDialog(
                      addFriendAction: () => sendFriendRequest(),
                      friendRequestStatus: friendRequestStatus,
                      confirmRequestAction: () => confirmFriendRequest(),
                      denyRequestAction: () => denyFriendRequest(),
                      blockUserAction: null,
                      hideFromUserAction: null,
                      removeFriendAction: () => deleteFriendConfirmation(),
                      messageUserAction: messageUser,
                    ),
                    true,
                  ),
                ),
              ],
              expandedHeight: 270.0,
              flexibleSpace: FlexibleSpaceBar(
                background: UserDetailsHeader(
                  username: widget.webblenUser.username,
                  userPicUrl: widget.webblenUser.profile_pic,
                  eventPoints: widget.webblenUser.eventPoints.toStringAsFixed(2),
                  eventImpact: widget.webblenUser.impactPoints.toStringAsFixed(2),
                  eventHistoryCount: widget.webblenUser.eventHistory.length.toString(),
                  commonalityPercentage: compatibilityPercentage,
                  viewFriendsAction: null,
                  addFriendAction: null,
                ),
              ),
              bottom: TabBar(
                indicatorColor: Colors.white,
                isScrollable: true,
                labelStyle: TextStyle(fontFamily: 'Barlow', fontWeight: FontWeight.w500),
                tabs: [
                  Tab(text: 'Past Events'),
                  Tab(text: 'Communities'),
                ],
                controller: _tabController,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }
}