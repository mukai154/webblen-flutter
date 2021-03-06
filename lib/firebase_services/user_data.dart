import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:webblen/models/event_post.dart';
import 'package:webblen/firebase_services/event_data.dart';

class UserDataService {

  final CollectionReference userRef = Firestore.instance.collection("users");
  final CollectionReference eventRef = Firestore.instance.collection("eventposts");
  final StorageReference storageReference = FirebaseStorage.instance.ref();
  final double degreeMinMax = 0.145;

  WebblenUser mapUserData(DocumentSnapshot data){
    WebblenUser user = new WebblenUser(
        blockedUsers: data['blockedUsers'],
        username: data['username'],
        uid: data['uid'],
        tags: data['tags'],
        profile_pic: data['profile_pic'],
        eventPoints: data['eventPoints'],
        userLat: data['userLat'],
        userLon: data['userLon'],
        lastCheckIn: data['lastCheckIn'],
        eventHistory: data['eventHistory']);
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

  Future<bool> checkIfUserExists(String username) async {
    QuerySnapshot querySnapshot = await userRef.where("username", isEqualTo: username).getDocuments();
    if (querySnapshot.documents.isNotEmpty){
      return true;
    } else {
      return false;
    }
  }

  Future<bool> createUser(File userImage, WebblenUser user, String uid) async {
    final String fileName = "$uid.jpg";
    final StorageUploadTask task = storageReference.child("profile_pics").child(fileName).putFile(userImage);
    final Uri downloadUrl = (await task.future).downloadUrl;

    user.profile_pic = downloadUrl.toString();
    user.userLat = 0.00;
    user.userLon = 0.00;
    user.eventHistory = [];
    user.eventPoints = 0;

    DateTime currentDateTime = DateTime.now();
    DateFormat formatter = new DateFormat("MM/dd/yyyy h:mm a");
    String lastCheckIn = formatter.format(currentDateTime);
    user.lastCheckIn = lastCheckIn;

    await Firestore.instance.collection("users").document(uid).setData(user.toMap()).whenComplete(() {
      return true;
    }).catchError((e) { return false; });
  }

  Future<String> currentUsername(String uid) async {
    DocumentSnapshot documentSnapshot = await userRef.document(uid).get();
    String username = documentSnapshot.data["username"];
    return username;
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

  Future<List> currentUserTags(String uid) async {
    DocumentSnapshot documentSnapshot = await userRef.document(uid).get();
    List tags = documentSnapshot.data["tags"];
    return tags;
  }

  Future<List<WebblenUser>> findNearbyUsers(double lat, double lon) async {
    print(lat);
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
    nearbyUsers..sort((a, b) => b.eventPoints.compareTo(a.eventPoints));
    return nearbyUsers;
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

    eventRef.document(event.eventKey).updateData({"attendees": attendees, "eventPayout": eventPayout}).whenComplete(() {
    }).catchError((e) {
      error = e.details;
    });
    return error;
  }


  Future<String> updateEventPoints(String uid, int newPoints) async {
    String error = "";
    DocumentSnapshot documentSnapshot = await userRef.document(uid).get();
    int pointCount = documentSnapshot.data["eventPoints"];
    pointCount += newPoints;
    userRef.document(uid).updateData({"eventPoints": pointCount}).whenComplete((){
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
}