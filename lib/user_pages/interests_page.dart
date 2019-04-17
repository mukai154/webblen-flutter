import 'package:flutter/material.dart';
import 'package:webblen/firebase_services/tag_data.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/services_general/services_show_alert.dart';
import 'dart:async';
import 'package:webblen/models/webblen_user.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:webblen/widgets_common/common_appbar.dart';


class InterestsPage extends StatefulWidget {

  static String tag = "interest-page";

  final WebblenUser currentUser;
  InterestsPage({this.currentUser});

  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {

  List tags;
  List selectedTags = [];
  bool isLoading = true;



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

  Widget _buildInterestsGrid(){
    return new Container(
      height: MediaQuery.of(context).size.height * 0.89,
      child: isLoading
          ? Container(
        color: FlatColors.carminPink,
        child: CustomCircleProgress(30.0, 30.0, 30.0, 30.0, Colors.white),
      )
          : new GridView.count(
        crossAxisCount: 4,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
        children: new List<Widget>.generate(tags.length, (index) {
          return GridTile(
              child: new InkResponse(
                onTap: () => tagClicked(index),
                child: new Card(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                    color: selectedTags.contains(tags[index])
                        ? FlatColors.webblenRed
                        : Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        tags[index] == "wine & brew"
                            ? selectedTags.contains(tags[index])
                            ? Image.asset('assets/images/wine_brew_light.png', height: 32.0, width: 32.0, fit: BoxFit.contain)
                            : Image.asset('assets/images/wine_brew_dark.png', height: 32.0, width: 32.0, fit: BoxFit.contain)
                            : selectedTags.contains(tags[index])
                            ? Image.asset('assets/images/${tags[index]}_light.png', height: 32.0, width: 32.0, fit: BoxFit.contain)
                            : Image.asset('assets/images/${tags[index]}_dark.png', height: 32.0, width: 32.0, fit: BoxFit.contain),
                        SizedBox(height: 4.0),
                        Fonts().textW500(
                            '${tags[index]}',
                            10.0,
                            selectedTags.contains(tags[index])
                                ? Colors.white
                                : FlatColors.darkGray,
                            TextAlign.center
                        )
                      ],
                    )
                ),
              )
          );
        }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    selectedTags = widget.currentUser.tags.toList(growable: true);
    EventTagService().getTags().then((dbTags){
      setState(() {
        tags = dbTags;
        isLoading = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: WebblenAppBar().actionAppBar(
          'Interests',
          GestureDetector(
            onTap: () => updateTags(),
            child: Padding(
              padding: EdgeInsets.only(top: 20.0, right: 16.0),
              child: Fonts().textW500('Update', 16.0, FlatColors.darkGray, TextAlign.center),
            ),
          ),
      ),
      body:  Container(
        child: isLoading ? LoadingScreen(context: context)
            : ListView(
              children: <Widget>[
                _buildInterestsGrid(),
              ],
        ),
      ),
    );
  }

  Future<Null> updateTags() async {
    ShowAlertDialogService().showLoadingDialog(context);
    UserDataService().updateUserTags(widget.currentUser.uid, selectedTags).then((error){
      if (error.isEmpty){
        Navigator.of(context).pop();
        ShowAlertDialogService().showSuccessDialog(context, "Interests Updated!", "Checkout your calendar to see if there's something you'd like to do");
      } else {
        Navigator.of(context).pop();
        ShowAlertDialogService().showFailureDialog(context, "There was an issue updating your intersets", "Please try again later");
      }
    });
  }

}