import 'package:flutter/material.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:webblen/widgets_common/common_header_row.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webblen/widgets_common/common_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:webblen/utils/event_tags.dart';
import 'package:webblen/widgets_common/common_flushbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:webblen/widgets_interests/interests_row.dart';

class SetupPage extends StatefulWidget {
  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  File userImage;
  String uid;
  String username;
  bool isLoading = true;
  List<String> availableTags = EventTags.allTags;
  List<String> selectedTags = [];

  List<WebblenUser> nearbyUsers = [];

  final homeScaffoldKey = new GlobalKey<ScaffoldState>();
  final interestsFormKey = new GlobalKey<FormState>();
  final usernameFormKey = new GlobalKey<FormState>();
  final userSetupScaffoldKey = new GlobalKey<ScaffoldState>();

  //Paging
  PageController _pageController;

  void nextPage() {
    _pageController.nextPage(
        duration: new Duration(milliseconds: 600), curve: Curves.fastOutSlowIn);
  }

  void previousPage() {
    _pageController.previousPage(
        duration: new Duration(milliseconds: 600), curve: Curves.easeIn);
  }

  //Form Validations
  void submitUsernameAndImage() async {
    setState(() {
      isLoading = true;
    });

    WebblenUser newUser = WebblenUser(
      blockedUsers: [],
      username: username.replaceAll(new RegExp(r"\s+\b|\b\s"), ""),
      uid: uid,
      tags: [],
      profile_pic: "",
      eventHistory: [],
      eventPoints: 0.00,
      impactPoints: 1.00,
      rewards: [],
      savedEvents: [],
      friends: [],
      achievements: [],
      notifyFlashEvents: true,
      notifyFriendRequests: true,
      notifyHotEvents: true,
      notifySuggestedEvents: true,
      lastNotificationSentAt: "1544294035172",
      messageNotificationCount: 0,
      friendRequestNotificationCount: 0,
      achievementNotificationCount: 0,
      eventNotificationCount: 0,
      walletNotificationCount: 0,
      isCommunityBuilder: false,
      isNewCommunityBuilder: false,
      communityBuilderNotificationCount: 0,
      notificationCount: 0,
      friendRequests: []
    );

    createNewUser(userImage, newUser, uid).whenComplete(() {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/dashboard', (Route<dynamic> route) => false);
    });
  }

  validateNamePic() async {
    final form = usernameFormKey.currentState;
    form.save();
    if (username.isEmpty) {
      AlertFlushbar(headerText: "Username Error", bodyText: "Username Required").showAlertFlushbar(context);
    } else if (userImage == null) {
      AlertFlushbar(headerText: "Image Error", bodyText: "Image Required").showAlertFlushbar(context);
    } else {
      username = username.toLowerCase().trim();
      await UserDataService().checkIfUserExists(username.replaceAll(new RegExp(r"\s+\b|\b\s"), "")).then((exists){
        if (exists){
          AlertFlushbar(headerText: "Username Error", bodyText: "Username Already Taken").showAlertFlushbar(context);
        } else {
          nextPage();
        }
      });

    }
  }

  Future<Null> createNewUser(File userImage, WebblenUser user, String uid) async {
    setState(() {
      isLoading = true;
    });
    StorageReference storageReference = FirebaseStorage.instance.ref();
    String fileName = "$uid.jpg";
    storageReference.child("profile_pics").child(fileName).putFile(userImage);
    String downloadUrl = await uploadUserImage(userImage, fileName);

    user.profile_pic = downloadUrl.toString();
    user.tags = selectedTags;

    Firestore.instance.collection("users").document(uid).setData(user.toMap()).whenComplete(() {
      return true;
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      AlertFlushbar(headerText: "Submit Error", bodyText: e.details)
          .showAlertFlushbar(context);
    });
  }

  Future<String> uploadUserImage(File userImage, String fileName) async {
    StorageReference storageReference = FirebaseStorage.instance.ref();
    StorageReference ref = storageReference.child("profile_pics").child(fileName);
    StorageUploadTask uploadTask = ref.putFile(userImage);
    String downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL() as String;
    return downloadUrl;
  }

