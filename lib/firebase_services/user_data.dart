import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:webblen/models/event_post.dart';
import 'package:webblen/firebase_services/event_data.dart';
import 'notification_data.dart';
import 'package:webblen/models/webblen_notification.dart';

class UserDataService {

  final CollectionReference userRef = Firestore.instance.collection("users");
  final CollectionReference eventRef = Firestore.instance.collection("eventposts");
  final CollectionReference questionRef = Firestore.instance.collection("question_user");
  final StorageReference storageReference = FirebaseStorage.instance.ref();
  final double degreeMinMax = 0.145;

  WebblenUser mapUserData(DocumentSnapshot data){
    WebblenUser user = new WebblenUser(
        blockedUsers: data['blockedUsers'],
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
    return user;
  }

  Future<bool> checkIfUserExistsByUID(String uid) async {
    DocumentSnapshot documentSnapshot = await userRef.document(uid).get();
    if (documentSnapshot.exists){
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkIfNewUser(String uid) async {
    DocumentSnapshot documentSnapshot = await userRef.document(uid).get();
    if (documentSnapshot.data["isNewUser"] == null){
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateNewUser(String uid) async {
    userRef.document(uid).updateData({"isNewUser": false}).whenComplete(() {
      return true;
    }).catchError((e) {
      return false;
    });
  }

  Future<bool> checkIfUserExists(String username) async {
    QuerySnapshot querySnapshot = await userRef.where("username", isEqualTo: username).getDocuments();
    if (querySnapshot.documents.isNotEmpty){
      return true;
    } else {
      return false;
    }
  }

  Future<bool> createUser(File userImage, WebblenUser user, String uid) async {
    String fileName = "$uid.jpg";
    storageReference.child("profile_pics").child(fileName).putFile(userImage);
    String downloadUrl = await storageReference.child("profile_pics").child(fileName).getDownloadURL();

    user.profile_pic = downloadUrl;
    user.userLat = 0.00;
    user.userLon = 0.00;
    user.eventHistory = [];
    user.savedEvents = [];
    user.achievements = [];
    user.friends = [];
    user.friendRequests = [];
    user.notifySuggestedEvents = true;
    user.notifyHotEvents = true;
    user.notifyFriendRequests = true;
    user.notifyFlashEvents = true;
    user.eventPoints = 0.00;

    DateTime currentDateTime = DateTime.now();
    DateFormat formatter = new DateFormat("MM/dd/yyyy h:mm a");
    String lastCheckIn = formatter.format(currentDateTime);
    user.lastCheckIn = lastCheckIn;
    user.lastNotificationSentAt = lastCheckIn;

    await Firestore.instance.collection("users").document(uid).setData(user.toMap()).whenComplete(() {
      return true;
    }).catchError((e) { return false; });
  }

  Future<String> currentUsername(String uid) async {
    DocumentSnapshot documentSnapshot = await userRef.document(uid).get();
    String username = documentSnapshot.data["username"];
    return username;
  }

  Future<String> findProfilePicUrl(String uid) async {
    DocumentSnapshot documentSnapshot = await userRef.document(uid).get();
    String profilePicUrl = documentSnapshot.data["profile_pic"];
    return profilePicUrl;
  }

  Future<WebblenUser> findUserByID(String uid) async {
    DocumentSnapshot documentSnapshot = await userRef.document(uid).get();
    WebblenUser user = WebblenUser.fromMap(documentSnapshot.data);
    return user;
  }

  Future<List> eventHistory(String uid) async {
    DocumentSnapshot documentSnapshot = await userRef.document(uid).get();
    List eventHistory = documentSnapshot.data["eventHistory"];
    return eventHistory;
  }

  Future<String> userImagePath(String uid) async {
    DocumentSnapshot documentSnapshot = await userRef.document(uid).get();
    String pathToImage = documentSnapshot.data["profile_pic"];
    return pathToImage;
  }

  Future<double> userPoints(String uid) async {
    DocumentSnapshot documentSnapshot = await userRef.document(uid).get();
    double points = documentSnapshot.data["eventPoints"] * 1.00;
    return points;
  }

  Future<List> currentUserTags(String uid) async {
    DocumentSnapshot documentSnapshot = await userRef.document(uid).get();
    List tags = documentSnapshot.data["tags"];
    return tags;
  }

  Future<List> currentUserRewards(String uid) async {
    DocumentSnapshot documentSnapshot = await userRef.document(uid).get();
    List rewards = documentSnapshot.data["rewards"];
    return rewards;
  }

  Future<List<WebblenUser>> findNearbyUsers(double lat, double lon) async {
    double latMax = lat + degreeMinMax;
    double latMin = lat - degreeMinMax;
    double lonMax = lon + degreeMinMax;
    double lonMin = lon - degreeMinMax;

    List<WebblenUser> nearbyUsers = [];

    QuerySnapshot querySnapshot = await userRef.where('userLat', isLessThanOrEqualTo: latMax).getDocuments();
    var eventsSnapshot = querySnapshot.documents;
    eventsSnapshot.forEach((userDoc){
      double lat = userDoc["userLat"];
      double lon = userDoc["userLon"];
      if (lat >= latMin && lon >= lonMin && lon <= lonMax){
        WebblenUser user = mapUserData(userDoc);
        nearbyUsers.add(user);
      }
    });
    nearbyUsers..sort((a, b) => b.eventHistory.length.compareTo(a.eventHistory.length));
    return nearbyUsers;
  }

  Future<double> calculateCompatibility(String uid, WebblenUser otherUser) async {
    double compatibility = 0.01;
    int numberOfSharedTags = 0;
    List userTags = await currentUserTags(uid);
    if (otherUser.tags.length > 0 && userTags.length > 0){
      otherUser.tags.forEach((tag){
        if (userTags.contains(tag)){
          numberOfSharedTags += 1;
        }
      });
      compatibility = numberOfSharedTags / userTags.length;
    }
    return compatibility;
  }

  Future<bool> updateTags(String uid, List tags) async {
    userRef.document(uid).updateData({"tags": tags}).whenComplete(() {
      return true;
    }).catchError((e) {
      return false;
    });
  }

  Future<String> updateUserCheckIn(String uid, double lat, double lon) async {
    String error = "";
    DateTime currentDateTime = DateTime.now();
    DateFormat formatter = new DateFormat("MM/dd/yyyy h:mm a");
    String lastCheckIn = formatter.format(currentDateTime);
    userRef.document(uid).updateData({"userLat": lat, "userLon" : lon, "lastCheckIn" : lastCheckIn}).whenComplete(() {
      return error;
    }).catchError((e) {
      error = e.details;
      return error;
    });
  }

  Future<String> eventCheckInStatus(String uid) async {
    String timeCheckInIsAvailable = "";
    DateTime currentDateTime = DateTime.now();
    DateFormat formatter = new DateFormat("MM/dd/yyyy h:mm a");
    DocumentSnapshot documentSnapshot = await userRef.document(uid).get();
    String eventCheckIn = documentSnapshot.data["eventCheckIn"] == null ? "01/01/2010 10:00 AM" : documentSnapshot.data["eventCheckIn"];
    DateTime eventCheckInDateTime = formatter.parse(eventCheckIn);
    if (currentDateTime.isAfter(eventCheckInDateTime.add(Duration(hours: 2)))){
      return timeCheckInIsAvailable;
    } else {
      eventCheckInDateTime = eventCheckInDateTime.add(Duration(hours: 2));
      timeCheckInIsAvailable = formatter.format(eventCheckInDateTime);
      return timeCheckInIsAvailable;
    }
  }

  Future<String> updateEventCheckIn(String uid, EventPost event) async {
    String error = "";
    String eventEnd = event.endTime;
    DateTime currentDateTime = DateTime.now();
    DateFormat formatter = new DateFormat("MM/dd/yyyy h:mm a");
    String lastCheckIn = formatter.format(currentDateTime);
    DocumentSnapshot documentSnapshot = await userRef.document(uid).get();
    List eventsAttended = documentSnapshot["eventHistory"];
    eventsAttended = eventsAttended.toList(growable: true);
    eventsAttended.add(event.eventKey);
    userRef.document(uid).updateData({"eventCheckIn": lastCheckIn, "eventHistory": eventsAttended}).whenComplete(() {
    }).catchError((e) {
      error = e.details;
    });
    List attendees = event.attendees == null ? [] : event.attendees.toList(growable: true);
    if (!attendees.contains(uid)){
      attendees.add(uid);
    }
    double payoutMultiplier = EventPostService().getAttendanceMultiplier(attendees.length);
    int eventPayout = (attendees.length * payoutMultiplier).round();
    if (event.flashEvent){
      DateFormat timeFormatter = DateFormat("h:mm a");
      String eventEndTime = event.startDate + " " + event.endTime;
      DateTime formattedEndTime = formatter.parse(eventEndTime);
      eventEnd = timeFormatter.format(formattedEndTime.add(Duration(minutes: 10)));
    }
    eventRef.document(event.eventKey).updateData({"attendees": attendees, "eventPayout": eventPayout, "endTime": eventEnd}).whenComplete(() {
    }).catchError((e) {
      error = e.details;
    });
    return error;
  }


  Future<String> updateEventPoints(String uid, double newPoints) async {
    String error = "";
    DocumentSnapshot documentSnapshot = await userRef.document(uid).get();
    double pointCount = documentSnapshot.data["eventPoints"] * 1.00;
    pointCount += newPoints;
    userRef.document(uid).updateData({"eventPoints": pointCount}).whenComplete((){
      return error;
    }).catchError((e) {
      error = e.details;
      return error;
    });
  }

  Future<String> powerUpPoints(String uid, double powerUpAmount) async {
    String error = "";
    DocumentSnapshot documentSnapshot = await userRef.document(uid).get();
    double pointCount = documentSnapshot.data["eventPoints"] * 1.00;
    double impactCount = documentSnapshot.data["impactPoints"] * 1.00;
    pointCount -= powerUpAmount;
    impactCount += powerUpAmount;
    userRef.document(uid).updateData({"eventPoints": pointCount, "impactPoints": impactCount}).whenComplete((){
      return error;
    }).catchError((e) {
      error = e.details;
      return error;
    });
  }

  Future<Null> addUserDataField(String dataName, dynamic data) async {
    QuerySnapshot querySnapshot = await userRef.getDocuments();
    querySnapshot.documents.forEach((doc){
      userRef.document(doc.documentID).updateData({"$dataName": data}).whenComplete(() {

      }).catchError((e) {

      });
    });

  }

  Future<String> setUserCloudMessageToken(String uid, String messageToken) async {
    String error = "";
    userRef.document(uid).updateData({"messageToken": messageToken}).whenComplete((){
      return error;
    }).catchError((e) {
      error = e.details;
      return error;
    });

  }

  //Questions
  Future<Map<String, dynamic>> retrieveMultipleChoiceQuestion(String uid) async {
    DocumentSnapshot questionSnapshot = await questionRef.document("multiple_choice").get();
    Map<String, dynamic> questionData = questionSnapshot.data;
    String dataVal = questionData["dataVal"];
    DocumentSnapshot userSnapshot =  await userRef.document(uid).get();
    Map<String, dynamic> userData = userSnapshot.data;
    if (userData[dataVal] != null){
      return null;
    } else {
      return questionData;
    }
  }

  Future<String> submitAnswerData(String uid, String dataVal, String answer) async {
    String error = "";
    userRef.document(uid).updateData({dataVal: answer}).whenComplete((){
      return error;
    }).catchError((e) {
      error = e.details;
      return error;
    });
  }

  Future<DocumentSnapshot> retrieveYesOrNoQuestion() async {
    DocumentSnapshot documentSnapshot = await questionRef.document("yes_or_no").get();
    return documentSnapshot;
  }

  Future<DocumentSnapshot> retrieveOpenQuestion() async {
    DocumentSnapshot documentSnapshot = await questionRef.document("open").get();
    return documentSnapshot;
  }

  Future<String> addFriend(String currentUid, String currentUsername, String uid) async {
    String requestStatus;
    DocumentSnapshot documentSnapshot = await userRef.document(uid).get();
    List friendsRequestsList= documentSnapshot.data["friendRequests"];
    int userNotificationCount = documentSnapshot.data["notificationCount"];
    friendsRequestsList = friendsRequestsList.toList(growable: true);
    friendsRequestsList.add(currentUid);
    userNotificationCount += 1;
    await userRef.document(uid).updateData({"friendRequests": friendsRequestsList, "notificationCount": userNotificationCount}).whenComplete(() {
      requestStatus = "success";
      NotificationDataService().addFriendRequestNotification(uid, currentUid, currentUsername);
    }).catchError((e) {
      requestStatus = e.details;
    });
    return requestStatus;
  }

  Future<String> confirmFriend(String currentUid, String uid) async {
    String requestStatus;
    DocumentSnapshot ownUserSnapshot = await userRef.document(currentUid).get();
    DocumentSnapshot otherUserSnapshot = await userRef.document(uid).get();
    List friendRequests = ownUserSnapshot.data["friendRequests"];
    List ownUserFriendsList= ownUserSnapshot.data["friends"];
    List otherUserFriendsList= otherUserSnapshot.data["friends"];
    friendRequests = friendRequests.toList(growable: true);
    ownUserFriendsList = ownUserFriendsList.toList(growable: true);
    otherUserFriendsList = otherUserFriendsList.toList(growable: true);
    friendRequests.remove(uid);
    ownUserFriendsList.add(uid);
    otherUserFriendsList.add(currentUid);

    await userRef.document(uid).updateData({"friends": otherUserFriendsList}).whenComplete(() {
      userRef.document(currentUid).updateData({"friends": ownUserFriendsList, "friendRequests" : friendRequests}).whenComplete(() {
        requestStatus = "success";
      }).catchError((e) {
        requestStatus = e.details;
      });
    }).catchError((e) {
      requestStatus = e.details;
    });
    return requestStatus;
  }

  Future<String> denyFriend(String currentUid, String uid) async {
    String requestStatus;
    DocumentSnapshot ownUserSnapshot = await userRef.document(currentUid).get();
    List friendRequests = ownUserSnapshot.data["friendRequests"];
    friendRequests = friendRequests.toList(growable: true);
    friendRequests.remove(uid);
    await userRef.document(currentUid).updateData({"friendRequests" : friendRequests}).whenComplete(() {
      requestStatus = "success";
    }).catchError((e) {
      requestStatus = e.details;
    });
    return requestStatus;
  }

  Future<String> removeFriend(String currentUid, String uid) async {
    String requestStatus;
    DocumentSnapshot ownUserSnapshot = await userRef.document(currentUid).get();
    DocumentSnapshot otherUserSnapshot = await userRef.document(uid).get();
    List ownUserFriendsList= ownUserSnapshot.data["friends"];
    List otherUserFriendsList= otherUserSnapshot.data["friends"];
    ownUserFriendsList = ownUserFriendsList.toList(growable: true);
    otherUserFriendsList = otherUserFriendsList.toList(growable: true);
    ownUserFriendsList.remove(uid);
    otherUserFriendsList.remove(currentUid);

    await userRef.document(uid).updateData({"friends": otherUserFriendsList}).whenComplete(() {
      userRef.document(currentUid).updateData({"friends": ownUserFriendsList}).whenComplete(() {
        requestStatus = "success";
      }).catchError((e) {
        requestStatus = e.details;
      });
    }).catchError((e) {
      requestStatus = e.details;
    });
    return requestStatus;
  }

  Future<String> checkFriendStatus(String currentUid, String uid) async {
    String friendStatus;
    DocumentSnapshot documentSnapshot = await userRef.document(uid).get();
    List friendsList = documentSnapshot.data["friends"];
    if (friendsList.contains(currentUid)){
      friendStatus = "friends";
    } else {
      List friendRequests = documentSnapshot.data["friendRequests"];
      if (friendRequests.contains(currentUid)) {
        friendStatus = "pending";
      } else {
        friendStatus = "not friends";
      }
    }
    return friendStatus;
  }

  Future<List> getFriendsList(String uid) async {
    List friends = [];
    DocumentSnapshot documentSnapshot = await userRef.document(uid).get();
    List friendUIDs = documentSnapshot.data["friends"];
    friendUIDs.forEach((friendUID){
      findUserByID(friendUID).then((friend){
        friends.add(friend);
      });
    });
    return friends;
  }

  Future<List> getFriendRequestIDs(String uid) async {
    DocumentSnapshot documentSnapshot = await userRef.document(uid).get();
    List friendRequests = documentSnapshot.data["friendRequests"];
    return friendRequests;
  }

}