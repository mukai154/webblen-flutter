import 'package:flutter/material.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:webblen/models/webblen_chat_message.dart';
import 'package:webblen/models/community_news.dart';
import 'package:webblen/models/webblen_reward.dart';
import 'package:webblen/animations/transition_animations.dart';
import 'package:webblen/user_pages/reward_payout_page.dart';
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
import 'package:webblen/user_pages/messages_page.dart';
import 'package:webblen/user_pages/community_news_details_page.dart';
import 'package:webblen/user_pages/community_builder_page.dart';
import 'package:webblen/user_pages/notifications_page.dart';
import 'package:webblen/user_pages/users_search_page.dart';
import 'package:webblen/event_pages/choose_event_type_page.dart';
import 'package:webblen/user_pages/settings_page.dart';
import 'package:webblen/user_pages/transaction_history_page.dart';
import 'package:webblen/onboarding/webblen_guide_page.dart';
import 'package:webblen/user_pages/video_player_page.dart';

class PageTransitionService{

  final BuildContext context;
  final NetworkImage userImage;
  final List userTags;
  final double userLat;
  final double userLon;
  final double userPoints;
  final String uid;
  final List<WebblenUser> nearbyUsers;
  final List<WebblenUser> usersList;
  final String username;
  final WebblenUser webblenUser;
  final WebblenUser currentUser;
  final WebblenChat chat;
  final String chatDocKey;
  final String peerUsername;
  final String peerProfilePic;
  final String profilePicUrl;
  final CommunityNewsPost newsPost;
  final String videoURL;
  final WebblenReward reward;

  PageTransitionService({
    this.context, this.userImage, this.username,
    this.userTags, this.userPoints, this.uid,
    this.nearbyUsers, this.usersList, this.userLat, this.userLon,
    this.webblenUser, this.currentUser, this.chat, this.chatDocKey,
    this.peerProfilePic, this.peerUsername, this.profilePicUrl,
    this.newsPost, this.videoURL, this.reward});

  void transitionToRootPage () => Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (Route<dynamic> route) => false);
  void transitionToEventListPage () =>  Navigator.push(context, SlideFromRightRoute(widget: EventCalendarPage(userTags: userTags)));
  void transitionToChooseEventCreationPage () =>  Navigator.push(context, SlideFromRightRoute(widget: ChooseEventTypePage(currentUID: uid)));
  void transitionToNewEventPage () => Navigator.of(context).pushNamedAndRemoveUntil('/new_event', (Route<dynamic> route) => false);
  void transitionToNewFlashEventPage () =>  Navigator.push(context, SlideFromRightRoute(widget: CreateFlashEventPage(uid: uid)));
  void transitionToShopPage () => Navigator.push(context, SlideFromRightRoute(widget: ShopPage(currentUser: currentUser, lat: userLat, lon: userLon)));
  void transitionToInterestsPage () =>  Navigator.push(context, SlideFromRightRoute(widget: InterestsPage(userTags: userTags)));
  void transitionToMyEventsPage () =>  Navigator.push(context, SlideFromRightRoute(widget: MyEventsPage()));
  void transitionToCheckInPage () =>  Navigator.push(context, SlideFromRightRoute(widget: EventCheckInPage()));
  void transitionToUserRanksPage () =>  Navigator.push(context, SlideFromRightRoute(widget: UserRanksPage(users: nearbyUsers, currentUser: currentUser)));
  void transitionToCreateRewardPage () =>  Navigator.push(context, SlideFromRightRoute(widget: CreateRewardPage()));
  void transitionToRegistrationPage () =>  Navigator.push(context, SlideFromRightRoute(widget: RegistrationPage()));
  void transitionToFriendsPage () =>  Navigator.push(context, SlideFromRightRoute(widget: FriendsPage(currentUser: currentUser)));
  void transitionToChatPage () =>  Navigator.push(context, SlideFromRightRoute(widget: Chat(chatDocKey: chatDocKey, currentUser: currentUser, peerProfilePic: peerProfilePic, peerUsername: peerUsername)));
  void transitionToMessagesPage () =>  Navigator.push(context, SlideFromRightRoute(widget: MessagesPage(currentUser: currentUser)));
  void transitionToUserDetailsPage () =>  Navigator.push(context, SlideFromRightRoute(widget: UserDetailsPage(currentUser: currentUser, webblenUser: webblenUser)));
  void transitionToWalletPage () =>  Navigator.push(context, SlideFromRightRoute(widget: WalletPage(currentUser: currentUser)));
  void transitionToCommunityNewsPost () =>  Navigator.push(context, SlideFromRightRoute(widget: CommunityNewsDetailsPage(newsPost: newsPost, currentUID: uid)));
  void transitionToCommunityBuilderPage () => Navigator.push(context, SlideFromRightRoute(widget: CommunityBuilderPage(currentUser: currentUser)));
  void transitionToNotificationsPage () => Navigator.push(context, SlideFromRightRoute(widget: NotificationPage(currentUser: currentUser)));
  void transitionToUserSearchPage () => Navigator.push(context, SlideFromRightRoute(widget: UserSearchPage(currentUser: currentUser, usersList: usersList)));
  void transitionToSettingsPage () => Navigator.push(context, SlideFromRightRoute(widget: SettingsPage(currentUser: currentUser)));
  void transitionToGuidePage () => Navigator.push(context, SlideFromRightRoute(widget: WebblenGuidePage()));
  void transitionToVideoPlayerPage () => Navigator.push(context, SlideFromRightRoute(widget: VideoPlayerPage(videoURL: videoURL)));
  void transitionToRewardPayoutPage () => Navigator.push(context, SlideFromRightRoute(widget: RewardPayoutPage(redeemingReward: reward,currentUser: currentUser)));
  void transitionToTransactionHistoryPage () => Navigator.push(context, SlideFromRightRoute(widget: TransactionHistoryPage(currentUser: currentUser)));
}