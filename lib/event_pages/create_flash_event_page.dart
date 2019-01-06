import 'package:flutter/material.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:async';
import 'package:webblen/models/event_post.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen/widgets_common/common_button.dart';
import 'package:flutter_google_places_autocomplete/flutter_google_places_autocomplete.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:webblen/widgets_common/common_alert.dart';
import 'package:webblen/firebase_services/event_data.dart';
import 'package:webblen/utils/event_tags.dart';
import 'package:webblen/services_general/services_location.dart';
import 'package:webblen/utils/strings.dart';

final homeScaffoldKey = new GlobalKey<ScaffoldState>();
final searchScaffoldKey = new GlobalKey<ScaffoldState>();
GoogleMapsPlaces _places = new GoogleMapsPlaces(apiKey: Strings.googleAPIKEY);


class CreateFlashEventPage extends StatefulWidget {

  final String uid;
  CreateFlashEventPage({this.uid});

  @override
  _CreateFlashEventPageState createState() => _CreateFlashEventPageState();
}

class _CreateFlashEventPageState extends State<CreateFlashEventPage> {

  bool isLoading = false;

  //Time
  TimeOfDay currentTime = TimeOfDay.now();
  DateFormat dateFormatter = DateFormat("MM/dd/yyyy");
  DateFormat timeFormatter = DateFormat("h:mm a");

  //Firebase
  String authorImagePath;
  String username = "Flash Event";
  List eventTags =  [];
  String eventTitle = "";
  String eventCaption = "";
  String eventDescription = "";
  bool uploadedImage = false;
  File eventImage;
  String address = "";
  String startDate = "";
  String endDate = "";
  String recurrenceType = "none";
  int recurrenceRadioVal = 0;
  String startTime = "";
  String endTime = "";
  String eventAddress = "";
  double lat;
  double lon;
  double radius = 0.25;
  String fbSite = "";
  String twitterSite = "";
  String website = "";
  String eventCost = "Free";
  String eventStartDateInMilliseconds = DateTime.now().millisecondsSinceEpoch.toString();
  String eventEndDateInMilliseconds = DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch.toString();
  EventPost eventPost;

  final StorageReference storageReference = FirebaseStorage.instance.ref();

  final flashEventFormKey = new GlobalKey<FormState>();



