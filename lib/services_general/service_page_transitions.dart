import 'package:flutter/material.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:webblen/models/webblen_chat_message.dart';
import 'package:webblen/models/community_news.dart';
import 'package:webblen/animations/transition_animations.dart';
import 'package:webblen/user_pages/settings_page.dart';
import 'package:webblen/user_pages/profile_page.dart';
import 'package:webblen/auth_pages/registration_page.dart';
import 'package:webblen/user_pages/interests_page.dart';
import 'package:webblen/user_pages/shop_page.dart';
import 'package:webblen/event_pages/my_events_page.dart';
import 'package:webblen/event_pages/event_check_in_page.dart';
import 'package:webblen/user_pages/user_ranks_page.dart';
import 'package:webblen/event_pages/create_reward_page.dart';
import 'package:webblen/event_pages/events_calendar_page.dart';
import 'package:webblen/user_pages/user_details_page.dart';
import 'package:webblen/event_pages/create_flash_event_page.dart';
import 'package:webblen/user_pages/friends_page.dart';
import 'package:webblen/user_pages/wallet_page.dart';
import 'package:webblen/user_pages/chat_page.dart';
import 'package:webblen/user_pages/community_news_details_page.dart';

class PageTransitionService{

  final BuildContext context;
  final NetworkImage userImage;
  final List userTags;
  final double userLat;
  final double userLon;
  final double userPoints;
  final String uid;
  final List<WebblenUser> nearbyUsers;
  final String username;
  final WebblenUser webblenUser;
  final WebblenChat chat;
  final String chatDocKey;
  final String peerUsername;
  final String peerProfilePic;
  final String profilePicUrl;
  final CommunityNewsPost newsPost;

  PageTransitionService({
    this.context, this.userImage, this.username,
    this.userTags, this.userPoints, this.uid,
    this.nearbyUsers, this.userLat, this.userLon,
    this.webblenUser, this.chat, this.chatDocKey,
    this.peerProfilePic, this.peerUsername, this.profilePicUrl,
    this.newsPost});

  void transitionToSettingsPage () => Navigator.push(context, SlideFromRightRoute(widget: SettingsPage()));
  void transitionToProfilePage () => Navigator.push(context, SlideFromRightRoute(widget: ProfileHomePage(userImage: userImage, username: username)));
  void transitionToEventListPage () =>  Navigator.push(context, SlideFromRightRoute(widget: EventCalendarPage(userTags: userTags)));
  void transitionToNewEventPage () => Navigator.of(context).pushNamedAndRemoveUntil('/new_event', (Route<dynamic> route) => false);
  void transitionToNewFlashEventPage () =>  Navigator.push(context, SlideFromRightRoute(widget: CreateFlashEventPage(uid: uid)));
  void transitionToShopPage () => Navigator.push(context, SlideFromRightRoute(widget: ShopPage(uid, userLat, userLon)));
  void transitionToInterestsPage () =>  Navigator.push(context, SlideFromRightRoute(widget: InterestsPage(userTags: userTags)));
  void transitionToMyEventsPage () =>  Navigator.push(context, SlideFromRightRoute(widget: MyEventsPage()));
  void transitionToCheckInPage () =>  Navigator.push(context, SlideFromRightRoute(widget: EventCheckInPage()));
  void transitionToUserRanksPage () =>  Navigator.push(context, SlideFromRightRoute(widget: UserRanksPage(users: nearbyUsers, currentUID: uid)));
  void transitionToCreateRewardPage () =>  Navigator.push(context, SlideFromRightRoute(widget: CreateRewardPage()));
  void transitionToRegistrationPage () =>  Navigator.push(context, SlideFromRightRoute(widget: RegistrationPage()));
  void transitionToFriendsPage () =>  Navigator.push(context, SlideFromRightRoute(widget: FriendsPage(currentUID: uid)));
  void transitionToChatPage () =>  Navigator.push(context, SlideFromRightRoute(widget: Chat(chatDocKey: chatDocKey, currentProfilePic: profilePicUrl, peerProfilePic: peerProfilePic, currentUsername: username, peerUsername: peerUsername, currentUID: uid)));
  void transitionToUserDetailsPage () =>  Navigator.push(context, SlideFromRightRoute(widget: UserDetailsPage(currentUID: uid, webblenUser: webblenUser)));
  void transitionToWalletPage () =>  Navigator.push(context, SlideFromRightRoute(widget: WalletPage()));
  void transitionToCommunityNewsPost () =>  Navigator.push(context, SlideFromRightRoute(widget: CommunityNewsDetailsPage(newsPost: newsPost, currentUID: uid)));
}