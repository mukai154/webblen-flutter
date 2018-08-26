import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'package:webblen/models/event_post.dart';
import 'dart:math';

class EventPostService {

  final CollectionReference eventRef = Firestore.instance.collection("eventposts");

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
        estimatedTurnout: eventDoc["estimatedTurnout"]
    );
    return event;
  }

  EventPost createEventData(String startDate){
    EventPost newEvent = EventPost(
        eventKey: "",
        address: "Prairie Den, North Broadway Drive, Fargo, ND",
        author: "thetrooper",
        authorImagePath: "https://firebasestorage.googleapis.com/v0/b/webblen-events.appspot.com/o/profile_pics%2FPd9KMOe1xadIXuJi515WmoXz4bk1.jpg?alt=media&token=5269d5b0-630c-4ff7-84a3-9d030f1688bd",
        title: "Bitcoin Meetup",
        caption: "Discuss news, ideas, and advancements in the crypto community! Every Tuesday at the Prarie Den Downtown.",
        description: "Cryptos & blockchain is changing the future. Whether you’re new to the space or a seasoned investor, it does not matter. All are welcome.",
        startDate: startDate,
        endDate: "",
        recurrenceType: "weekly",
        startTime: "7:00 PM",
        endTime: "9:00 PM",
        isAdmin: false,
        lat: 46.8777892,
        lon: -96.7878757,
        radius: 8.1,
        pathToImage: "https://firebasestorage.googleapis.com/v0/b/webblen-events.appspot.com/o/events%2F479941279.jpg?alt=media&token=a060b008-5fc0-4108-9422-51883c9cff52",
        tags: ["community", "activism", "business", "finance", "science", "technology"],
        views: 0,
        estimatedTurnout: 0,
        fbSite: "https://www.facebook.com/groups/BitcoinFargo",
        twitterSite: "",
        website: "",
        costToAttend: 0.00
    );
    return newEvent;
  }

  Future<Null> populateData(String eventDate) async {
    final String eventKey = "${Random().nextInt(999999999)}";
    EventPost event = createEventData(eventDate);
    event.eventKey = eventKey;
    Firestore.instance.collection("eventposts").document(eventKey).setData(event.toMap()).whenComplete(() {
      print('success');
    }).catchError((e) => print(e.details));
  }

  Future<int> eventCountByUser(String username) async {
    QuerySnapshot querySnapshot = await eventRef.where('author', isEqualTo: username).getDocuments();
    var eventsSnapshot = querySnapshot.documents;
    return eventsSnapshot.length;
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

}