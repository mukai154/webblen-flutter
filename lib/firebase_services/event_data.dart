import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:webblen/models/event_post.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:webblen/utils/custom_dates.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class EventPostService {

  final CollectionReference eventRef = Firestore.instance.collection("eventposts");
  final CollectionReference userRef = Firestore.instance.collection("users");
  final StorageReference storageReference = FirebaseStorage.instance.ref();
  final double degreeMinMax = 0.145;
  final double checkInDegreeMinMax = 0.0009;

  EventPost createEventData(String startDate){
    EventPost newEvent = EventPost(
        eventKey: "",
        address: "3234 43rd Street South, Fargo, ND, USA",
        author: "kali",
        authorImagePath: "https://firebasestorage.googleapis.com/v0/b/webblen-events.appspot.com/o/profile_pics%2FTKkPuTcBohfH187plsulaXM6TB83.jpg?alt=media&token=39aac564-8677-46ce-abfd-ff9e061be68e",
        title: "Brewing Up Laughs",
        caption: "Nerd Nite is a monthly lecture event that strives for a humorous, salacious, yet deeply academic vibe.",
        description: "It’s often about science or technology, but by no means is it limited to such topics. And it’s definitely entertaining. Our unofficial tag line is “It’s like the Discovery Channel – with beer!” There are Nerd Nites around the world, Fargo is just one of them.",
        startDate: startDate,
        endDate: "",
        recurrenceType: "monthly",
        startTime: "7:00 PM",
        endTime: "9:00 PM",
        isAdmin: false,
        lat: 46.83131699999999,
        lon: -96.85608289999999,
        radius: 8.1,
        pathToImage: "https://firebasestorage.googleapis.com/v0/b/webblen-events.appspot.com/o/events%2F813462208.jpg?alt=media&token=2c00ed3b-afae-4531-944c-ddccca60d538",
        tags: ["education", "technology", "art", "culture", "entertainment", "amusement"],
        views: 0,
        estimatedTurnout: 0,
        fbSite: "https://nerdnite.com",
        twitterSite: "",
        website: "",
        costToAttend: 0.00,
        actualTurnout: 0,
        pointsDistributedToUsers: false,
        attendees: [],
        eventPayout: 0.00
    );
    return newEvent;
  }

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

  Future<String> uploadEvent(File eventImage, EventPost event, String username) async {
    String result;
    final String eventKey = "${Random().nextInt(999999999)}";
    String fileName = "$eventKey.jpg";
    String downloadUrl = await uploadEventImage(eventImage, fileName);
    event.pathToImage = downloadUrl;
    event.eventKey = eventKey;
    event.author = username;
    await Firestore.instance.collection("eventposts").document(eventKey).setData(event.toMap()).whenComplete(() {
      result = "success";
    }).catchError((e) {
      result = e.toString();
    });
    return result;
  }

  Future<String> uploadEventImage(File eventImage, String fileName) async {
    StorageReference ref = storageReference.child("events").child(fileName);
    StorageUploadTask uploadTask = ref.putFile(eventImage);
    String downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL() as String;
    return downloadUrl;
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
        DocumentSnapshot eventDoc = await eventRef.document(key).get();
        if (eventDoc != null){
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
    double userImpact = userSnapshot.data["impactPoints"] * 1.00;
    eventPayout = (attendanceCount * attendanceMultiplier) + (userImpact * 0.05);
    eventRef.document(eventID).updateData({"eventPayout": eventPayout}).whenComplete((){
    }).catchError((e) {
      status = e.details;
    });
    return status;
  }

  Future<String> updateEventTitle(String eventID, String newTitle) async {
    String status = "";
    eventRef.document(eventID).updateData({"title": newTitle}).whenComplete((){
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
      eventRef.document(eventID).updateData({"estimatedTurnout": estimatedTurnout}).whenComplete((){
        returnVal = estimatedTurnout;
      }).catchError((e) {
        returnVal = 10;
      });
    } else {
      returnVal = currentTurnout;
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

}