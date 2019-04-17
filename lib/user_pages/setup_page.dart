import 'package:flutter/material.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:webblen/widgets_common/common_header_row.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/widgets_common/common_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:io';
import 'package:webblen/utils/event_tags.dart';
import 'package:webblen/widgets_common/common_flushbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:webblen/utils/webblen_image_picker.dart';
import 'package:webblen/services_general/service_page_transitions.dart';
import 'package:webblen/services_general/services_show_alert.dart';

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
      notifyWalletDeposits: true,
      notifyNewMessages: true,
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
      friendRequests: [],
      isOnWaitList: false,
      messageToken: '',
      isNew: true
    );

    createNewUser(userImage, newUser, uid).then((error) {
      if (error.isEmpty){
        PageTransitionService(context: context).transitionToRootPage();
      }
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

  Future<String> createNewUser(File userImage, WebblenUser user, String uid) async {
    String error = "";
    ShowAlertDialogService().showLoadingDialog(context);
    StorageReference storageReference = FirebaseStorage.instance.ref();
    String fileName = "$uid.jpg";
    storageReference.child("profile_pics").child(fileName).putFile(userImage);
    String downloadUrl = await uploadUserImage(userImage, fileName);

    user.profile_pic = downloadUrl.toString();
    user.tags = selectedTags;

    Firestore.instance.collection("users").document(uid).setData(user.toMap()).whenComplete(() {
    }).catchError((e) {
      Navigator.of(context).pop();
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


  void setUserProfilePic() async {
    File newImage;
    newImage = await WebblenImagePicker(context: context, ratioX: 1.0, ratioY: 1.0).initializeImagePickerCropper();
    if (newImage != null){
      userImage = newImage;
      setState(() {});
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
    return Theme(
      data: ThemeData(
        cursorColor: Colors.white
      ),
      child:  Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: new TextFormField(
          initialValue: username,
          textAlign: TextAlign.center,
          style: new TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.w700),
          autofocus: false,
          onSaved: (value) => username = value,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Username",
            hintStyle: TextStyle(color: Colors.white30),
          ),
        ),
      ),
    );
  }

  Widget _buildInterestsGrid(){
    return new Container(
      height: MediaQuery.of(context).size.height * 0.60,
      child: isLoading
          ? Container(
        color: FlatColors.carminPink,
        child: CustomCircleProgress(30.0, 30.0, 30.0, 30.0, Colors.white),
      )
          : new GridView.count(
        crossAxisCount: 4,
        scrollDirection: Axis.horizontal,
        children: new List<Widget>.generate(availableTags.length, (index) {
          return new GridTile(
              child: new InkResponse(
                onTap: () => tagClicked(index),
                child: new Card(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                    color: selectedTags.contains(availableTags[index])
                        ? FlatColors.webblenRed
                        : Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        availableTags[index] == "wine & brew"
                            ? selectedTags.contains(availableTags[index])
                            ? Image.asset('assets/images/wine_brew_light.png', height: 32.0, width: 32.0, fit: BoxFit.contain)
                            : Image.asset('assets/images/wine_brew_dark.png', height: 32.0, width: 32.0, fit: BoxFit.contain)
                            : selectedTags.contains(availableTags[index])
                            ? Image.asset('assets/images/${availableTags[index]}_light.png', height: 32.0, width: 32.0, fit: BoxFit.contain)
                            : Image.asset('assets/images/${availableTags[index]}_dark.png', height: 32.0, width: 32.0, fit: BoxFit.contain),
                        SizedBox(height: 4.0),
                        Fonts().textW500(
                            '${availableTags[index]}',
                            12.0,
                            selectedTags.contains(availableTags[index])
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
          onTap: setUserProfilePic,
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

    final nextButton = CustomColorButton(
                    text: "Next",
                    textColor: FlatColors.darkGray,
                    backgroundColor: Colors.white,
                    height: 45.0,
                    width: 250.0,
                    onPressed: () => validateNamePic()
                  );

    final backButton = FlatBackButton("Back", FlatColors.clouds, Colors.white70, this.previousPage);

    final completeSetupButton = CustomColorButton(
                    text: "Complete Setup",
                    textColor: FlatColors.londonSquare,
                    backgroundColor: Colors.white,
                    height: 45.0,
                    width: 200.0,
                    onPressed: () => submitUsernameAndImage()
                  );

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
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [FlatColors.webblenOrange, FlatColors.webblenOrangePink]),
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Form(
              key: usernameFormKey,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  addImageButton,
                  SizedBox(height: 35.0),
                  _buildUsernameField(),
                  SizedBox(height: 35.0),
                  nextButton
                ],
              ),
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