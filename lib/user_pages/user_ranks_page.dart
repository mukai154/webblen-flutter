import 'package:flutter/material.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:webblen/widgets_user/user_row.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/services_general/service_page_transitions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen/widgets_common/common_appbar.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'dart:async';
import 'package:webblen/firebase_services/auth.dart';
import 'package:webblen/widgets_data_streams/stream_user_data.dart';
import 'package:webblen/services_general/services_location.dart';
import 'package:webblen/widgets_common/common_button.dart';

class UserRanksPage extends StatefulWidget {

  @override
  _UserRanksPageState createState() => _UserRanksPageState();
}

class _UserRanksPageState extends State<UserRanksPage> {

  String uid;
  WebblenUser currentUser;
  StreamSubscription userStream;
  double currentLat;
  double currentLon;
  List<WebblenUser> nearbyUsers = [];
  bool hasLocation = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<Null> initialize() async {
    BaseAuth().currentUser().then((val) {
      uid = val;
      Firestore.instance.collection("users").document(uid).get().then((userDoc){
        if (userDoc.exists) {
          StreamUserData.getUserStream(uid, getUser).then((StreamSubscription<DocumentSnapshot> s){
            userStream = s;
          });
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil('/setup', (Route<dynamic> route) => false);
        }
      });

    });
  }

  getUser(WebblenUser user){
    currentUser = user;
    if (currentUser != null){
      loadLocation();
    }
  }

  Future<Null> loadLocation() async {
    LocationService().getCurrentLocation(context).then((location){
      if (this.mounted){
        if (location != null){
          hasLocation = true;
          currentLat = location.latitude;
          currentLon = location.longitude;
        }
        isLoading = false;
        setState(() {});
      }
    });
  }

  Widget noUsersFoundWidget() {
    return Container(
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
          Fonts().textW800("There's nobody around...", 24.0, FlatColors.darkGray, TextAlign.center),
          //new Text("No Nearby Users Found", style: Fonts.noEventsFont, textAlign: TextAlign.center),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {


    Geoflutterfire geo = Geoflutterfire();
    GeoFirePoint center = isLoading ? null : geo.point(latitude: currentLat, longitude: currentLon);
    CollectionReference userRef = Firestore.instance.collection("users");

    return Scaffold(
      appBar: WebblenAppBar().actionAppBar(
          'People Nearby',
          IconButton(
            icon: Icon(FontAwesomeIcons.search, color: FlatColors.darkGray, size: 18.0),
            onPressed: () => PageTransitionService(context: context, usersList: nearbyUsers, currentUser: currentUser).transitionToUserSearchPage(),
          ),
      ),
      body: isLoading
        ? LoadingScreen(context: context, loadingDescription: "")
          : hasLocation
          ? StreamBuilder(
              stream: geo.collection(collectionRef: userRef)
                  .within(center: center, radius: 20, field: 'location'),
              builder: (context, AsyncSnapshot<List<DocumentSnapshot>> docSnapshots) {
                if (!docSnapshots.hasData) {
                  return Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Center(child: CustomLinearProgress(progressBarColor: FlatColors.webblenRed)),
                  );
                } else {
                  docSnapshots.data.sort((docA, docB) => docB['eventHistory'].length.compareTo(docA['eventHistory'].length));
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index){
                      WebblenUser user = WebblenUser.fromMap(docSnapshots.data[index].data);
                      if (user != null && !nearbyUsers.contains(user)){
                        nearbyUsers.add(user);
                      }
                      return UserRow(
                        user: user,
                        isFriendsWithUser: currentUser.friends.contains(user.uid),
                        showUserOptions: null,
                        transitionToUserDetails: () => PageTransitionService(context: context, currentUser: currentUser, webblenUser: user).transitionToUserDetailsPage(),
                      );
                    },
                    itemCount: docSnapshots.data.length,
                  );
                }
              },
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Fonts().textW400("Unable to Access Location", 18.0, FlatColors.darkGray, TextAlign.center),
                CustomColorButton(
                  text: "Try Again",
                  textColor: Colors.white,
                  backgroundColor: FlatColors.webblenRed,
                  height: 45.0,
                  width: 200,
                  onPressed: () => loadLocation(),
                )
              ],
            ),
    );
  }
}