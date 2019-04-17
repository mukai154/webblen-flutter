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
import 'package:webblen/utils/webblen_image_picker.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'package:webblen/new_event_paging/confirm_new_event_page.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:webblen/utils/strings.dart';
import 'package:webblen/services_general/services_location.dart';
import 'package:webblen/widgets_common/common_flushbar.dart';
import 'package:webblen/widgets_common/common_appbar.dart';
import 'package:webblen/services_general/services_show_alert.dart';
import 'package:webblen/models/webblen_user.dart';

class NewEventPage extends StatefulWidget {

  final WebblenUser currentUser;
  NewEventPage({this.currentUser});

  @override
  State<StatefulWidget> createState() {
    return _NewEventPageState();
  }
}

class _NewEventPageState extends State<NewEventPage> {

  //Time
  TimeOfDay currentTime = TimeOfDay.now();

  //Keys
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  final searchScaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: Strings.googleAPIKEY);
  GlobalKey<FormState> page1FormKey;
  final page2FormKey = GlobalKey<FormState>();
  final page3FormKey = GlobalKey<FormState>();
  final page4FormKey = GlobalKey<FormState>();
  final page5FormKey = GlobalKey<FormState>();
  final page6FormKey = GlobalKey<FormState>();
  final page7FormKey = GlobalKey<FormState>();

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
  EventPost newEventPost = EventPost();
  List<String> pageTitles = ['Event Details', 'Add Photo', 'Event Tags', 'Event Date', 'Event Time', 'External Links', 'Event Address'];
  int eventPageTitleIndex = 0;

  //Paging
  PageController _pageController;
  void nextPage() {
    setState(() {
      eventPageTitleIndex += 1;
    });
    _pageController.nextPage(duration: Duration(milliseconds: 600), curve: Curves.fastOutSlowIn);
  }
  void previousPage(){
    setState(() {
      eventPageTitleIndex -= 1;
    });
    _pageController.previousPage(duration: Duration(milliseconds: 600), curve: Curves.easeIn);
  }

  //Form Validations
  void validateEventTitleCaption(){
    final form = page1FormKey.currentState;
    form.save();
    if (eventTitle == null || eventTitle.isEmpty) {
      AlertFlushbar(headerText: "Event Title Error", bodyText: "Event Title Cannot be Empty").showAlertFlushbar(context);
    } else if (eventCaption == null || eventCaption.isEmpty){
      AlertFlushbar(headerText: "Description Error", bodyText: "Event Description Cannot Be Empty").showAlertFlushbar(context);
    } else {
      setState(() {
        newEventPost.title = eventTitle;
        newEventPost.caption = eventCaption;
      });
      nextPage();
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
    DateFormat formatter = DateFormat('MM/dd/yyyy');
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

  void setEventImagePic() async {
    File newImage;
    newImage = await WebblenImagePicker(context: context, ratioX: 3.0, ratioY: 5.0).initializeImagePickerCropper();
    if (newImage != null){
      eventImage = newImage;
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
                  //Text("Cancel Event Creation?", style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                ],
              ),
            ),
            content: Fonts().textW700('Place Text Here', 18.0, FlatColors.darkGray, TextAlign.center),
            //Text("Any progress you've made will be lost.", style: Fonts.alertDialogBody, textAlign: TextAlign.center),
            actions: <Widget>[
              FlatButton(
                child: Fonts().textW700('Place Text Here', 18.0, FlatColors.darkGray, TextAlign.center),
                //Text("No", style: Fonts.alertDialogAction),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Fonts().textW700('Place Text Here', 18.0, FlatColors.darkGray, TextAlign.center),
               // Text("Yes", style: Fonts.alertDialogAction),
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
    String tag = availableTags[index];
    if (eventTags.contains(tag)) {
      setState(() {
        eventTags.remove(tag);
      });
    } else {
      if (eventTags.length == 6){
        scaffold.showSnackBar(SnackBar(content: Text("Max Tag Limit Reached")));
      } else {
        setState(() {
          eventTags.add(tag);
        });
      }
    }
  }

  void handleNewDate(DateTime selectedDate) {
    ScaffoldState scaffold = homeScaffoldKey.currentState;
    DateTime today = DateTime.now();
    if (selectedDate.isBefore(today)) {
      scaffold.showSnackBar(SnackBar(
        content: Text("Invalid Event Date"),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 800),
      ));
    } else {
      DateFormat formatter = DateFormat('MM/dd/yyyy');
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
    _pageController = PageController();
    page1FormKey = GlobalKey<FormState>();
  }


  @override
  Widget build(BuildContext context) {
    //Image Button
    final addImageButton = Material(
      borderRadius: BorderRadius.circular(25.0),
      elevation: 0.0,
      color: Colors.transparent,
      child: InkWell(
        onTap: setEventImagePic,
        borderRadius: BorderRadius.circular(80.0),
        child: eventImage == null
            ? Icon(Icons.camera_alt, size: 40.0, color: FlatColors.darkGray,)
            : Container(
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
    final formButton3 = NewEventFormButton("Next", FlatColors.blackPearl, Colors.white, this.validateTags);
    final formButton4 = NewEventFormButton("Next", FlatColors.blackPearl, Colors.white, this.validateDate);
    final formButton5 = NewEventFormButton("Next", FlatColors.blackPearl, Colors.white, this.validateTime);
    final formButton6 = NewEventFormButton("Next", FlatColors.blackPearl, Colors.white, this.validateSites);
    final formButton7 = NewEventFormButton("Submit", FlatColors.blackPearl, Colors.white, this.validateAndSubmit);
    final backButton = FlatBackButton("Back", FlatColors.blackPearl, Colors.white, this.previousPage);

    //**Title & Caption Page Page
    final eventFormPage1 = Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Form(
          key: page1FormKey,
          child: ListView(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                    child: TextFormField(
                      style: TextStyle(color: FlatColors.darkGray, fontWeight: FontWeight.w700, fontSize: 24.0),
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      validator: (value) => value.isEmpty ? 'Title Cannot Be Empty' : null,
                      onSaved: (value) => eventTitle = value,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Event Title",
                        hintStyle: TextStyle(color: Colors.black26),
                        errorStyle: TextStyle(color: Colors.red),
                        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                    child: TextFormField(
                      style: TextStyle(color: FlatColors.darkGray, fontWeight: FontWeight.w700),
                      keyboardType: TextInputType.multiline,
                      autofocus: false,
                      validator: (value) => value.isEmpty ? 'Description Cannot Be Empty' : null,
                      onSaved: (value) => eventCaption = value,
                      maxLength: 500,
                      maxLengthEnforced: true,
                      maxLines: 10,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Description",
                        hintStyle: TextStyle(color: Colors.black12),
                        errorStyle: TextStyle(color: Colors.red),
                        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                      ),
                    ),
                  ),
                  formButton1
                ],
              )

            ],
          ),
        )
      ),
    );


    //**Add Image Page
    final eventFormPage2 = Container(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Form(
                  key: page2FormKey,
                  child: Column(
                    children: <Widget>[
                      eventImage == null
                          ? SizedBox(height: MediaQuery.of(context).size.height * 0.3)
                          : SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                      addImageButton,
                      SizedBox(height: 30.0),
                      eventImage == null
                          ? SizedBox(height: 16.0)//NewEventFormButton("Skip", form2Color, Colors.white, nextPage)
                          : formButton2,
                      backButton
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
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Form(
                key: page3FormKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    _buildInterestsGrid(),
                    formButton3,
                    backButton,
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

      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Form(
                key: page4FormKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                    _buildCalendar(),
                    DarkHeaderRow(16.0, 16.0, "Reoccurence"),
                    _buildRadioButtons(),
                    SizedBox(height: 32.0),
                    formButton4,
                    backButton,
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
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Form(
                key: page5FormKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    _buildTimePickers(),
                    formButton5,
                    backButton,
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
      child: ListView(
        children: <Widget>[
          Form(
            key: page6FormKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.13),
                _buildFbUrlField(),
                _buildTwitterUrlField(),
                _buildWebUrlField(),
                SizedBox(height: 16.0),
                formButton6,
                backButton,
              ],
            ),
          )
        ],
      ),
    );

    //**Address Page
    final eventFormPage7 = Container(
      child: ListView(
        children: <Widget>[
          Form(
            key: page7FormKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.13),
                _buildSearchAutoComplete(),
                SizedBox(height: 32.0),
                Row(
                  children: <Widget>[
                    SizedBox(width: 16.0),
                    Fonts().textW500('Notify Users Within: ', 16.0, FlatColors.darkGray, TextAlign.left),
                    Fonts().textW400('${(radius.toStringAsFixed(2))} Miles ', 16.0, FlatColors.darkGray, TextAlign.left),
                  ],
                ),
                _buildDistanceSlider(),
                SizedBox(height: 32.0),
                Row(
                  children: <Widget>[
                    SizedBox(width: 16.0),
                    Fonts().textW700('Estimated Reach: ', 16.0, FlatColors.darkGray, TextAlign.left),
                    Fonts().textW400('${(radius.round() * 13)}', 16.0, FlatColors.darkGray, TextAlign.left),
                  ],
                ),
                SizedBox(height: 4.0),
                Row(
                  children: <Widget>[
                    SizedBox(width: 16.0),
                    Fonts().textW700('Total Cost: ', 16.0, FlatColors.darkGray, TextAlign.left),
                    Fonts().textW400('FREE', 16.0, FlatColors.darkGray, TextAlign.left),
                  ],
                ),
                SizedBox(height: 30.0),
                formButton7,
                backButton,
              ],
            ),
          )
        ],
      ),
    );

    return Scaffold(
      appBar: WebblenAppBar().newEventAppBar(context, pageTitles[eventPageTitleIndex]),
      key: homeScaffoldKey,
      body: PageView(
          physics: NeverScrollableScrollPhysics(),
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

  Widget _buildCalendar(){
    return Theme(
        data: ThemeData(
          primaryColor: FlatColors.webblenRed,
          accentColor: FlatColors.webblenRed,
        ),
        child: Container(
          margin: EdgeInsets.symmetric(
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
            isExpandable: true,
            showTodayAction: false,
          ),
        ),
    );
  }

  Widget _buildRadioButtons() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Fonts().textW500("none", 16.0, FlatColors.darkGray, TextAlign.left),
                        Radio<int>(
                          value: 0,
                          groupValue: recurrenceRadioVal,
                          onChanged: handleRadioValueChanged,
                          activeColor: FlatColors.webblenRed,
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Fonts().textW500("weekly", 16.0, FlatColors.darkGray, TextAlign.left),
                        Radio<int>(
                          value: 1,
                          groupValue: recurrenceRadioVal,
                          onChanged: handleRadioValueChanged,
                          activeColor: FlatColors.webblenRed,
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Fonts().textW500("monthly", 16.0, FlatColors.darkGray, TextAlign.left),
                        Radio<int>(
                          value: 2,
                          groupValue: recurrenceRadioVal,
                          onChanged: handleRadioValueChanged,
                          activeColor: FlatColors.webblenRed,
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
    return Theme(
      data: ThemeData(
        primaryColor: FlatColors.webblenRed,
        accentColor: FlatColors.webblenRed,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 64.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Start Time", style: TextStyle(color: FlatColors.darkGray, fontWeight: FontWeight.w600, fontSize: 20.0)),
                    SizedBox(height: 8.0),
                    RaisedButton(
                        color: Colors.white,
                        child: startTime.isEmpty
                            ? Text("Set Start Time", style: TextStyle(color: FlatColors.darkGray, fontWeight: FontWeight.w600))
                            : Text("$startTime", style: TextStyle(color: FlatColors.darkGray, fontWeight: FontWeight.w600)),
                        onPressed: () => _selectStartTime(context)
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text("End Time", style: TextStyle(color: FlatColors.darkGray, fontWeight: FontWeight.w600, fontSize: 20.0)),
                    SizedBox(height: 8.0),
                    RaisedButton(
                      color: Colors.white,
                      child: endTime.isEmpty
                          ? Text("Set End Time", style: TextStyle(color: FlatColors.darkGray, fontWeight: FontWeight.w600))
                          : Text("$endTime", style: TextStyle(color: FlatColors.darkGray, fontWeight: FontWeight.w600)),
                      onPressed: () => _selectEndTime(context),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 64.0),
          ],
        ),
      ),
    );
  }

  Widget _buildInterestsGrid(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.60,
      child: GridView.count(
        crossAxisCount: 4,
        scrollDirection: Axis.horizontal,
        children: List<Widget>.generate(availableTags.length, (index) {
          return GridTile(
              child: InkResponse(
                onTap: () => tagClicked(index),
                child: Card(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                  color: eventTags.contains(availableTags[index])
                      ? FlatColors.webblenRed
                      : Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      availableTags[index] == "wine & brew"
                        ? eventTags.contains(availableTags[index])
                          ? Image.asset('assets/images/wine_brew_light.png', height: 32.0, width: 32.0, fit: BoxFit.contain)
                          : Image.asset('assets/images/wine_brew_dark.png', height: 32.0, width: 32.0, fit: BoxFit.contain)
                        : eventTags.contains(availableTags[index])
                          ? Image.asset('assets/images/${availableTags[index]}_light.png', height: 32.0, width: 32.0, fit: BoxFit.contain)
                          : Image.asset('assets/images/${availableTags[index]}_dark.png', height: 32.0, width: 32.0, fit: BoxFit.contain),
                      Fonts().textW500(
                          '${availableTags[index]}',
                          12.0,
                          eventTags.contains(availableTags[index])
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

  Widget _buildFbUrlField(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: TextFormField(
        style: TextStyle(color: FlatColors.darkGray, fontSize: 16.0, fontWeight: FontWeight.w700),
        autofocus: false,
        onSaved: (value) => fbSite = value,
        initialValue: fbSite,
        decoration: InputDecoration(
          icon: Icon(FontAwesomeIcons.facebook, color: FlatColors.darkGray),
          border: InputBorder.none,
          hintText: "Facebook URL",
          hintStyle: TextStyle(color: FlatColors.londonSquare, fontWeight: FontWeight.w300),
          contentPadding: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
        ),
      ),
    );
  }

  Widget _buildTwitterUrlField(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: TextFormField(
        style: TextStyle(color: FlatColors.darkGray, fontSize: 16.0, fontWeight: FontWeight.w700),
        autofocus: false,
        onSaved: (value) => twitterSite = value,
        initialValue: twitterSite,
        decoration: InputDecoration(
          icon: Icon(FontAwesomeIcons.twitter, color: FlatColors.darkGray),
          border: InputBorder.none,
          hintText: "Twitter URL",
          hintStyle: TextStyle(color: FlatColors.londonSquare, fontWeight: FontWeight.w300),
          contentPadding: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
        ),
      ),
    );
  }

  Widget _buildWebUrlField(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: TextFormField(
        style: TextStyle(color: FlatColors.darkGray, fontSize: 16.0, fontWeight: FontWeight.w700),
        autofocus: false,
        onSaved: (value) => website = value,
        initialValue: website,
        decoration: InputDecoration(
          icon: Icon(FontAwesomeIcons.globe, color: FlatColors.darkGray),
          border: InputBorder.none,
          hintText: "Website URL",
          hintStyle: TextStyle(color: FlatColors.londonSquare, fontWeight: FontWeight.w300),
          contentPadding: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
        ),
      ),
    );
  }

  Widget _buildSearchAutoComplete(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Fonts().textW500(
            eventAddress == ""
            ? "Set Address"
            : "$eventAddress",
            16.0,
            FlatColors.darkGray,
            TextAlign.center),
        SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
                color: Colors.white70,
                onPressed: () async {
                  // show input autocomplete with selected mode
                  // then get the Prediction selected
                  Prediction p = await PlacesAutocomplete.show(
                      context: context,
                      apiKey: Strings.googleAPIKEY,
                      onError: (res) {
                        homeScaffoldKey.currentState.showSnackBar(
                            SnackBar(content: Text(res.errorMessage)));
                      },
                      mode: Mode.overlay,
                      language: "en",
                      components: [Component(Component.country, "us")]);
                  PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
                  setState(() {
                    lat = detail.result.geometry.location.lat;
                    lon = detail.result.geometry.location.lng;
                    newEventPost.lat = lat;
                    newEventPost.lon = lon;
                    eventAddress = p.description.replaceAll(', USA', '');
                    newEventPost.address = eventAddress;
                  });
//              displayPrediction(p, homeScaffoldKey.currentState);
                },
                child: Text("Search Address")
            ),
            RaisedButton(
                color: Colors.white70,
                onPressed: () async {
                  LocationService().getCurrentLocation(context).then((location){
                    if (this.mounted){
                      if (location == null){
                        ShowAlertDialogService().showFailureDialog(context, 'Cannot Retrieve Location', 'Location Permission Disabled');
                      } else {
                        var currentLocation = location;
                          lat = currentLocation.latitude;
                          lon = currentLocation.longitude;
                          newEventPost.lat = lat;
                          newEventPost.lon = lon;
                          LocationService().getAddressFromLatLon(lat, lon).then((foundAddress){
                            eventAddress = foundAddress.replaceAll(', USA', '');
                            newEventPost.address = eventAddress;
                            setState(() {});
                          });
                      }
                    }
                  });
                },
                child: Text("Current Location")
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDistanceSlider(){
    return Slider(
      activeColor: FlatColors.webblenRed,
      value: radius,
      min: 0.25,
      max: 10.0,
      divisions: 39,
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
    DateFormat timeFormatter = DateFormat("MM/dd/yyyy h:mm a");
    DateTime startDateTime = timeFormatter.parse(startDate + " " + startTime);
    String startDateInMilliseconds = startDateTime.millisecondsSinceEpoch.toString();
    DateTime endDateTime = timeFormatter.parse(startDate + " " + endTime);
    String endDateInMilliseconds =  endDateTime.millisecondsSinceEpoch.toString();
    newEventPost.eventKey = "";
    newEventPost.author = widget.currentUser.uid;
    newEventPost.authorImagePath = widget.currentUser.profile_pic;
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