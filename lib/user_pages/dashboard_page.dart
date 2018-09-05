import 'dart:async';
import 'user_ranks_page.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:webblen/firebase_services/event_data.dart';
import 'package:webblen/event_pages/my_events_page.dart';
import 'package:webblen/event_pages/event_list_page.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'package:webblen/widgets_dashboard/dashboard_tile.dart';
import 'package:webblen/widgets_dashboard/tile_user_profile_content.dart';
import 'package:webblen/widgets_dashboard/tile_calendar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/user_pages/settings_page.dart';
import 'package:webblen/user_pages/profile_page.dart';
import 'package:webblen/mapping/map_page.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:webblen/user_pages/interests_page.dart';
import 'package:webblen/firebase_services/community_data.dart';
import 'package:webblen/animations/transition_animations.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:webblen/widgets_common/common_alert.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen/event_pages/event_check_in_page.dart';


class DashboardPage extends StatefulWidget {

  static String tag = 'dashboard-Page';

  final String loggedInUID;
  DashboardPage({this.loggedInUID});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  bool test = true;
  String uid;
  String username;
  String userImagePath;
  NetworkImage userImage;
  bool userImageLoaded = false;
  List userTags;
  int eventCount;
  int activeUserCount = 1;
  double currentLat;
  double currentLon;
  List eventHistory;
  List<WebblenUser> nearbyUsers = [];


  Map<String, double> _startLocation;
  Map<String, double> _currentLocation;
  StreamSubscription<Map<String, double>> _locationSubscription;
  Location _location = new Location();
  bool retrievedLocation = false;
  bool _permission = false;

  List<double> activityChart = [];
  final List<List<double>> charts = [
    [0.0, 0.3, 0.7, 0.6, 0.55, 0.8, 1.2, 1.3, 1.35, 0.9, 0.5, 1.7, 1.8, 1.7, 0.2, 0.8, 1.9, 2.0, 2.2, 1.9, 2.2, 2.1, 2.0, 2.3, 2.4, 2.45, 2.6, 3.6, 2.6, 2.7, 4.9, 2.8, 2.4],
    [0.0, 0.3, 0.7, 0.6, 0.55, 0.8, 1.2, 1.3, 1.35, 0.9, 0.5, 1.7, 1.8, 1.7, 0.2, 0.8, 1.9, 2.0, 2.2, 1.9, 2.2, 2.1, 2.0, 2.3, 2.4, 2.45, 2.6, 3.6, 2.6, 2.7, 4.9, 2.8, 2.4, 5.0, 3.3, 4.7, 0.6, 0.55, 2.7, 4.9, 2.8, 2.4, 5.0, 3.3, 4.7, 0.6, 0.55, 1.7, 2.7, 4.9, 2.8, 2.4, 5.0, 3.3, 4.7, 0.6, 0.55, 1.9, 2.2, 2.1, 2.0, 2.3, 2.4, 2.45, 2.6, 3.6, 2.6, 2.7, 2.9, 2.8, 3.4,],
    [0.0, 0.3, 0.7, 0.6, 0.55, 0.8, 1.2, 1.3, 1.35, 0.9, 1.5, 1.7, 1.8, 1.7, 1.2, 0.8, 1.9, 2.0, 2.2, 1.9, 2.2, 2.1, 2.0, 2.3, 2.4, 2.45, 2.6, 3.6, 2.6, 2.7, 2.9, 2.8, 3.4, 0.0, 0.3, 0.7, 0.6, 0.55, 0.8, 1.2, 1.3, 1.35, 2.7, 4.9, 2.8, 2.4, 5.0, 3.3, 4.7, 0.6, 0.55, 1.9, 2.0, 2.2, 1.9, 2.2, 2.1, 2.0, 2.3, 2.4, 2.45, 2.6, 3.6, 2.6, 2.7, 2.9, 2.8, 3.4, 0.0, 0.3, 0.7, 0.6, 0.55, 0.8, 1.2, 1.3, 1.35, 0.9, 1.5, 1.7, 1.8, 1.7, 1.2, 0.8, 1.9, 2.0, 2.2, 1.9, 2.2, 2.1, 2.0, 2.3, 2.4, 2.45, 2.6, 3.6, 2.6, 2.7, 2.9, 2.8, 3.4]
  ];

