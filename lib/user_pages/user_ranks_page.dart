import 'package:flutter/material.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:webblen/widgets_user/user_row.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/services_general/service_page_transitions.dart';
import 'package:webblen/widgets_common/common_alert.dart';
import 'package:webblen/services_general/services_show_alert.dart';
import 'package:webblen/firebase_services/user_data.dart';

class UserRanksPage extends StatefulWidget {

  final List<WebblenUser> users;
  final String currentUID;
  UserRanksPage({this.users, this.currentUID});

  @override
  _UserRanksPageState createState() => _UserRanksPageState();
}

class _UserRanksPageState extends State<UserRanksPage> {

  Future<Null> sendFriendRequest(WebblenUser user) async {
    Navigator.of(context).pop();
    ShowAlertDialogService().showLoadingDialog(context);
    UserDataService().currentUsername(widget.currentUID).then((currentUsername){
      if (currentUsername != null){
        UserDataService().addFriend(widget.currentUID, currentUsername, user.uid).then((requestStatus){
          Navigator.of(context).pop();
          if (requestStatus == "success"){
            ShowAlertDialogService().showSuccessDialog(context, "Friend Request Sent!",  user.username + " Will Need to Confirm Your Request");
          } else {
            ShowAlertDialogService().showFailureDialog(context, "Request Failed", requestStatus);
          }
        });
      } else {
        ShowAlertDialogService().showFailureDialog(context, "Request Failed", "We're Not Too Sure What Happened... Please Try Again Later");
      }
    });
  }

  Future<Null> removeFriend(WebblenUser user) async {
    Navigator.of(context).pop();
    ShowAlertDialogService().showLoadingDialog(context);
    UserDataService().currentUsername(widget.currentUID).then((currentUsername){
      if (currentUsername != null){
        UserDataService().removeFriend(widget.currentUID, user.uid).then((requestStatus){
          Navigator.of(context).pop();
          if (requestStatus == "success"){
            ShowAlertDialogService().showSuccessDialog(context, "Friend Deleted",  "You and @" + user.username + " are no longer friends");
          } else {
            ShowAlertDialogService().showFailureDialog(context, "Request Failed", requestStatus);
          }
        });
      } else {
        ShowAlertDialogService().showFailureDialog(context, "Request Failed", "We're Not Too Sure What Happened... Please Try Again Later");
      }
    });
  }

  Widget buildUsers(){
    return new CustomScrollView(slivers: <Widget>[
      const SliverAppBar(
        title: const Text('Users Nearby', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.black87)),
        elevation: 1.0,
        floating: true,
        snap: true,
        backgroundColor: Color(0xFFF9F9F9),
        brightness: Brightness.light,
        leading: BackButton(color: Colors.black38),
      ),
      new SliverList(
        delegate: new SliverChildListDelegate(
          widget.users.length < 2
            ? buildNoUserList()
            : buildUserList(widget.users),
        ),
      ),
    ]);
  }

  List buildUserList(List<WebblenUser> userList) {
    List<Widget> users = List();
    for (int i = 0; i < userList.length; i++) {
      bool isFriendsWithUser = false;
      String friendRequestStatus;
      if (userList[i].friends != null && userList[i].friends.contains(widget.currentUID)){
        friendRequestStatus = "friends";
        isFriendsWithUser = true;
      } else {
        if (userList[i].friendRequests != null && userList[i].friendRequests.contains(widget.currentUID)){
          friendRequestStatus = "pending";
        } else {
          friendRequestStatus = "not friends";
        }
      }
      users.add(
        Padding(
          padding: new EdgeInsets.symmetric(vertical: 8.0),
          child: new UserRow(
              user: userList[i],
              transitionToUserDetails: () => transitionToUserDetails(userList[i]),
              showUserOptions: () => ShowAlertDialogService().showAlert(
                  context,
                  UserDetailsOptionsDialog(
                    addFriendAction: () => sendFriendRequest(userList[i]),
                    friendRequestStatus: friendRequestStatus,
                    removeFriendAction: () => removeFriend(userList[i]),
                    messageUserAction: null,
                  ),
                  true
              ),
              isFriendsWithUser: isFriendsWithUser),
        ),
      );
    }
    return users;
  }

  List buildNoUserList() {
    List<Widget> widgets = List();
    for (int i = 0; i < 1; i++) {
      widgets.add(
        Container(
          width: MediaQuery.of(context).size.width,
          color: Color(0xFFF9F9F9),
          child: new Column(
            children: <Widget>[
              SizedBox(height: 160.0),
              new Container(
                height: 85.0,
                width: 85.0,
                child: new Image.asset("assets/images/sleepy.png", fit: BoxFit.scaleDown),
              ),
              SizedBox(height: 16.0),
              new Text("No Nearby Users Found", style: Fonts.noEventsFont, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }
    return widgets;
  }

  void transitionToUserDetails(WebblenUser webblenUser){
    PageTransitionService(context: context, uid: widget.currentUID, webblenUser: webblenUser).transitionToUserDetailsPage();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildUsers()
    );
  }
}