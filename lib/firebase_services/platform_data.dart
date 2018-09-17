import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlatformDataService {

  Future<bool> isUpdateAvailable() async {
    bool updateAvailable = false;
    String currentVersion = "5.2.0";
    DocumentSnapshot documentSnapshot = await Firestore.instance.collection("app_release_info").document("general").get();
    String releasedVersion = documentSnapshot.data["versionNumber"];
    bool versionIsRequired = documentSnapshot.data["versionIsRequired"];
    if (currentVersion != releasedVersion && versionIsRequired){
      updateAvailable = true;
    }
    return updateAvailable;
  }

}
