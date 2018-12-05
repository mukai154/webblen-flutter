import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:webblen/widgets_common/common_button.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:flutter/material.dart';
import 'package:webblen/services_general/service_page_transitions.dart';
import 'package:webblen/widgets_dashboard/question_tile.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:webblen/firebase_services/event_data.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'package:webblen/widgets_dashboard/dashboard_tile.dart';
import 'package:webblen/widgets_dashboard/tile_user_profile_content.dart';
import 'package:webblen/widgets_common/common_notification.dart';
import 'package:webblen/widgets_dashboard/tile_calendar_content.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:webblen/widgets_dashboard/tile_nearby_users_content.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:webblen/widgets_common/common_alert.dart';
import 'package:webblen/firebase_services/platform_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen/widgets_dashboard/tile_shop_content.dart';
import 'package:webblen/widgets_dashboard/tile_new_event_content.dart';
import 'package:webblen/widgets_dashboard/tile_interests_content.dart';
import 'package:webblen/widgets_dashboard/tile_my_events_content.dart';
import 'package:webblen/widgets_dashboard/build_top_users.dart';
import 'package:webblen/services_general/services_location.dart';
import 'package:webblen/widgets_user_details/user_details_profile_pic.dart';

class DashboardPage extends StatefulWidget {

  final String loggedInUID;
  DashboardPage({this.loggedInUID});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  String notifToken;

  bool questionActive = false;
  bool eventOccurringNearby = false;
  String questionForUser;
  List questionOptions;
  String questionDataVal;
  String answerToUpload;
  bool uploadingQuestionAnswer = false;
  bool answerUploaded;
  bool answerSelected = false;
  bool updateRequired = false;
  String uid;
  String username;
  String userImagePath;
  NetworkImage userImage;
  bool loadingComplete = false;
  List userTags;
  int eventCount;
  int activeUserCount;
  double currentLat;
  double currentLon;
  List eventHistory;
  List<WebblenUser> nearbyUsers = [];
  bool isNewUser;
  bool didClickNotice = false;

  Map<String, double> currentLocation;
  Location userLocation = new Location();
  bool retrievedLocation = false;
  bool locationPermission = false;

