import 'package:flutter/material.dart';
import 'package:webblen/animations/transition_animations.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/widgets_common/common_header_row.dart';
import 'package:webblen/widgets_common/common_button.dart';
import 'package:webblen/models/event_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:webblen/styles/fonts.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:webblen/utils/event_tags.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:intl/intl.dart';
import 'package:flutter_google_places_autocomplete/flutter_google_places_autocomplete.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'package:webblen/new_event_paging/confirm_new_event_page.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:webblen/utils/strings.dart';
import 'package:webblen/widgets_common/common_flushbar.dart';
import 'package:card_settings/card_settings.dart';
import 'package:webblen/widgets_common/common_appbar.dart';

class NewEventPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new _NewEventPageState();
  }
}

class _NewEventPageState extends State<NewEventPage> {

  //Time
  TimeOfDay currentTime = TimeOfDay.now();

  //Firebase
  String uid;
  String authorImagePath;
  String username = "";
  bool isLoading = true;

  //Keys
  final homeScaffoldKey = new GlobalKey<ScaffoldState>();
  final searchScaffoldKey = new GlobalKey<ScaffoldState>();
  GoogleMapsPlaces _places = new GoogleMapsPlaces(apiKey: Strings.googleAPIKEY);
  GlobalKey<FormState> page1FormKey;
  final page2FormKey = new GlobalKey<FormState>();
  final page3FormKey = new GlobalKey<FormState>();
  final page4FormKey = new GlobalKey<FormState>();
  final page5FormKey = new GlobalKey<FormState>();
  final page6FormKey = new GlobalKey<FormState>();
  final page7FormKey = new GlobalKey<FormState>();


  //Event
  final eventRef = Firestore.instance.collection("tags");
  List<String> availableTags = EventTags.allTags;
  String eventTitle = "";
  String eventCaption = "";
  String eventDescription = "";
  bool uploadedImage = false;
  File eventImage;
  List<String> eventTags = [];
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
  EventPost newEventPost = new EventPost();

  //Paging
  PageController _pageController;
  void nextPage() { _pageController.nextPage(duration: new Duration(milliseconds: 600), curve: Curves.fastOutSlowIn); }
  void previousPage(){ _pageController.previousPage(duration: new Duration(milliseconds: 600), curve: Curves.easeIn); }

  //Form Validations
  void validateEventTitleCaption(){
    final form = page1FormKey.currentState;
    form.save();
    if (eventTitle == null) {
      AlertFlushbar(headerText: "Event Title Error", bodyText: "Event Title Cannot be Empty").showAlertFlushbar(context);
    } else if (eventCaption.isEmpty){
      AlertFlushbar(headerText: "Caption Error", bodyText: "Event Caption Cannot Be Empty").showAlertFlushbar(context);
    } else {
      setState(() {
        newEventPost.title = eventTitle;
        newEventPost.caption = eventCaption;
        newEventPost.description = eventDescription;
      });
      _pageController.nextPage(duration: new Duration(milliseconds: 600), curve: Curves.fastOutSlowIn);
    }
  }

  void validateTags() {
    final form = page3FormKey.currentState;
    form.save();
    if (eventTags.isEmpty){
      AlertFlushbar(headerText: "Event Tag Error", bodyText: "Event Needs At Least 1 Tag").showAlertFlushbar(context);
    } else {
      setState(() {
        newEventPost.tags = eventTags;
      });
      nextPage();
    }
  }

  void validateDate(){
    DateFormat formatter = new DateFormat('MM/dd/yyyy');
    final form = page4FormKey.currentState;
    form.save();
    if (startDate.isEmpty) {
      startDate = formatter.format(DateTime.now());
    }
    String currentDay = formatter.format(DateTime.now());
    DateTime currentDate = formatter.parse(currentDay);
    DateTime eventDate = formatter.parse(startDate);
    if (eventDate.isBefore(currentDate)){
      AlertFlushbar(headerText: "Date Error", bodyText: "Invalid Date").showAlertFlushbar(context);
    } else {
      setState(() {
        newEventPost.startDate = startDate;
      });
      nextPage();
    }
  }


