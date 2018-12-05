import 'package:flutter/material.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'package:webblen/firebase_services/tag_data.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/services_general/services_show_alert.dart';
import 'package:webblen/widgets_interests/interests_row.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';


class InterestsPage extends StatefulWidget {

  static String tag = "interest-page";

  final List userTags;
  InterestsPage({this.userTags});

  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {

  List<String> tags;
  List<String> selectedTags = [];
  String uid;
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    BaseAuth().currentUser().then((val) {
      setState(() {
        uid = val == null ? null : val;
      });
    });
    EventTagService().getTags().then((dbTags){
      widget.userTags.forEach((tag) {
        selectedTags.add(tag.toString());
      });
      setState(() {
        tags = dbTags;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 2.0,
        backgroundColor: Color(0xFFF9F9F9),
        title: new Text("Interests", style: Fonts.headerTextStyle),
        leading: BackButton(color: FlatColors.londonSquare),
        actions: <Widget>[
          isLoading ? Container() : FlatButton(onPressed: updateTags, child: Text("Update"))
        ],
      ),
      body: new Container(
        child: isLoading ? _buildLoadingScreen()
            :new ListView(
          children: <Widget>[
            _buildInterestsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildInterestsGrid(){
    return Container(
        height: MediaQuery.of(context).size.height * 0.88,
        child: new GridView.count(
          crossAxisCount: 1,
          scrollDirection: Axis.vertical,
          childAspectRatio: 3,
          children: isLoading == true ? <Widget>[CustomCircleProgress(40.0, 40.0, 40.0, 40.0, Colors.white)]
              : new List<Widget>.generate(tags.length, (index) {
            return new GridTile(
                child: new InkResponse(
                  onTap: () => tagClicked(index),
                  child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                      child: InterestRow(
                          interest: tags[index],
                          isInterested: selectedTags.contains(tags[index]) ? true : false)
                  ),
                ),
            );
          }),
        ),
      );
  }

  tagClicked(int index){
    String tag = tags[index];
    if (selectedTags.contains(tag)) {
      setState(() {
        selectedTags.remove(tag);
      });
    } else {
      setState(() {
        selectedTags.add(tag);
      });
    }
  }

  updatedInterests(BuildContext context) {
    ShowAlertDialogService().showSuccessDialog(context, "Interests Updated!", "Checkout your calendar to see if there's something you'd like to do");
  }

  failedAlert(BuildContext context, String details) {
    ShowAlertDialogService().showSuccessDialog(context, "There was an issue updating your intersets", "Please try again later");
  }

  Future<Null> updateTags() async {
    setState(() {
      isLoading = true;
    });
    CollectionReference userRef = Firestore.instance.collection("users");
    userRef.document(uid).updateData({'tags': selectedTags}).whenComplete(() {
      updatedInterests(context);
      setState(() {
        isLoading = false;
      });
    }).catchError((e) {
      failedAlert(context, e.details);
      setState(() {
        isLoading = false;
      });
    });
  }

  Widget _buildLoadingIndicator(){
    return Theme(
      data: ThemeData(
          accentColor: Colors.white
      ),
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 40.0,
              width: 40.0,
              child: CircularProgressIndicator(backgroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingScreen()  {
    return new Container(
      child: new Column /*or Column*/(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            height: 85.0,
            width: 85.0,
            child: _buildLoadingIndicator(),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}