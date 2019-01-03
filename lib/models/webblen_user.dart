class WebblenUser {

  List blockedUsers;
  String username;
  String uid;
  List tags;
  String profile_pic;
  double eventPoints;
  double impactPoints;
  double userLat;
  double userLon;
  String lastCheckIn;
  List eventHistory;
  List rewards;
  List savedEvents;
  List friends;
  List friendRequests;
  List achievements;
  bool isCommunityBuilder;
  bool isNewCommunityBuilder;
  bool notifyFlashEvents;
  bool notifyFriendRequests;
  bool notifyHotEvents;
  bool notifySuggestedEvents;
  String lastNotificationSentAt;
  int messageNotificationCount;
  int friendRequestNotificationCount;
  int achievementNotificationCount;
  int eventNotificationCount;
  int walletNotificationCount;
  int communityBuilderNotificationCount;
  int notificationCount;



  WebblenUser({
    this.blockedUsers,
    this.username,
    this.uid,
    this.tags,
    this.profile_pic,
    this.eventPoints,
    this.impactPoints,
    this.userLat,
    this.userLon,
    this.lastCheckIn,
    this.eventHistory,
    this.rewards,
    this.savedEvents,
    this.friends,
    this.friendRequests,
    this.achievements,
    this.notifyFlashEvents,
    this.notifyFriendRequests,
    this.notifyHotEvents,
    this.notifySuggestedEvents,
    this.lastNotificationSentAt,
    this.messageNotificationCount,
    this.friendRequestNotificationCount,
    this.achievementNotificationCount,
    this.eventNotificationCount,
    this.walletNotificationCount,
    this.isCommunityBuilder,
    this.communityBuilderNotificationCount,
    this.notificationCount,
    this.isNewCommunityBuilder
  });

  WebblenUser.fromMap(Map<String, dynamic> data)
      : this(blockedUsers: data['blockedUsers'],
      username: data['username'],
      uid: data['uid'],
      tags: data['tags'],
      profile_pic: data['profile_pic'],
      eventPoints: data['eventPoints'] * 1.00,
      impactPoints: data['impactPoints'] * 1.00,
      userLat: data['userLat'],
      userLon: data['userLon'],
      lastCheckIn: data['lastCheckIn'],
      eventHistory: data['eventHistory'],
      rewards: data['rewards'],
      savedEvents: data['savedEvents'],
      friends: data['friends'],
      friendRequests: data['friendRequests'],
      achievements: data['acheivements'],
      notifyFlashEvents: data['notifyFlashEvents'],
      notifyFriendRequests: data['notifyFriendRequests'],
      notifySuggestedEvents: data['notifySuggestedEvents'],
      lastNotificationSentAt: data['lastNotificationSentAt'],
      messageNotificationCount: data['messageNotificationCount'],
      friendRequestNotificationCount: data['friendRequestNotificationCount'],
      achievementNotificationCount: data['achievementNotificationCount'],
      eventNotificationCount: data['eventNotificationCount'],
      walletNotificationCount: data['walletNotificationCount'],
      isCommunityBuilder: data['isCommunityBuilder'],
      isNewCommunityBuilder: data['isNewCommunityBuilder'],
      communityBuilderNotificationCount: data['communityBuilderNotificationCount'],
      notificationCount: data['notificationCount']
  );

  Map<String, dynamic> toMap() => {
    'blockedUsers': this.blockedUsers,
    'username': this.username,
    'uid': this.uid,
    'profile_pic': this.profile_pic,
    'tags': this.tags,
    'eventPoints': this.eventPoints,
    'impactPoints': this.impactPoints,
    'userLat': this.userLat,
    'userLon': this.userLon,
    'lastCheckIn': this.lastCheckIn,
    'eventHistory': this.eventHistory,
    'rewards': this.rewards,
    'savedEvents': this.savedEvents,
    'friends': this.friends,
    'friendRequests': this.friendRequests,
    'achievements': this.achievements,
    'notifyFlashEvents': this.notifyFlashEvents,
    'notifyFriendRequests': this.notifyFriendRequests,
    'notifySuggestedEvents': this.notifySuggestedEvents,
    'lastNotificationSentAt': this.lastNotificationSentAt,
    'messageNotificationCount': this.messageNotificationCount,
    'friendRequestNotificationCount': this.friendRequestNotificationCount,
    'achievementNotificationCount': this.achievementNotificationCount,
    'eventNotificationCount': this.eventNotificationCount,
    'walletNotificationCount': this.walletNotificationCount,
    'isCommunityBuilder': this.isCommunityBuilder,
    'communityBuilderNotificationCount': this.communityBuilderNotificationCount,
    'isNewCommunityBuilder': this.isNewCommunityBuilder,
    'notificationCount': this.notificationCount
  };
}