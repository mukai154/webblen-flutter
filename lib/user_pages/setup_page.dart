import 'package:flutter/material.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'package:webblen/models/webblen_user.dart';
import 'package:webblen/common_widgets/common_header_row.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:webblen/common_widgets/common_button.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:location/location.dart';


class SetupPage extends StatefulWidget {

  @override
  _SetupPageState createState() => _SetupPageState();
}


class _SetupPageState extends State<SetupPage> {

  File userImage;
  String uid;
  String username;
  bool isLoading = true;
  double currentLat;
  double currentLon;
  List<WebblenUser> nearbyUsers = [];


  Map<String, double> _startLocation;
  Map<String, double> _currentLocation;
  StreamSubscription<Map<String, double>> _locationSubscription;
  Location _location = new Location();
  bool retrievedLocation = false;
  bool _permission = false;

  final usernameFormKey = new GlobalKey<FormState>();
  final userSetupScaffoldKey = new GlobalKey<ScaffoldState>();

  //Form Validations
  void submitUsernameAndImage() async {
    setState(() {
      isLoading = true;
    });
    ScaffoldState scaffold = userSetupScaffoldKey.currentState;
    final form = usernameFormKey.currentState;
    form.save();
    if (username.isEmpty) {
      setState(() {
        isLoading = false;
      });
      scaffold.showSnackBar(new SnackBar(
        content: new Text("Username Required"),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 800),
      ));
    } else if (userImage == null){
      setState(() {
        isLoading = false;
      });
      scaffold.showSnackBar(new SnackBar(
        content: new Text("User Image Required"),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 800),
      ));
    } else {
      username = username.toLowerCase().replaceAll(new RegExp(r"\s+\b|\b\s"), "");
      UserDataService().checkIfUserExists(username).then((exists){
        if (exists){
          setState(() {
            isLoading = false;
            scaffold.showSnackBar(new SnackBar(
              content: new Text("Username Already Exists"),
              backgroundColor: Colors.red,
              duration: Duration(milliseconds: 800),
            ));
          });
        } else {
          WebblenUser newUser = WebblenUser(blockedUsers: [], username: username, uid: uid, tags: [], profile_pic: "", eventHistory: [], eventPoints: 0);
          createNewUser(userImage, newUser, uid).whenComplete((){
              Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (Route<dynamic> route) => false);
          });
        }
      });
    }
  }

  Future<Null> createNewUser(File userImage, WebblenUser user, String uid) async {
    setState(() {
      isLoading = true;
    });
    StorageReference storageReference = FirebaseStorage.instance.ref();
    final String fileName = "$uid.jpg";
    final StorageUploadTask task = storageReference.child("profile_pics").child(fileName).putFile(userImage);
    final Uri downloadUrl = (await task.future).downloadUrl;

    user.profile_pic = downloadUrl.toString();

    Firestore.instance.collection("users").document(uid).setData(user.toMap()).whenComplete(() {
      return true;
    }).catchError((e) {
      setState(() {
        isLoading = false;
        failedAlert(context, e.details);
      });
    });

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
            title: new Text("Event Submission Failed", style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
            content: new Text("There Was an Issue Submitting Your Event: $details", style: Fonts.alertDialogBody, textAlign: TextAlign.center),
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
    //File img = await ImagePicker.pickImage(source: ImageSource.camera);
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
        toolbarColor: FlatColors.exodusPurple
    );
    if (croppedFile != null) {
      userImage = croppedFile;
    }
  }

  Widget _buildUsernameField(){
    return new Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: new TextFormField(
        textAlign: TextAlign.center,
        style: new TextStyle(color: FlatColors.blackPearl, fontSize: 30.0, fontWeight: FontWeight.w700),
        autofocus: false,
        onSaved: (value) => username = value,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Username",
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(){
    return Theme(
      data: ThemeData(
          accentColor: FlatColors.londonSquare
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
      width: MediaQuery.of(context).size.width,
      color: FlatColors.clouds,
      child: new Column /*or Column*/(
        children: <Widget>[
          SizedBox(height: 240.0),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BaseAuth().currentUser().then((userID){
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
      child: MaterialButton(
        onPressed: imagePicker,
        height: 100.0,
        minWidth: 100.0,
        child: userImage == null
            ? new Icon(Icons.camera_alt, size: 40.0)
            : new ConstrainedBox(constraints: new BoxConstraints.expand(height: 100.0, width: 100.0),
          child: new Image.file(userImage, fit: BoxFit.cover),
        ),
      ),
    );

    final submitButton = PrimaryButton("Next", 45.0, this.submitUsernameAndImage);

    final body = Container(
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
                      DarkHeaderRow(16.0, 16.0, "Setup Profile"),
                      SizedBox(height: 30.0),
                      addImageButton,
                      SizedBox(height: 30.0),
                      _buildUsernameField(),
                      SizedBox(height: 16.0),
                      submitButton,
                    ],
                  ),
                )
              ],
        ),
      ),
    );

    return Scaffold(
      key: userSetupScaffoldKey,
      body: isLoading ? _buildLoadingScreen() : body,
    );
  }
}