  static final List<String> chartDropdownItems = [ 'Last 7 days', 'Last month', 'Last year' ];
  String actualDropdown = chartDropdownItems[0];
  int actualChart = 0;

  void transitionToSettingsPage () => Navigator.push(context, SlideFromRightRoute(widget: SettingsPage()));
  void transitionToProfilePage () => Navigator.push(context, ScaleRoute(widget: ProfileHomePage(userImage: userImage)));
  void transitionToEventListPage () =>  Navigator.push(context, ScaleRoute(widget: EventListPage(userTags: userTags)));
  void transitionToNewEventPage () => Navigator.of(context).pushNamedAndRemoveUntil('/new_event', (Route<dynamic> route) => false);
  void transitionToMapPage () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => MapPage()));
  void transitionToInterestsPage () =>  Navigator.push(context, SlideFromRightRoute(widget: InterestsPage(userTags: userTags)));
  void transitionToMyEventsPage () =>  Navigator.push(context, SlideFromRightRoute(widget: MyEventsPage()));
  void transitionToCheckInPage () =>  Navigator.push(context, SlideFromRightRoute(widget: EventCheckInPage()));
  void transitionToUserRanksPage () =>  Navigator.push(context, SlideFromRightRoute(widget: UserRanksPage(users: nearbyUsers)));

  Future<bool> invalidAlert(BuildContext context, String message) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) { return AlertMessage(message); });
  }

  @override
  void initState() {
    super.initState();
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
            UserDataService().userImagePath(uid).then((imagePath){
              setState(() {
                userImagePath = imagePath;
                if (userImagePath == null || userImagePath.isEmpty){
                  Navigator.of(context).pushNamedAndRemoveUntil('/setup', (Route<dynamic> route) => false);
                } else {
                  userImage = NetworkImage(userImagePath);
                  userImage.resolve(new ImageConfiguration()).addListener((_, __) {
                    if (mounted) {
                      setState(() {
                        userImageLoaded = true;
                      });
                    }
                  });
                }
                _locationSubscription =
                    _location.onLocationChanged().listen((Map<String,double> result) {
                      if (this.mounted){
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
                      }
                    });
              });
            });
          }
        });
      });
    });
