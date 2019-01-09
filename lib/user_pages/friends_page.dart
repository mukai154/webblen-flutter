import 'package:flutter/material.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:webblen/widgets_user/user_row.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/services_general/service_page_transitions.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:webblen/services_general/services_show_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/widgets_chat/chat_preview_row.dart';
import 'package:webblen/models/webblen_chat_message.dart';


class FriendsPage extends StatefulWidget {

  final String currentUID;
  final String currentUsername;
  final String currentProfilePicUrl;
  FriendsPage({this.currentUID, this.currentUsername, this.currentProfilePicUrl});

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> with SingleTickerProviderStateMixin {

  bool showLoadingDialog;
  bool loadingFriends = true;
  bool loadingRequests = true;
  List friendList = [];
  int friendCount;


  Widget buildFriendsView(){
    return loadingFriends
        ? _buildLoadingScreen()
        : Container(
      height: MediaQuery.of(context).size.height * 0.88,
      child: friendCount == 0 || friendCount == null
          ? buildEmptyListView("You Currently Have No Friends. Go Out to Events and Makes Some!", "desert")
          : ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) => new UserRow(user: friendList[index], transitionToUserDetails: () => transitionToUserDetails(friendList[index]), showUserOptions: null, isFriendsWithUser: true),
          itemCount: friendCount,
          padding: new EdgeInsets.symmetric(vertical: 8.0)
      ),
    );
  }


  Widget buildEmptyListView(String emptyCaption, String pictureName){
    return Container(
      margin: EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width,
      color: Color(0xFFF9F9F9),
      child: new Column(
        children: <Widget>[
          SizedBox(height: 160.0),
          new Container(
            height: 85.0,
            width: 85.0,
            child: new Image.asset("assets/images/$pictureName.png", fit: BoxFit.scaleDown),
          ),
          SizedBox(height: 16.0),
          Fonts().textW600(emptyCaption, MediaQuery.of(context).size.width * 0.045, FlatColors.blueGray, TextAlign.center),
        ],
      ),
    );
  }
  

  Widget _buildLoadingScreen()  {
    return new Container(
      width: MediaQuery.of(context).size.width,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 185.0),
          CustomCircleProgress(50.0, 50.0, 40.0, 40.0, FlatColors.londonSquare),
        ],
      ),
    );
  }

  void transitionToUserDetails(WebblenUser webblenUser){
    PageTransitionService(context: context, uid: widget.currentUID, webblenUser: webblenUser).transitionToUserDetailsPage();
  }




  @override
  void initState()  {
    super.initState();
    UserDataService().findUserByID(widget.currentUID).then((user){
      setState(() {
        friendCount = user.friends.length;
        List friendIDs = user.friends;
        friendIDs.forEach((friendID){
          UserDataService().findUserByID(friendID).then((user){
            friendList.add(user);
            if (friendIDs.last == friendID){
              loadingFriends = false;
              setState(() {});
            }
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    final appBar = AppBar (
      elevation: 2.0,
      brightness: Brightness.light,
      backgroundColor: Color(0xFFF9F9F9),
      title: Text('Friends', style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: FlatColors.blackPearl)),
      leading: BackButton(color: FlatColors.londonSquare),
    );

    return Scaffold(
      appBar: appBar,
      body: Container(
          child:  buildFriendsView(),
        ),
    );
  }
}