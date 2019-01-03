import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:math';
import 'dart:io';
import 'package:webblen/models/community_news.dart';

class CommunityDataService {

  final CollectionReference communityDataRef = Firestore.instance.collection("community_activity");
  final CollectionReference communityNewsDataRef = Firestore.instance.collection("community_news");
  final StorageReference storageReference = FirebaseStorage.instance.ref();
  final double degreeMinMax = 0.145;
  final double checkInDegreeMinMax = 0.0009;

  Future<int> activeUserCount() async {
    DocumentSnapshot documentSnapshot = await communityDataRef.document("user_activity").get();
    int minUserCount = documentSnapshot.data["min"];
    int maxUserCount = documentSnapshot.data["max"];
    int randUserCount = Random().nextInt(maxUserCount) + minUserCount;
    return randUserCount;
  }

  Future<String> uploadNews(File newsImage, CommunityNewsPost communityNews) async {
    String result;
    final String communityPostKey = "${Random().nextInt(999999999)}";
    String fileName = "$communityPostKey.jpg";
    String downloadUrl = await uploadNewsImage(newsImage, fileName);
    communityNews.newsImageUrl = downloadUrl;
    await Firestore.instance.collection("community_news").document(communityPostKey).setData(communityNews.toMap()).whenComplete(() {
      result = "success";
    }).catchError((e) {
      result = e.toString();
    });
    return result;
  }

  Future<String> uploadNewsImage(File eventImage, String fileName) async {
    StorageReference ref = storageReference.child("community_news").child(fileName);
    StorageUploadTask uploadTask = ref.putFile(eventImage);
    String downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL() as String;
    return downloadUrl;
  }

  Future<List<CommunityNewsPost>> findNewsNearLocation(double lat, double lon) async {
    double latMax = lat + degreeMinMax;
    double latMin = lat - degreeMinMax;
    double lonMax = lon + degreeMinMax;
    double lonMin = lon - degreeMinMax;

    List<CommunityNewsPost> nearbyNews = [];

    QuerySnapshot querySnapshot = await communityNewsDataRef.where('lat', isLessThanOrEqualTo: latMax).where('lat', isGreaterThanOrEqualTo: latMin).getDocuments();
    List newsSnapshot = querySnapshot.documents;
    newsSnapshot.forEach((newsDoc){
      if (newsDoc["lon"] >= lonMin && newsDoc["lon"] <= lonMax && newsDoc["isGlobal"] == false){
        CommunityNewsPost communityNewsPost = CommunityNewsPost(
            timestamp: newsDoc['timestamp'],
            alwaysDisplay: newsDoc['alwaysDisplay'],
            newsTitle: newsDoc['newsTitle'],
            newsImageUrl: newsDoc['newsImageUrl'],
            newsUrl: newsDoc['newsUrl'],
            contentType: newsDoc['contentType'],
            content: newsDoc['content'],
            isGlobal: newsDoc['isGlobal'],
            userImageUrl: newsDoc['userImageUrl'],
            username: newsDoc['username'],
            lat: newsDoc['lat'],
            lon: newsDoc['lon']
        );
        nearbyNews.add(communityNewsPost);
      }
    });

    nearbyNews.sort((postA, postB) => int.parse(postA.timestamp).compareTo(int.parse(postB.timestamp)));
    return nearbyNews;
  }

  Future<List<CommunityNewsPost>> findGlobalNews() async {

    List<CommunityNewsPost> globalNews = [];

    QuerySnapshot querySnapshot = await communityNewsDataRef.where('isGlobal', isEqualTo: true).getDocuments();
    List newsSnapshot = querySnapshot.documents;
    newsSnapshot.forEach((newsDoc){
      CommunityNewsPost communityNewsPost = CommunityNewsPost(
          timestamp: newsDoc['timestamp'],
          alwaysDisplay: newsDoc['alwaysDisplay'],
          newsTitle: newsDoc['newsTitle'],
          newsImageUrl: newsDoc['newsImageUrl'],
          newsUrl: newsDoc['newsUrl'],
          contentType: newsDoc['contentType'],
          content: newsDoc['content'],
          isGlobal: newsDoc['isGlobal'],
          userImageUrl: newsDoc['userImageUrl'],
          username: newsDoc['username'],
          lat: newsDoc['lat'],
          lon: newsDoc['lon']
      );
      globalNews.add(communityNewsPost);
    });

    globalNews.sort((postA, postB) => int.parse(postA.timestamp).compareTo(int.parse(postB.timestamp)));
    return globalNews;
  }

  Future<List<CommunityNewsPost>> getCommunityNews(double lat, double lon) async {

    List<CommunityNewsPost> communityNews = [];

    List<CommunityNewsPost> nearbyNews = await findNewsNearLocation(lat, lon);
    List<CommunityNewsPost> globalNews = await findGlobalNews();

    communityNews = (globalNews + nearbyNews).toSet().toList(); //+ nearbyNews

    return communityNews;
  }


}