import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:webblen/models/event_post.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class EventPostService {

  final CollectionReference eventRef = Firestore.instance.collection("eventposts");
  final CollectionReference userRef = Firestore.instance.collection("users");
  final double degreeMinMax = 0.145;
  final double checkInDegreeMinMax = 0.0009;


  EventPost createEventPost(DocumentSnapshot eventDoc){
    EventPost event = new EventPost(
        eventKey: eventDoc["eventKey"],
        title: eventDoc["title"],
        address: eventDoc["address"],
        author: eventDoc["author"],
        authorImagePath: eventDoc["authorImagePath"],
        caption: eventDoc["caption"],
        description: eventDoc["description"],
        isAdmin: eventDoc["isAdmin"],
        startDate: eventDoc["startDate"],
        endDate: eventDoc["endDate"],
        startTime: eventDoc["startTime"],
        endTime: eventDoc["endTime"],
        tags: eventDoc["tags"],
        views: eventDoc["views"],
        fbSite: eventDoc["fbSite"],
        twitterSite: eventDoc["twitterSite"],
        pathToImage: eventDoc["pathToImage"],
        website: eventDoc["website"],
        estimatedTurnout: eventDoc["estimatedTurnout"],
        actualTurnout: eventDoc['actualTurnout'],
        costToAttend: eventDoc['costToAttend'],
        eventPayout: eventDoc['eventPayout'],
        pointsDistributedToUsers: eventDoc['pointsDistributedToUsers'],
        attendees: eventDoc['attendees']);
    return event;
  }

  EventPost createEventData(String startDate){
    EventPost newEvent = EventPost(
        eventKey: "",
        address: "The Stage at Island Park, 4th Street South, Fargo, ND, USA",
        author: "fargo",
        authorImagePath: "https://firebasestorage.googleapis.com/v0/b/webblen-events.appspot.com/o/profile_pics%2Fm8p4ZCY5LdcjAn97hCTQuSCKik62.jpg?alt=media&token=b18a5517-8be6-49aa-ac83-8de1950a10d7",
        title: "1 Million Cups",
        caption: "A weekly opportunity for local entrepreneurs to present and connect with the FM community over caffeinated goodness and great ideas",
        description: "Grab a mug + coworker/friend and head to Island Park! Starts at 9:15 am.",
        startDate: startDate,
        endDate: "",
        recurrenceType: "weekly",
        startTime: "9:15 AM",
        endTime: "10:30 AM",
        isAdmin: false,
        lat: 46.87094570000001,
        lon: -96.78608120000001,
        radius: 8.1,
        pathToImage: "https://firebasestorage.googleapis.com/v0/b/webblen-events.appspot.com/o/events%2F841803816.jpg?alt=media&token=f15f971d-484d-4d34-87e7-b541baa46bfd",
        tags: ["community", "activism", "business", "finance", "entertainment", "amusement"],
        views: 0,
        estimatedTurnout: 0,
        fbSite: "https://www.facebook.com/EmergingPrairie",
        twitterSite: "https://www.twitter.com/1millioncupsfar",
        website: "https://www.1millioncups.com/fargo",
        costToAttend: 0.00,
        actualTurnout: 0,
        pointsDistributedToUsers: false,
        attendees: [],
        eventPayout: 0
    );
    return newEvent;
  }

  getAttendanceMultiplier(int attendanceCount){
    double multiplier = 1.00;
    if (attendanceCount > 5 && attendanceCount <= 10){
      multiplier = 1.15;
    } else if (attendanceCount > 10 && attendanceCount <= 20){
      multiplier = 1.5;
    } else if (attendanceCount > 20 && attendanceCount <= 50){
      multiplier = 1.75;
    } else if (attendanceCount > 50 && attendanceCount <= 100){
      multiplier = 2.00;
    } else if (attendanceCount > 100 && attendanceCount <= 150){
      multiplier = 2.15;
    } else if (attendanceCount > 150 && attendanceCount <= 200){
      multiplier = 2.75;
    } else if (attendanceCount > 200 && attendanceCount <= 300){
      multiplier = 3.0;
    }
    return multiplier;
  }

  Future<Null> populateData(String eventDate) async {
    final String eventKey = "${Random().nextInt(999999999)}";
    EventPost event = createEventData(eventDate);
    event.eventKey = eventKey;
    Firestore.instance.collection("eventposts").document(eventKey).setData(event.toMap()).whenComplete(() {
      //print('success');
    }).catchError((e) => print(e.details));
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

    QuerySnapshot querySnapshot = await eventRef.where('lat', isLessThanOrEqualTo: latMax).getDocuments();
    List<DocumentSnapshot> eventsSnapshot = querySnapshot.documents;
    eventsSnapshot.forEach((eventDoc){
      if (!(eventDoc["lat"] >= latMin && eventDoc["lon"] >= lonMin && eventDoc["lon"] <= lonMax)){
        eventsSnapshot.remove(eventDoc);
      }
    });

    return eventsSnapshot;
  }

  Future<List<EventPost>> findEventsForCheckIn(double lat, double lon) async {
    double latMax = lat + checkInDegreeMinMax;
    double latMin = lat - checkInDegreeMinMax;
    double lonMax = lon + checkInDegreeMinMax;
    double lonMin = lon - checkInDegreeMinMax;

    DateFormat timeFormatter = new DateFormat("MM/dd/yyyy h:mm a");
    DateTime currentDateTime = new DateTime.now();


    List<EventPost> nearbyEvents = [];

    QuerySnapshot querySnapshot = await eventRef.where('lat', isLessThanOrEqualTo: latMax).getDocuments();
    var eventsSnapshot = querySnapshot.documents;
    eventsSnapshot.forEach((eventDoc){
      if (eventDoc["lat"] >= latMin && eventDoc["lon"] >= lonMin && eventDoc["lon"] <= lonMax){
        String eventStart = eventDoc["startDate"] + " " + eventDoc["startTime"];
        String eventEnd = eventDoc["startDate"] + " " + eventDoc["endTime"];
        DateTime eventStartDateTime = timeFormatter.parse(eventStart);
        DateTime eventEndDateTime = timeFormatter.parse(eventEnd);
        if (currentDateTime.isAfter(eventStartDateTime) && currentDateTime.isBefore(eventEndDateTime)){
          EventPost event = createEventPost(eventDoc);
          nearbyEvents.add(event);
        }
      }
    });

    return nearbyEvents;
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

  Future<Null> distributePoints(EventPost event) async {
    String error = "";
    if (event.attendees != null){
      event.attendees.forEach((attendeeUID){
        UserDataService().updateEventPoints(attendeeUID, event.eventPayout).then((error){
          if (error.isNotEmpty){
           // print(error);
          }
        });
      });
      eventRef.document(event.eventKey).updateData({"pointsDistributedToUsers": true}).whenComplete((){
        //return error;
      }).catchError((e) {
        error = e.details;
        //return error;
      });
    }
  }


  Future<Null> receiveEventPoints(List eventKeys) async {
    String error = "";
    DateTime currentDateTime = DateTime.now();
    DateFormat formatter = new DateFormat("MM/dd/yyyy h:mm a");
    if (eventKeys != null){
      eventKeys.forEach((key) async {
        DocumentSnapshot documentSnapshot = await eventRef.document(key).get();
        if (documentSnapshot != null){
          EventPost event = EventPostService().createEventPost(documentSnapshot);
          String eventEnd = event.startDate + " " + event.endTime;
          DateTime eventTime = formatter.parse(eventEnd);
          if (!event.pointsDistributedToUsers && currentDateTime.isAfter(eventTime)){
            int points = event.eventPayout;
            if (event.attendees != null){
              event.attendees.forEach((uid) async {
                DocumentSnapshot documentSnapshot = await userRef.document(uid).get();
                int userPoints = documentSnapshot.data["eventPoints"];
                userPoints += points;
                userRef.document(uid).updateData({"eventPoints": userPoints}).whenComplete((){
                }).catchError((e) {
                  error = e.details;
                });
              });
            }
            eventRef.document(event.eventKey).updateData({"pointsDistributedToUsers": true}).whenComplete((){
            }).catchError((e) {
              error = e.details;
            });
          }
        }
      });
    }
  }

  Future<String> updateEventPayOut(String eventID) async {
    String error = "";
    int eventPayout;
    double attendanceMultiplier;
    DocumentSnapshot documentSnapshot = await eventRef.document(eventID).get();
    List attendees = documentSnapshot.data["attendees"];
    int attendanceCount = attendees.length;
    attendanceMultiplier = getAttendanceMultiplier(attendanceCount);
    eventPayout = (attendanceCount * attendanceMultiplier).round();
    eventRef.document(eventID).updateData({"eventPayout": eventPayout}).whenComplete((){
      return error;
    }).catchError((e) {
      error = e.details;
      return error;
    });
  }

  Future<String> updateEventTitle(String eventID, String newTitle) async {
    String error = "";
    eventRef.document(eventID).updateData({"title": newTitle}).whenComplete((){
      return error;
    }).catchError((e) {
      error = e.details;
      return error;
    });
  }

  Future<String> updateEventCaption(String eventID, String newCaption) async {
    String error = "";
    eventRef.document(eventID).updateData({"caption": newCaption}).whenComplete((){
      return error;
    }).catchError((e) {
      error = e.details;
      return error;
    });
  }

  Future<String> updateEventDescription(String eventID, String newTitle) async {
    String error = "";
    eventRef.document(eventID).updateData({"title": newTitle}).whenComplete((){
      return error;
    }).catchError((e) {
      error = e.details;
      return error;
    });
  }

  Future<int> updateEventViews(String eventID) async {
    DocumentSnapshot documentSnapshot = await eventRef.document(eventID).get();
    int viewCount = documentSnapshot.data["views"];
    viewCount += 1;
    eventRef.document(eventID).updateData({"views": viewCount}).whenComplete((){
      return viewCount;
    }).catchError((e) {
      return 10;
    });
  }

  Future<int> updateEstimatedTurnout(String eventID) async {
    DocumentSnapshot documentSnapshot = await eventRef.document(eventID).get();
    int viewCount = documentSnapshot.data["views"];
    int currentTurnout = documentSnapshot.data["estimatedTurnout"];
    viewCount += 1;
    double estimatedCalculation = viewCount / 3;
    int randNum = Random().nextInt(10);
    int estimatedTurnout = estimatedCalculation.round();

    if (randNum <= 3 && currentTurnout < estimatedTurnout){
      eventRef.document(eventID).updateData({"estimatedTurnout": estimatedTurnout}).whenComplete((){
        return estimatedTurnout;
      }).catchError((e) {
        return 10;
      });
    } else {
      return currentTurnout;
    }
  }

  Future<Null> addEventDataField(String dataName, dynamic data) async {
    QuerySnapshot querySnapshot = await eventRef.getDocuments();
    querySnapshot.documents.forEach((doc){
      eventRef.document(doc.documentID).updateData({"$dataName": data}).whenComplete(() {

      }).catchError((e) {

      });
    });

  }

}