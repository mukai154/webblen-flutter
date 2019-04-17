import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:webblen/models/event_post.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:webblen/utils/custom_dates.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'firebase_notification_services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class EventPostService {

  Geoflutterfire geo = Geoflutterfire();
  final CollectionReference eventRef = Firestore.instance.collection("eventposts");
  final CollectionReference userRef = Firestore.instance.collection("users");
  final StorageReference storageReference = FirebaseStorage.instance.ref();
  final double degreeMinMax = 0.145;
  final double checkInDegreeMinMax = 0.0009;

  getAttendanceMultiplier(int attendanceCount){
    double multiplier = 0.75;
    if (attendanceCount > 5 && attendanceCount <= 10){
      multiplier = 0.85;
    } else if (attendanceCount > 10 && attendanceCount <= 20){
      multiplier = 1.00;
    } else if (attendanceCount > 20 && attendanceCount <= 100){
      multiplier = 1.25;
    } else if (attendanceCount > 100 && attendanceCount <= 500){
      multiplier = 1.75;
    } else if (attendanceCount > 500 && attendanceCount <= 1000){
      multiplier = 2.00;
    } else if (attendanceCount > 1000 && attendanceCount <= 2000){
      multiplier = 2.15;
    } else if (attendanceCount > 2000){
      multiplier = 2.5;
    }
    return multiplier;
  }

  Future<Null> updateAllEvents() async{
    QuerySnapshot snapshot = await eventRef.getDocuments();
    snapshot.documents.forEach((doc){
      if (doc.data['lat'] != null && doc.data['lon'] != null){
        double lat = doc.data['lat'];
        double lon = doc.data['lon'];
        GeoFirePoint newLocation = geo.point(latitude: lat, longitude: lon);
        eventRef.document(doc.documentID).updateData({"location": newLocation.data}).whenComplete(() {
        }).catchError((e) {
        });
      }
    });
  }

  Future<String> uploadEvent(File eventImage, EventPost event, String username) async {
    String error = '';
    final String eventKey = "${Random().nextInt(999999999)}";
    String fileName = "$eventKey.jpg";
    String downloadUrl = await uploadEventImage(eventImage, fileName);
    event.pathToImage = downloadUrl;
    event.eventKey = eventKey;
    event.author = username;
    await Firestore.instance.collection("eventposts").document(eventKey).setData(event.toMap()).whenComplete(() {
    }).catchError((e) {
      error = e.toString();
    });
    return error;
  }

  Future<String> uploadEventImage(File eventImage, String fileName) async {
    StorageReference ref = storageReference.child("events").child(fileName);
    StorageUploadTask uploadTask = ref.putFile(eventImage);
    String downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL() as String;
    return downloadUrl;
  }

  Future<String> updateEventImage(File eventImage, String fileName) async {
    StorageReference ref = storageReference.child("events").child(fileName);
    StorageUploadTask uploadTask = ref.putFile(eventImage);
    String downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL() as String;
    return downloadUrl;
  }

  Future<String> updateEvent(EventPost eventPost) async {
    String status = "";
    eventRef.document(eventPost.eventKey).setData(eventPost.toMap()).whenComplete((){
    }).catchError((e) {
      status = e.details;
    });
    return status;
  }

  Future<String> updateEventWithImage(EventPost eventPost, File newImage) async {
    String status = "";
    String imgUrl = await updateEventImage(newImage, "${eventPost.eventKey}.jpg");
    eventPost.pathToImage = imgUrl;
    eventRef.document(eventPost.eventKey).setData(eventPost.toMap()).whenComplete((){
    }).catchError((e) {
      status = e.details;
    });
    return status;
  }



  Future<int> eventCountByUser(String username) async {
    QuerySnapshot querySnapshot = await eventRef.where('author', isEqualTo: username).getDocuments();
    var eventsSnapshot = querySnapshot.documents;
    return eventsSnapshot.length;
  }


  Future<List<DocumentSnapshot>> findEventsNearLocation(double lat, double lon) async {
    double latMax = lat + degreeMinMax;
    double latMin = lat - degreeMinMax;
    double lonMax = lon + degreeMinMax;
    double lonMin = lon - degreeMinMax;

    List<DocumentSnapshot> nearbyEvents = [];

    QuerySnapshot querySnapshot = await eventRef.where('lat', isLessThanOrEqualTo: latMax).getDocuments();
    List eventsSnapshot = querySnapshot.documents;
    eventsSnapshot.forEach((eventDoc){
      if (eventDoc["lat"] >= latMin && eventDoc["lon"] >= lonMin && eventDoc["lon"] <= lonMax && eventDoc["flashEvent"] == false){
        nearbyEvents.add(eventDoc);

      }
    });

    return nearbyEvents;
  }

