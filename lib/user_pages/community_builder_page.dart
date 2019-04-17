import 'package:flutter/material.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:async';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen/firebase_services/community_data.dart';
import 'package:webblen/widgets_common/common_button.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:webblen/models/community_news.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:webblen/models/webblen_user.dart';

final homeScaffoldKey = new GlobalKey<ScaffoldState>();
final searchScaffoldKey = new GlobalKey<ScaffoldState>();
final kGoogleApiKey = "AIzaSyB_2NYpBFaRL7lJfgYY_VRkWTAWH__YPP0";
GoogleMapsPlaces _places = new GoogleMapsPlaces(apiKey: kGoogleApiKey);


class CommunityBuilderPage extends StatefulWidget {

  final WebblenUser currentUser;
  CommunityBuilderPage({this.currentUser});

  @override
  _CommunityBuilderPageState createState() => _CommunityBuilderPageState();
}

class _CommunityBuilderPageState extends State<CommunityBuilderPage> {

  //Firebase
  String uid;
  String timestamp;
  String newsTitle;
  File newsImage;
  String newsImageUrl = "";
  String newsUrl = "";
  String content;
  String contentType;
  bool isGlobal = true;
  bool alwaysDisplay = true;
  double lat;
  double lon;
  bool isLoading = false;
  bool uploadedImage = false;
  String address;
  final StorageReference storageReference = FirebaseStorage.instance.ref();

  final communityPostKey = new GlobalKey<FormState>();



