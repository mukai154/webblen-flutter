import 'package:flutter/material.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:webblen/widgets_user/user_row.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/services_general/service_page_transitions.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class FriendsPage extends StatefulWidget {

  final WebblenUser currentUser;
  FriendsPage({this.currentUser});

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> with SingleTickerProviderStateMixin {

  bool showLoadingDialog;
  bool loadingFriends = true;
  bool loadingRequests = true;
  List<WebblenUser> friendList = [];
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
    PageTransitionService(context: context, currentUser: widget.currentUser, webblenUser: webblenUser).transitionToUserDetailsPage();
  }




  @override
  void initState()  {
    super.initState();
      setState(() {
        friendCount = widget.currentUser.friends.length;
        List friendIDs = widget.currentUser.friends;
        friendIDs.forEach((friendID){
          UserDataService().findUserByID(friendID).then((user){
            friendList.add(user);
            if (friendIDs.last == friendID){
              friendList.sort((friendA, friendB) => friendA.username.compareTo(friendB.username));
              loadingFriends = false;
              setState(() {});
            }
          });
        });
      });
  }

  @override
  Widget build(BuildContext context) {

    final appBar = AppBar (
      elevation: 0.5,
      brightness: Brightness.light,
      backgroundColor: Color(0xFFF9F9F9),
      title: Text('Friends', style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: FlatColors.blackPearl)),
      leading: BackButton(color: FlatColors.londonSquare),
      actions: <Widget>[
        IconButton(
          icon: Icon(FontAwesomeIcons.search, size: 20.0, color: Colors.black45),
          onPressed: () => PageTransitionService(context: context, usersList: friendList, currentUser: widget.currentUser).transitionToUserSearchPage(),
        )
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: Container(
          child:  buildFriendsView(),
        ),
    );
  }
}