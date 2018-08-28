import 'package:flutter/material.dart';
import 'package:webblen/profile_widgets/main_menu.dart';
import 'package:webblen/profile_widgets/profile_model.dart';
import 'package:webblen/profile_widgets/profile_header.dart';
import 'package:webblen/profile_widgets/quick_actions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/firebase_services/auth.dart';



class ProfileHomePage extends StatefulWidget {

  static String tag = 'profile-page';

  @override
  _ProfileHomePageState createState() => _ProfileHomePageState();
}

class _ProfileHomePageState extends State<ProfileHomePage> {

  //Firebase
  String uid;

  @override
  void initState() {
    super.initState();
    BaseAuth().currentUser().then((val) {
      setState(() {
        uid = val == null ? null : val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection("users").document(uid).snapshots(),
          builder: (context, userSnapshot) {
            if (!userSnapshot.hasData) return Text("Loading...");
            var userData = userSnapshot.data;
            return new ListView(
              padding: const EdgeInsets.all(0.0),
              children: <Widget>[
                new ProfileHeader(
                    profilePic: userData["profile_pic"],
                    username: userData["username"],
                    eventPoints: userData["eventPoints"],
                ),
                new QuickActions(),
              ],
            );
          }
      ),
    );
  }
}
