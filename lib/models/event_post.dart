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
  int eventPayout;
  bool pointsDistributedToUsers;
  List attendees;
  double costToAttend;


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
    this.attendees
  });

  static eventTestPost(String key) {
    EventPost testPost = EventPost(
        eventKey: key,
        address: "1125 16th St N, Fargo ND, USA",
        author: "johndoe",
        authorImagePath: "https://www.rd.com/wp-content/uploads/2018/02/03_Hilarious-Photos-that-Will-Get-You-Through-the-Week_293553839_Kichigin-760x506.jpg",
        title: "Title Event 1",
        caption: "Fusce commodo nisl at arcu pretium semper. Sed eget magna ligula. Quisque a libero lacinia, commodo nisi lacinia, faucibus augue",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce pulvinar gravida velit in interdum. Fusce commodo nisl at arcu pretium semper. Sed eget magna ligula. Quisque a libero lacinia, commodo nisi lacinia, faucibus augue. Maecenas lacinia vulputate urna ut hendrerit. Aenean quam lacus, fermentum vitae odio vitae, ornare ultrices odio. Aliquam rhoncus eros eu eros lacinia, sed ullamcorper odio efficitur. Duis feugiat sapien at lacus vulputate, fermentum laoreet odio consectetur.",
        startDate: "01/01/2019",
        endDate: "01/02/2019",
        recurrenceType: "none",
        startTime: "12:00 PM",
        endTime: "11:00 PM",
        isAdmin: false,
        lat: 46.868459,
        lon: -96.797893,
        radius: 400.0,
        pathToImage: "https://images.unsplash.com/photo-1533461502717-83546f485d24?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=831bf6a64a9f4226415aec34ee335705&auto=format&fit=crop&w=668&q=80",
        tags: ["amusement", "food", "drink"],
        views: 101,
        estimatedTurnout: 0,
        actualTurnout: 0,
        fbSite: "https://www.facebook.com/webblenllc",
        twitterSite: "https://www.twitter.com/webblenllc",
        website: "https://www.webblen.io",
        eventPayout: 120,
        attendees: [],
        pointsDistributedToUsers: false,
        costToAttend: 2.00
    );

    return testPost;
  }

  static eventTestData() {
    List<EventPost> eventTestList = [
      eventTestPost("fdkafjepoae"),
      eventTestPost("kdakjdifpea"),
      eventTestPost("lkdjaifpefepa")
    ];
    return eventTestList;
  }

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
      eventPayout: data['eventPayout'],
      pointsDistributedToUsers: data['pointsDistributedToUsers'],
      attendees: data['attendees']);

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
    'pointsDistrubtedToUsers': this.pointsDistributedToUsers,
    'attendees': this.attendees
  };
}