  void validateTime(){
    final form = page5FormKey.currentState;
    form.save();
    if (startTime.isEmpty) {
      AlertFlushbar(headerText: "Time Error", bodyText: "Event Needs a Start Time").showAlertFlushbar(context);
    } else if (endTime.isEmpty){
      AlertFlushbar(headerText: "Time Error", bodyText: "Event Needs an End Time").showAlertFlushbar(context);
    } else {
      setState(() {
        newEventPost.startTime = startTime;
        newEventPost.endTime = endTime;
      });
      nextPage();
    }
  }

  void validateAndSubmit(){
    final form = page7FormKey.currentState;
    form.save();
    if (eventAddress.isEmpty){
      AlertFlushbar(headerText: "Address Error", bodyText: "Address Required").showAlertFlushbar(context);
    } else {
      createEvent();
      Navigator.push(context, ScaleRoute(widget: ConfirmEventPage(newEvent: newEventPost, newEventImage: eventImage)));
    }
  }

  void validateSites(){
    final form = page6FormKey.currentState;
    form.save();
    nextPage();
  }

  void handleRadioValueChanged(int value) {
    setState(() {
      recurrenceRadioVal = value;
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
        ratioX: 3.0,
        ratioY: 5.0,
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
          return AlertDialog(
            title: Container(
              child: Column(
                children: <Widget>[
                  Image.asset("assets/images/warning.png", height: 45.0, width: 45.0),
                  SizedBox(height: 8.0),
                  Text("Cancel Event Creation?", style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                ],
              ),
            ),
            content: new Text("Any progress you've made will be lost.", style: Fonts.alertDialogBody, textAlign: TextAlign.center),
            actions: <Widget>[
              new FlatButton(
                child: new Text("No", style: Fonts.alertDialogAction),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text("Yes", style: Fonts.alertDialogAction),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (Route<dynamic> route) => false);
                },
              ),
            ],
          );
        });
  }

  Future<Null> tagClicked(int index) async {
    ScaffoldState scaffold = homeScaffoldKey.currentState;
    if (!isLoading) {
      String tag = availableTags[index];
      if (eventTags.contains(tag)) {
        setState(() {
          eventTags.remove(tag);
        });
      } else {
        if (eventTags.length == 6){
          scaffold.showSnackBar(new SnackBar(content: new Text("Max Tag Limit Reached")));
        } else {
          setState(() {
            eventTags.add(tag);
          });
        }
      }
    }
  }

  void handleNewDate(DateTime selectedDate) {
    ScaffoldState scaffold = homeScaffoldKey.currentState;
    DateTime today = DateTime.now();
    if (selectedDate.isBefore(today)) {
      scaffold.showSnackBar(new SnackBar(
        content: new Text("Invalid Event Date"),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 800),
      ));
    } else {
      DateFormat formatter = new DateFormat('MM/dd/yyyy');
      startDate = formatter.format(selectedDate);
    }
  }

  Future<Null> _selectStartTime(BuildContext context) async {
    final TimeOfDay picked =  await showTimePicker(context: context, initialTime: currentTime);
    if (picked != null){
      setState(() {
        startTime = picked.format(context);
      });
    }
  }

  Future<Null> _selectEndTime(BuildContext context) async {
    final TimeOfDay picked =  await showTimePicker(context: context, initialTime: currentTime);
    if (picked != null){
      setState(() {
        endTime = picked.format(context);
      });
    }
  }


  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
    page1FormKey = new GlobalKey<FormState>();
