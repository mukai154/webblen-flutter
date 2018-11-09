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
  List achievements;

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
    this.rewards
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
      rewards: data['rewards']
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
    'rewards': this.rewards
  };
}