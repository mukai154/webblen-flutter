import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:webblen/widgets_common/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:webblen/services_general/service_page_transitions.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:webblen/firebase_services/event_data.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'package:webblen/widgets_dashboard/dashboard_tile.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:webblen/widgets_dashboard/tile_nearby_users_content.dart';
import 'package:webblen/firebase_services/platform_data.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:webblen/services_general/services_location.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:webblen/models/community_news.dart';
import 'package:webblen/firebase_services/firebase_notification_services.dart';
import 'package:webblen/services_general/services_show_alert.dart';
import 'package:webblen/widgets_dashboard/user_drawer_menu.dart';
import 'package:webblen/widgets_data_streams/stream_user_notifications.dart';
import 'package:webblen/widgets_data_streams/stream_user_account.dart';
//import 'package:webblen/utils/create_geofence.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/widgets_dashboard/tile_free_webblen_content.dart';
import 'package:webblen/widgets_dashboard/check_in_tile.dart';
import 'package:webblen/widgets_dashboard/waitlist_tile.dart';
import 'package:webblen/widgets_dashboard/widget_new_user_alert.dart';
import 'package:webblen/utils/admob.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/widgets_dashboard/tile_community_content.dart';
import 'package:webblen/widgets_dashboard/tile_discover_content.dart';
import 'package:webblen/widgets_common/common_button.dart';

class DashboardPage extends StatefulWidget {

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

//class _DashboardPageState extends State<DashboardPage> with TickerProviderStateMixin {
class _DashboardPageState extends State<DashboardPage> {

  RefreshController refreshController = RefreshController();
  //AnimationController animationController;

  var _homeScaffoldKey = GlobalKey<ScaffoldState>();

  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  String notifToken;

  WebblenUser currentUser;
  bool updateRequired = false;
  String uid;
  NetworkImage userImage;
  bool isLoading = true;
  bool isNewUser = false;
  int activeUserCount;
  double currentLat;
  double currentLon;
  List<CommunityNewsPost> communityNewsPosts;
  bool didClickNotice = false;
  bool checkInFound = false;

  bool hasLocation = false;
  bool webblenIsAvailable = true;
  bool viewedAd = false;
  String areaName;


  Future<Null> initialize() async {
    BaseAuth().currentUser().then((val) {
      uid = val;
      UserDataService().findUserByID(uid).then((user){
        if (user != null){
          currentUser = user;
          isNewUser = currentUser.isNew;
          Admob().initialize();
          Admob().loadRewardedVideo(currentUser, context);
          EventDataService().receiveEventPoints(currentUser.eventHistory);
          FirebaseNotificationsService().updateFirebaseMessageToken(uid);
          FirebaseNotificationsService().configFirebaseMessaging(context, uid);
          loadLocation();
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil('/setup', (Route<dynamic> route) => false);
        }
      });
    });
  }