//  Future<Null> setEventGeoFences(double lat, double lon) async {
//    double latMax = lat + degreeMinMax;
//    double latMin = lat - degreeMinMax;
//    double lonMax = lon + degreeMinMax;
//    double lonMin = lon - degreeMinMax;
//
//    int currentDateTime = DateTime.now().millisecondsSinceEpoch;
//    List<bg.Geofence> eventGeofences = [];
//
//    QuerySnapshot querySnapshot = await eventRef.where('lat', isLessThanOrEqualTo: latMax).getDocuments();
//    List eventsSnapshot = querySnapshot.documents;
//    eventsSnapshot.forEach((eventDoc){
//      if (eventDoc["lat"] >= latMin && eventDoc["lon"] >= lonMin && eventDoc["lon"] <= lonMax && eventDoc["flashEvent"] == false){
//        int eventStartDateTime = int.parse(eventDoc["startDateInMilliseconds"]);
//        int eventEndDateTime = int.parse(eventDoc["endDateInMilliseconds"]);
//        if (currentDateTime >= eventStartDateTime && currentDateTime <= eventEndDateTime){
//          EventPost event = EventPost.fromMap(eventDoc.data);
//          bg.Geofence eventGeofence = bg.Geofence(
//            identifier: event.title,
//            radius: event.radius,
//            latitude: event.lat,
//            longitude: event.lon,
//            notifyOnEntry: true,
//          );
//          eventGeofences.add(eventGeofence);
//        }
//      }
//      bg.BackgroundGeolocation.addGeofences(eventGeofences);
//    });
//
//  }
//
//  configureGeoFenceEvents(){
//    bg.BackgroundGeolocation.onGeofence((bg.GeofenceEvent event) { print('onGeofence $event'); });
//  }

  Future<List<EventPost>> findEventsForCheckIn(double lat, double lon) async {
    double latMax = lat + checkInDegreeMinMax;
    double latMin = lat - checkInDegreeMinMax;
    double lonMax = lon + checkInDegreeMinMax;
    double lonMin = lon - checkInDegreeMinMax;

    int currentDateTime = DateTime.now().millisecondsSinceEpoch;


    List<EventPost> nearbyEvents = [];

    QuerySnapshot querySnapshot = await eventRef.where('lat', isLessThanOrEqualTo: latMax).getDocuments();
    var eventsSnapshot = querySnapshot.documents;
    eventsSnapshot.forEach((eventDoc){
      if (eventDoc["lat"] >= latMin && eventDoc["lon"] >= lonMin && eventDoc["lon"] <= lonMax){
        int eventStartDateTime = int.parse(eventDoc["startDateInMilliseconds"]);
        int eventEndDateTime = int.parse(eventDoc["endDateInMilliseconds"]);
        if (currentDateTime >= eventStartDateTime && currentDateTime <= eventEndDateTime){
          EventPost event = EventPost.fromMap(eventDoc.data);
          nearbyEvents.add(event);

        }
      }
    });

    return nearbyEvents;
  }

  Future<bool> checkInFound(double lat, double lon) async {
    bool checkInFound = false;
    double latMax = lat + checkInDegreeMinMax;
    double latMin = lat - checkInDegreeMinMax;
    double lonMax = lon + checkInDegreeMinMax;
    double lonMin = lon - checkInDegreeMinMax;

    int currentDateTime = DateTime.now().millisecondsSinceEpoch;

    QuerySnapshot querySnapshot = await eventRef.where('lat', isLessThanOrEqualTo: latMax).getDocuments();
    var eventsSnapshot = querySnapshot.documents;
    eventsSnapshot.forEach((eventDoc){
      if (eventDoc["lat"] >= latMin && eventDoc["lon"] >= lonMin && eventDoc["lon"] <= lonMax){
        int eventStartDateTime = int.parse(eventDoc["startDateInMilliseconds"]);
        int eventEndDateTime = int.parse(eventDoc["endDateInMilliseconds"]);
        if (currentDateTime >= eventStartDateTime && currentDateTime <= eventEndDateTime){
          checkInFound = true;
          return;
        }
      }
    });

    return checkInFound;
  }

  Future<EventPost> findEventByKey(String eventKey) async {
    EventPost event;
    DocumentSnapshot eventDoc = await eventRef.document(eventKey).get();
    if (eventDoc.exists){
      event = EventPost.fromMap(eventDoc.data);
    }
    return event;
  }

  Future<Null> saveEvent(String eventKey, String uid) async {
    DocumentSnapshot userDoc = await userRef.document(uid).get();
    List savedEvents = userDoc['savedEvents'];
    savedEvents = savedEvents.toList(growable: true);
    savedEvents.add(eventKey);
    userRef.document(uid).updateData({"savedEvents": savedEvents}).whenComplete((){
    }).catchError((e) {
    });
  }

  Future<List<EventPost>> filterEventsByDate(List<EventPost> events, String dateType) async {
    DateFormat formatter = new DateFormat("MM/dd/yyyy");
    DateTime today = DateTime.now();
    List<EventPost> filteredEventList = [];
    events.forEach((event){
      DateTime eventDate = formatter.parse(event.startDate);
      if (eventDate.month == today.month && eventDate.day == today.day && dateType == "today"){
        filteredEventList.add(event);
      } else if (eventDate.difference(today) <= Duration(days: 1) && eventDate.isAfter(today) && dateType == "tomorrow"){
        filteredEventList.add(event);
      } else if (eventDate.difference(today) <= Duration(days: 7) && eventDate.isAfter(today) && dateType == "this week"){
        filteredEventList.add(event);
      } else if (eventDate.difference(today) <= Duration(days: 14) && eventDate.isAfter(today) && dateType == "next week"){
        filteredEventList.add(event);
      } else if (eventDate.difference(today) <= Duration(days: 31) && eventDate.month == today.month && eventDate.isAfter(today) && dateType == "this month"){
        filteredEventList.add(event);
      } else if (eventDate.isAfter(today) && event.recurrenceType == "none") {
        filteredEventList.add(event);
      }
    });
    return filteredEventList;
  }

  Future<List<EventPost>> eventsHappeningNow(List<EventPost> events) async {
    DateFormat timeFormatter = new DateFormat("MM/dd/yyyy h:mm a");
    List<EventPost> filteredEventList = [];
    DateTime currentDateTime = new DateTime.now();
    events.forEach((event){
      String eventStart = event.startDate + " " + event.startTime;
      String eventEnd = event.startDate + " " + event.endTime;
      DateTime eventStartDateTime = timeFormatter.parse(eventStart);
      DateTime eventEndDateTime = timeFormatter.parse(eventEnd);
      if (currentDateTime.isAfter(eventStartDateTime) && currentDateTime.isBefore(eventEndDateTime)){
        filteredEventList.add(event);
      }
    });
    return filteredEventList;
  }

  eventStartDateWeekDay(EventPost event) {
    DateFormat timeFormatter = new DateFormat("MM/dd/yyyy h:mm a");
    String eventDateTime = event.startDate + " " + event.startTime;
    DateTime eventStartDateTime = timeFormatter.parse(eventDateTime);
    String weekDay = CustomDates().weekdayToString(eventStartDateTime.weekday);
    return weekDay;
  }

  eventStartDateDay(EventPost event) {
    DateFormat timeFormatter = new DateFormat("MM/dd/yyyy h:mm a");
    String eventDateTime = event.startDate + " " + event.startTime;
    DateTime eventStartDateTime = timeFormatter.parse(eventDateTime);
    return eventStartDateTime.day.toString();
  }

  eventStartDateMonth(EventPost event) {
    DateFormat timeFormatter = new DateFormat("MM/dd/yyyy h:mm a");
    String eventDateTime = event.startDate + " " + event.startTime;
    DateTime eventStartDateTime = timeFormatter.parse(eventDateTime);
    String month = CustomDates().monthToString(eventStartDateTime.month);
    return month;
  }

  eventStartDateYear(EventPost event) {
    DateFormat timeFormatter = new DateFormat("MM/dd/yyyy h:mm a");
    String eventDateTime = event.startDate + " " + event.startTime;
    DateTime eventStartDateTime = timeFormatter.parse(eventDateTime);
    return eventStartDateTime.year.toString();
  }

  Future<Null> distributePoints(EventPost event) async {
    if (event.attendees != null){
      event.attendees.forEach((attendeeUID){
        UserDataService().updateEventPoints(attendeeUID, event.eventPayout).then((error){
          if (error.isNotEmpty){
            // print(error);
          } else {
            FirebaseNotificationsService().createWalletDepositNotification(attendeeUID, event.eventPayout, "webblen");
          }
        });
      });
      eventRef.document(event.eventKey).updateData({"pointsDistributedToUsers": true}).whenComplete((){
        //return error;
      }).catchError((e) {
        //return error;
      });
    }
  }


  Future<Null> receiveEventPoints(List eventKeys) async {
    DateTime currentDateTime = DateTime.now();
    DateFormat formatter = new DateFormat("MM/dd/yyyy h:mm a");
    if (eventKeys != null){
      eventKeys.forEach((key) async {
        QuerySnapshot eventDocs = await eventRef
        .where('eventKey', isEqualTo: key)
        .where('pointsDistributedToUsers', isEqualTo: false)
        .getDocuments();
        if (eventDocs != null && eventDocs.documents.isNotEmpty){
          eventDocs.documents.forEach((eventDoc){
            EventPost event = EventPost.fromMap(eventDoc.data);
            String eventEnd = event.startDate + " " + event.endTime;
            DateTime eventTime = formatter.parse(eventEnd);
            if (!event.pointsDistributedToUsers && currentDateTime.isAfter(eventTime)){
              double points = event.eventPayout;
              if (event.attendees != null){
                event.attendees.forEach((uid) async {
                  DocumentSnapshot documentSnapshot = await userRef.document(uid).get();
                  double userImpact = documentSnapshot.data["impactPoints"] * 1.00;
                  double userPoints = documentSnapshot.data["eventPoints"] * 1.00;
                  double rewardAmount = (userImpact * 0.05) * (points * 0.8);
                  userPoints += rewardAmount;
                  userRef.document(uid).updateData({"eventPoints": userPoints}).whenComplete((){
                  }).catchError((e) {
                    print('error receiving points');
                  });
                });
              }
              eventRef.document(event.eventKey).updateData({"pointsDistributedToUsers": true}).whenComplete((){
              }).catchError((e) {
                print('error receiving points');
              });
            }
          });
        }
      });
    }
  }

  Future<String> updateEventPayOut(String uid, String eventID) async {
    String status = "";
    double eventPayout;
    double attendanceMultiplier;
    DocumentSnapshot eventSnapshot = await eventRef.document(eventID).get();
    List attendees = eventSnapshot.data["attendees"];
    int attendanceCount = attendees.length;
    attendanceMultiplier = getAttendanceMultiplier(attendanceCount);
    DocumentSnapshot userSnapshot = await userRef.document(uid).get();
    double userImpact = userSnapshot.data["impactPoints"].toDouble();
    eventPayout = (attendanceCount * attendanceMultiplier) + (userImpact * 0.05);
    eventRef.document(eventID).updateData({"eventPayout": eventPayout}).whenComplete((){
    }).catchError((e) {
      status = e.details;
    });
    return status;
  }



  Future<String> updateEventCaption(String eventID, String newCaption) async {
    String status = "";
    eventRef.document(eventID).updateData({"caption": newCaption}).whenComplete((){
    }).catchError((e) {
      status = e.details;
    });
    return status;
  }

  Future<String> updateEventDescription(String eventID, String newTitle) async {
    String status = "";
    eventRef.document(eventID).updateData({"title": newTitle}).whenComplete((){
    }).catchError((e) {
      status = e.details;
    });
    return status;
  }

  Future<int> updateEventViews(String eventID) async {
    DocumentSnapshot documentSnapshot = await eventRef.document(eventID).get();
    int viewCount = documentSnapshot.data["views"];
    viewCount += 1;
    eventRef.document(eventID).updateData({"views": viewCount}).whenComplete((){
    }).catchError((e) {
      return 10;
    });
    return viewCount;
  }

  Future<int> updateEstimatedTurnout(String eventID) async {
    int returnVal = 0;
    DocumentSnapshot documentSnapshot = await eventRef.document(eventID).get();
    int viewCount = documentSnapshot.data["views"];
    int currentTurnout = documentSnapshot.data["estimatedTurnout"];
    viewCount += 1;
    double estimatedCalculation = viewCount / 3;
    int randNum = Random().nextInt(10);
    int estimatedTurnout = estimatedCalculation.round();
    if (randNum <= 3 && currentTurnout < estimatedTurnout){
      eventRef.document(eventID).updateData({"estimatedTurnout": estimatedTurnout, "views": viewCount}).whenComplete((){
        returnVal = estimatedTurnout;
      }).catchError((e) {
        returnVal = 10;
      });
    } else {
      eventRef.document(eventID).updateData({ "views": viewCount}).whenComplete((){
        returnVal = estimatedTurnout;
      }).catchError((e) {
        returnVal = 10;
      });
    }
    return returnVal;
  }

  Future<Null> addEventDataField(String dataName, dynamic data) async {
    QuerySnapshot querySnapshot = await eventRef.getDocuments();
    querySnapshot.documents.forEach((doc){
      eventRef.document(doc.documentID).updateData({"$dataName": data}).whenComplete(() {
      }).catchError((e) {
      });
    });
  }

  Future<String> deleteEvent(String eventID) async {
    String error = "";
    await eventRef.document(eventID).delete().whenComplete((){
    }).catchError((e) {
      error = e.toString();
    });
    return error;
  }

  Future<Null> addEventToCalendar(String startDate) async {
    DateFormat timeFormatter = new DateFormat("MM/dd/yyyy h:mm a");
    DateTime startTime = timeFormatter.parse(startDate + " 9:15 AM");
    String startTimeInMilliseconds = startTime.millisecondsSinceEpoch.toString();
    DateTime endTime = timeFormatter.parse(startDate + " 10:15 AM");
    String endTimeInMilliseconds = endTime.millisecondsSinceEpoch.toString();
    EventPost event = EventPost(
      eventKey: "${Random().nextInt(999999999)}",
      address: '333 4th St S, Fargo, ND 58103',
      author: '@mukai',
      authorImagePath: 'https://firebasestorage.googleapis.com/v0/b/webblen-events.appspot.com/o/events%2F783596688.jpg?alt=media&token=70817002-b5ca-4c7b-9c5e-7ba6db6aaa65',
      title: '1 Million Cups',
      caption: "Join us for #1MCFar! A gathering where we celebrate and learn from entrepreneurs and the community. Grab coffee and a friend and we'll see you there!",
      description: '',
      startDate: startDate,
      endDate: startDate,
      recurrenceType: 'weekly',
      startTime: '9:15 AM',
      endTime: '10:15 PM',
      isAdmin: false,
      lat: 46.870846,
      lon: -96.786142,
      radius: 50,
      pathToImage: '',
      tags: ['business', 'community', 'education', 'activism', 'culture'],
      views: Random().nextInt(135),
      estimatedTurnout: Random().nextInt(50),
      actualTurnout: 0,
      fbSite: 'https://www.facebook.com/EmergingPrairie/',
      twitterSite: 'https://twitter.com/1MillionCupsFar',
      website: 'https://www.1millioncups.com/fargo',
      eventPayout: 0.00,
      pointsDistributedToUsers: false,
      attendees: [],
      costToAttend: 0.00,
      flashEvent: false,
      startDateInMilliseconds: startTimeInMilliseconds,
      endDateInMilliseconds: endTimeInMilliseconds
    );

    await Firestore.instance.collection("eventposts").document(event.eventKey).setData(event.toMap()).whenComplete(() {
    }).catchError((e) {
    });
  }

}