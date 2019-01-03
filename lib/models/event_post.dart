class EventPost {

  String eventKey;
  String address;
  String author;
  String authorImagePath;
  String title;
  String caption;
  String description;
  String startDate;
  String endDate;
  String recurrenceType;
  String startTime;
  String endTime;
  bool isAdmin;
  double lat;
  double lon;
  double radius;
  String pathToImage;
  List tags;
  int views;
  int estimatedTurnout;
  int actualTurnout;
  String fbSite;
  String twitterSite;
  String website;
  double eventPayout;
  bool pointsDistributedToUsers;
  List attendees;
  double costToAttend;
  bool flashEvent;
  String startDateInMilliseconds;
  String endDateInMilliseconds;


  EventPost({
    this.eventKey,
    this.address,
    this.author,
    this.authorImagePath,
    this.title,
    this.caption,
    this.description,
    this.startDate,
    this.endDate,
    this.recurrenceType,
    this.startTime,
    this.endTime,
    this.isAdmin,
    this.lat,
    this.lon,
    this.radius,
    this.pathToImage,
    this.tags,
    this.views,
    this.estimatedTurnout,
    this.actualTurnout,
    this.fbSite,
    this.twitterSite,
    this.website,
    this.costToAttend,
    this.eventPayout,
    this.pointsDistributedToUsers,
    this.attendees,
    this.flashEvent,
    this.startDateInMilliseconds,
    this.endDateInMilliseconds
  });

  EventPost.fromMap(Map<String, dynamic> data)
      : this(eventKey: data['eventKey'],
      address: data['address'],
      author: data['author'],
      authorImagePath: data['authorImagePath'],
      title: data['title'],
      caption: data['caption'],
      description: data['description'],
      startDate: data['startDate'],
      endDate: data['endDate'],
      recurrenceType: data['recurrenceType'],
      startTime: data['startTime'],
      endTime: data['endTime'],
      isAdmin: data['isAdmin'],
      lat: data['lat'],
      lon: data['lon'],
      radius: data['radius'],
      pathToImage: data['pathToImage'],
      tags: data['tags'],
      views: data['views'],
      estimatedTurnout: data['estimatedTurnout'],
      actualTurnout: data['actualTurnout'],
      fbSite: data['fbSite'],
      twitterSite: data['twitterSite'] ?? false,
      website: data['website'],
      costToAttend: data['costToAttend'],
      eventPayout: data['eventPayout'] * 1.0,
      pointsDistributedToUsers: data['pointsDistributedToUsers'],
      attendees: data['attendees'],
      flashEvent: data['flashEvent'],
      startDateInMilliseconds: data['startDateInMilliseconds'],
      endDateInMilliseconds: data['endDateInMilliseconds']
  );

  Map<String, dynamic> toMap() => {
    'eventKey': this.eventKey,
    'address': this.address,
    'author': this.author,
    'authorImagePath': this.authorImagePath,
    'title': this.title,
    'caption': this.caption,
    'description': this.description,
    'startDate': this.startDate,
    'endDate': this.endDate,
    'recurrenceType': this.recurrenceType,
    'startTime': this.startTime,
    'endTime': this.endTime,
    'isAdmin': this.isAdmin,
    'lat': this.lat,
    'lon': this.lon,
    'radius': this.radius,
    'pathToImage': this.pathToImage,
    'tags': this.tags,
    'views': this.views,
    'estimatedTurnout': this.estimatedTurnout,
    'actualTurnout': this.actualTurnout,
    'fbSite': this.fbSite,
    'twitterSite': this.twitterSite,
    'website': this.website,
    'costToAttend': this.costToAttend,
    'eventPayout': this.eventPayout,
    'pointsDistributedToUsers': this.pointsDistributedToUsers,
    'attendees': this.attendees,
    'flashEvent': this.flashEvent,
    'startDateInMilliseconds': this.startDateInMilliseconds,
    'endDateInMilliseconds': this.endDateInMilliseconds
  };
}