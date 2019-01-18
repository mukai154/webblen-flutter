import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'common_custom_alert.dart';
import 'package:webblen/styles/fonts.dart';
import 'common_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'common_progress.dart';


class FailureDialog extends StatelessWidget {

  final String header;
  final String body;

  FailureDialog({this.header, this.body});


  @override
  Widget build(BuildContext context) {

    return new CustomAlertDialog(
      content: new Container(
        height: 200.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius:
          new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // dialog top
            Container(
                child: Column(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.exclamationCircle, color: Colors.red, size: 30.0),
                    SizedBox(height: 8.0),
                    Text(header, style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                  ],
                )
            ),
            // dialog centre
            SizedBox(height: 8.0),
            Container(
              child: Column(
                children: <Widget>[
                  new Text(body, style: Fonts.alertDialogBody, textAlign: TextAlign.center),
                ],
              ),
            ),
            // dialog bottom
            Container(
              child: Column(
                children: <Widget>[
                  CustomColorButton(
                        text: "Ok",
                        textColor: FlatColors.londonSquare,
                        backgroundColor: Colors.white,
                        height: 45.0,
                        width: 200.0,
                        onPressed: () => Navigator.pop(context),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateAvailableDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:Container(
        child: Column(
          children: <Widget>[
            Image.asset("assets/images/warning.png", height: 45.0, width: 45.0),
            SizedBox(height: 8.0),
            Text("Update Required", style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
          ],
        ),
      ),
      content: new Text("Please Update Your Current Version of Webblen to Continue", style: Fonts.alertDialogBody, textAlign: TextAlign.center),
      actions: <Widget>[
        new FlatButton(
          child: new Text("Ok", style: Fonts.alertDialogAction),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class SuccessDialog extends StatelessWidget {

  final String header;
  final String body;
  SuccessDialog({this.header, this.body});

  @override
  Widget build(BuildContext context) {
    return new CustomAlertDialog(
      content: new Container(
        width: 260.0,
        height: 230.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius:
          new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // dialog top
            Container(
                child: Column(
                  children: <Widget>[
                    Image.asset("assets/images/checked.png", height: 45.0, width: 45.0),
                    SizedBox(height: 8.0),
                    Text(header, style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                  ],
                )
            ),
            // dialog centre
            SizedBox(height: 16.0),
            Container(
              child: Column(
                children: <Widget>[
                  new Text(body, style: Fonts.alertDialogBody, textAlign: TextAlign.center),
                ],
              ),
            ),
            SizedBox(height: 14.0),
            // ),
            // dialog bottom
            Container(
              child: Column(
                children: <Widget>[
                  CustomColorButton(
                        text: "Ok",
                        textColor: FlatColors.londonSquare,
                        backgroundColor: Colors.white,
                        height: 45.0,
                        width: 200.0,
                        onPressed: () => Navigator.pop(context),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FlashEventSuccessDialog extends StatelessWidget {

  final String messageA;
  final String messageB;
  final BuildContext successContext;
  FlashEventSuccessDialog({this.messageA, this.messageB, this.successContext});


  @override
  Widget build(BuildContext context) {
    return new CustomAlertDialog(
      content: new Container(
        width: 260.0,
        height: 200.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius:
          new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // dialog top
            Container(
                child: Column(
                  children: <Widget>[
                    Image.asset("assets/images/checked.png", height: 45.0, width: 45.0),
                    SizedBox(height: 8.0),
                    Text(messageA, style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                  ],
                )
            ),
            // dialog centre
            SizedBox(height: 16.0),
            Container(
              child: Column(
                children: <Widget>[
                  new Text(messageB, style: Fonts.alertDialogBody, textAlign: TextAlign.center),
                ],
              ),
            ),
            SizedBox(height: 14.0),
            // ),
            // dialog bottom
            Container(
              child: Column(
                children: <Widget>[
                  CustomColorButton(
                        text: "Ok",
                        textColor: FlatColors.londonSquare,
                        backgroundColor: Colors.white,
                        height: 45.0,
                        width: 200.0,
                        onPressed: (){
                          Navigator.pop(context);
                          Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (Route<dynamic> route) => false);
                        },
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CancelActionDialog extends StatelessWidget {

  final String header;
  final String body;
  final VoidCallback cancelAction;

  CancelActionDialog({this.header, this.body, this.cancelAction});


  @override
  Widget build(BuildContext context) {

    return new CustomAlertDialog(
      content: new Container(
        height: 245.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius:
          new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // dialog top
            Container(
                child: Column(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.exclamationCircle, color: Colors.red, size: 30.0),
                    SizedBox(height: 8.0),
                    Text(header, style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                  ],
                )
            ),
            // dialog centre
            SizedBox(height: 16.0),
            Container(
              child: Column(
                children: <Widget>[
                  new Text(body, style: Fonts.alertDialogBody, textAlign: TextAlign.center),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            // dialog bottom
            Container(
              child: Column(
                children: <Widget>[
                  CustomColorButton(
                        text: "Yes",
                        textColor: Colors.white,
                        backgroundColor: FlatColors.webblenRed,
                        height: 45.0,
                        width: 200.0,
                        onPressed: cancelAction,
                      ),
                  CustomColorButton(
                        text: "Back",
                        textColor: FlatColors.londonSquare,
                        backgroundColor: Colors.white,
                        height: 45.0,
                        width: 200.0,
                        onPressed: () => Navigator.pop(context),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class EventUploadSuccessDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new CustomAlertDialog(
      content: new Container(
        width: 260.0,
        height: 200.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius:
          new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // dialog top
            Container(
                child: Column(
                  children: <Widget>[
                    Image.asset("assets/images/checked.png", height: 45.0, width: 45.0),
                    SizedBox(height: 8.0),
                    Text("Event Posted!", style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                  ],
                )
            ),
            // dialog centre
            SizedBox(height: 16.0),
            Container(
              child: Column(
                children: <Widget>[
                  new Text("Interested Users Nearby Will be Notified", style: Fonts.alertDialogBody, textAlign: TextAlign.center),
                ],
              ),
            ),
            // ),
            // dialog bottom
            Container(
              child: Column(
                children: <Widget>[
                  CustomColorButton(
                        text: "Ok",
                        textColor: FlatColors.londonSquare,
                        backgroundColor: Colors.white,
                        height: 45.0,
                        width: 200.0,
                        onPressed: (){
                          Navigator.pop(context);
                          Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (Route<dynamic> route) => false);
                        }
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoDialog extends StatelessWidget {

  final String header;
  final String body;
  InfoDialog({this.header, this.body});

  @override
  Widget build(BuildContext context) {
    return new CustomAlertDialog(
      content: new Container(
        width: 260.0,
        height: 240.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius:
          new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // dialog top
            Container(
                child: Column(
                  children: <Widget>[
                    Image.asset("assets/images/question.png", height: 30.0, width: 30.0),
                    SizedBox(height: 8.0),
                    Text(header, style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                  ],
                )
            ),
            // dialog centre
            SizedBox(height: 8.0),
            Container(
              child: Column(
                children: <Widget>[
                  new Text(body, style: Fonts.alertDialogBody, textAlign: TextAlign.center),
                ],
              ),
            ),
            // ),
            // dialog bottom
            Container(
              child: Column(
                children: <Widget>[
                  CustomColorButton(
                        text: "Ok",
                        textColor: FlatColors.londonSquare,
                        backgroundColor: Colors.white,
                        height: 45.0,
                        width: 200.0,
                        onPressed: () => Navigator.pop(context)
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionMessage extends StatelessWidget {

  final String messageHeader;
  final String messageA;
  final VoidCallback callback;

  ActionMessage({this.messageHeader, this.messageA, this.callback});


  @override
  Widget build(BuildContext context) {

    final content = Container(
      height: 80.0,
      child: Column(
        children: <Widget>[
          new Text(messageHeader, style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: FlatColors.blackPearl), textAlign: TextAlign.center),
        ],
      ),
    );

    return AlertDialog(
      title: Container(
        child: Column(
          children: <Widget>[
            Image.asset("assets/images/check_in.png", height: 60.0, width: 60.0),
          ],
        ),
      ),
      content: content,
      actions: <Widget>[
        new FlatButton(onPressed: () { Navigator.pop(context); },
          child: new Text("Cancel", style: new TextStyle(fontWeight: FontWeight.w500)),
        ),
        new FlatButton(onPressed: () { callback(); },
          child: new Text("Confirm", style: new TextStyle(fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}

//***EVENT INFO
class AdditionalEventInfoDialog extends StatelessWidget {
  final int estimatedTurnout;
  final double eventCost;
  AdditionalEventInfoDialog({this.estimatedTurnout, this.eventCost});

  @override
  Widget build(BuildContext context) {
    return new CustomAlertDialog(
      content: new Container(
        width: 260.0,
        height: 180.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius:
          new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // dialog top
            Container(
                child: Column(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.users, size: 30.0, color: FlatColors.darkMountainGreen),
                    SizedBox(height: 16.0),
                    Text("Turnout Info", style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                  ],
                )
            ),
            // dialog centre
            SizedBox(height: 24.0),
            Container(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(FontAwesomeIcons.users, size: 20.0, color: FlatColors.blueGray),
                          SizedBox(width: 16.0),
                          Text(estimatedTurnout.toString(), style: Fonts.alertDialogBody, textAlign: TextAlign.center),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(FontAwesomeIcons.dollarSign, size: 20.0, color: FlatColors.blueGray),
                          SizedBox(width: 2.0),
                          eventCost == null
                              ? Text("Free", style: Fonts.alertDialogBody, textAlign: TextAlign.center)
                              : Text(eventCost.toString(), style: Fonts.alertDialogBody, textAlign: TextAlign.center),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            // ),
            // dialog bottom
            Container(
              child: Column(
                children: <Widget>[
                  CustomColorButton(
                        text: "Back",
                        textColor: FlatColors.londonSquare,
                        backgroundColor: Colors.white,
                        height: 45.0,
                        width: 200.0,
                        onPressed: () => Navigator.pop(context)
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DateTimeEventInfoDialog extends StatelessWidget {
  final String date;
  final String startTime;
  final String endTime;
  DateTimeEventInfoDialog({this.date, this.startTime, this.endTime});

  @override
  Widget build(BuildContext context) {
    return new CustomAlertDialog(
      content: new Container(
        width: 260.0,
        height: 200.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius:
          new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // dialog top
            Container(
                child: Column(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.clock, size: 30.0, color: FlatColors.electronBlue),
                    SizedBox(height: 16.0),
                    Text("Date & Time", style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                  ],
                )
            ),
            // dialog centre
            SizedBox(height: 16.0),
            Container(
              child: Column(
                children: <Widget>[
                  Text(date, style: Fonts.alertDialogBody, textAlign: TextAlign.center),
                  SizedBox(height: 8.0),
                  Text(startTime + " - " + endTime, style: Fonts.alertDialogBody, textAlign: TextAlign.center),
                ],
              ),
            ),
            SizedBox(height: 14.0),
            // ),
            // dialog bottom
            Container(
              child: Column(
                children: <Widget>[
                  CustomColorButton(
                        text: "Ok",
                        textColor: FlatColors.londonSquare,
                        backgroundColor: Colors.white,
                        height: 45.0,
                        width: 200.0,
                        onPressed: () => Navigator.pop(context)
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LocationEventInfoDialog extends StatelessWidget {
  final String address;
  final double lat;
  final double lon;
  LocationEventInfoDialog({this.address, this.lat, this.lon});

  @override
  Widget build(BuildContext context) {
    return new CustomAlertDialog(
      content: new Container(
        width: 260.0,
        height: 215.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius:
          new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // dialog top
            Container(
                child: Column(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.directions, size: 40.0, color: FlatColors.vibrantYellow),
                    SizedBox(height: 8.0),
                    Text("Address", style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                  ],
                )
            ),
            // dialog centre
            SizedBox(height: 16.0),
            Container(
              child: Column(
                children: <Widget>[
                  Text(address, style: Fonts.alertDialogBody, textAlign: TextAlign.center),
                ],
              ),
            ),
            SizedBox(height: 14.0),
            // ),
            // dialog bottom
            Container(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 16.0),
                    CustomColorButton(
                        text: "Ok",
                        textColor: FlatColors.londonSquare,
                        backgroundColor: Colors.white,
                        height: 45.0,
                        width: 200.0,
                        onPressed: () => Navigator.pop(context)
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DescriptionEventInfoDialog extends StatelessWidget {

  final String description;
  DescriptionEventInfoDialog({this.description});

  @override
  Widget build(BuildContext context) {
    return new CustomAlertDialog(
      content: new Container(
        width: 260.0,
        height: description.isEmpty ? 200.0 : 345.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius:
          new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // dialog top
            Container(
                child: Column(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.alignLeft, size: 30.0, color: FlatColors.blueGray),
                    SizedBox(height: 16.0),
                    Text("Details", style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                  ],
                )
            ),
            // dialog centre
            SizedBox(height: 16.0),
            Container(
              child: Column(
                children: <Widget>[
                  description.isEmpty
                      ? Text("No Additional Details", style: Fonts.alertDialogBody, textAlign: TextAlign.center)
                      : description.length < 60
                      ? Text(description, style: Fonts.alertDialogBody, textAlign: TextAlign.center)
                      : Text(description, style: Fonts.alertDialogBodySmall, textAlign: TextAlign.center),
                ],
              ),
            ),
            SizedBox(height: 14.0),
            // ),
            // dialog bottom
            Container(
              child: Column(
                children: <Widget>[
                  CustomColorButton(
                        text: "Back",
                        textColor: FlatColors.londonSquare,
                        backgroundColor: Colors.white,
                        height: 45.0,
                        width: 200.0,
                        onPressed: () => Navigator.pop(context)
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//***EVENT CHECK IN
class EventCheckInDialog extends StatelessWidget {

  final String eventTitle;
  final VoidCallback confirmAction;
  EventCheckInDialog({this.eventTitle, this.confirmAction});

  @override
  Widget build(BuildContext context) {
    return new CustomAlertDialog(
      content: new Container(
        width: 260.0,
        height: 220.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // dialog top
            Container(
                child: Column(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.userCheck, size: 30.0, color: FlatColors.exodusPurple),
                    SizedBox(height: 16.0),
                    Text("Check In", style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                  ],
                )
            ),
            // dialog centre
            SizedBox(height: 16.0),
            Container(
              child: Column(
                children: <Widget>[
                  Text("Check into " + eventTitle + "?", style: Fonts.alertDialogBody, textAlign: TextAlign.center),
                ],
              ),
            ),
            SizedBox(height: 14.0),
            // ),
            // dialog bottom
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CustomColorButton(
                    text: "Cancel",
                    textColor: FlatColors.londonSquare,
                    backgroundColor: Colors.white,
                    height: 45.0,
                    width: 200.0,
                    onPressed: () => Navigator.pop(context)
                  ),
                  CustomColorButton(
                    text: "Confirm",
                    textColor: FlatColors.londonSquare,
                    backgroundColor: Colors.white,
                    height: 45.0,
                    width: 200.0,
                    onPressed: confirmAction
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventCheckInSuccessDialog extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return new CustomAlertDialog(
      content: new Container(
        width: 260.0,
        height: 150.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // dialog top
            Container(
                child: Column(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.clipboardCheck, size: 30.0, color: FlatColors.darkMountainGreen),
                    SizedBox(height: 16.0),
                    Text("Check In Successful", style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                  ],
                )
            ),
            Container(
              child: Column(
                children: <Widget>[
                  CustomColorButton(
                    text: "Ok",
                    textColor: FlatColors.londonSquare,
                    backgroundColor: Colors.white,
                    height: 45.0,
                    width: 200.0,
                    onPressed: () => Navigator.pop(context)
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhoneVerificationDialog extends StatelessWidget {

  final Widget textFieldWidget;
  final VoidCallback submitSMSAction;
  PhoneVerificationDialog({this.textFieldWidget, this.submitSMSAction});

  @override
  Widget build(BuildContext context) {
    return new CustomAlertDialog(
      content: new Container(
        width: 260.0,
        height: 150.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // dialog top
            Container(
                child: Column(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.userCheck, size: 30.0, color: FlatColors.exodusPurple),
                    SizedBox(height: 16.0),
                    Text("Enter SMS Code", style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                  ],
                )
            ),
            // dialog centre
            SizedBox(height: 16.0),
            Container(
              child: Column(
                children: <Widget>[
                  textFieldWidget
                ],
              ),
            ),
            SizedBox(height: 14.0),
            Container(
              child: Column(
                children: <Widget>[
                  CustomColorButton(
                    text: "Submit",
                    textColor: FlatColors.londonSquare,
                    backgroundColor: Colors.white,
                    height: 45.0,
                    width: 200.0,
                    onPressed: () => submitSMSAction
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountOptionsDialog extends StatelessWidget {


  final VoidCallback editPhotoAction;
  final VoidCallback editUsernameAction;
  final VoidCallback hideAccountAction;
  final VoidCallback viewGuideAction;
  final VoidCallback logoutAction;
  final VoidCallback cancelAction;
  AccountOptionsDialog({this.editPhotoAction, this.editUsernameAction, this.hideAccountAction, this.cancelAction, this.viewGuideAction, this.logoutAction});

  @override
  Widget build(BuildContext context) {
    return new CustomAlertDialog(
      content: new Container(
        width: 260.0,
        height: 300.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                child: Column(
                  children: <Widget>[
                    Text("Account Options", style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                  ],
                )
            ),
            Container(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 8.0),
                  CustomColorButton(
                    text: "Change Photo",
                    textColor: FlatColors.londonSquare,
                    backgroundColor: Colors.white,
                    height: 45.0,
                    width: 200.0,
                    onPressed: editPhotoAction
                  ),
//                  CustomAlertFlatButtonLarge("Change Username", FlatColors.electronBlue, Colors.transparent, editUsernameAction),
//                  SizedBox(height: 4.0),
                  CustomColorButton(
                    text: "View Guide",
                    textColor: FlatColors.londonSquare,
                    backgroundColor: Colors.white,
                    height: 45.0,
                    width: 200.0,
                    onPressed: viewGuideAction
                  ),
                  CustomColorButton(
                    text: "Logout",
                    textColor: FlatColors.clouds,
                    backgroundColor: Colors.red,
                    height: 45.0,
                    width: 200.0,
                    onPressed: logoutAction
                  ),
                  CustomColorButton(
                    text: "Back",
                    textColor: FlatColors.londonSquare,
                    backgroundColor: Colors.white,
                    height: 45.0,
                    width: 200.0,
                    onPressed: () => Navigator.pop(context)
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateFlashEventDialog extends StatelessWidget {


  final VoidCallback confirmAction;
  final VoidCallback explainAction;
  CreateFlashEventDialog({this.confirmAction, this.explainAction});

  @override
  Widget build(BuildContext context) {
    return new CustomAlertDialog(
      content: new Container(
        width: 260.0,
        height: 220.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // dialog top
            Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(Icons.crop_square, color: Colors.white, size: 50.0),
                        Icon(FontAwesomeIcons.bolt, size: 30.0, color: FlatColors.webblenRed),
                        IconButton(
                          icon: Icon(FontAwesomeIcons.infoCircle, size: 20.0, color: FlatColors.londonSquare),
                          onPressed: explainAction,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Text("Create Flash Event?", style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                    SizedBox(height: 8.0),
                  ],
                )
            ),
            Container(
              child: Column(
                children: <Widget>[
                  CustomColorButton(
                    text: "Create",
                    textColor: Colors.white,
                    backgroundColor: FlatColors.webblenRed,
                    height: 45.0,
                    width: 200.0,
                    onPressed: confirmAction
                  ),
                  CustomColorButton(
                    text: "Cancel",
                    textColor: FlatColors.londonSquare,
                    backgroundColor: Colors.white,
                    height: 45.0,
                    width: 200.0,
                    onPressed: () => Navigator.pop(context)
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserDetailsOptionsDialog extends StatelessWidget {

  final String friendRequestStatus;
  final VoidCallback addFriendAction;
  final VoidCallback confirmRequestAction;
  final VoidCallback denyRequestAction;
  final VoidCallback messageUserAction;
  final VoidCallback removeFriendAction;
  final VoidCallback hideFromUserAction;
  final VoidCallback blockUserAction;
  UserDetailsOptionsDialog({this.addFriendAction, this.removeFriendAction, this.confirmRequestAction, this.denyRequestAction, this.hideFromUserAction, this.blockUserAction, this.friendRequestStatus, this.messageUserAction});

  @override
  Widget build(BuildContext context) {
    return new CustomAlertDialog(
      content: new Container(
        height: 200.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                child: Column(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.cog, size: 30.0, color: FlatColors.londonSquare),
                    SizedBox(height: 8.0),
                    friendRequestStatus == "receivedRequest"
                      ? Text("Pending Friend Request", style: Fonts.alertDialogHeader, textAlign: TextAlign.center)
                      : Text("Options", style: Fonts.alertDialogHeader, textAlign: TextAlign.center),
                  ],
                )
            ),
            Container(
              child: Column(
                children: <Widget>[
                  friendRequestStatus == "friends"
                    ? CustomColorButton(
                        text: "Message",
                        textColor: FlatColors.londonSquare,
                        backgroundColor: Colors.white,
                        height: 45.0,
                        width: 200.0,
                        onPressed: messageUserAction
                      )
                    : Container(),
                  friendRequestStatus == "friends"
                      ? CustomColorButton(
                          text: "Remove Friend",
                          textColor: FlatColors.clouds,
                          backgroundColor: Colors.red,
                          height: 45.0,
                          width: 200.0,
                          onPressed: removeFriendAction
                        )
                      : friendRequestStatus == "pending"
                      ? CustomColorButton(
                          text: "Request Pending",
                          textColor: FlatColors.londonSquare,
                          backgroundColor: Colors.white,
                          height: 45.0,
                          width: 200.0,
                          onPressed: null
                        )
                      : friendRequestStatus == "receivedRequest"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CustomColorButton(
                              text: "Accept",
                              textColor: Colors.white,
                              backgroundColor: FlatColors.darkMountainGreen,
                              height: 40.0,
                              width: MediaQuery.of(context).size.width * 0.22,
                              onPressed: confirmRequestAction,
                            ),
                            CustomColorButton(
                              text: "Ignore",
                              textColor: FlatColors.darkGray,
                              backgroundColor: Colors.white,
                              height: 40.0,
                              width: MediaQuery.of(context).size.width * 0.22,
                              onPressed: denyRequestAction,
                            ),
                          ],
                        )
                      : CustomColorButton(
                          text: "Add Friend",
                          textColor: FlatColors.londonSquare,
                          backgroundColor: Colors.white,
                          height: 45.0,
                          width: 200.0,
                          onPressed: addFriendAction
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new CustomAlertDialog(
      content: new Container(
        width: 100.0,
        height: 100.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  CustomCircleProgress(50.0, 50.0, 50.0, 50.0, FlatColors.londonSquare)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}