  Future<bool> failedAlert(BuildContext context, String details) {
    setState(() {
      isLoading = false;
    });
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Event Submission Failed",
                style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
            content: new Text(
                "There Was an Issue Submitting Your Event: $details",
                style: Fonts.alertDialogBody,
                textAlign: TextAlign.center),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Ok", style: Fonts.alertDialogAction),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void imagePicker() async {
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      cropImage(img);
    }
  }

  void cropImage(File img) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: img.path,
        ratioX: 1.0,
        ratioY: 1.0,
        toolbarTitle: 'Cropper',
        toolbarColor: FlatColors.exodusPurple);
    if (croppedFile != null) {
      userImage = croppedFile;
    }
  }

  Future<Null> tagClicked(int index) async {
    String tag = availableTags[index];
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

  Widget _buildUsernameField() {
    return new Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: new TextFormField(
        initialValue: username,
        textAlign: TextAlign.center,
        style: new TextStyle(
            color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.w700),
        autofocus: false,
        onSaved: (value) => username = value,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Username",
          hintStyle: TextStyle(color: Colors.white30),
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
        children: isLoading == true ? <Widget>[CustomCircleProgress(40.0, 40.0, 40.0, 40.0, Colors.black45)]
            : new List<Widget>.generate(availableTags.length, (index) {
          return new GridTile(
            child: new InkResponse(
              onTap: () => tagClicked(index),
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                  child: InterestRow(
                      interest: availableTags[index],
                      isInterested: selectedTags.contains(availableTags[index]) ? true : false)
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  void initState() {
    _pageController = new PageController();
    super.initState();
    BaseAuth().currentUser().then((userID) {
      setState(() {
        uid = userID;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final addImageButton = Material(
      borderRadius: BorderRadius.circular(25.0),
      elevation: 0.0,
      color: Colors.transparent,
      child: InkWell(
          onTap: imagePicker,
          borderRadius: BorderRadius.circular(80.0),
          child: userImage == null
              ? new Icon(Icons.camera_alt, size: 40.0, color: Colors.white,)
              : new Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                boxShadow: ([
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2.0,
                    spreadRadius: 2.0,
                    offset: Offset(0.0, 5.0),
                  ),
                ])),
            child: CircleAvatar(
              backgroundImage: FileImage(userImage),
              radius: 80.0,
            ),
          )
      ),
    );

    final nextButton = PrimaryButton("Next", 45.0, this.validateNamePic);
    final backButton = FlatBackButton("Back", FlatColors.clouds, Colors.white70, this.previousPage);
    final completeSetupButton = PrimaryButton("Complete Setup", 45.0, this.submitUsernameAndImage);

    //**Tags Page
    final interestsPage = Container(
      child: ListView(
        children: <Widget>[
          new Column(
            children: <Widget>[
              new Form(
                key: interestsFormKey,
                child: new Column(
                  children: <Widget>[
                    SizedBox(height: 16.0),
                    DarkHeaderRowWithAction(8.0, 16.0, "Select Interests", () => this.submitUsernameAndImage()),
                    Container(
                      height: 1.0,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black45
                    ),
                    _buildInterestsGrid(),
                    completeSetupButton,
                    backButton,
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );

    final namePicPage = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [FlatColors.webblenOrange, FlatColors.webblenOrangePink]),
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            new Form(
              key: usernameFormKey,
              child: new Column(
                children: <Widget>[
                  SizedBox(height: 16.0),
                  HeaderRow(16.0, 16.0, "Setup Profile"),
                  SizedBox(height: 50.0),
                  addImageButton,
                  SizedBox(height: 50.0),
                  _buildUsernameField(),
                  SizedBox(height: 50.0),
                  nextButton
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return new Scaffold(
      key: homeScaffoldKey,
      body: new PageView(
          physics: new NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [namePicPage, interestsPage]),
    );
  }
}