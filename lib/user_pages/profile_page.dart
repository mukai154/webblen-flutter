import 'package:flutter/material.dart';
import 'package:webblen/widgets_profile/profile_header.dart';
import 'package:webblen/widgets_profile/quick_actions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/animations/transition_animations.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'wallet_page.dart';
import 'package:webblen/widgets_common/common_alert.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:webblen/widgets_common/common_flushbar.dart';
import 'friends_page.dart';
import 'package:webblen/firebase_services/notification_data.dart';
import 'package:webblen/models/webblen_notification.dart';

class ProfileHomePage extends StatefulWidget {

  static String tag = 'profile-page';

  final NetworkImage userImage;
  final String username;
  ProfileHomePage({this.userImage, this.username});

  @override
  _ProfileHomePageState createState() => _ProfileHomePageState();
}

class _ProfileHomePageState extends State<ProfileHomePage> {


  //Firebase
  String uid;
  File userImage;
  bool isLoading = false;
  List<WebblenNotification> friendNotifications = [];
  List<WebblenNotification> walletNotifications = [];
  List<WebblenNotification> messageNotifications = [];
  List<WebblenNotification> achievementNotifications = [];

  void transitionToFriendsPage () =>  Navigator.push(context, SlideFromRightRoute(widget: FriendsPage(currentUID: uid, currentUsername: widget.username)));


  Future<bool> showAccountOptionsAlert(BuildContext context){
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AccountOptionsDialog(
            editPhotoAction: imagePicker,
            editUsernameAction: null,
            hideAccountAction: null,
            cancelAction: cancelAlertAction,
          );
        });
  }

  cancelAlertAction(){
    Navigator.of(context).pop();
  }

  Future<Null> updateUserPic(File userImage, String uid) async {
    setState(() {
      isLoading = true;
    });
    StorageReference storageReference = FirebaseStorage.instance.ref();
    String fileName = "$uid.jpg";
    storageReference.child("profile_pics").child(fileName).putFile(userImage);
    String downloadUrl = await uploadUserImage(userImage, fileName);

    Firestore.instance.collection("users").document(uid).updateData({"profile_pic": downloadUrl}).whenComplete(() {
      setState(() {
        isLoading = false;
      });
      return true;
    }).catchError((e) {
      AlertFlushbar(headerText: "Submit Error", bodyText: e.details)
          .showAlertFlushbar(context);
    });
  }

  Future<String> uploadUserImage(File userImage, String fileName) async {
    setState(() {

    });
    StorageReference storageReference = FirebaseStorage.instance.ref();
    StorageReference ref = storageReference.child("profile_pics").child(fileName);
    StorageUploadTask uploadTask = ref.putFile(userImage);
    String downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL() as String;
    return downloadUrl;
  }

  void imagePicker() async {
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      cropImage(img);
      Navigator.of(context).pop();
    }
  }

  void cropImage(File img) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: img.path,
        ratioX: 1.0,
        ratioY: 1.0,
        toolbarTitle: 'Cropper',
        toolbarColor: FlatColors.clouds);
    if (croppedFile != null) {
      userImage = croppedFile;
      updateUserPic(userImage, uid);
    }
  }

  @override
  void initState() {
    super.initState();
    BaseAuth().currentUser().then((val) {
      setState(() {
        uid = val == null ? null : val;
      });
      NotificationDataService().getUserNotifications(uid).then((userNotifications){
        friendNotifications = NotificationDataService().filterNotifications(userNotifications, "friend");
        walletNotifications = NotificationDataService().filterNotifications(userNotifications, "wallet");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: StreamBuilder(
          stream: Firestore.instance.collection("users").document(uid).snapshots(),
          builder: (context, userSnapshot) {
            bool canMakeRewards = false;
            if (!userSnapshot.hasData) return Text("Loading...");
            var userData = userSnapshot.data;
            if (userData["canMakeRewards"] != null && userData["canMakeRewards"]) canMakeRewards = true;
            return new ListView(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
              children: <Widget>[
                SizedBox(height: 8.0),
                new ProfileHeader(
                    isLoading : isLoading,
                    userImagePath: userData["profile_pic"],
                    username: userData["username"],
                    eventPoints: userData["eventPoints"] * 1.00,
                    impact: userData["impactPoints"] * 1.00,
                    eventHistory: userData["eventHistory"],
                    canMakeRewards: canMakeRewards,
                    accountOptionsAction: () => showAccountOptionsAlert(context),
                ),
                new QuickActions(
                  friendsNotificationCount: friendNotifications.length,
                  walletNotificationCount: walletNotifications.length,
                  friendsAction: transitionToFriendsPage,
                  walletAction: () =>  Navigator.push(context, SlideFromRightRoute(widget: WalletPage(uid: uid, totalPoints: userData["eventPoints"] * 1.00))),
                ),
              ],
            );
          }
      ),
    );
  }
}