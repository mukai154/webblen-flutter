import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlatformDataService {

  Future<bool> isUpdateAvailable() async {
    bool updateAvailable = false;
    String currentVersion = "5.1.0";
    DocumentSnapshot documentSnapshot = await Firestore.instance.collection("app_release_info").document("general").get();
    String releasedVersion = documentSnapshot.data["versionNumber"];
    if (currentVersion != releasedVersion){
      updateAvailable = true;
    }
    return updateAvailable;
  }

}