//    EventTagService().getTags().then((loadedTags){
//      setState(() {
//        availableTags = loadedTags;
//      });
//    });
    BaseAuth().currentUser().then((val) {
      setState(() {
        uid = val == null ? null : val;
        UserDataService().userImagePath(uid).then((pathToImage){
          setState(() {
            authorImagePath = pathToImage;
          });
        });
        UserDataService().currentUsername(val).then((currentUsername) {
          setState(() {
            username = currentUsername;
            isLoading = false;
          });
        });
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    //Image Button
    final addImageButton = Material(
      borderRadius: BorderRadius.circular(25.0),
      elevation: 0.0,
      color: Colors.transparent,
      child: InkWell(
        onTap: imagePicker,
        borderRadius: BorderRadius.circular(80.0),
        child: eventImage == null
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
          child: Image.file(eventImage, height: 280.0, width: 175.0, fit: BoxFit.cover),
        ),
      ),
    );

    //Form Buttons
    final formButton1 = NewEventFormButton("Next", FlatColors.blackPearl, Colors.white, this.validateEventTitleCaption);
    final formButton2 = NewEventFormButton("Next", FlatColors.blackPearl, Colors.white, this.nextPage);
    final backButton2 = FlatBackButton("Back", FlatColors.clouds, Colors.white70, this.previousPage);
    final formButton3 = NewEventFormButton("Next", FlatColors.blackPearl, Colors.white, this.validateTags);
    final backButton3 = FlatBackButton("Back", FlatColors.clouds, Colors.white70, this.previousPage);
    final formButton4 = NewEventFormButton("Next", FlatColors.blackPearl, Colors.white, this.validateDate);
    final backButton4 = FlatBackButton("Back", FlatColors.clouds, Colors.white70, this.previousPage);
    final formButton5 = NewEventFormButton("Next", FlatColors.blackPearl, Colors.white, this.validateTime);
    final backButton5 = FlatBackButton("Back", FlatColors.clouds, Colors.white70, this.previousPage);
    final formButton6 = NewEventFormButton("Next", FlatColors.blackPearl, Colors.white, this.validateSites);
    final backButton6 = FlatBackButton("Back", FlatColors.clouds, Colors.white70, this.previousPage);
    final formButton7 = NewEventFormButton("Submit", FlatColors.blackPearl, Colors.white, this.validateAndSubmit);
    final backButton7 = FlatBackButton("Back", FlatColors.clouds, Colors.white70, this.previousPage);

    //**Title & Caption Page Page
    final eventFormPage1 = Container(
      child: new GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Form(
          key: page1FormKey,
          child: ListView(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CardSettings(
                    cardElevation: 0.5,
                    children: <Widget>[
                      CardSettingsHeader(label: 'Event Details'),
                      CardSettingsText(
                        label: 'Title',
                        hintText: "Awesome Event Name",
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Title Required.';
                        },
                        onSaved: (value) => eventTitle = value,
                      ),
                      CardSettingsParagraph(
                        maxLength: 300,
                        maxLengthEnforced: true,
                        label: 'Description',
                        validator: (value) {
                          //if (!value.startsWith('http:')) return 'Must be a valid website.';
                          if (value == null || value.isEmpty) return 'Description Required';
                        },
                        onSaved: (value) => eventDescription = value,
                      ),
                    ],
                  ),
                  formButton1
                ],
              )

            ],
          ),
        )
      ),