//    double userLon = -96.79284326627281;
//    UserDataService().addUserDataField("userLon", userLon);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initLocationState() async {
    Map<String, double> location;
    String error = "";
    try {
      _permission = await _location.hasPermission();
      location = await _location.getLocation();
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
        _startLocation = location;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    // ** APP BAR
    final appBar = AppBar (
      elevation: 2.0,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      title: Text('Home', style: Fonts.dashboardTitleStyle),
      leading: IconButton(icon: Icon(FontAwesomeIcons.mapMarkerAlt, color: FlatColors.londonSquare),
          onPressed: () { transitionToCheckInPage(); }
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings, size: 24.0, color: FlatColors.londonSquare),
          onPressed: () { transitionToSettingsPage(); },
        ),
      ],
    );

    return Scaffold (
        appBar: appBar,
        body: userTags == null ? new LoadingScreen(context: context)
        : StaggeredGridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  children: <Widget>[
                    DashboardTile(
                      child: TileUserProfileContent(
                        username: username,
                        userImageLoaded: userImageLoaded,
                        userImagePath: userImagePath,
                      ),
                      onTap: () { transitionToProfilePage(); },
                    ),
                    DashboardTile(
                      child: TileCalendarContent(),
                      onTap: () { transitionToEventListPage(); },
                    ),
//                    _buildTile(
//                      Padding
//                        (
//                        padding: const EdgeInsets.all(24.0),
//                        child: Column (
//                            mainAxisAlignment: MainAxisAlignment.start,
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget> [
//                              Hero(
//                                tag: 'map-green',
//                                child: Material (
//                                    color: FlatColors.greenTeal,
//                                    shape: CircleBorder(),
//                                    child: Padding (
//                                      padding: EdgeInsets.all(16.0),
//                                      child: Icon(Icons.map, color: Colors.white, size: 30.0),
//                                    )
//                                ),
//                              ),
//                              Padding(padding: EdgeInsets.only(bottom: 16.0)),
//                              Text('Map', style: TextStyle(color: FlatColors.blackPearl, fontWeight: FontWeight.w700, fontSize: 24.0)),
//                              Text("Events in Your Area", style: Fonts.subHeaderTextStyle),
//                            ]
//                        ),
//                      ),
//                      onTap: () { transitionToMapPage(); }
//                    ),
                    _buildTile(
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Hero(
                                  tag: 'new-event-yellow',
                                  child: Material(
                                      color: FlatColors.vibrantYellow,
                                      shape: CircleBorder(),
                                      child: Padding (
                                        padding: const EdgeInsets.all(16.0),
                                        child: Icon(Icons.add_circle, color: Colors.white, size: 30.0),
                                      )
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 16.0)),
                                Text('New Event', style: TextStyle(color: FlatColors.blackPearl, fontWeight: FontWeight.w700, fontSize: 20.0)),
                                Text("Create an Event for Your Community", style: Fonts.subHeaderTextStyle2),
                              ]
                          ),
                        ),
                        onTap: () { transitionToNewEventPage(); }
                    ),
                    _buildTile(
                        Padding (
                          padding: const EdgeInsets.all(24.0),
                          child: Column (
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget> [
                                Hero(
                                  tag: 'interests-red',
                                  child: Material (
                                      color: FlatColors.redOrange,
                                      shape: CircleBorder(),
                                      child: Padding (
                                        padding: EdgeInsets.all(16.0),
                                        child: Icon(Icons.favorite, color: Colors.white, size: 30.0),
                                      )
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 16.0)),
                                Text('Interests', style: TextStyle(color: FlatColors.blackPearl, fontWeight: FontWeight.w700, fontSize: 20.0)),
                                Text("What Interests You?", style: Fonts.subHeaderTextStyle2),
                              ]
                          ),
                        ),
                        onTap: () { transitionToInterestsPage(); }
                    ),
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
                                      items: chartDropdownItems.map((String title)
                                      {
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
                      onTap: () { transitionToUserRanksPage(); },
                    ),
                    _buildTile(
                      Padding (
                        padding: const EdgeInsets.all(24.0),
                        child: Row (
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget> [
                              Column (
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget> [
                                  Text('My Events', style: TextStyle(color: FlatColors.londonSquare)),
                                  eventCount == null ? new Text("Loading")//CustomCircleProgress(60.0, 60.0, 30.0, 30.0, FlatColors.londonSquare)
                                  :Text('$eventCount', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 34.0))
                                ],
                              ),
                              Material (
                                  color: FlatColors.exodusPurple,
                                  borderRadius: BorderRadius.circular(30.0),
                                  child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Icon(Icons.date_range, color: Colors.white, size: 30.0),
                                      )
                                  )
                              )
                            ]
                        ),
                      ),
                      onTap: () { transitionToMyEventsPage();  },
                    )
                  ],
                  staggeredTiles: [
                    StaggeredTile.extent(2, 120.0),
                    StaggeredTile.extent(2, 180.0),
                    //StaggeredTile.extent(1, 180.0),
                    StaggeredTile.extent(1, 180.0),
                    StaggeredTile.extent(1, 180.0),
                    StaggeredTile.extent(2, 220.0),
                    StaggeredTile.extent(2, 120.0),
                  ],
                ),
    );
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
          // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null ? () => onTap() : () { print('Not set yet'); },
            child: child
        )
    );
  }
}

