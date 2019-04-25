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

  Future<String> createCommunity(Community community, String areaName, String uid) async {
    String error = "";
    DocumentSnapshot userDoc = await usersRef.document(uid).get();

    Map<dynamic, dynamic> communities = userDoc.data['communityMemberMap'];
    communities.addAll({community.name: community.areaName});
    await locRef.document(areaName).collection('communities').document(community.name).setData(community.toMap()).whenComplete((){
    }).catchError((e){
      error = e.details.toString();
    });
    await usersRef.document(uid).updateData({'communityMemberMap': communities}).whenComplete((){
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

  Future<bool> findIfCommunityExists(String areaName, String comName) async {
    bool communityNameExists = false;
    DocumentSnapshot docSnap = await locRef.document(areaName).collection('communities').document(comName).get();
    if (docSnap.exists){
      communityNameExists = true;
    }
    return communityNameExists;
  }

  Future<List<Community>> findAllMemberCommunities(String uid, String userImageUrl) async {
    List<Community> memberCommunities = [];
    DocumentSnapshot userDoc = await usersRef.document(uid).get();
    Map<dynamic, dynamic> communities = userDoc.data['communityMemberMap'];
    for (var entry in communities.entries){
      await locRef.document(entry.value).collection('communities').document(entry.key).get().then((docSnap){
        if (docSnap.exists){
          Community community = Community.fromMap(docSnap.data);
          memberCommunities.add(community);
        }
      });
    }
    return memberCommunities;
  }

  Future<Map<dynamic, dynamic>> updateCommunityMembers(String uid, String userImagePath, String areaName, String comName) async{
    Map<dynamic, dynamic> comMembers;
    List invited = [];
    DocumentSnapshot comDoc = await locRef.document(areaName).collection('communities').document(comName).get();
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
    locRef.document(areaName).collection('communities').document(comName).updateData(({'members': comMembers})).whenComplete((){

    }).catchError((error){

    });
    return comMembers;
  }

  Future<List> updateFollowers(String uid, String areaName, String comName) async{
    List followers = [];
    DocumentSnapshot comDoc = await locRef.document(areaName).collection('communities').document(comName).get();
    followers = comDoc.data['followers'].toList(growable: true);
    if (followers.contains(uid)){
      followers.remove(uid);
    } else {
      followers.add(uid);
    }
    locRef.document(areaName).collection('communities').document(comName).updateData(({'followers': followers})).whenComplete((){

    }).catchError((e){

    });
    return followers;
  }

  Future<String> inviteUsers(List invitedUsers, String areaName, String comName, String senderUid, String senderName) async{
    String error = "";
    List invited = [];
    List newInvites = [];
    String notifData = comName + "." + areaName;
    DocumentSnapshot comDoc = await locRef.document(areaName).collection('communities').document(comName).get();
    invited = comDoc.data['invited'].toList(growable: true);
    invitedUsers.forEach((uid){
      if (!invited.contains(uid)){
        invited.add(uid);
        newInvites.add(uid);
      }
    });
    await locRef.document(areaName).collection('communities').document(comName).updateData(({'invited': invited})).whenComplete((){
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

  Future<String> removeInvitedUser(String uid, String areaName, String comName) async{
    String error = "";
    List invited = [];
    DocumentSnapshot comDoc = await locRef.document(areaName).collection('communities').document(comName).get();
    invited = comDoc.data['invited'].toList(growable: true);
    if (invited.contains(uid)){
      invited.remove(uid);
    }
    await locRef.document(areaName).collection('communities').document(comName).updateData(({'invited': invited})).whenComplete((){

    }).catchError((e){
      error = e.details;
    });
    return error;
  }

  Future<String> leaveCommunity(String uid, String areaName, String comName) async{
    String error = "";
    Map<dynamic, dynamic> comMembers;
    Map<dynamic, dynamic> communities;
    DocumentSnapshot comDoc = await locRef.document(areaName).collection('communities').document(comName).get();
    DocumentSnapshot userDoc = await usersRef.document(uid).get();
    communities = userDoc.data['communities'];
    comMembers = comDoc.data['members'];
    communities.remove(comName);
    comMembers.remove(uid);
    if (comMembers.length <= 2){
      await locRef.document(areaName).collection('communities').document(comName).delete();
      comMembers.forEach((key, val){
        FirebaseNotificationsService().createCommunityDisbandedNotification("", key, "$comName in $areaName has been disbanded from not having enough members");
      });
    } else {
      await locRef.document(areaName).collection('communities').document(comName).updateData(({'members': comMembers})).whenComplete((){
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

  Future<String> joinCommunity(String uid, String userImageURL, String areaName, String comName) async{
    String error = "";
    Map<dynamic, dynamic> comMembers;
    Map<dynamic, dynamic> communities;
    int oldMemberCount;
    int newMemberCount;
    DocumentSnapshot comDoc = await locRef.document(areaName).collection('communities').document(comName).get();
    if (comDoc.exists){
      DocumentSnapshot comDoc = await locRef.document(areaName).collection('communities').document(comName).get();
      DocumentSnapshot userDoc = await usersRef.document(uid).get();
      communities = userDoc.data['communityMemberMap'];
      comMembers = comDoc.data['members'];
      oldMemberCount = comMembers.length;
      communities.addAll({comName: areaName});
      comMembers.addAll({uid: userImageURL});
      newMemberCount = comMembers.length;
      await locRef.document(areaName).collection('communities').document(comName).updateData(({'members': comMembers})).whenComplete((){
      }).catchError((e){
        error = e.details;
      });
      await usersRef.document(uid).updateData({'communityMemberMap': communities}).whenComplete((){
      }).catchError((e){
        error = e.details;
      });
      if (oldMemberCount <= 2 && newMemberCount >= 3){
        comMembers.forEach((key, val){
          FirebaseNotificationsService().createCommunityDisbandedNotification("", key, "$areaName is now Active");
        });
      }
    } else {
      error = "Community No Longer Exists";
    }

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

  Future<String> updateCommunityEventActivity(List tags, String areaName, String comName) async {
    String error = "";
    List comTags = [];
    List newTagList;
    int activityCount = 0;
    int eventCount  = 0;
    DocumentSnapshot comDoc = await locRef.document(areaName).collection('communities').document(comName).get();
    comTags = comDoc.data['subtags'] == null ? [] : comDoc.data['subtags'];
    activityCount = comDoc.data['activityCount'] == null ? 0 : comDoc.data['activityCount'];
    eventCount = comDoc.data['eventCount'] == null ? 0 : comDoc.data['eventCount'];
    activityCount += 1;
    eventCount += 1;
    newTagList = List.from(comTags)..addAll(tags);
    List uniqueTags = newTagList.toSet().toList();
    await locRef.document(areaName).collection("communities").document(comName).updateData({"subtags": uniqueTags, "activityCount": activityCount, "eventCount": eventCount}).whenComplete(() {
    }).catchError((e) {
      error = e.toString();
    });
    return error;
  }

  Future<String> deletePost(String postID) async {
    String error = "";
    await communityNewsDataRef.document(postID).delete();
    await storageReference.child("community_news").child('$postID.jpg').delete();
    return error;
  }

}