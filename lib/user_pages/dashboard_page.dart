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
import 'package:webblen/widgets_common/common_notification.dart';
import 'package:webblen/widgets_dashboard/tile_calendar_content.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:webblen/widgets_dashboard/tile_nearby_users_content.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:webblen/widgets_common/common_alert.dart';
import 'package:webblen/widgets_user/user_row.dart';
import 'package:webblen/firebase_services/platform_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen/widgets_dashboard/tile_shop_content.dart';
import 'package:webblen/widgets_dashboard/tile_new_event_content.dart';
import 'package:webblen/widgets_dashboard/tile_interests_content.dart';
import 'package:webblen/widgets_dashboard/tile_community_builder_content.dart';
import 'package:webblen/widgets_dashboard/build_top_users.dart';
import 'package:webblen/services_general/services_location.dart';
import 'package:webblen/widgets_user/user_details_profile_pic.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:webblen/widgets_dashboard/tile_community_news_content.dart';
import 'package:webblen/firebase_services/community_data.dart';
import 'package:webblen/models/community_news.dart';
import 'package:webblen/widgets_dashboard/build_news_post_widgets.dart';
import 'package:webblen/widgets_dashboard/community_tile.dart';
import 'package:webblen/firebase_services/firebase_notification_services.dart';
import 'package:webblen/services_general/services_show_alert.dart';
import 'package:ads/ads.dart';

class DashboardPage extends StatefulWidget {

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  RefreshController refreshController = RefreshController();

  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  String notifToken;


  WebblenUser currentUser;
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
  NetworkImage userImage;
  bool loadingComplete = false;
  bool userFound = false;
  bool isNewUser = false;
  int activeUserCount;
  int eventCount;
  double currentLat;
  double currentLon;
  List<WebblenUser> nearbyUsers;
  List<CommunityNewsPost> communityNewsPosts;
  bool didClickNotice = false;

  Map<String, double> currentLocation;
  Location userLocation = new Location();
  bool retrievedLocation = false;
  bool locationDenied = false;

  int returnTopUsersNearbyIndex(){
    int nearbyIndex;
    if (nearbyUsers.length > 9){
      nearbyIndex = 9;
    } else {
      nearbyIndex = nearbyUsers.length - 1;
    }
    return nearbyIndex;
  } 
  // Platform messages are asynchronous, so we initialize in an async method.
  initializeLocationServices() async {
    LocationService().getCurrentLocation(context).then((location){
      if (this.mounted){
        if (location == null){
          setState(() {
            locationDenied = true;
          });
        } else {
          setState(() {
            locationDenied = false;
            currentLocation = location;
          });
        }
      }
    });
  }

  Future<Null> initialize() async {
    setState(() {
      loadingComplete = false;
    });
    initializeLocationServices();
    BaseAuth().currentUser().then((val) {
        uid = val;
        UserDataService().checkIfUserExistsByUID(uid).then((exists){
          if (!exists){
            Navigator.of(context).pushNamedAndRemoveUntil('/setup', (Route<dynamic> route) => false);
          } else {
            userFound = true;
            UserDataService().findUserByID(uid).then((user){
                currentUser = user;
                if (currentUser.profile_pic == null || currentUser.profile_pic.isEmpty){
                  Navigator.of(context).pushNamedAndRemoveUntil('/setup', (Route<dynamic> route) => false);
                } else {
                  FirebaseNotificationsService().updateFirebaseMessageToken(uid);
                  FirebaseNotificationsService().configFirebaseMessaging(context);
                  UserDataService().checkIfNewUser(uid).then((isNew){
                    isNewUser = isNew;
                  });
                  UserDataService().retrieveMultipleChoiceQuestion(uid).then((questionData){
                    if (questionData != null){
                      if (questionData["isActive"] == true){
                        questionForUser = questionData["question"];
                        questionOptions = questionData["options"];
                        questionDataVal = questionData["dataVal"];
                      }
                    }
                  });
                  EventPostService().eventCountByUser(currentUser.username).then((count){
                    eventCount = count;
                  });
                  EventPostService().receiveEventPoints(currentUser.eventHistory);
                  if (!locationDenied){
                    userLocation.getLocation().then((result){
                      currentLat = result["latitude"];
                      currentLon = result["longitude"];
                      UserDataService().updateUserCheckIn(uid, currentLat, currentLon);
                        UserDataService().findNearbyUsers(currentLat, currentLon).then((users){
                          CommunityDataService().getCommunityNews(currentLat, currentLon).then((communityNews){
                              nearbyUsers = users;
                              print(users.length);
                              activeUserCount = nearbyUsers.length;
                              communityNewsPosts = communityNews;
                              retrievedLocation = true;
                              loadingComplete = true;
                              setState(() {});
                          });
                        });
                    });
                  }
                  PlatformDataService().isUpdateAvailable().then((updateIsAvailable){
                    if (updateIsAvailable){
                      setState(() {
                        updateRequired = updateIsAvailable;
                      });
                    }
                  });
                }
            });
          }
        });
    });
  }

