import 'package:flutter/material.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:webblen/models/webblen_chat_message.dart';
import 'package:webblen/models/community_news.dart';
import 'package:webblen/models/webblen_reward.dart';
import 'package:webblen/animations/transition_animations.dart';
import 'package:webblen/user_pages/reward_payout_page.dart';
import 'package:webblen/user_pages/shop_page.dart';
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
import 'package:webblen/user_pages/community_create_post_page.dart';
import 'package:webblen/user_pages/notifications_page.dart';
import 'package:webblen/user_pages/users_search_page.dart';
import 'package:webblen/event_pages/choose_event_type_page.dart';
import 'package:webblen/user_pages/join_waitlist_page.dart';
import 'package:webblen/user_pages/settings_page.dart';
import 'package:webblen/user_pages/transaction_history_page.dart';
import 'package:webblen/models/community.dart';
import 'package:webblen/event_pages/event_details_page.dart';
import 'package:webblen/event_pages/create_event_page.dart';
import 'package:webblen/event_pages/event_attendees_page.dart';
import 'package:webblen/event_pages/event_edit_page.dart';
import 'package:webblen/user_pages/discover_page.dart';
import 'package:webblen/user_pages/community_profile_page.dart';
import 'package:webblen/user_pages/choose_post_type_page.dart';
import 'package:webblen/models/event.dart';
import 'package:webblen/user_pages/communities_page.dart';
import 'package:webblen/user_pages/community_new_page.dart';
import 'package:webblen/user_pages/community_post_comments_page.dart';
import 'package:webblen/user_pages/invite_members_page.dart';


class PageTransitionService{

  final BuildContext context;
  final bool isRecurring;
  final List userIDs;
  final String uid;
  final List<WebblenUser> usersList;
  final String username;
  final String areaName;

  final WebblenUser webblenUser;
  final WebblenUser currentUser;
  final WebblenChat chat;
  final String chatDocKey;
  final String peerUsername;
  final String peerProfilePic;
  final String profilePicUrl;
  final CommunityNewsPost newsPost;
  final WebblenReward reward;
  final Event event;
  final bool eventIsLive;
  final Community community;

  PageTransitionService({
    this.context, this.username, this.isRecurring,
    this.uid, this.usersList, this.webblenUser,
    this.currentUser, this.chat, this.chatDocKey,
    this.peerProfilePic, this.peerUsername, this.profilePicUrl,
    this.newsPost, this.reward, this.event,
    this.userIDs, this.eventIsLive, this.community,
    this.areaName
  });

  void transitionToRootPage () => Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (Route<dynamic> route) => false);
  void returnToRootPage () => Navigator.of(context).popUntil((route) => route.isFirst);
