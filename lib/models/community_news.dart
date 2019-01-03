class CommunityNewsPost {

  String timestamp;
  String newsTitle;
  String newsImageUrl;
  String newsUrl;
  String username;
  String userImageUrl;
  String content;
  String contentType;
  bool isGlobal;
  double lat;
  double lon;
  bool alwaysDisplay;


  CommunityNewsPost({
    this.timestamp,
    this.newsTitle,
    this.newsImageUrl,
    this.newsUrl,
    this.username,
    this.userImageUrl,
    this.content,
    this.contentType,
    this.isGlobal,
    this.lat,
    this.lon,
    this.alwaysDisplay
  });

  CommunityNewsPost.fromMap(Map<String, dynamic> data)
      : this(
      timestamp: data['timestamp'],
      newsTitle: data['newsTitle'],
      newsImageUrl: data['newsImageUrl'],
      newsUrl: data['newsUrl'],
      username: data['username'],
      userImageUrl: data['userImageUrl'],
      content: data['content'],
      contentType: data['contentType'],
      isGlobal: data['isGlobal'],
      lat: data['lat'],
      lon: data['lon'],
      alwaysDisplay: data['alwaysDisplay']
  );

  Map<String, dynamic> toMap() => {
    'timestamp': this.timestamp,
    'newsTitle': this.newsTitle,
    'newsImageUrl': this.newsImageUrl,
    'newsUrl': this.newsUrl,
    'userImageUrl': this.userImageUrl,
    'username': this.username,
    'content': this.content,
    'contentType': this.contentType,
    'isGlobal': this.isGlobal,
    'lat': this.lat,
    'lon': this.lon,
    'alwaysDisplay': this.alwaysDisplay
  };
}