//        ListView(
//          children: <Widget>[
//            new Column(
//              children: <Widget>[
//                new Form(
//                  key: page1FormKey,
//                  child: new Column(
//                    children: <Widget>[
//                      SizedBox(height: 8.0),
//                      _buildCancelButton(Colors.white70),
//                      _buildEventTitleField(),
//                      _buildEventCaptionField(),
//                      _buildEventDescriptionField(),
//                      SizedBox(height: 16.0),
//                      formButton1
//                    ],
//                  ),
//                )
//              ],
//            ),
//          ],
//        ),
      );


    //**Add Image Page
    final eventFormPage2 = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [FlatColors.webblenOrange, FlatColors.webblenOrangePink]),
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: new ListView(
          children: <Widget>[
            new Column(
              children: <Widget>[
                new Form(
                  key: page2FormKey,
                  child: new Column(
                    children: <Widget>[
                      SizedBox(height: 16.0),
                      _buildCancelButton(Colors.white70),
                      HeaderRow(16.0, 16.0, "Add Photo"),
                      SizedBox(height: 50.0),
                      addImageButton,
                      SizedBox(height: 30.0),
                      eventImage == null
                          ? SizedBox(height: 16.0)//NewEventFormButton("Skip", form2Color, Colors.white, nextPage)
                          : formButton2,
                      backButton2
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );


    //**Tags Page
    final eventFormPage3 = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [FlatColors.webblenOrangePink, FlatColors.webblenPink]),
      ),
      child: ListView(
        children: <Widget>[
          new Column(
            children: <Widget>[
              new Form(
                key: page3FormKey,
                child: new Column(
                  children: <Widget>[
                    SizedBox(height: 16.0),
                    _buildCancelButton(Colors.white70),
                    HeaderRow(8.0, 16.0, "Event Tags"),
                    _buildInterestsGrid(),
                    formButton3,
                    backButton3,
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );

    //**Calendar Page
    final eventFormPage4 = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [FlatColors.webblenPink, FlatColors.webblenPurple]),
      ),
      child: ListView(
        children: <Widget>[
          new Column(
            children: <Widget>[
              new Form(
                key: page4FormKey,
                child: new Column(
                  children: <Widget>[
                    SizedBox(height: 16.0),
                    _buildCancelButton(Colors.white70),
                    HeaderRow(16.0, 16.0, "Choose Date"),
                    _buildCalendar(),
                    HeaderRow(16.0, 16.0, "Reoccurence"),
                    _buildRadioButtons(),
                    SizedBox(height: 32.0),
                    formButton4,
                    backButton4,
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );

    //**Time Page
    final eventFormPage5 = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [FlatColors.webblenPurple, FlatColors.webblenLightBlue]),
      ),
      child: ListView(
        children: <Widget>[
          new Column(
            children: <Widget>[
              new Form(
                key: page5FormKey,
                child: new Column(
                  children: <Widget>[
                    SizedBox(height: 16.0),
                    _buildCancelButton(Colors.white70),
                    HeaderRow(16.0, 16.0, "Choose Time"),
                    _buildTimePickers(),
                    formButton5,
                    backButton5,
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );

    //**External Links
    final eventFormPage6 = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [FlatColors.webblenLightBlue, FlatColors.webblenDarkBlue]),
      ),
      child: ListView(
        children: <Widget>[
          new Form(
            key: page6FormKey,
            child: new Column(
              children: <Widget>[
                SizedBox(height: 16.0),
                _buildCancelButton(Colors.white70),
                HeaderRow(16.0, 16.0, "External Sites (Optional)"),
                SizedBox(height: 16.0),
                _buildFbUrlField(),
                _buildTwitterUrlField(),
                _buildWebUrlField(),
                SizedBox(height: 16.0),
                formButton6,
                backButton6,
              ],
            ),
          )
        ],
      ),
    );

    //**Address Page
    final eventFormPage7 = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [FlatColors.webblenDarkBlue, FlatColors.clouds]),
      ),
      child: ListView(
        children: <Widget>[
          new Form(
            key: page7FormKey,
            child: new Column(
              children: <Widget>[
                SizedBox(height: 16.0),
                _buildCancelButton(Colors.white70),
                HeaderRow(16.0, 16.0, "Address"),
                _buildSearchAutoComplete(),
                SizedBox(height: 18.0),
                HeaderRow(16.0, 16.0, "Notification Distance"),
                new Row(
                  children: <Widget>[
                    SizedBox(width: 16.0),
                    Text("${(radius.toStringAsFixed(2))} Miles", style: new TextStyle(color: Colors.white70, fontWeight: FontWeight.w400, fontSize: 16.0)),
                  ],
                ),
                _buildDistanceSlider(),
                SizedBox(height: 16.0),
                new Row(
                  children: <Widget>[
                    SizedBox(width: 16.0),
                    Text("Estimated Reach: ${(radius.round() * 13)}", style: new TextStyle(color: Colors.white70, fontWeight: FontWeight.w400, fontSize: 16.0)),
                  ],
                ),
                SizedBox(height: 16.0),
                new Row(
                  children: <Widget>[
                    SizedBox(width: 16.0),
                    Text("Total: Free", style: new TextStyle(color: Colors.white70, fontWeight: FontWeight.w400, fontSize: 16.0)),
                    //Text("Total: \$${((radius * 3.5).toStringAsFixed(2))}", style: new TextStyle(color: Colors.white70, fontWeight: FontWeight.w400, fontSize: 16.0)),
                  ],
                ),
                SizedBox(height: 30.0),
                formButton7,
                backButton7,
              ],
            ),
          )
        ],
      ),
    );

    return new Scaffold(
      appBar: WebblenAppBar().newEventAppBar(context, "New Event"),
      key: homeScaffoldKey,
      body: new PageView(
          physics: new NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            eventFormPage1,
            eventFormPage2,
            eventFormPage3,
            eventFormPage4,
            eventFormPage5,
            eventFormPage6,
            eventFormPage7
          ]
      ),
    );
  }

  //** PAGE WIDGETS
  Widget _buildCancelButton(Color color){
    return new Row(
      children: <Widget>[
        SizedBox(width: 4.0),
        IconButton(
          icon: Icon(FontAwesomeIcons.times, color: color, size: 24.0),
          onPressed: () => invalidAlert(context),
        ),
      ],
    );
  }

  Widget _buildEventTitleField(){
    return new Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: new TextFormField(
        initialValue: newEventPost.title,
        maxLength: 30,
        style: new TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.w700),
        autofocus: false,
        onSaved: (value) => eventTitle = value,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Event Title",
          hintStyle: TextStyle(color: Colors.white70),
          counterStyle: Fonts.bodyTextStyleWhite,
          contentPadding: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
        ),
      ),
    );
  }

  Widget _buildEventCaptionField(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: new BorderRadius.circular(16.0),
      ),
      child: new TextFormField(
        initialValue: newEventPost.caption,
        maxLines: 5,
        maxLength: 160,
        autofocus: false,
        onSaved: (value) => eventCaption = value,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Caption",
          counterStyle: Fonts.bodyTextStyleGray,
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        ),
      ),
    );
  }

  Widget _buildEventDescriptionField(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: new BorderRadius.circular(16.0),
      ),
      child: new TextFormField(
        initialValue: newEventPost.description,
        maxLines: 7,
        maxLength: 300,
        autofocus: false,
        onSaved: (value) => eventDescription = value,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Additional Info (Optional)",
          counterStyle: Fonts.bodyTextStyleGray,
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        ),
      ),
    );
  }

  Widget _buildCalendar(){
    return new Container(
      margin: new EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [BoxShadow(
            color: Colors.black26,
            blurRadius: 5.0,
            offset: Offset(0.0, 5.0),
          ),]
      ),
      child: Calendar(
        onDateSelected: (dateTime) => handleNewDate(dateTime),
        isExpandable: false,
        showTodayAction: false,
      ),
    );
  }

  Widget _buildRadioButtons() {
    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: new Column(
          children: <Widget>[
            new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Container(
                    child: new Row(
                      children: <Widget>[
                        new Text("none", style: new TextStyle(color: FlatColors.clouds, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                        new Radio<int>(
                          value: 0,
                          groupValue: recurrenceRadioVal,
                          onChanged: handleRadioValueChanged,
                          activeColor: Colors.white,
                        )
                      ],
                    ),
                  ),
                  new Container(
                    child: new Row(
                      children: <Widget>[
                        new Text("weekly", style: new TextStyle(color: FlatColors.clouds, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                        new Radio<int>(
                          value: 1,
                          groupValue: recurrenceRadioVal,
                          onChanged: handleRadioValueChanged,
                          activeColor: Colors.white,
                        )
                      ],
                    ),
                  ),
                  new Container(
                    child: new Row(
                      children: <Widget>[
                        new Text("monthly", style: new TextStyle(color: FlatColors.clouds, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                        new Radio<int>(
                          value: 2,
                          groupValue: recurrenceRadioVal,
                          onChanged: handleRadioValueChanged,
                          activeColor: Colors.white,
                        )
                      ],
                    ),
                  ),
                ]
            ),
          ]
      ),
    );
  }

  Widget _buildTimePickers(){
    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: new Column(
        children: <Widget>[
          SizedBox(height: 64.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Text("Start Time", style: new TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20.0)),
                  SizedBox(height: 8.0),
                  new RaisedButton(
                      color: Colors.white,
                      child: startTime.isEmpty
                          ? Text("Set Start Time", style: new TextStyle(color: FlatColors.darkGray, fontWeight: FontWeight.w600))
                          : Text("$startTime", style: new TextStyle(color: FlatColors.darkGray, fontWeight: FontWeight.w600)),
                      onPressed: () => _selectStartTime(context)
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  new Text("End Time", style: new TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20.0)),
                  SizedBox(height: 8.0),
                  new RaisedButton(
                    color: Colors.white,
                    child: endTime.isEmpty
                        ? Text("Set End Time", style: new TextStyle(color: FlatColors.darkGray, fontWeight: FontWeight.w600))
                        : Text("$endTime", style: new TextStyle(color: FlatColors.darkGray, fontWeight: FontWeight.w600)),
                    onPressed: () => _selectEndTime(context),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 64.0),
        ],
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
                  color: eventTags.contains(availableTags[index])
                      ? Colors.white30
                      : Colors.transparent,
                  child: new Center(
                    child: new Text('${availableTags[index]}', style: Fonts.bodyTextStyleWhiteSmall),
                  ),
                ),
              )
          );
        }),
      ),
    );
  }

  Widget _buildFbUrlField(){
    return new Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: new TextFormField(
        style: new TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w700),
        autofocus: false,
        onSaved: (value) => fbSite = value,
        initialValue: fbSite,
        decoration: InputDecoration(
          icon: Icon(FontAwesomeIcons.facebook, color: Colors.white),
          border: InputBorder.none,
          hintText: "Facebook URL",
          hintStyle: new TextStyle(color: FlatColors.clouds, fontWeight: FontWeight.w300),
          contentPadding: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
        ),
      ),
    );
  }

  Widget _buildTwitterUrlField(){
    return new Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: new TextFormField(
        style: new TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w700),
        autofocus: false,
        onSaved: (value) => twitterSite = value,
        initialValue: twitterSite,
        decoration: InputDecoration(
          icon: Icon(FontAwesomeIcons.twitter, color: Colors.white),
          border: InputBorder.none,
          hintText: "Twitter URL",
          hintStyle: new TextStyle(color: FlatColors.clouds, fontWeight: FontWeight.w300),
          contentPadding: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
        ),
      ),
    );
  }

  Widget _buildWebUrlField(){
    return new Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: new TextFormField(
        style: new TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w700),
        autofocus: false,
        onSaved: (value) => website = value,
        initialValue: website,
        decoration: InputDecoration(
          icon: Icon(FontAwesomeIcons.globe, color: Colors.white),
          border: InputBorder.none,
          hintText: "Website URL",
          hintStyle: new TextStyle(color: FlatColors.clouds, fontWeight: FontWeight.w300),
          contentPadding: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
        ),
      ),
    );
  }

  Widget _buildSearchAutoComplete(){
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text(
          (eventAddress == ""
              ? "Set Address"
              : "$eventAddress"),
          style: Fonts.bodyTextStyleWhite,
        ),
        SizedBox(height: 16.0),
        new RaisedButton(
            color: Colors.white70,
            onPressed: () async {
              // show input autocomplete with selected mode
              // then get the Prediction selected
              Prediction p = await showGooglePlacesAutocomplete(
                  context: context,
                  apiKey: Strings.googleAPIKEY,
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
                newEventPost.lat = lat;
                newEventPost.lon = lon;
                eventAddress = p.description;
                newEventPost.address = eventAddress;
              });
//              displayPrediction(p, homeScaffoldKey.currentState);
            },
            child: new Text("Search")),
      ],
    );
  }

  Widget _buildDistanceSlider(){
    return new Slider(
      inactiveColor: FlatColors.londonSquare,
      activeColor: Colors.white,
      value: radius,
      min: 0.25,
      max: 10.0,
      divisions: 39,
      label: '$radius d',
      onChanged: (double value) {
        setState(() {
          radius = value;
        });
      },
    );
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
      lat = detail.result.geometry.location.lat;
      lon = detail.result.geometry.location.lng;
      eventAddress = p.description;
    }
  }

  createEvent(){
    DateFormat timeFormatter = new DateFormat("MM/dd/yyyy h:mm a");
    DateTime startDateTime = timeFormatter.parse(startDate + " " + startTime);
    String startDateInMilliseconds = startDateTime.millisecondsSinceEpoch.toString();
    DateTime endDateTime = timeFormatter.parse(startDate + " " + endTime);
    String endDateInMilliseconds =  endDateTime.millisecondsSinceEpoch.toString();
    newEventPost.eventKey = "";
    newEventPost.author = username;
    newEventPost.authorImagePath = authorImagePath;
    newEventPost.recurrenceType = "none";
    newEventPost.isAdmin = false;
    newEventPost.pathToImage = "";
    newEventPost.views = 0;
    newEventPost.estimatedTurnout = 0;
    newEventPost.actualTurnout = 0;
    newEventPost.fbSite = "";
    newEventPost.twitterSite = "";
    newEventPost.website = "";
    newEventPost.costToAttend = 0.00;
    newEventPost.eventPayout = 0.00;
    newEventPost.pointsDistributedToUsers = false;
    newEventPost.attendees = [];
    newEventPost.flashEvent = false;
    newEventPost.startDateInMilliseconds = startDateInMilliseconds;
    newEventPost.endDateInMilliseconds = endDateInMilliseconds;
  }
}