  Future<Null> loadLocation() async {
    LocationService().getCurrentLocation(context).then((location){
      if (this.mounted){
        UserDataService().findUserByID(uid).then((user){
          currentUser = user;
          if (location != null){
            hasLocation = true;
            currentLat = location.latitude;
            currentLon = location.longitude;
            UserDataService().updateUserCheckIn(uid, currentLat, currentLon);
            PlatformDataService().getAreaName(currentLat, currentLon).then((area){
              if (area.isEmpty){
                webblenIsAvailable = false;
              }
              areaName = area;
              isLoading = false;
              setState(() {});
            });
          } else {
            isLoading = false;
            setState(() {});
          }
        });
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

  Widget buildRefreshHeader(context,mode){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: CustomLinearProgress(progressBarColor: FlatColors.webblenRed),
    );
  }

  void refreshData(bool up){
    if (up) {
      loadLocation();
      Future.delayed(const Duration(milliseconds: 2009))
          .then((val) {
        refreshController.sendBack(true, RefreshStatus.completed);
      });
    }
  }

//  void showCheckInAnimation() {
//    animationController.stop();
//    animationController.reset();
//    animationController.repeat(
//      period: Duration(seconds: 1),
//    );
//  }

  @override
  void initState() {
    super.initState();
    initialize();
//    animationController = AnimationController(vsync: this);

  }

  @override
  void dispose() {
    //animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold (
        appBar: WebblenAppBar().homeAppBar(
            uid != null ? StreamUserAccount(uid: uid, accountAction: () => didPressAccountButton()) : Container(),
            Image.asset(
              'assets/images/webblen_logo_text.jpg',
              width: 170.0,
              fit: BoxFit.cover,
            ),
            uid != null ? StreamUserNotifications(uid: uid, notifAction: () => didPressNotificationsBell(), isLoading: isLoading) : Container()
        ),
        key: _homeScaffoldKey,
        drawer: UserDrawerMenu(context: context, uid: uid).buildUserDrawerMenu(),
        body: isLoading == true ? LoadingScreen(context: context, loadingDescription: "Registering Location...")
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
                padding: EdgeInsets.symmetric(vertical: 16.0),
                children: <Widget>[
                  hasLocation
                    ? webblenIsAvailable
                      ? CheckInTile()
                      : CreateWaitListWidget(isOnWaitList: currentUser.isOnWaitList, buttonAction: () => PageTransitionService(context: context, currentUser: currentUser).transitionToWaitListPage())
                    : Padding(
                      padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                      child: Column(
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
                  ),
                  DashboardTile(
                    child: TileDiscoverContent(),
                    onTap: () => didPressDiscoverTile(),
                  ),
                  DashboardTile(
                    child: TileCommunityContent(),
                    onTap: () => didPressMyCommunitiesTile(),
                  ),
                  !viewedAd
                    ? DashboardTile(
                        child: TileFreeWebblenContent(),
                        onTap: () => didPressFreeWebblenTile(),
                      )
                    : Container(),
                  webblenIsAvailable
                      ? DashboardTile(
                      child: !hasLocation
                          ? Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: Fonts().textW400("Please Enable Location Permissions To Access All Features", 18.0, FlatColors.darkGray, TextAlign.center),
                          )
                      )
                          : TileNearbyUsersContent(currentUser: currentUser, lat: currentLat, lon: currentLon),
                      onTap: () => didPressNearbyUserTile(),
                  )
                      : Container()
                ],
                staggeredTiles: [
                  webblenIsAvailable ? StaggeredTile.extent(2, MediaQuery.of(context).size.height * 0.3) : StaggeredTile.extent(2, 300),
                  StaggeredTile.extent(2, 75.0),
                  StaggeredTile.extent(2, 75.0),
                  !viewedAd ? StaggeredTile.extent(2, 75.0) : StaggeredTile.extent(2, 0.0),
                  StaggeredTile.extent(2, 200.0)
                ],
              ),
            ),
            isNewUser && !didClickNotice
                ? NewUserAlertWidget(
              tapAction: (){
                _homeScaffoldKey.currentState.openDrawer();
                setState(() {
                  didClickNotice = true;
                });
              },
            )
                : Container()
          ],
        ),
    );
  }

  bool updateAlertIsEnabled(){
    bool showAlert = false;
    if (!isLoading && updateRequired){
      showAlert = true;
    }
    return showAlert;
  }

  void didPressNotificationsBell(){
    if (!isLoading && currentUser.username != null && !updateAlertIsEnabled() && hasLocation){
      PageTransitionService(context: context, currentUser: currentUser).transitionToNotificationsPage();
    } else if (updateAlertIsEnabled()){
      ShowAlertDialogService().showUpdateDialog(context);
    } else if (!hasLocation){
      ShowAlertDialogService().showFailureDialog(context, "Cannot Access Location", "Please Enable Location Permissions to Access All Features");
    }
  }

  void didPressCheckInTile(){
    if (!isLoading && currentUser.username != null && !updateAlertIsEnabled() && hasLocation){
      PageTransitionService(context: context, currentUser: currentUser).transitionToCheckInPage();
    } else if (updateAlertIsEnabled()){
      ShowAlertDialogService().showUpdateDialog(context);
    } else if (!hasLocation){
      ShowAlertDialogService().showFailureDialog(context, "Cannot Access Location", "Please Enable Location Permissions to Access All Features");
    }
  }

  void didPressAccountButton(){
    if (!isLoading && currentUser != null && !updateAlertIsEnabled() && hasLocation){
      _homeScaffoldKey.currentState.openDrawer();
    } else if (updateAlertIsEnabled()){
      ShowAlertDialogService().showUpdateDialog(context);
    } else if (!hasLocation){
      ShowAlertDialogService().showFailureDialog(context, "Cannot Access Location", "Please Enable Location Permissions to Access All Features");
    }
  }

  void didPressDiscoverTile(){
    if (!isLoading && currentUser != null && !updateAlertIsEnabled() && hasLocation){
      PageTransitionService(context: context, currentUser: currentUser, areaName: areaName).transitionToDiscoverPage();
    } else if (updateAlertIsEnabled()){
      ShowAlertDialogService().showUpdateDialog(context);
    } else if (!hasLocation){
      ShowAlertDialogService().showFailureDialog(context, "Cannot Access Location", "Please Enable Location Permissions to Access All Features");
    }
  }

  void didPressFreeWebblenTile() async {
    if (!isLoading && currentUser != null && !updateAlertIsEnabled() && hasLocation){
      Admob().showRewardVideo().whenComplete((){
        setState(() {
          viewedAd = true;
        });
      });
    } else if (updateAlertIsEnabled()){
      ShowAlertDialogService().showUpdateDialog(context);
    } else if (!hasLocation){
      ShowAlertDialogService().showFailureDialog(context, "Cannot Access Location", "Please Enable Location Permissions to Access All Features");
    }
  }

  void didPressMyCommunitiesTile(){
    if (!isLoading && currentUser != null && !updateAlertIsEnabled()){
      PageTransitionService(context: context, currentUser: currentUser, areaName: areaName).transitionToMyCommunitiesPage();
    } else if (updateAlertIsEnabled()){
      ShowAlertDialogService().showUpdateDialog(context);
    }
  }

  void didPressNearbyUserTile(){
    if (!isLoading && currentUser != null && !updateAlertIsEnabled()){
      PageTransitionService(context: context, currentUser: currentUser).transitionToUserRanksPage();
    } else if (updateAlertIsEnabled()){
      ShowAlertDialogService().showUpdateDialog(context);
    }
  }

}