  //Config Firebase Messaging/Notif Actions
  configFirebaseMessaging(){
    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message){
        print(message);
        print("onLaunch");
        setState(() {
          eventOccurringNearby = true;
        });
      },
      onMessage: (Map<String, dynamic> message){
        print(message);
        setState(() {
          eventOccurringNearby = true;
        });
      },
      onResume: (Map<String, dynamic> message){
        print(message);
        print("onResume");
        setState(() {
          eventOccurringNearby = true;
        });
      },
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: false,
            alert: true,
            badge: true
        )
    );
    firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings iosSetting){
      //print('ios settings registered');
    });
    firebaseMessaging.getToken().then((token){
      updateFirebaseMessageToken(token);
    });
  }

  updateFirebaseMessageToken(String token){
    UserDataService().setUserCloudMessageToken(uid, token);
    setState(() {
      notifToken = token;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initializeLocationServices() async {
    LocationService().getCurrentLocation(context).then((location){
      if (this.mounted){
        setState(() {
          currentLocation = location;
        });
      }
    });
  }

  int returnTopUsersNearbyIndex(){
    int nearbyIndex;
    if (nearbyUsers.length > 9){
      nearbyIndex = 9;
    } else {
      nearbyIndex = nearbyUsers.length - 1;
    }
    return nearbyIndex;
  }

  buildNearbyUsers(){
    List<Widget> nearbyUserWidgetList;
    if (nearbyUsers.isNotEmpty){
      nearbyUserWidgetList = BuildTopUsers(top10NearbyUsers: nearbyUsers.sublist(0, returnTopUsersNearbyIndex()), context: context, currentUID: uid).buildTopUsers();
    }
    return nearbyUserWidgetList;
  }

  Future<Null> initialize() async {
    setState(() {
      loadingComplete = false;
    });
    initializeLocationServices();
    BaseAuth().currentUser().then((val) {
      setState(() {
        uid = val == null ? null : val;
        //print(uid);
        UserDataService().checkIfUserExistsByUID(uid).then((exists){
          if (!exists){
            Navigator.of(context).pushNamedAndRemoveUntil('/setup', (Route<dynamic> route) => false);
          } else {
            configFirebaseMessaging();
            UserDataService().currentUsername(uid).then((currentUsername){
              setState(() {
                username = currentUsername;
                EventPostService().eventCountByUser(username).then((count){
                  setState(() {
                    eventCount = count;
                  });
                });
              });
            });
            UserDataService().checkIfNewUser(uid).then((isNew){
              setState(() {
                isNewUser = isNew;
              });
            });
            UserDataService().currentUserTags(uid).then((userTagsList){
              setState(() {
                userTags = userTagsList;
              });
            });
            UserDataService().eventHistory(uid).then((history){
              setState(() {
                eventHistory = history;
                EventPostService().receiveEventPoints(eventHistory);
              });
            });
            UserDataService().retrieveMultipleChoiceQuestion(uid).then((questionData){
              if (questionData != null){
                if (questionData["isActive"] == true){
                  setState(() {
                    questionForUser = questionData["question"];
                    questionOptions = questionData["options"];
                    questionDataVal = questionData["dataVal"];
                  });
                }
              }
            });
            UserDataService().userImagePath(uid).then((imagePath){
              setState(() {
                userImagePath = imagePath;
                if (userImagePath == null || userImagePath.isEmpty){
                  Navigator.of(context).pushNamedAndRemoveUntil('/setup', (Route<dynamic> route) => false);
                } else {
                  setState(() {
                    loadingComplete = true;
                  });
                }
                userLocation.getLocation().then((result){
                  setState(() {
                    currentLat = result["latitude"];
                    currentLon = result["longitude"];
                  });
                  if (!retrievedLocation){
                    UserDataService().updateUserCheckIn(uid, currentLat, currentLon);
                    UserDataService().findNearbyUsers(currentLat, currentLon).then((users){
                      setState(() {
                        nearbyUsers = users;
                        activeUserCount = nearbyUsers.length;
                      });
                    });
                    setState(() {
                      retrievedLocation = true;
                    });
                  }
                });
                PlatformDataService().isUpdateAvailable().then((updateIsAvailable){
                  if (updateIsAvailable){
                    setState(() {
                      updateRequired = updateIsAvailable;
                    });
                  }
                });
              });
            });
          }
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initialize();
    //UserDataService().addUserDataField("notificationCount", 0);
  }

  @override
  Widget build(BuildContext context) {
    // ** APP BAR
    final appBar = AppBar (
      elevation: 0.5,
      brightness: Brightness.light,
      backgroundColor: Color(0xFFF9F9F9),
      title: Text('Home', style: Fonts.dashboardTitleStyle),
      leading:
      eventOccurringNearby
          ? IconButton(
              icon: Icon(FontAwesomeIcons.bolt, color: FlatColors.webblenRed),
              onPressed: () => didPressMarkerIcon())
          : IconButton(
          icon: Icon(FontAwesomeIcons.mapMarkerAlt, color: FlatColors.londonSquare),
          onPressed: () => didPressMarkerIcon()),
      actions: <Widget>[
//        IconButton(
//          icon: Icon(Icons.settings, size: 24.0, color: FlatColors.londonSquare),
//          onPressed: () => didPressSettings(),
//        ),
        StreamBuilder(
            stream: Firestore.instance.collection("users").document(uid).snapshots(),
            builder: (context, userSnapshot) {
              if (!userSnapshot.hasData) return CustomCircleProgress(20.0, 20.0, 20.0, 20.0, FlatColors.londonSquare);
              var userData = userSnapshot.data;
              int notificationCount = userData["notificationCount"];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: InkWell(
                  onTap: () => didPressAccountTile(),
                  child: Hero(
                    tag: 'user-profile-pic-dashboard',
                    child: notificationCount == 0 ? userImagePath != null ? UserDetailsProfilePic(userPicUrl:  userData["profile_pic"], size: 40.0) : CustomCircleProgress(20.0, 20.0, 20.0, 20.0, FlatColors.londonSquare)
                          : NotificationBubble(notificationCount.toString()),
                  ),
                )
              );
            }
        ),
      ],
    );

    return Scaffold (
        appBar: appBar,
        body: userTags == null ? LoadingScreen(context: context)
            : Stack(
          children: <Widget>[
            StaggeredGridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              children: <Widget>[
                DashboardTile(
                  child: questionForUser != null ? QuestionTile(
                    child: questionContent(),
                  ) : TileNearbyUsersContent(activeUserCount: activeUserCount, top10NearbyUsers: buildNearbyUsers()),
                  onTap: () => didPressCommunityTile(),
                ),
//                DashboardTile(
//                  child: null,
//                  onTap: () => didPressCalendarTile(),
//                ),
                DashboardTile(
                  child: TileCalendarContent(),
                  onTap: () => didPressCalendarTile(),
                ),
                DashboardTile(
                  child: TileShopContent(),
                  onTap: () => didPressShopTile(),
                ),
                DashboardTile(
                  child: TileNewEventContent(),
                  onTap: () => didPressNewEventTile(),
                ),
                DashboardTile(
                  child: TileInterestsContent(),
                  onTap: () => didPressInterestsTile(),
                ),
                DashboardTile(
                  child: TileMyEventsContent(eventCount: eventCount),
                  onTap: () => didPressMyEventsTile(),
                )
              ],
              staggeredTiles: [
                questionForUser == null ? StaggeredTile.extent(2, 180.0) : StaggeredTile.extent(2, 270.0),
                //StaggeredTile.extent(2, 120.0),
                StaggeredTile.extent(1, 180.0),
                StaggeredTile.extent(1, 180.0),
                StaggeredTile.extent(1, 180.0),
                StaggeredTile.extent(1, 180.0),
                StaggeredTile.extent(2, 120.0),
              ],
            ),
            newUserNotice(),
          ],
        )
    );
  }

  Widget newUserNotice() {
    if (isNewUser && !didClickNotice) {
      return Positioned(
        //height: 45.0,
        width: 300.0,
        top: 16.0,
        right: 8.0,
        child: GestureDetector(
          onTap: () {setState(() { didClickNotice = true; });},
          child: Container(
            decoration: BoxDecoration(
              color: FlatColors.redOrange,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("New? Be Sure to Checkout Our Guide!",
                    style: Fonts.noticeWhiteTextStyle,),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
                  child: Icon(FontAwesomeIcons.arrowUp, size: 16.0,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }


  Widget questionContent(){
    return Padding (
      padding: const EdgeInsets.all(24.0),
      child: Column (
        children: <Widget>[
          Row (
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              Expanded(
                child: Column (
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                    uploadingQuestionAnswer ? uploadingIndicator() : Text("Question", style: TextStyle(color: FlatColors.londonSquare)),
                    nearbyUsers == null
                        ? new Text("Loading")//CustomCircleProgress(60.0, 60.0, 30.0, 30.0, FlatColors.londonSquare)
                        : Text(questionForUser, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16.0)),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
            ],
          ),
          buildQuestionOptions(),
          Padding(
              padding: EdgeInsets.all(4.0),
              child: answerSelected
                  ? CustomColorButton("Submit", 35.0, MediaQuery.of(context).size.width * 0.8, (){didPressSubmitAnswer();}, FlatColors.clouds, FlatColors.blackPearl)
                  : CustomColorButton("Submit", 35.0, MediaQuery.of(context).size.width * 0.8, null, FlatColors.clouds, FlatColors.londonSquare)

          )
        ],
      ),
    );
  }

  Widget buildQuestionOptions(){
    return new Container(
      height: 90.0,
      child: questionOptions != null
          ? new GridView.count(
        crossAxisCount: 2,
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        childAspectRatio: 20.0/55.0,
        children: new List<Widget>.generate(questionOptions.length, (index) {
          return new GridTile(
              child: new InkResponse(
                onTap: () => answerClicked(index),
                child: new Card(
                  elevation: 1.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  color: answerToUpload == questionOptions[index]
                      ? FlatColors.electronBlue
                      : FlatColors.clouds,
                  child: new Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('${questionOptions[index]}', style: answerToUpload == questionOptions[index] ? Fonts.dashboardQuestionTextStyleWhite : Fonts.dashboardQuestionTextStyleGray, textAlign: TextAlign.center,),
                    ),
                  ),
                ),
              )
          );
        }),
      )
          : Container(child: CustomCircleProgress(30.0, 30.0, 30.0, 30.0, Colors.white)),
    );
  }

  Widget uploadingIndicator() {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 2.0,
            child: LinearProgressIndicator(backgroundColor: Colors.transparent),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Future<Null> answerClicked(int index) async {
    if (!uploadingQuestionAnswer) {
      String answer = questionOptions[index];
      if (answerToUpload != answer) {
        setState(() {
          answerSelected = true;
          answerToUpload = answer;
        });
      }
    }
  }

  Future<bool> invalidAlert(BuildContext context, String message) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) { return FailureDialog(header: "There was an Issue", body: message); });
  }

  Future<bool> successAlert(BuildContext context, String messageA, String messageB) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) { return SuccessDialog(header: messageA, body: messageB); });
  }

  Future<bool> updateAlert(BuildContext context) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) { return UpdateAvailableDialog(); });
  }

  bool updateAlertIsEnabled(){
    bool showAlert = false;
    if (loadingComplete && updateRequired){
      showAlert = true;
    }
    return showAlert;
  }

  void didPressMarkerIcon(){
    if (loadingComplete && username != null && !updateAlertIsEnabled()){
      if (eventOccurringNearby){
        setState(() {
          eventOccurringNearby = false;
        });
      }
      PageTransitionService(context: context).transitionToCheckInPage();
    } else if (updateAlertIsEnabled()){
      updateAlert(context);
    }
  }

  void didPressSettings(){
    if (uid != null && isNewUser){
      UserDataService().updateNewUser(uid).then((isComplete){
        PageTransitionService(context: context).transitionToSettingsPage();
      });
    } else {
      PageTransitionService(context: context).transitionToSettingsPage();
    }
  }

  void didPressAccountTile(){
    if (loadingComplete && username != null && !updateAlertIsEnabled()){
      PageTransitionService(context: context, userImage: userImage, username: username).transitionToProfilePage();
    } else if (updateAlertIsEnabled()){
      updateAlert(context);
    }
  }

  void didPressCalendarTile(){
    if (loadingComplete && username != null && !updateAlertIsEnabled()){
      PageTransitionService(context: context, userTags: userTags).transitionToEventListPage();
    } else if (updateAlertIsEnabled()){
      updateAlert(context);
    }
  }

  void didPressShopTile(){
    if (loadingComplete && username != null && !updateAlertIsEnabled()){
      PageTransitionService(context: context, uid: uid, userLat: currentLat, userLon: currentLon).transitionToShopPage();
    } else if (updateAlertIsEnabled()){
      updateAlert(context);
    }
  }

  void didPressNewEventTile(){
    if (loadingComplete && username != null && !updateAlertIsEnabled()){
      PageTransitionService(context: context).transitionToNewEventPage();
    } else if (updateAlertIsEnabled()){
      updateAlert(context);
    }
  }

  void didPressInterestsTile(){
    if (loadingComplete && username != null && !updateAlertIsEnabled()){
      PageTransitionService(context: context, userTags: userTags).transitionToInterestsPage();
    } else if (updateAlertIsEnabled()){
      updateAlert(context);
    }
  }

  void didPressCommunityTile(){
    if (loadingComplete && username != null && !updateAlertIsEnabled()){
      PageTransitionService(context: context, nearbyUsers: nearbyUsers, uid: uid).transitionToUserRanksPage();
    } else if (updateAlertIsEnabled()){
      updateAlert(context);
    }
  }

  void didPressMyEventsTile(){
    if (loadingComplete && username != null && !updateAlertIsEnabled()){
      PageTransitionService(context: context).transitionToMyEventsPage();
    } else if (updateAlertIsEnabled()){
      updateAlert(context);
    }
  }

  void didPressSubmitAnswer(){
    if (!uploadingQuestionAnswer){
      setState(() {
        uploadingQuestionAnswer = true;
      });
      UserDataService().submitAnswerData(uid, questionDataVal, answerToUpload).then((e){
        setState(() {
          uploadingQuestionAnswer = false;
          questionForUser = null;
          successAlert(context, "Thanks for Your Thoughts!", "Your Account's Suggestions have been Improved!");
        });
      });
    }
  }

}