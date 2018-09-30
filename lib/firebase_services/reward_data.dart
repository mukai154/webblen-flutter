import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:webblen/models/event_post.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class EventPostService {

  final CollectionReference rewardRef = Firestore.instance.collection("rewards");
  final CollectionReference userRef = Firestore.instance.collection("users");

  Future<String> updateAmountOfRewardAvailable(String rewardID) async {
    DocumentSnapshot documentSnapshot = await rewardRef.document(rewardID).get();
    int amountAvailable = documentSnapshot.data["amountAvailable"];
    if (amountAvailable > 0){
      amountAvailable -= 1;
    }
    rewardRef.document(rewardID).updateData({"amountAvailable": amountAvailable}).whenComplete((){
      return amountAvailable.toString();
    }).catchError((e) {
      return "error";
    });
  }

  Future<String> purchaseReward(String uid, String rewardID, double cost) async {
    String error = "";
    DocumentSnapshot userSnapshot = await userRef.document(uid).get();
    double userPoints = userSnapshot.data["eventPoints"] * 1.00;
    if (userPoints < cost){
      error = "Not Enough Points";
      return error;
    } else {
      List<String> userRewards = userSnapshot.data["rewards"];
      userRewards.add(rewardID);
      userPoints = userPoints - cost;
      rewardRef.document(rewardID).updateData({"eventPoints": userPoints, "rewards": userRewards}).whenComplete((){
        return error;
      }).catchError((e) {
        error = e.details;
        return error;
      });
    }
  }

}