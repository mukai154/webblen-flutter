import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:math';
import 'dart:io';
import 'package:webblen/models/community_news.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:webblen/models/community.dart';
import 'package:webblen/firebase_services/firebase_notification_services.dart';
class CommunityDataService {

  Geoflutterfire geo = Geoflutterfire();
  final CollectionReference locRef = Firestore.instance.collection("available_locations");
  final CollectionReference eventRef = Firestore.instance.collection("events");
  final CollectionReference usersRef = Firestore.instance.collection("users");
  final CollectionReference communityNewsDataRef = Firestore.instance.collection("community_news");
  final StorageReference storageReference = FirebaseStorage.instance.ref();
  final double degreeMinMax = 0.145;
  final double checkInDegreeMinMax = 0.0009;

  Future<String> createCommunity(double lat, double lon, Community community, String uid) async {
    String error = "";
    GeoFirePoint center = geo.point(latitude: lat, longitude: lon);
    List<DocumentSnapshot> nearLocations = await geo.collection(collectionRef: locRef).within(center: center, radius: 20, field: 'location').first;
    DocumentSnapshot userDoc = await usersRef.document(uid).get();
    Map<dynamic, dynamic> communities = userDoc.data['communities'];
    communities.addAll({community.name: community.areaGeohash});
    nearLocations.forEach((locSnapshot) async {
      await locRef.document(locSnapshot.documentID).collection('communities').document(community.name).setData(community.toMap()).whenComplete((){
      }).catchError((e){
        error = e.details.toString();
      });
    });
    await usersRef.document(uid).updateData({'communities': communities}).whenComplete((){
    }).catchError((e){
      error = e.details;
    });
    return error;
  }

  Future<String> findLocationIDByGeohash(String areaGeohash) async {
    String locID = "";
    QuerySnapshot querySnapshot = await locRef.where('location.geohash', isEqualTo: areaGeohash).getDocuments();
    locID = querySnapshot.documents.isNotEmpty ? querySnapshot.documents.first.documentID : "";
    return locID;
  }

  Future<bool> findIfCommunityExists(double lat, double lon, String name, String areaGeohash) async {
    bool communityNameExists = false;
    QuerySnapshot nearLocations = await locRef.where('location.geohash', isEqualTo: areaGeohash).getDocuments();
    QuerySnapshot communityQuery = await Firestore.instance
        .collection('available_locations')
        .document(nearLocations.documents.first.documentID)
        .collection('communities')
        .where('name', isEqualTo: name)
        .limit(1)
        .getDocuments();
    if (communityQuery.documents.isNotEmpty){
      communityNameExists = true;
    }
    return communityNameExists;
  }

