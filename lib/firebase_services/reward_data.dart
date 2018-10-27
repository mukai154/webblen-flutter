import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/models/webblen_reward.dart';

class RewardDataService {

  final CollectionReference rewardRef = Firestore.instance.collection("rewards");
  final CollectionReference userRef = Firestore.instance.collection("users");
  final double degreeMinMax = 0.145;


  Future<List<WebblenReward>> findEventsNearLocation(double lat, double lon) async {
    double latMax = lat + degreeMinMax;
    double latMin = lat - degreeMinMax;
    double lonMax = lon + degreeMinMax;
    double lonMin = lon - degreeMinMax;

    List<WebblenReward> nearbyRewards = [];

    QuerySnapshot querySnapshot = await rewardRef.where('rewardLat', isLessThanOrEqualTo: latMax).getDocuments();
    List eventsSnapshot = querySnapshot.documents;
    eventsSnapshot.forEach((rewardDoc){
      if (rewardDoc["rewardLat"] >= latMin && rewardDoc["rewardLon"] >= lonMin && rewardDoc["rewardLon"] <= lonMax){
        WebblenReward reward = WebblenReward.fromMap(rewardDoc.data);
        nearbyRewards.add(reward);
      }
    });

    return nearbyRewards;
  }

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
    List userRewards = userSnapshot.data["rewards"].toList();
    print(userRewards);
    if (userPoints < cost){
      error = "Not Enough Points";
    } else if (userRewards.contains(rewardID)){
      error = "Reward Already Purchased";
    } else {
      userRewards.add(rewardID);
      userPoints = userPoints - cost;
      userRef.document(uid).updateData({"eventPoints": userPoints, "rewards": userRewards}).whenComplete((){
      }).catchError((e) {
        error = e.details;
      });
    }
    return error;
  }

  Future<WebblenReward> findRewardByID(String rewardID) async {
    WebblenReward reward;
    DocumentSnapshot documentSnapshot = await rewardRef.document(rewardID).get();
    if (documentSnapshot.exists){
      reward = WebblenReward.fromMap(documentSnapshot.data);
    }
    return reward;
  }

  Future<Null> deleteRewardByID(String rewardID) async {
    DocumentSnapshot documentSnapshot = await rewardRef.document(rewardID).get();
    if (documentSnapshot.exists){
      rewardRef.document(rewardID).delete();
    }
  }

  filterEvents(List<WebblenReward> rewardsList, double filterCost, String filterCategory){
    List<WebblenReward> filteredRewards;
    filteredRewards = rewardsList.where((reward) => reward.rewardCategory == filterCategory).toList();
    return filteredRewards;
  }

}