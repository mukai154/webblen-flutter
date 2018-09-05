import 'package:flutter/material.dart';


class EventDateTabBar extends StatelessWidget {
  final TabController tabController;
  final Color color;

  EventDateTabBar(this.tabController, this.color);

  @override
  Widget build(BuildContext context) {
    return new Container(
      constraints: BoxConstraints(maxHeight: 36.0),
      decoration: new BoxDecoration(
        color: color,
      ),
        child: TabBar(
        controller: tabController,
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        isScrollable: true,
        tabs: <Widget>[
          new Tab(text: "Today"),
          new Tab(text: "Tomorrow"),
          new Tab(text: "This Week"),
          new Tab(text: "Next Week"),
          new Tab(text: "This Month"),
          new Tab(text: "Later"),
        ],
      ),
    );

  }
}