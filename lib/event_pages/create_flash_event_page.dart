import 'package:flutter/material.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'dart:async';
import 'package:webblen/models/event_post.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen/widgets_common/common_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:webblen/widgets_common/common_alert.dart';
import 'package:webblen/firebase_services/event_data.dart';
import 'package:webblen/utils/event_tags.dart';
import 'package:webblen/services_general/services_location.dart';
import 'package:webblen/utils/webblen_image_picker.dart';
import 'package:webblen/services_general/services_show_alert.dart';
import 'package:webblen/services_general/service_page_transitions.dart';
import 'package:webblen/widgets_common/common_appbar.dart';

final homeScaffoldKey = new GlobalKey<ScaffoldState>();
final searchScaffoldKey = new GlobalKey<ScaffoldState>();

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
    ShowAlertDialogService().showLoadingDialog(context);
    EventPostService().uploadEvent(eventImage, flashEvent, username).then((error){
      if (error.isEmpty){
        Navigator.of(context).pop();
        ShowAlertDialogService().showActionSuccessDialog(
            context,
            'Flash Event Created!',
            'Nearby Users Will Be Notified!',
            (){
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            }
        );
      } else {
        Navigator.of(context).pop();
        ShowAlertDialogService().showFailureDialog(context, 'Event Submission Failed', 'Please Try Again');
        setState(() {
          isLoading = false;
        });
      }
    });
  }


  void imagePicker() async {
    File img = await WebblenImagePicker(context: context, ratioX: 9.0, ratioY: 7.0).initializeImagePickerCropper();
    if (img != null) {
      eventImage = img;
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
      lat = location.latitude;
      lon = location.longitude;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget addImageButton() {
      return GestureDetector(
        onTap: imagePicker,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 300.0,
          decoration: BoxDecoration(
            color: Colors.black12
          ),
          child: eventImage == null
            ? Center(
                child: Icon(Icons.camera_alt, size: 40.0, color: FlatColors.londonSquare),
              )
            : Image.file(eventImage, fit: BoxFit.cover),
        ),
      );
    }

    Widget _buildEventTitleField(){
      return new Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: new TextFormField(
          textAlign: TextAlign.center,
          initialValue: eventTitle,
          maxLength: 30,
          style: TextStyle(color: FlatColors.blackPearl, fontFamily: 'Nunito', fontSize: 24.0, fontWeight: FontWeight.w700),
          autofocus: false,
          onSaved: (value) => eventTitle = value,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Event Title",
            counterStyle: TextStyle(fontFamily: 'Barlow'),
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
          textAlign: TextAlign.center,
          initialValue: eventCaption,
          maxLines: 2,
          autofocus: false,
          onSaved: (value) => eventCaption = value,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Event Description",
            counterStyle: TextStyle(fontFamily: 'Barlow'),
            contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: WebblenAppBar().basicAppBar('Create Flash Event'),
      key: homeScaffoldKey,
      body: Container(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: new ListView(
            children: <Widget>[
              new Form(
                key: flashEventFormKey,
                child:  Column(
                  children: <Widget>[
                    addImageButton(),
                    SizedBox(height: 8.0),
                    _buildEventTitleField(),
                    _buildEventDescriptionField(),
                    SizedBox(height: 8.0),
                    CustomColorButton(
                      text: "Create Flash Event",
                      textColor: FlatColors.darkGray,
                      backgroundColor: Colors.white,
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