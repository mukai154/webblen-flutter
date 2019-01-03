import 'package:flutter/material.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:webblen/widgets_user/user_row.dart';
import 'package:webblen/services_general/service_page_transitions.dart';
class BuildTopUsers {

  final List<WebblenUser> top10NearbyUsers;
  final String currentUID;
  final BuildContext context;

  BuildTopUsers({this.context, this.top10NearbyUsers, this.currentUID});

  void transitionToUserDetails(WebblenUser webblenUser){
    PageTransitionService(context: context, uid: currentUID, webblenUser: webblenUser).transitionToUserDetailsPage();
  }

  List buildTopUsers() {
    List<Widget> topUsers = List();
      for (int i = 0; i < top10NearbyUsers.length; i++) {
        topUsers.add(
          UserRowMin(user: top10NearbyUsers[i], transitionToUserDetails: () => transitionToUserDetails(top10NearbyUsers[i]))
        );
      }
    return topUsers;
  }

}