  //Form Validations
  void validateEvent(){
    setState(() {
      isLoading = true;
    });
    FocusScope.of(context).requestFocus(new FocusNode());
    ScaffoldState scaffold = homeScaffoldKey.currentState;
    final form = flashEventFormKey.currentState;
    form.save();
    if (eventTitle.isEmpty) {
      scaffold.showSnackBar(new SnackBar(
        content: new Text("Title Cannot be Empty"),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 800),
      ));
      setState(() {
        isLoading = false;
      });
    } else if (eventCaption.isEmpty){
      scaffold.showSnackBar(new SnackBar(
        content: new Text("Description Cannot be Empty"),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 800),
      ));
      setState(() {
        isLoading = false;
      });
    } else if (eventImage == null){
      scaffold.showSnackBar(new SnackBar(
        content: new Text("Event Must Have Image"),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 800),
      ));
      setState(() {
        isLoading = false;
      });
    } else if (lat == null || lon == null){
      scaffold.showSnackBar(new SnackBar(
        content: new Text("There was an error getting your location"),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 800),
      ));
      setState(() {
        isLoading = false;
      });
    } else {
      EventPost newFlashEvent = createFlashEvent();
      uploadFlashEvent(eventImage, newFlashEvent);
    }
  }

  uploadFlashEvent(File image, EventPost flashEvent) async {
    setState(() {
      isLoading = true;
    });
    EventPostService().uploadEvent(eventImage, flashEvent, username).then((result){
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
        ratioX: 1.0,
        ratioY: 1.0,
        toolbarTitle: 'Cropper',
        toolbarColor: FlatColors.exodusPurple
    );
    if (croppedFile != null) {
      eventImage = croppedFile;
      setState(() {});
    }
  }

  Future<bool> invalidAlert(BuildContext context) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return CancelActionDialog(
            header: "Cancel Flash Event?",
            body: "All Progress Will Be Lost",
            cancelAction: (){
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
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
          return FlashEventSuccessDialog(messageA: "Flash Event Created!", messageB: "Nearby Users Will Be Notified");
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
                  Text("Reward Submission Failed", style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                ],
              ),
            ),
            content: new Text("There Was an Issue Submitting Your Reward: $details", style: Fonts.alertDialogBody, textAlign: TextAlign.center),
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

  EventPost createFlashEvent() {
    EventPost flashEvent = EventPost(
        eventKey: "",
        address: "Address Unavailable",
        author: "Flash Event",
        authorImagePath: "https://pbs.twimg.com/profile_images/1052889774984323072/MQgZ4BcW_400x400.jpg",
        title: eventTitle,
        caption: eventCaption,
        description: "",
        startDate: dateFormatter.format(DateTime.now()),
        endDate: dateFormatter.format(DateTime.now()),
        recurrenceType: "none",
        startTime: timeFormatter.format(DateTime.now()),
        endTime: timeFormatter.format(DateTime.now().add(Duration(hours: 1))),
        isAdmin: false,
        lat: lat,
        lon: lon,
        radius: radius,
        pathToImage: "",
        tags: EventTags.allTags,
        views: 0,
        estimatedTurnout: 0,
        actualTurnout: 0,
        fbSite: fbSite,
        twitterSite: twitterSite,
        website: website,
        costToAttend: 0.00,
        eventPayout: 0.00,
        pointsDistributedToUsers: false,
        attendees: [],
        flashEvent: true,
        startDateInMilliseconds: eventStartDateInMilliseconds,
        endDateInMilliseconds: eventEndDateInMilliseconds
    );
    return flashEvent;
  }

  @override
  void initState() {
    super.initState();
    LocationService().getCurrentLocation(context).then((location){
      lat = location["latitude"];
      lon = location["longitude"];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget addImageButton() {
      return Material(
        borderRadius: BorderRadius.circular(40.0),
        elevation: 0.0,
        child: MaterialButton(
          height: 60.0,
          elevation: 0.0,
          onPressed: imagePicker,
          child: eventImage == null
              ? Container(
              height: 80.0,
              width: 80.0,
              child: Icon(Icons.camera_alt, size: 40.0, color: FlatColors.londonSquare))
              : ClipRRect(
            borderRadius: BorderRadius.circular(40.0),
            child: Image.file(eventImage, width: 80.0, height: 80.0),
          ),
        ),
      );
    }

    Widget _buildCancelButton(Color color){
      return new Row(
        children: <Widget>[
          SizedBox(width: 4.0),
          IconButton(
            icon: Icon(FontAwesomeIcons.times, color: FlatColors.londonSquare, size: 24.0),
            onPressed: () => invalidAlert(context),
          ),
        ],
      );
    }

    Widget _buildEventTitleField(){
      return new Container(
        margin: EdgeInsets.symmetric( horizontal: 16.0),
        child: new TextFormField(
          textAlign: TextAlign.center,
          initialValue: eventTitle,
          maxLength: 30,
          style: new TextStyle(color: FlatColors.blackPearl, fontSize: 24.0, fontWeight: FontWeight.w700),
          autofocus: false,
          onSaved: (value) => eventTitle = value,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Event Title",
            counterStyle: Fonts.bodyTextStyleWhite,
            contentPadding: EdgeInsets.fromLTRB(4.0, 10.0, 8.0, 0.0),
          ),
        ),
      );
    }

    Widget _buildEventDescriptionField(){
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.circular(16.0),
        ),
        child: new TextFormField(
          initialValue: eventCaption,
          maxLines: 2,
          autofocus: false,
          onSaved: (value) => eventCaption = value,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Event Description",
            counterStyle: Fonts.bodyTextStyleGray,
            contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
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
                height: 20.0,
                width: 20.0,
                child: CircularProgressIndicator(backgroundColor: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      key: homeScaffoldKey,
      body: Container(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: new ListView(
            children: <Widget>[
              new Form(
                key: flashEventFormKey,
                child: new Column(
                  children: <Widget>[
                    SizedBox(height: 16.0),
                    _buildCancelButton(Colors.white70),
                    SizedBox(height: 30.0),
                    addImageButton(),
                    SizedBox(height: 8.0),
                    _buildEventTitleField(),
                    _buildEventDescriptionField(),
                    SizedBox(height: 8.0),
                    isLoading 
                    ? _buildLoadingIndicator() 
                    : CustomColorButton(
                      text: "Create Flash Event",
                      textColor: Colors.white,
                      backgroundColor: FlatColors.blueGray,
                      height: 45.0,
                      width: 200.0,
                      onPressed: () => validateEvent(),
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
}