  Widget buildRefreshHeader(context,mode){
    return CustomLinearProgress(Colors.black26, Colors.transparent);
  }

  void refreshData(bool up){
    if (up) {
      retrievedLocation = false;
      initialize();
      Future.delayed(const Duration(milliseconds: 2009))
          .then((val) {
        refreshController.sendBack(true, RefreshStatus.completed);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Ads.init('ca-app-pub-2136415475966451', testing: true);
    initialize();
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
        loadingComplete
            ? StreamBuilder(
              stream: Firestore.instance.collection("users").document(uid).snapshots(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData || !userFound) return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: CustomCircleProgress(10.0, 10.0, 10.0, 10.0, FlatColors.londonSquare),
                );
                var userData = userSnapshot.data;
                int notifCount = userData["notificationCount"];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: InkWell(
                    onTap: () => didPressAccountTile(),
                    child: Hero(
                      tag: 'user-profile-pic-dashboard',
                      child: notifCount == 0 ? currentUser != null && currentUser.profile_pic != null
                          ? UserDetailsProfilePic(userPicUrl:  userData["profile_pic"], size: 40.0)
                          : CustomCircleProgress(20.0, 20.0, 10.0, 10.0, FlatColors.londonSquare)
                            : NotificationBubble(notifCount.toString()),
                    ),
                  )
                );
              })
            : Container(),
      ],
    );

    return Scaffold (
        appBar: appBar,
        body: currentUser == null ? LoadingScreen(context: context)
            : Stack(
          children: <Widget>[
            SmartRefresher(
              enablePullDown: true,
              controller: refreshController,
              onRefresh: refreshData,
              headerBuilder: buildRefreshHeader,
              child: StaggeredGridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 0.0,
                mainAxisSpacing: 8.0,
                padding: EdgeInsets.symmetric(vertical: 8.0),
                children: <Widget>[
                  CommunityTile(
                    child: locationDenied
                        ? Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text("Please Enable Location Permissions To Access All Features", textAlign: TextAlign.center,)
                          )
                        : communityNewsPosts != null ? buildNews() : Container(),
                    onTap: null,
                  ),
                  DashboardTile(
                    child: locationDenied
                        ? Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text("Please Enable Location Permissions To Access All Features", textAlign: TextAlign.center,)
                          )
                        : questionForUser != null ? QuestionTile(child: questionContent())
                        : nearbyUsers != null ? buildNearbyUsers() : Container(),
                    onTap: () => didPressCommunityTile(),
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
                  currentUser.isCommunityBuilder
                    ? DashboardTile(
                      child: TileCommunityBuilderContent(),
                      onTap: () => didPressCommunityBuilderTile(),
                    )
                    : Container()
                  
                ],
                staggeredTiles: [
                  StaggeredTile.extent(2, MediaQuery.of(context).size.height * 0.415),
                  questionForUser == null ? StaggeredTile.extent(2, 200.0) : StaggeredTile.extent(2, 270.0),
                  StaggeredTile.extent(1, 180.0),
                  StaggeredTile.extent(1, 180.0),
                  StaggeredTile.extent(1, 180.0),
                  StaggeredTile.extent(1, 180.0),
                  currentUser.isCommunityBuilder ? StaggeredTile.extent(2, 120.0) : StaggeredTile.extent(2, 1.0),
                ],
              ),
            ),
            newUserNotice(),
          ],
        )
    );
  }

  Widget buildNearbyUsers(){
    Widget nearbyUsersWidget;
    if (nearbyUsers.length > 1){
      List top10NearbyUsers = nearbyUsers.sublist(0, returnTopUsersNearbyIndex());
      List<Widget> userWidgets = BuildTopUsers(context: context, top10NearbyUsers: top10NearbyUsers, currentUID: uid).buildTopUsers();
      nearbyUsersWidget = TileNearbyUsersContent(activeUserCount: activeUserCount, top10NearbyUsers: userWidgets);
    } else {
      nearbyUsersWidget = TileNoNearbyUsersContent();
    }
    return nearbyUsersWidget;
  }

  Widget buildNews(){
    List<Widget> newsWidgets = BuildNewsPostWidgets(context: context, communityNewsPosts: communityNewsPosts, currentUID: uid, userTags: currentUser.tags).buildNewsWidgets();
    return TileCommunityNewsContent(newsPosts: newsWidgets);
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
                    nearbyUsers.isEmpty
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
                  ? CustomColorButton(
                        text: "Submit",
                        textColor: FlatColors.blackPearl,
                        backgroundColor: Colors.white,
                        height: 45.0,
                        width: 200.0,
                        onPressed: () => didPressSubmitAnswer(),
                      )
                  : CustomColorButton(
                        text: "Submit",
                        textColor: FlatColors.blueGray,
                        backgroundColor: FlatColors.clouds,
                        height: 45.0,
                        width: 200.0,
                        onPressed: null,
                      ),
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

  bool updateAlertIsEnabled(){
    bool showAlert = false;
    if (loadingComplete && updateRequired){
      showAlert = true;
    }
    return showAlert;
  }

  void didPressMarkerIcon(){
    if (loadingComplete && currentUser.username != null && !updateAlertIsEnabled() && !locationDenied){
      if (eventOccurringNearby){
        setState(() {
          eventOccurringNearby = false;
        });
      }
      PageTransitionService(context: context).transitionToCheckInPage();
    } else if (updateAlertIsEnabled()){
      ShowAlertDialogService().showUpdateDialog(context);
    } else if (locationDenied){
      ShowAlertDialogService().showFailureDialog(context, "Cannot Access Location", "Please Enable Location Permissions to Access All Features");
    }
  }

  void didPressAccountTile(){
    if (loadingComplete && currentUser != null && !updateAlertIsEnabled() && !locationDenied){
      PageTransitionService(context: context, userImage: userImage, username: currentUser.username ).transitionToProfilePage();
    } else if (updateAlertIsEnabled()){
       ShowAlertDialogService().showUpdateDialog(context);
    } else if (locationDenied){
      ShowAlertDialogService().showFailureDialog(context, "Cannot Access Location", "Please Enable Location Permissions to Access All Features");
    }
  }

  void didPressCalendarTile(){
    if (loadingComplete && currentUser != null && !updateAlertIsEnabled() && !locationDenied){
      PageTransitionService(context: context, userTags: currentUser.tags).transitionToEventListPage();
    } else if (updateAlertIsEnabled()){
      ShowAlertDialogService().showUpdateDialog(context);
    } else if (locationDenied){
      ShowAlertDialogService().showFailureDialog(context, "Cannot Access Location", "Please Enable Location Permissions to Access All Features");
    }
  }

  void didPressShopTile(){
    if (loadingComplete && currentUser != null && !updateAlertIsEnabled() && !locationDenied){
      PageTransitionService(context: context, uid: uid, userLat: currentLat, userLon: currentLon).transitionToShopPage();
    } else if (updateAlertIsEnabled()){
      ShowAlertDialogService().showUpdateDialog(context);
    } else if (locationDenied){
      ShowAlertDialogService().showFailureDialog(context, "Cannot Access Location", "Please Enable Location Permissions to Access All Features");
    }
  }

  void didPressNewEventTile(){
    if (loadingComplete && currentUser != null && !updateAlertIsEnabled() && !locationDenied){
      PageTransitionService(context: context).transitionToNewEventPage();
    } else if (updateAlertIsEnabled()){
      ShowAlertDialogService().showUpdateDialog(context);
    } else if (locationDenied){
      ShowAlertDialogService().showFailureDialog(context, "Cannot Access Location", "Please Enable Location Permissions to Access All Features");
    }
  }

  void didPressInterestsTile(){
    if (loadingComplete && currentUser != null && !updateAlertIsEnabled()){
      PageTransitionService(context: context, userTags: currentUser.tags).transitionToInterestsPage();
    } else if (updateAlertIsEnabled()){
       ShowAlertDialogService().showUpdateDialog(context);
    }
  }

  void didPressCommunityTile(){
    if (loadingComplete && currentUser != null && !updateAlertIsEnabled()){
      PageTransitionService(context: context, profilePicUrl: currentUser.profile_pic, username: currentUser.username).transitionToUserRanksPage();
    } else if (updateAlertIsEnabled()){
       ShowAlertDialogService().showUpdateDialog(context);
    }
  }

  void didPressCommunityBuilderTile(){
    if (loadingComplete && currentUser != null && !updateAlertIsEnabled() && !locationDenied){
      PageTransitionService(context: context).transitionToMyEventsPage();
    } else if (updateAlertIsEnabled()){
      ShowAlertDialogService().showUpdateDialog(context);
    } else if (locationDenied){
      ShowAlertDialogService().showFailureDialog(context, "Cannot Access Location", "Please Enable Location Permissions to Access All Features");
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
        });
        ShowAlertDialogService().showSuccessDialog(context, "Thanks for Your Thoughts!", "Your Account's Suggestions have been Improved!");
      });
    }
  }

}