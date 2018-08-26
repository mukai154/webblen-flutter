import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:webblen/styles/gradients.dart';
import 'package:webblen/firebase_services/event_data.dart';
import 'package:webblen/event_pages/my_events_page.dart';
import 'package:webblen/event_pages/event_list_page.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/user_pages/settings_page.dart';
import 'package:webblen/profile_widgets/profile_page.dart';
import 'package:webblen/mapping/map_page.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:webblen/user_pages/interests_page.dart';
import 'package:webblen/firebase_services/community_data.dart';
import 'package:webblen/animations/transition_animations.dart';

class DashboardPage extends StatefulWidget {

  static String tag = 'dashboard-Page';

  final String loggedInUID;
  DashboardPage({this.loggedInUID});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  String uid;
  String username;
  String userImagePath;
  List userTags;
  int eventCount;
  int activeUserCount = 1;

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
  void transitionToProfilePage () => Navigator.push(context, ScaleRoute(widget: ProfileHomePage()));
  void transitionToEventListPage () =>  Navigator.push(context, ScaleRoute(widget: EventListPage(userTags: userTags)));
  void transitionToNewEventPage () => Navigator.of(context).pushNamedAndRemoveUntil('/new_event', (Route<dynamic> route) => false);
  void transitionToMapPage () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => MapPage()));
  void transitionToInterestsPage () =>  Navigator.push(context, SlideFromRightRoute(widget: InterestsPage(userTags: userTags)));
  void transitionToMyEventsPage () =>  Navigator.push(context, SlideFromRightRoute(widget: MyEventsPage()));

  @override
  void initState() {
    super.initState();
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
            UserDataService().userImagePath(uid).then((imagePath){
              setState(() {
                userImagePath = imagePath;
                if (userImagePath == null || userImagePath.isEmpty){
                  Navigator.of(context).pushNamedAndRemoveUntil('/setup', (Route<dynamic> route) => false);
                }
              });
            });
          }
        });
      });
    });
//    List<String> tags = [];
//    UserDataService().addUserDataField("tags", tags);
  }

  @override
  Widget build(BuildContext context) {

    // ** APP BAR
    final appBar = AppBar (
      elevation: 2.0,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      title: Text('Home', style: Fonts.dashboardTitleStyle),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings, size: 24.0, color: FlatColors.londonSquare),
          onPressed: () {
           transitionToSettingsPage();
          },
        ),
      ],
    );

    return Scaffold (
        appBar: appBar,
        body: userTags == null ? _buildLoadingScreen()
        :StaggeredGridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  children: <Widget>[
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
                                    Text('Account', style: TextStyle(color: FlatColors.londonSquare)),
                                    username == null ? _buildLoadingIndicator()
                                    :Text('@' + username, style: TextStyle(color: FlatColors.darkGray, fontWeight: FontWeight.w600, fontSize: 24.0)),
                                  ],
                                ),
                                Hero (
                                  tag: 'profile_pic',
                                  child: Padding(
                                    padding: EdgeInsets.all(0.0),
                                    child: Hero(
                                      tag: 'user-profile-pic',
                                      child: userImagePath == null ? _buildLoadingIndicator()
                                      :CircleAvatar(
                                        radius: 30.0,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: NetworkImage(userImagePath),
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                          ),
                        ),
                        onTap: () { transitionToProfilePage(); }
                    ),
                    _buildTile(
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Hero(
                                tag: 'event-blue',
                                child: Material(
                                    color: FlatColors.electronBlue,
                                    shape: CircleBorder(),
                                    child: Padding (
                                      padding: const EdgeInsets.all(16.0),
                                      child: Icon(Icons.today, color: Colors.white, size: 30.0),
                                    )
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 16.0)),
                              Text('Calendar', style: TextStyle(color: FlatColors.blackPearl, fontWeight: FontWeight.w700, fontSize: 24.0)),
                              Text("Event Calendar", style: Fonts.subHeaderTextStyle),
                            ]
                        ),
                      ),
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
                                      StreamBuilder(
                                          stream: Firestore.instance.collection("community_activity").document("user_data").snapshots(),
                                          builder: (context, activitySnapshot) {
                                            if (!activitySnapshot.hasData) return Text('Loading...');
                                            var activityData = activitySnapshot.data;
                                            return Text('$activeUserCount Active Users', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18.0));
                                          }
                                      ),
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
                                        return DropdownMenuItem
                                          (
                                          value: title,
                                          child: Text(title, style: TextStyle(color: FlatColors.blackPearl, fontWeight: FontWeight.w400, fontSize: 14.0)),
                                        );
                                      }).toList()
                                  )
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 4.0)),
                              StreamBuilder(
                                  stream: Firestore.instance.collection("community_activity").document("user_data").snapshots(),
                                  builder: (context, communityActvitySnapshot) {
                                    if (!communityActvitySnapshot.hasData) return new Text("Loading");
                                    return Sparkline(
                                      data: charts[actualChart],
                                      lineWidth: 5.0,
                                      lineColor: FlatColors.lightCarribeanGreen,
                                    );
                                  }
                              ),
                            ],
                          )
                      ),
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
                                  eventCount == null ? _buildLoadingIndicator()
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
                    StaggeredTile.extent(2, 110.0),
                    StaggeredTile.extent(2, 180.0),
                    //StaggeredTile.extent(1, 180.0),
                    StaggeredTile.extent(1, 180.0),
                    StaggeredTile.extent(1, 180.0),
                    StaggeredTile.extent(2, 220.0),
                    StaggeredTile.extent(2, 110.0),
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

  Widget _buildLoadingIndicator(){
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20.0,
            width: 20.0,
            child: CircularProgressIndicator(backgroundColor: FlatColors.darkGray),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingScreen()  {
    return new Container(
      width: MediaQuery.of(context).size.width,
      decoration: new BoxDecoration(
        gradient: Gradients.twinkleBlue(),
      ),
      child: new Column /*or Column*/(
        children: <Widget>[
          SizedBox(height: 240.0),
          new Container(
            height: 85.0,
            width: 85.0,
            child: _buildLoadingIndicator(),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}