import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:webblen/widgets_common/common_button.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:webblen/services_general/service_page_transitions.dart';
import 'package:webblen/widgets_dashboard/question_tile.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:webblen/firebase_services/event_data.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'package:webblen/widgets_dashboard/dashboard_tile.dart';
import 'package:webblen/widgets_dashboard/tile_user_profile_content.dart';
import 'package:webblen/widgets_dashboard/tile_calendar_content.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:webblen/firebase_services/community_data.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:webblen/widgets_common/common_alert.dart';
import 'package:webblen/firebase_services/platform_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen/widgets_dashboard/tile_shop_content.dart';
import 'package:webblen/widgets_dashboard/tile_new_event_content.dart';
import 'package:webblen/widgets_dashboard/tile_interests_content.dart';
import 'package:webblen/widgets_dashboard/tile_my_events_content.dart';

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
  int activeUserCount = 1;
  double currentLat;
  double currentLon;
  List eventHistory;
  List<WebblenUser> nearbyUsers = [];
  bool isNewUser;
  bool didClickNotice = false;


  Map<String, double> currentLocation;
  StreamSubscription<Map<String, double>> _locationSubscription;
  Location userLocation = new Location();
  bool retrievedLocation = false;
  bool locationPermission = false;

  List<double> activityChart = [];
  final List<List<double>> charts = [
    [0.0, 0.3, 0.7, 0.6, 0.55, 0.8, 1.2, 1.3, 1.35, 0.9, 0.5, 1.7, 1.8, 1.7, 0.2, 0.8, 1.9, 2.0, 2.2, 1.9, 2.2, 2.1, 2.0, 2.3, 2.4, 2.45, 2.6, 3.6, 2.6, 2.7, 4.9, 2.8, 2.4],
    [0.0, 0.3, 0.7, 0.6, 0.55, 0.8, 1.2, 1.3, 1.35, 0.9, 0.5, 1.7, 1.8, 1.7, 0.2, 0.8, 1.9, 2.0, 2.2, 1.9, 2.2, 2.1, 2.0, 2.3, 2.4, 2.45, 2.6, 3.6, 2.6, 2.7, 4.9, 2.8, 2.4, 5.0, 3.3, 4.7, 0.6, 0.55, 2.7, 4.9, 2.8, 2.4, 5.0, 3.3, 4.7, 0.6, 0.55, 1.7, 2.7, 4.9, 2.8, 2.4, 5.0, 3.3, 4.7, 0.6, 0.55, 1.9, 2.2, 2.1, 2.0, 2.3, 2.4, 2.45, 2.6, 3.6, 2.6, 2.7, 2.9, 2.8, 3.4,],
    [0.0, 0.3, 0.7, 0.6, 0.55, 0.8, 1.2, 1.3, 1.35, 0.9, 1.5, 1.7, 1.8, 1.7, 1.2, 0.8, 1.9, 2.0, 2.2, 1.9, 2.2, 2.1, 2.0, 2.3, 2.4, 2.45, 2.6, 3.6, 2.6, 2.7, 2.9, 2.8, 3.4, 0.0, 0.3, 0.7, 0.6, 0.55, 0.8, 1.2, 1.3, 1.35, 2.7, 4.9, 2.8, 2.4, 5.0, 3.3, 4.7, 0.6, 0.55, 1.9, 2.0, 2.2, 1.9, 2.2, 2.1, 2.0, 2.3, 2.4, 2.45, 2.6, 3.6, 2.6, 2.7, 2.9, 2.8, 3.4, 0.0, 0.3, 0.7, 0.6, 0.55, 0.8, 1.2, 1.3, 1.35, 0.9, 1.5, 1.7, 1.8, 1.7, 1.2, 0.8, 1.9, 2.0, 2.2, 1.9, 2.2, 2.1, 2.0, 2.3, 2.4, 2.45, 2.6, 3.6, 2.6, 2.7, 2.9, 2.8, 3.4]
  ];

  static final List<String> chartDropdownItems = [ 'Last 7 days', 'Last month', 'Last year' ];
  String actualDropdown = chartDropdownItems[0];
  int actualChart = 0;

  // Platform messages are asynchronous, so we initialize in an async method.
  initLocationState() async {
    Map<String, double> location;
    String error = "";
    try {
      locationPermission = await userLocation.hasPermission();
      location = await userLocation.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Location Permission Denied';
        invalidAlert(context, error);
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'Permission denied - Please Enable Location Services From App Settings';
        invalidAlert(context, error);
      }
      location = null;
    }
    if (this.mounted){
      setState(() {
        currentLocation = location;
      });
    }
  }

  configFirebaseMessaging(){
    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message){
        print("onLaunch");
      },
      onMessage: (Map<String, dynamic> message){
        print("onMessage");
      },
      onResume: (Map<String, dynamic> message){
        print("onResum");
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

  Future<Null> initialize() async {
    setState(() {
      loadingComplete = false;
    });
    initLocationState();
    BaseAuth().currentUser().then((val) {
      setState(() {
        uid = val == null ? null : val;
        //print(uid);
        UserDataService().checkIfUserExistsByUID(uid).then((exists){
          if (!exists){
            Navigator.of(context).pushNamedAndRemoveUntil('/setup', (Route<dynamic> route) => false);
          } else {
            CommunityDataService().activeUserCount().then((userCount){
              //configFirebaseMessaging();
              setState(() {
                activeUserCount = userCount;
              });
            });
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
//    UserDataService().addUserDataField("userLon", userLon);
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    // ** APP BAR
    final appBar = AppBar (
      elevation: 1.0,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      title: Text('Home', style: Fonts.dashboardTitleStyle),
      leading: IconButton(icon: Icon(FontAwesomeIcons.mapMarkerAlt, color: FlatColors.londonSquare),
        onPressed: () => didPressMarkerIcon(),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings, size: 24.0, color: FlatColors.londonSquare),
          onPressed: () => didPressSettings(),
        ),
      ],
    );

    return Scaffold (
        appBar: appBar,
        body: userTags == null ? new LoadingScreen(context: context)
            : Stack(
          children: <Widget>[
            StaggeredGridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              children: <Widget>[
                DashboardTile(
                  child: TileUserProfileContent(
                      username: username,
                      userImageLoaded: loadingComplete,
                      userImagePath: userImagePath
                  ),
                  onTap: () => didPressAccountTile(),
                ),
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
                questionForUser != null ? QuestionTile(
                  child: questionContent(),
                ) :
                _buildTile(
                  Padding (
                    padding: const EdgeInsets.all(24.0),
                    child: Column (
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row (
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget> [
                            Column (
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget> [
                                Text('Community Activity', style: TextStyle(color: FlatColors.londonSquare)),
                                nearbyUsers == null ?  new Text("Loading")//CustomCircleProgress(60.0, 60.0, 30.0, 30.0, FlatColors.londonSquare)
                                    : Text('${nearbyUsers.length} Active Users', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16.0)),
                              ],
                            ),
                            DropdownButton(
                                isDense: true,
                                value: actualDropdown,
                                onChanged: (String value) => setState(() {
                                  actualDropdown = value;
                                  actualChart = chartDropdownItems.indexOf(value); // Refresh the chart
                                }),
                                items: chartDropdownItems.map((String title) {
                                  return DropdownMenuItem(
                                    value: title,
                                    child: Text(title, style: TextStyle(color: FlatColors.blackPearl, fontWeight: FontWeight.w400, fontSize: 14.0)),
                                  );
                                }).toList()
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 4.0)),
                        Sparkline(
                          data: charts[actualChart],
                          lineWidth: 5.0,
                          lineColor: FlatColors.lightCarribeanGreen,
                        ),
                      ],
                    ),
                  ),
                  onTap: () => didPressCommunityTile(),
                ),
                DashboardTile(
                  child: TileMyEventsContent(eventCount: eventCount),
                  onTap: () => didPressMyEventsTile(),
                )
              ],
              staggeredTiles: [
                StaggeredTile.extent(2, 120.0),
                StaggeredTile.extent(1, 180.0),
                StaggeredTile.extent(1, 180.0),
                StaggeredTile.extent(1, 180.0),
                StaggeredTile.extent(1, 180.0),
                questionForUser == null ? StaggeredTile.extent(2, 220.0) : StaggeredTile.extent(2, 295.0),
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

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(16.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: onTap != null ? () => onTap() : () { print('Not set yet'); },
          child: child,
        )
    );
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
                        : Text("What's Your Biggest Reason to Go to Events?", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16.0)),
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
                  ? CustomColorButton("Submit", 35.0, (){didPressSubmitAnswer();}, FlatColors.clouds, FlatColors.blackPearl)
                  : CustomColorButton("Submit", 35.0, null, FlatColors.clouds, FlatColors.londonSquare)

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
        builder: (BuildContext context) { return AlertMessage(message); });
  }

  Future<bool> successAlert(BuildContext context, String messageA, String messageB) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) { return SuccessDialog(messageA: messageA, messageB: messageB); });
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
      PageTransitionService(context: context, userImage: userImage).transitionToProfilePage();
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
      PageTransitionService(context: context, users: nearbyUsers).transitionToUserRanksPage();
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