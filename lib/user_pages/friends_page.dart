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

  TabController _tabController;
  bool showLoadingDialog;
  bool loadingFriends = true;
  bool loadingRequests = true;
  List friendList = [];
  int friendCount;
  List friendRequests = [];
  int requestCount;
  List messages;
  int messageCount;
  Stream<QuerySnapshot> userMessagesStream;
  List<WebblenChat> userChats;

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

  Widget buildFriendRequestsView(){
    UserDataService().updateFriendRequestNotifications(widget.currentUID);
    return StreamBuilder(
        stream: Firestore.instance.collection("users").document(widget.currentUID).snapshots(),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) return _buildLoadingScreen();
          var userData = userSnapshot.data;
          List requests = userData["friendRequests"];
          requestCount = requests.length;
          if (requests.isNotEmpty) {
            requests.forEach((requestUID) {
              UserDataService().findUserByID(requestUID).then((user) {
                if ((!friendRequests.contains(user))) {
                    friendRequests.add(user);
                }
                if (requestUID == requests.last && loadingRequests) {
                  setState(() {
                    loadingRequests = false;
                  });
                }
              });
            });
          } else {
              loadingRequests = false;
          }
          return loadingRequests
              ? _buildLoadingScreen()
              : Container(
            height: MediaQuery.of(context).size.height * 0.88,
            child: friendRequests.isEmpty
                ? buildEmptyListView("You Currently Have No Requests", "cloudy")
                : ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) => new UserRowFriendRequest(
                  user: friendRequests[index],
                  transitionToUserDetails: () => transitionToUserDetails(friendRequests[index]),
                  confirmRequest: () => confirmFriendRequest(friendRequests[index].uid),
                  denyRequest: () => denyFriendRequest(friendRequests[index].uid)),
                itemCount: requestCount,
                padding: new EdgeInsets.symmetric(vertical: 8.0)
            ),
          );
        }
    );
  }
  
  Widget buildMessagesView(){
    UserDataService().updateMessageNotifications(widget.currentUID);
    return Container(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('chats')
            .where('users', arrayContains: widget.currentUID)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
          if (!chatSnapshot.hasData) return _buildLoadingScreen();
          print(chatSnapshot.data.documents.length);

          return chatSnapshot.data.documents.isEmpty
              ? buildEmptyListView("You Have No Messages", "paper_plane")
              : ListView(
              children: chatSnapshot.data.documents.map((DocumentSnapshot chatDoc){
                if (chatDoc['isActive'] == null || chatDoc['isActive'] == false){
                  return Container();
                }
                //chatSnapshot.data.documents.sort((chatDocA, chatDocB) => chatDocA.data['timestamp'] < chatDocB.data['timestamp']);
                WebblenChat chatData = WebblenChat.fromMap(chatDoc.data);
                String username = chatData.usernames.firstWhere((username) => username != widget.currentUsername);
                String peerUid = chatData.users.firstWhere((user) => user != widget.currentUID);
                String peerProfilePic = chatData.userProfiles[peerUid];
                if (chatData.lastMessageSentBy == widget.currentUsername){
                  chatData.lastMessageSentBy = "you: ";
                } else {
                  chatData.lastMessageSentBy = "";
                }
                return ChatRowPreview(
                  chattingWith: username,
                  lastMessageSentBy: chatData.lastMessageSentBy,
                  userProfilePic: peerProfilePic,
                  dateSent: chatData.lastMessageTimeStamp,
                  lastMessageSent: chatData.lastMessagePreview,
                  transitionToChat: () => PageTransitionService(
                      context: context,
                      username: widget.currentUsername,
                      uid: widget.currentUID,
                      profilePicUrl: widget.currentProfilePicUrl,
                      chatDocKey: chatDoc.documentID,
                      peerUsername: username,
                      peerProfilePic: peerProfilePic).transitionToChatPage(),
                  lastMessageType: chatData.lastMessageType,
                  seenByUser: chatData.seenBy.contains(widget.currentUID) ? true : false,
                );
            }).toList(),
          );
        },
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

  confirmFriendRequest(String uid) async {
    ShowAlertDialogService().showLoadingDialog(context);
    UserDataService().confirmFriend(widget.currentUID, uid).then((status){

      if (status == "success" || status == null){
        WebblenUser confirmedFriend = friendRequests.where((user) => user.uid == uid).first;
        friendRequests.remove(confirmedFriend);
        friendList.add(confirmedFriend);
        setState(() {});
        Navigator.of(context).pop();
        ShowAlertDialogService().showSuccessDialog(context, "Friend Added!", "You and @" + confirmedFriend.username + " are now friends");
      } else {
        Navigator.of(context).pop();
        ShowAlertDialogService().showFailureDialog(context, "There was an Issue!", "Please Try Again Later");
      }
    });
  }

  denyFriendRequest(String uid) async {
    ShowAlertDialogService().showLoadingDialog(context);
    UserDataService().denyFriend(widget.currentUID, uid).then((status){
      print(status);
      if (status == "success"){
        friendRequests.removeWhere((user) => user.uid == uid);
        setState(() {});
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pop();
        ShowAlertDialogService().showFailureDialog(context, "There was an Issue!", "Please Try Again Later");
      }
    });
  }

  void transitionToUserDetails(WebblenUser webblenUser){
    PageTransitionService(context: context, uid: widget.currentUID, webblenUser: webblenUser).transitionToUserDetailsPage();
  }

  Future<Null> setFriends() async {
    await UserDataService().getFriendsList(widget.currentUID).then((list){
      friendList = list;
      setState(() {});
    });
  }

  Future<Null> setRequests() async {
    await UserDataService().getFriendRequestIDs(widget.currentUID).then((uids) {
      uids.forEach((uid) {
        UserDataService().findUserByID(uid).then((user) {
          friendRequests.add(user);
          if (uids.last == uid) {
            setState(() {});
          }
        });
      });
    });
  }

  @override
  void initState()  {
    super.initState();
    _tabController = new TabController(length: 3, initialIndex: 0, vsync: this);
    UserDataService().findUserByID(widget.currentUID).then((user){
      setState(() {
        friendCount = user.friends.length;
        messageCount = user.messageNotificationCount;
        requestCount = user.friendRequestNotificationCount;
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
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: FlatColors.electronBlue,
        labelColor: FlatColors.londonSquare,
        isScrollable: true,
        tabs: <Widget>[
          friendCount == null ? Tab(text: "Friends") : Tab(text: "Friends ($friendCount)") ,
          messageCount == null ? Tab(text: "Messages") : Tab(text: "Messages ($messageCount)"),
          requestCount == null ? Tab(text: "Requests") : Tab(text: "Requests ($requestCount)"),
        ],
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            buildFriendsView(),
            buildMessagesView(),
            buildFriendRequestsView()
          ],
        ),
    );
  }
}