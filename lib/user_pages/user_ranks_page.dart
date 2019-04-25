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

class UserRanksPage extends StatefulWidget {

  final WebblenUser currentUser;
  UserRanksPage({this.currentUser});

  @override
  _UserRanksPageState createState() => _UserRanksPageState();
}

class _UserRanksPageState extends State<UserRanksPage> {

  double degreeMinMax = 0.145;
  List<WebblenUser> nearbyUsers = [];
  bool isLoading = true;
  final ScrollController scrollController = new ScrollController();


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
              Fonts().textW800("There's nobody around...", 24.0, FlatColors.darkGray, TextAlign.center),
              //new Text("No Nearby Users Found", style: Fonts.noEventsFont, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }
    return widgets;
  }

  void transitionToUserDetails(WebblenUser webblenUser){
    PageTransitionService(context: context, currentUser: widget.currentUser, webblenUser: webblenUser).transitionToUserDetailsPage();
  }

  void transitionToSearchPage(){
    PageTransitionService(context: context, usersList: nearbyUsers, currentUser: widget.currentUser).transitionToUserSearchPage();
  }


  @override
  Widget build(BuildContext context) {

    double lat = widget.currentUser.location['geopoint'].latitude;
    double lon = widget.currentUser.location['geopoint'].longitude;

    Geoflutterfire geo = Geoflutterfire();
    GeoFirePoint center = geo.point(latitude: lat, longitude: lon);
    CollectionReference userRef = Firestore.instance.collection("users");

    return Scaffold(
      appBar: WebblenAppBar().actionAppBar(
          'People Nearby',
          IconButton(
            icon: Icon(FontAwesomeIcons.search, color: FlatColors.darkGray, size: 18.0),
            onPressed: () => transitionToSearchPage(),
          ),
      ),
      body: StreamBuilder(
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
            docSnapshots.data.reversed;
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index){
                WebblenUser user = WebblenUser.fromMap(docSnapshots.data[index].data);
                if (!nearbyUsers.contains(user)){
                  nearbyUsers.add(user);
                }
                return UserRow(
                  user: user,
                  isFriendsWithUser: widget.currentUser.friends.contains(user.uid),
                  showUserOptions: null,
                  transitionToUserDetails: () => transitionToUserDetails(user),
                );
              },
              itemCount: docSnapshots.data.length,
              controller: scrollController,
            );
          }
        },
      ),
    );
  }
}