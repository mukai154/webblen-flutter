import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class UserDataService {

  final CollectionReference userRef = Firestore.instance.collection("users");
  final StorageReference storageReference = FirebaseStorage.instance.ref();

  Future<bool> checkIfUserExistsByUID(String uid) async {
    DocumentSnapshot documentSnapshot = await userRef.document(uid).get();
    if (documentSnapshot.exists){
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkIfUserExists(String username) async {
    QuerySnapshot querySnapshot = await userRef.where("username", isEqualTo: username).getDocuments();
    if (querySnapshot.documents.isNotEmpty){
      return true;
    } else {
      return false;
    }
  }

  Future<bool> createUser(File userImage, WebblenUser user, String uid) async {
    final String fileName = "$uid.jpg";
    final StorageUploadTask task = storageReference.child("profile_pics").child(fileName).putFile(userImage);
    final Uri downloadUrl = (await task.future).downloadUrl;

    user.profile_pic = downloadUrl.toString();

    await Firestore.instance.collection("users").document(uid).setData(user.toMap()).whenComplete(() {
      return true;
    }).catchError((e) { return false; });
  }

  Future<String> currentUsername(String uid) async {
    DocumentSnapshot documentSnapshot = await userRef.document(uid).get();
    String username = documentSnapshot.data["username"];
    return username;
  }

  Future<String> userImagePath(String uid) async {
    DocumentSnapshot documentSnapshot = await userRef.document(uid).get();
    String pathToImage = documentSnapshot.data["profile_pic"];
    return pathToImage;
  }

  Future<List> currentUserTags(String uid) async {
    DocumentSnapshot documentSnapshot = await userRef.document(uid).get();
    List tags = documentSnapshot.data["tags"];
    return tags;
  }

  Future<bool> updateTags(String uid, List tags) async {
    userRef.document(uid).setData({"tags": tags}).whenComplete(() {
       return true;
      }).catchError((e) {
        return false;
    });
  }

  Future<Null> addUserDataField(String dataName, dynamic data) async {
    QuerySnapshot querySnapshot = await userRef.getDocuments();
    querySnapshot.documents.forEach((doc){
      userRef.document(doc.documentID).updateData({"$dataName": data}).whenComplete(() {

      }).catchError((e) {

      });
    });

  }
}