  //Form Validations
  void validateNews(){
    setState(() {
      isLoading = true;
    });
    ScaffoldState scaffold = homeScaffoldKey.currentState;
    final form = communityPostKey.currentState;
    form.save();
    if (newsTitle.isEmpty) {
      scaffold.showSnackBar(new SnackBar(
        content: new Text("Title Cannot be Empty"),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 800),
      ));
      setState(() {
        isLoading = false;
      });
    } else if (content.isEmpty){
      scaffold.showSnackBar(new SnackBar(
        content: new Text("Description Cannot be Empty"),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 800),
      ));
      setState(() {
        isLoading = false;
      });
    } else if (newsImage == null){
      scaffold.showSnackBar(new SnackBar(
        content: new Text("Post Must Have Image"),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 800),
      ));
      setState(() {
        isLoading = false;
      });
    } else if (lat == null || lon == null){
      scaffold.showSnackBar(new SnackBar(
        content: new Text("Post Must Have a Location"),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 800),
      ));
      setState(() {
        isLoading = false;
      });
    } else {
      CommunityNewsPost newsPost = createNewsPost();
      uploadNewsPost(newsImage, newsPost);
    }
  }

  void imagePicker() async {
    //File img = await ImagePicker.pickImage(source: ImageSource.camera);
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      cropImage(img);
      setState(() {});
    }
  }

  void cropImage(File img) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: img.path,
        ratioX: 4.0,
        ratioY: 3.0,
        toolbarTitle: 'Cropper',
        toolbarColor: FlatColors.clouds
    );
    if (croppedFile != null) {
      newsImage = croppedFile;
      setState(() {});
    }
  }

  Future<bool> invalidAlert(BuildContext context) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(
              child: Column(
                children: <Widget>[
                  Image.asset("assets/images/warning.png", height: 45.0, width: 45.0),
                  SizedBox(height: 8.0),
                  Fonts().textW700('Place Text Here', 18.0, FlatColors.darkGray, TextAlign.center),
                  //Text("Cancel Community Post?", style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                ],
              ),
            ),
            content: Fonts().textW700('Place Text Here', 18.0, FlatColors.darkGray, TextAlign.center),
            //new Text("Any progress you've made will be lost.", style: Fonts.alertDialogBody, textAlign: TextAlign.center),
            actions: <Widget>[
              new FlatButton(
                child: Fonts().textW700('Place Text Here', 18.0, FlatColors.darkGray, TextAlign.center),
                //new Text("No", style: Fonts.alertDialogAction),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: Fonts().textW700('Place Text Here', 18.0, FlatColors.darkGray, TextAlign.center),
                //new Text("Yes", style: Fonts.alertDialogAction),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<bool> successAlert(BuildContext context) {
    setState(() {
      isLoading = false;
    });
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title:Container(
              child: Column(
                children: <Widget>[
                  Image.asset("assets/images/checked.png", height: 45.0, width: 45.0),
                  SizedBox(height: 8.0),
                  Fonts().textW700('Place Text Here', 18.0, FlatColors.darkGray, TextAlign.center),
                  //Text("Post Submitted!", style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                ],
              ),
            ),
            content: Fonts().textW700('Place Text Here', 18.0, FlatColors.darkGray, TextAlign.center),
            //new Text("Your Post Will Be Shown to Your Community", style: Fonts.alertDialogBody, textAlign: TextAlign.center),
            actions: <Widget>[
              new FlatButton(
                child: Fonts().textW700('Place Text Here', 18.0, FlatColors.darkGray, TextAlign.center),
                //new Text("Ok", style: Fonts.alertDialogAction),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
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
            title: Container(
              child: Column(
                children: <Widget>[
                  Image.asset("assets/images/warning.png", height: 45.0, width: 45.0),
                  SizedBox(height: 8.0),
                  Fonts().textW700('Place Text Here', 18.0, FlatColors.darkGray, TextAlign.center),
                  //Text("Post Submission Failed", style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                ],
              ),
            ),
            content: Fonts().textW700('Place Text Here', 18.0, FlatColors.darkGray, TextAlign.center),
            //new Text("There Was an Issue Submitting Your Post: $details", style: Fonts.alertDialogBody, textAlign: TextAlign.center),
            actions: <Widget>[
              new FlatButton(
                child:Fonts().textW700('Place Text Here', 18.0, FlatColors.darkGray, TextAlign.center),
                //new Text("Ok", style: Fonts.alertDialogAction),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  uploadNewsPost(File image, CommunityNewsPost newsPost) async {
    setState(() {
      isLoading = true;
    });
    await CommunityDataService().uploadNews(image, newsPost).then((result){
      if (result.toString() == "success"){
        successAlert(context);
      } else {
        failedAlert(context, result.toString());
        setState(() {
          isLoading = false;
        });
      }
    });
  }


  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
      lat = detail.result.geometry.location.lat;
      lon = detail.result.geometry.location.lng;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: homeScaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [FlatColors.vibrantYellow, FlatColors.casandoraYellow]),
        ),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: new ListView(
            children: <Widget>[
              new Form(
                key: communityPostKey,
                child: new Column(
                  children: <Widget>[
                    SizedBox(height: 16.0),
                    _buildCancelButton(Colors.white70),
                    SizedBox(height: 30.0),
                    addImageButton(),
                    SizedBox(height: 8.0),
                    _buildNewsTitleField(),
                    SizedBox(height: 8.0),
                    _buildPostContent(),
                    SizedBox(height: 8.0),
                    _buildPostContentTypeField(),
                    SizedBox(height: 8.0),
                    _buildNewsUrlField(),
                    SizedBox(height: 8.0),
                    _buildSearchAutoComplete(),
                    SizedBox(height: 8.0),
                    isLoading 
                    ? _buildLoadingIndicator() 
                    : CustomColorButton(
                        text: "Submit News",
                        textColor: Colors.white,
                        backgroundColor: FlatColors.blueGray,
                        height: 45.0,
                        width: 200.0,
                        onPressed: () => validateNews(),
                      ),
                    SizedBox(height: 24.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget addImageButton() {
    return Material(
      borderRadius: BorderRadius.circular(40.0),
      elevation: 0.0,
      child: MaterialButton(
        height: 60.0,
        elevation: 0.0,
        color: Colors.white,
        onPressed: imagePicker,
        child: newsImage == null
            ? Container(
            height: 80.0,
            width: 80.0,
            child: Icon(Icons.camera_alt, size: 40.0, color: FlatColors.londonSquare))
            : ClipRRect(
          borderRadius: BorderRadius.circular(40.0),
          child: Image.file(newsImage, width: 80.0, height: 80.0),
        ),
      ),
    );
  }

  Widget _buildCancelButton(Color color){
    return new Row(
      children: <Widget>[
        SizedBox(width: 4.0),
        IconButton(
          icon: Icon(FontAwesomeIcons.times, color: Colors.white, size: 24.0),
          onPressed: () => invalidAlert(context),
        ),
      ],
    );
  }

  Widget _buildNewsTitleField(){
    return new Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: new TextFormField(
        initialValue: newsTitle,
        maxLength: 30,
        style: new TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.w700),
        autofocus: false,
        onSaved: (value) => newsTitle = value,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Post Title",
          counterStyle: TextStyle(fontFamily: 'Barlow'),
          contentPadding: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
        ),
      ),
    );
  }

  Widget _buildPostContent(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: new BorderRadius.circular(16.0),
      ),
      child: new TextFormField(
        initialValue: content,
        maxLines: 2,
        autofocus: false,
        onSaved: (value) => content = value,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Content",
          counterStyle: TextStyle(fontFamily: 'Barlow'),
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        ),
      ),
    );
  }

  Widget _buildPostContentTypeField(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: new BorderRadius.circular(16.0),
      ),
      child: new TextFormField(
        initialValue: contentType,
        maxLines: 1,
        autofocus: false,
        onSaved: (value) => contentType = value,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Content Type",
          counterStyle: TextStyle(fontFamily: 'Barlow'),
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        ),
      ),
    );
  }

  Widget _buildNewsUrlField(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: new BorderRadius.circular(16.0),
      ),
      child: new TextFormField(
        initialValue: newsUrl,
        maxLines: 1,
        autofocus: false,
        onSaved: (value) => newsUrl = value,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Post Url (Optional)",
          counterStyle: TextStyle(fontFamily: 'Barlow'),
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        ),
      ),
    );
  }


  Widget _buildSearchAutoComplete(){
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 16.0),
        new RaisedButton(
            color: Colors.white70,
            onPressed: () async {
              // show input autocomplete with selected mode
              // then get the Prediction selected
              Prediction p = await PlacesAutocomplete.show(
                  context: context,
                  apiKey: kGoogleApiKey,
                  onError: (res) {
                    homeScaffoldKey.currentState.showSnackBar(
                        new SnackBar(content: new Text(res.errorMessage)));
                  },
                  mode: Mode.overlay,
                  language: "en",
                  components: [new Component(Component.country, "us")]);
              PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
              setState(() {
                lat = detail.result.geometry.location.lat;
                lon = detail.result.geometry.location.lng;
                address = detail.result.formattedAddress;
              });
            },
            child: new Text(address == null ? "Set Location" : "$address")),
      ],
    );
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
              height: 20.0,
              width: 20.0,
              child: CircularProgressIndicator(backgroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  CommunityNewsPost createNewsPost(){
    CommunityNewsPost newsPost = CommunityNewsPost(
      alwaysDisplay: alwaysDisplay,
      username: widget.currentUser.username,
      userImageUrl: widget.currentUser.profile_pic,
      isGlobal: isGlobal,
      lat: lat,
      lon: lon,
      newsImageUrl: newsImageUrl,
      newsTitle: newsTitle,
      newsUrl: newsUrl,
      content: content,
      contentType: contentType,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString()
    );
    return newsPost;
  }

}