  Future<List<Community>> findAllMemberCommunities(String uid, String userImageUrl, Map<dynamic, dynamic> communities) async {
    List<Community> memberCommunities = [];
    communities.forEach((key, val) async {
      String comGeohash = val.toString();
      QuerySnapshot querySnapshot = await locRef.where('location.geohash', isEqualTo: comGeohash).getDocuments();
      String areaID = querySnapshot.documents.first.documentID;
      QuerySnapshot comSnapshot = await locRef.document(areaID)
          .collection('communities')
          .where('members.$uid', isEqualTo: userImageUrl)
          .where('status', isEqualTo: 'active')
          .getDocuments();
      comSnapshot.documents.forEach((comSnapshot){
        Community community = Community.fromMap(comSnapshot.data);
        memberCommunities.add(community);
      });
    });
    return memberCommunities;
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

    }).catchError((e){

    });
    return followers;
  }

  Future<String> inviteUsers(List invitedUsers, String geohash, String comName, String senderUid, String senderName) async{
    String error = "";
    List invited = [];
    List newInvites = [];
    String notifData = comName + "." + geohash;
    QuerySnapshot querySnapshot = await locRef.where('location.geohash', isEqualTo: geohash).getDocuments();
    String locRefID = querySnapshot.documents.first.documentID;
    DocumentSnapshot comDoc = await locRef.document(locRefID).collection('communities').document(comName).get();
    invited = comDoc.data['invited'].toList(growable: true);
    invitedUsers.forEach((uid){
      if (!invited.contains(uid)){
        invited.add(uid);
        newInvites.add(uid);
      }
    });
    await locRef.document(locRefID).collection('communities').document(comName).updateData(({'invited': invited})).whenComplete((){
      newInvites.forEach((uid) async {
        await FirebaseNotificationsService().createInviteNotification(senderUid, notifData, uid, "@$senderName invited you to join $comName").whenComplete((){
        }).catchError((e){
          error = e.details;
        });
      });
    }).catchError((e){
      error = e.details;
    });
    return error;
  }

  Future<String> removeInvitedUser(String uid, String geohash, String comName) async{
    String error = "";
    List invited = [];
    QuerySnapshot querySnapshot = await locRef.where('location.geohash', isEqualTo: geohash).getDocuments();
    String locRefID = querySnapshot.documents.first.documentID;
    DocumentSnapshot comDoc = await locRef.document(locRefID).collection('communities').document(comName).get();
    invited = comDoc.data['invited'].toList(growable: true);
    if (invited.contains(uid)){
      invited.remove(uid);
    }
    await locRef.document(locRefID).collection('communities').document(comName).updateData(({'invited': invited})).whenComplete((){

    }).catchError((e){
      error = e.details;
    });
    return error;
  }

  Future<String> leaveCommunity(String uid, String geohash, String comName) async{
    String error = "";
    Map<dynamic, dynamic> comMembers;
    Map<dynamic, dynamic> communities;
    QuerySnapshot querySnapshot = await locRef.where('location.geohash', isEqualTo: geohash).getDocuments();
    String locRefID = querySnapshot.documents.first.documentID;
    DocumentSnapshot comDoc = await locRef.document(locRefID).collection('communities').document(comName).get();
    DocumentSnapshot userDoc = await usersRef.document(uid).get();
    communities = userDoc.data['communities'];
    comMembers = comDoc.data['members'];
    communities.remove(comName);
    print(communities);
    comMembers.remove(uid);
    if (comMembers.length <= 2){
      await locRef.document(locRefID).collection('communities').document(comName).delete();
    } else {
      await locRef.document(locRefID).collection('communities').document(comName).updateData(({'members': comMembers})).whenComplete((){
      }).catchError((e){
        error = e.details;
      });
    }
    await usersRef.document(uid).updateData({'communities': communities}).whenComplete((){
    }).catchError((e){
      error = e.details;
    });
    return error;
  }

  Future<String> joinCommunity(String uid, String userImageURL, String geohash, String comName) async{
    String error = "";
    Map<dynamic, dynamic> comMembers;
    Map<dynamic, dynamic> communities;
    QuerySnapshot querySnapshot = await locRef.where('location.geohash', isEqualTo: geohash).getDocuments();
    String locRefID = querySnapshot.documents.first.documentID;
    DocumentSnapshot comDoc = await locRef.document(locRefID).collection('communities').document(comName).get();
    DocumentSnapshot userDoc = await usersRef.document(uid).get();
    communities = userDoc.data['communities'];
    comMembers = comDoc.data['members'];
    communities.addAll({comName: geohash});
    comMembers.addAll({uid: userImageURL});
    if (comMembers.length <= 2){
      await locRef.document(locRefID).collection('communities').document(comName).delete();
    } else {
      await locRef.document(locRefID).collection('communities').document(comName).updateData(({'members': comMembers})).whenComplete((){
      }).catchError((e){
        error = e.details;
      });
    }
    await usersRef.document(uid).updateData({'communities': communities}).whenComplete((){
    }).catchError((e){
      error = e.details;
    });
    return error;
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
    String error = "";
    final String postID = "${Random().nextInt(999999999)}";
    String fileName = "$postID.jpg";
    communityNews.postID = postID;
    if (newsImage != null){
      String downloadUrl = await uploadNewsImage(newsImage, fileName);
      communityNews.imageURL = downloadUrl;
    }
    await Firestore.instance.collection("community_news").document(postID).setData(communityNews.toMap()).whenComplete(() {
    }).catchError((e) {
      error = e.toString();
    });
    return error;
  }

  Future<String> uploadNewsImage(File eventImage, String fileName) async {
    StorageReference ref = storageReference.child("community_news").child(fileName);
    StorageUploadTask uploadTask = ref.putFile(eventImage);
    String downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL() as String;
    return downloadUrl;
  }

  Future<String> deletePost(String postID) async {
    String error = "";
    await communityNewsDataRef.document(postID).delete();
    await storageReference.child("community_news").child('$postID.jpg').delete();
    return error;
  }


}