//  void transitionToEventListPage () =>  Navigator.push(context, SlideFromRightRoute(widget: EventCalendarPage(currentUser: currentUser)));
//  void transitionToEventEditPage () =>  Navigator.push(context, SlideFromRightRoute(widget: EventEditPage(event: event, currentUser: currentUser, eventIsLive: eventIsLive)));
  void transitionToChooseEventCreationPage () =>  Navigator.push(context, SlideFromRightRoute(widget: ChooseEventTypePage(currentUID: uid)));
  void transitionToNewEventPage () =>  Navigator.push(context, SlideFromRightRoute(widget: CreateEventPage(currentUser: currentUser, community: community, isRecurring: isRecurring)));
  void transitionToNewFlashEventPage () =>  Navigator.push(context, SlideFromRightRoute(widget: CreateFlashEventPage(currentUser: currentUser)));
  void transitionToEventPage () =>  Navigator.push(context, SlideFromRightRoute(widget: EventDetailsPage(event: event, currentUser: currentUser, eventIsLive: eventIsLive)));
  void transitionToShopPage () => Navigator.push(context, SlideFromRightRoute(widget: ShopPage(currentUser: currentUser)));
  void transitionToCheckInPage () =>  Navigator.push(context, SlideFromRightRoute(widget: EventCheckInPage(currentUser: currentUser)));
  void transitionToEventAttendeesPage () =>  Navigator.push(context, SlideFromRightRoute(widget: EventAttendeesPage(currentUser: currentUser, userIDs: userIDs)));
  void transitionToUserRanksPage () =>  Navigator.push(context, SlideFromRightRoute(widget: UserRanksPage(currentUser: currentUser)));
  void transitionToCreateRewardPage () =>  Navigator.push(context, SlideFromRightRoute(widget: CreateRewardPage()));
  void transitionToFriendsPage () =>  Navigator.push(context, SlideFromRightRoute(widget: FriendsPage(currentUser: currentUser)));
  void transitionToChatPage () =>  Navigator.push(context, SlideFromRightRoute(widget: Chat(chatDocKey: chatDocKey, currentUser: currentUser, peerProfilePic: peerProfilePic, peerUsername: peerUsername)));
  void transitionToMessagesPage () =>  Navigator.push(context, SlideFromRightRoute(widget: MessagesPage(currentUser: currentUser)));
  void transitionToUserDetailsPage () =>  Navigator.push(context, SlideFromRightRoute(widget: UserDetailsPage(currentUser: currentUser, webblenUser: webblenUser)));
  void transitionToWalletPage () =>  Navigator.push(context, SlideFromRightRoute(widget: WalletPage(currentUser: currentUser)));
  void transitionToDiscoverPage () =>  Navigator.push(context, SlideFromRightRoute(widget: DiscoverPage(currentUser: currentUser, areaName: areaName)));
  void transitionToMyCommunitiesPage () =>  Navigator.push(context, SlideFromRightRoute(widget: MyCommunitiesPage(currentUser: currentUser, areaName: areaName)));
  void transitionToNewCommunityPage () =>  Navigator.push(context, SlideFromRightRoute(widget: CreateCommunityPage(currentUser: currentUser, areaName: areaName)));
  void transitionToChoosePostTypePage () =>  Navigator.push(context, SlideFromRightRoute(widget: ChoosePostTypePage(currentUser: currentUser, community: community)));
  void transitionToPostCommentsPage () =>  Navigator.push(context, SlideFromRightRoute(widget: CommunityPostCommentsPage(currentUser: currentUser, newsPost: newsPost)));
  void transitionToCommunityProfilePage () =>  Navigator.push(context, SlideFromRightRoute(widget: CommunityProfilePage(currentUser: currentUser, community: community)));
  void transitionToCommunityInvitePage () =>  Navigator.push(context, SlideFromRightRoute(widget: InviteMembersPage(currentUser: currentUser, community: community)));
  void transitionToCommunityCreatePostPage () =>  Navigator.push(context, SlideFromRightRoute(widget: CommunityCreatePostPage(currentUser: currentUser, community: community)));
//  void transitionToCommunityBuilderPage () => Navigator.push(context, SlideFromRightRoute(widget: CommunityCreatePostPage(currentUser: currentUser, community: community)));
  void transitionToNotificationsPage () => Navigator.push(context, SlideFromRightRoute(widget: NotificationPage(currentUser: currentUser)));
  void transitionToUserSearchPage () => Navigator.push(context, SlideFromRightRoute(widget: UserSearchPage(currentUser: currentUser, usersList: usersList, userIDs: userIDs)));
  void transitionToSettingsPage () => Navigator.push(context, SlideFromRightRoute(widget: SettingsPage(currentUser: currentUser)));
  void transitionToRewardPayoutPage () => Navigator.push(context, SlideFromRightRoute(widget: RewardPayoutPage(redeemingReward: reward,currentUser: currentUser)));
  void transitionToTransactionHistoryPage () => Navigator.push(context, SlideFromRightRoute(widget: TransactionHistoryPage(currentUser: currentUser)));
  void transitionToWaitListPage () => Navigator.push(context, SlideFromRightRoute(widget: JoinWaitlistPage(currentUser: currentUser)));

}