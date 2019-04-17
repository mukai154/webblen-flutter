import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:math';
import 'dart:io';
import 'package:webblen/models/community_news.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:webblen/models/community.dart';

class CommunityDataService {

  Geoflutterfire geo = Geoflutterfire();
  final CollectionReference locRef = Firestore.instance.collection("available_locations");
  final CollectionReference communityNewsDataRef = Firestore.instance.collection("community_news");
  final StorageReference storageReference = FirebaseStorage.instance.ref();
  final double degreeMinMax = 0.145;
  final double checkInDegreeMinMax = 0.0009;

  Future<List<Community>> findTopCommunities(double lat, double lon) async {
    List<Community> topCommunities = [];
    GeoFirePoint center = geo.point(latitude: lat, longitude: lon);
    List<DocumentSnapshot> nearLocations = await geo.collection(collectionRef: locRef).within(center: center, radius: 20, field: 'location').first;
    nearLocations.forEach((locSnapshot) async {
      QuerySnapshot communityQuery = await Firestore.instance
          .collection('available_locations')
          .document(locSnapshot.documentID)
          .collection('communities')
          .orderBy('activityCount', descending: true)
          .limit(10).getDocuments();
      communityQuery.documents.forEach((comSnapshot){
        Community community = Community.fromMap(comSnapshot.data);
        topCommunities.add(community);
      });
    });
    return topCommunities;
  }

  Future<List<Community>> findMostActiveCommunities(double lat, double lon) async {
    List<Community> mostActiveCommunities = [];
    GeoFirePoint center = geo.point(latitude: lat, longitude: lon);
    List<DocumentSnapshot> nearLocations = await geo.collection(collectionRef: locRef).within(center: center, radius: 20, field: 'location').first;
    nearLocations.forEach((locSnapshot) async {
      QuerySnapshot communityQuery = await Firestore.instance
          .collection('available_locations')
          .document(locSnapshot.documentID)
          .collection('communities')
          .orderBy('lastActivityTimeInMilliseconds', descending: true)
          .limit(10).getDocuments();
      communityQuery.documents.forEach((comSnapshot){
        Community community = Community.fromMap(comSnapshot.data);
        mostActiveCommunities.add(community);
      });
    });
    return mostActiveCommunities;
  }

  Future<List<Community>> findFollowedCommunities(double lat, double lon, String uid) async {
    List<Community> mostActiveCommunities = [];
    GeoFirePoint center = geo.point(latitude: lat, longitude: lon);
    List<DocumentSnapshot> nearLocations = await geo.collection(collectionRef: locRef).within(center: center, radius: 20, field: 'location').first;
    nearLocations.forEach((locSnapshot) async {
      QuerySnapshot communityQuery = await Firestore.instance
          .collection('available_locations')
          .document(locSnapshot.documentID)
          .collection('communities')
          .where('followers', arrayContains: uid)
          .getDocuments();
      communityQuery.documents.forEach((comSnapshot){
        Community community = Community.fromMap(comSnapshot.data);
        mostActiveCommunities.add(community);
      });
    });
    return mostActiveCommunities;
  }

  Future<List<Community>> findMemberCommunities(double lat, double lon, String uid, String userImageUrl) async {
    List<Community> mostActiveCommunities = [];
    GeoFirePoint center = geo.point(latitude: lat, longitude: lon);
    List<DocumentSnapshot> nearLocations = await geo.collection(collectionRef: locRef).within(center: center, radius: 20, field: 'location').first;
    nearLocations.forEach((locSnapshot) async {
      QuerySnapshot communityQuery = await Firestore.instance
          .collection('available_locations')
          .document(locSnapshot.documentID)
          .collection('communities')
          .where('members.uid', isEqualTo: userImageUrl)
          .getDocuments();
      communityQuery.documents.forEach((comSnapshot){
        Community community = Community.fromMap(comSnapshot.data);
        mostActiveCommunities.add(community);
      });
    });
    return mostActiveCommunities;
  }

  Future<Map<dynamic, dynamic>> updateCommunityMembers(String uid, String userImagePath, String geohash, String comName) async{
    Map<dynamic, dynamic> comMembers;
    List invited = [];
    QuerySnapshot querySnapshot = await locRef.where('location.geohash', isEqualTo: geohash).getDocuments();
    String locRefID = querySnapshot.documents.first.documentID;
    DocumentSnapshot comDoc = await locRef.document(locRefID).collection('communities').document(comName).get();
    comMembers = comDoc.data['members'];
    invited = comDoc.data['invited'].toList(growable: true);
    if (comMembers.keys.contains(uid)){
      comMembers.remove(uid);
    } else {
      if (invited.contains(uid)){
        invited.remove(uid);
      }
      comMembers.addAll({uid : userImagePath});
    }
    locRef.document(locRefID).collection('communities').document(comName).updateData(({'members': comMembers})).whenComplete((){

    }).catchError((error){

    });
    return comMembers;
  }

  Future<List> updateFollowers(String uid, String geohash, String comName) async{
    List followers = [];
    QuerySnapshot querySnapshot = await locRef.where('location.geohash', isEqualTo: geohash).getDocuments();
    String locRefID = querySnapshot.documents.first.documentID;
    DocumentSnapshot comDoc = await locRef.document(locRefID).collection('communities').document(comName).get();
    followers = comDoc.data['followers'].toList(growable: true);
    if (followers.contains(uid)){
      followers.remove(uid);
    } else {
      followers.add(uid);
    }
    locRef.document(locRefID).collection('communities').document(comName).updateData(({'followers': followers})).whenComplete((){

    }).catchError((error){

    });
    return followers;
  }

//  Future<Null> createCommunity(String communityName, String userID) async {
//    String result;
//    final String communityPostKey = "${Random().nextInt(999999999)}";
//    String fileName = "$communityPostKey.jpg";
//    String downloadUrl = await uploadNewsImage(newsImage, fileName);
//    communityNews.newsImageUrl = downloadUrl;
//    await Firestore.instance.collection("community_news").document(communityPostKey).setData(communityNews.toMap()).whenComplete(() {
//      result = "success";
//    }).catchError((e) {
//      result = e.toString();
//    });
//    return result;
//  }
//
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
      CommunityNewsPost communityNewsPost = CommunityNewsPost.fromMap(newsDoc);
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