import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class CommunityDataService {

  final CollectionReference communityDataRef = Firestore.instance.collection("community_activity");

  Future<int> activeUserCount() async {
    DocumentSnapshot documentSnapshot = await communityDataRef.document("user_activity").get();
    int minUserCount = documentSnapshot.data["min"];
    int maxUserCount = documentSnapshot.data["max"];
    int randUserCount = Random().nextInt(maxUserCount) + minUserCount;
    return randUserCount;
  }


}