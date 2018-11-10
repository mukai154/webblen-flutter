import 'package:flutter/material.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:webblen/custom_widgets/user_row.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/services_general/service_page_transitions.dart';


class UserRanksPage extends StatefulWidget {

  final List<WebblenUser> users;
  final String currentUID;
  UserRanksPage({this.users, this.currentUID});

  @override
  _UserRanksPageState createState() => _UserRanksPageState();
}

class _UserRanksPageState extends State<UserRanksPage> {

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
      users.add(
        Padding(
          padding: new EdgeInsets.symmetric(vertical: 8.0),
          child: new UserRow(user: userList[i], transitionToUserDetails: () => transitionToUserDetails(userList[i]),),
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