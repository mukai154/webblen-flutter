class WebblenUser {

  List blockedUsers;
  String username;
  String uid;
  List tags;
  String profile_pic;

  WebblenUser({
    this.blockedUsers,
    this.username,
    this.uid,
    this.tags,
    this.profile_pic,
  });

  WebblenUser.fromMap(Map<String, dynamic> data)
      : this(blockedUsers: data['blockedUsers'],
      username: data['username'],
      uid: data['uid'],
      tags: data['tags'],
      profile_pic: data['profile_pic']);

  Map<String, dynamic> toMap() => {
    'blockedUsers': this.blockedUsers,
    'username': this.username,
    'uid': this.uid,
    'profile_pic': this.profile_pic,
    'tags': this.tags
  };
}