//import 'package:flutter/material.dart';
//import 'package:webblen/services_general/service_page_transitions.dart';
//import 'package:webblen/models/community_news.dart';
//import 'tile_community_news_content.dart';
//
//
//class BuildNewsPostWidgets {
//
//  final List<CommunityNewsPost> communityNewsPosts;
//  final BuildContext context;
//  final String currentUID;
//  final List userTags;
//
//  BuildNewsPostWidgets({this.context, this.communityNewsPosts, this.currentUID, this.userTags});
//
//  void transitionToCommunityNewsPost(CommunityNewsPost newsPost){
//    PageTransitionService(context: context, newsPost: newsPost, uid: currentUID, userTags: userTags).transitionToCommunityNewsPost();
//  }
//
//
//  List buildNewsWidgets() {
//    List<Widget> newsPosts = List();
//      for (int i = 0; i < communityNewsPosts.length; i++) {
//       newsPosts.add(
//          CommunityNewsRow(newsPost: communityNewsPosts[i], newsAction: () => transitionToCommunityNewsPost(communityNewsPosts[i]), viewingDetails: false),
//       );
//      }
//    return newsPosts;
//  }
//}