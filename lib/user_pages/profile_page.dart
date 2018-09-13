import 'package:flutter/material.dart';
import 'package:webblen/widgets_profile/profile_header.dart';
import 'package:webblen/widgets_profile/quick_actions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/animations/transition_animations.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'wallet_page.dart';



class ProfileHomePage extends StatefulWidget {

  static String tag = 'profile-page';

  final NetworkImage userImage;
  ProfileHomePage({this.userImage});

  @override
  _ProfileHomePageState createState() => _ProfileHomePageState();
}

class _ProfileHomePageState extends State<ProfileHomePage> {


  //Firebase
  String uid;

  void transitionToWalletPage (double points) =>  Navigator.push(context, SlideFromRightRoute(widget: WalletPage(uid: uid, totalPoints: points)));


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
                    userImage: widget.userImage,
                    username: userData["username"],
                    eventPoints: userData["eventPoints"] * 1.00,
                    impact: userData["impactPoints"] * 1.00,
                    eventHistory: userData["eventHistory"]
                ),
                new QuickActions(walletAction: () => transitionToWalletPage(userData["eventPoints"] * 1.00)),
              ],
            );
          }
      ),
    );
  }
}
