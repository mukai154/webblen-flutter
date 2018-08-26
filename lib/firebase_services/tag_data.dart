import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventTagService {

  Future<List> getTags() async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection("tags").getDocuments();
    var docsSnapshot = querySnapshot.documents;
    List<String> tags = [];
    docsSnapshot.forEach((snapshot){
      tags.add(snapshot.documentID);
    });
    return tags;
  }

}

