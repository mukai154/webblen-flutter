class WebblenUser {

  List blockedUsers;
  String username;
  String uid;
  List tags;
  String profile_pic;
  int eventPoints;
  double userLat;
  double userLon;
  String lastCheckIn;
  List eventHistory;

  WebblenUser({
    this.blockedUsers,
    this.username,
    this.uid,
    this.tags,
    this.profile_pic,
    this.eventPoints,
    this.userLat,
    this.userLon,
    this.lastCheckIn,
    this.eventHistory
  });

  WebblenUser.fromMap(Map<String, dynamic> data)
      : this(blockedUsers: data['blockedUsers'],
      username: data['username'],
      uid: data['uid'],
      tags: data['tags'],
      profile_pic: data['profile_pic'],
      eventPoints: data['eventPoints'],
      userLat: data['userLat'],
      userLon: data['userLon'],
      lastCheckIn: data['lastCheckIn'],
      eventHistory: data['eventHistory']);

  Map<String, dynamic> toMap() => {
    'blockedUsers': this.blockedUsers,
    'username': this.username,
    'uid': this.uid,
    'profile_pic': this.profile_pic,
    'tags': this.tags,
    'eventPoints': this.eventPoints,
    'userLat': this.userLat,
    'userLon': this.userLon,
    'lastCheckIn': this.lastCheckIn,
    'eventHistory': this.eventHistory
  };
}