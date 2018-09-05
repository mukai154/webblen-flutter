import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';


class EmailTextField extends StatelessWidget {

  String email;
  String hintText;

  EmailTextField(this.email, this.hintText);

  @override
  Widget build(BuildContext context) {
    return new Padding(padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: new TextFormField(
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        validator: (value) => value.isEmpty ? 'Email Cannot be Empty' : null,
        onSaved: (value) => email = value,
        decoration: InputDecoration(
          icon: Icon(Icons.email, color: Colors.white70,),
          hintText: hintText,
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        ),
      ),
    );
  }

}

class PasswordTextField extends StatelessWidget {

  String password;
  String hintText;

  PasswordTextField(this.password, this.hintText);

  @override
  Widget build(BuildContext context) {
    return new Padding(padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      child: new TextFormField(
        keyboardType: TextInputType.text,
        obscureText: true,
        autofocus: false,
        validator: (value) => value.isEmpty ? 'Password Cannot be Empty' : null,
        onSaved: (value) => password = value,
        decoration: InputDecoration(
          icon: Icon(Icons.lock, color: Colors.white70,),
          hintText: hintText,
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        ),
      ),
    );
  }
}

class NewEventTitleField extends StatelessWidget {

  String title;
  String hintText;

  NewEventTitleField(this.title, this.hintText);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: new TextFormField(
          maxLength: 20,
          style: new TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.w700),
          autofocus: false,
          onSaved: (value) => title = value,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            contentPadding: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
          ),
        ),
    );
  }
}

class NewEventCaptionField extends StatelessWidget {

  String eventCaption;
  String hintText;

  NewEventCaptionField(this.eventCaption, this.hintText);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: new BorderRadius.circular(16.0),
      ),
      child: new TextFormField(
        maxLines: 3,
        maxLength: 140,
        autofocus: false,
        onSaved: (value) => eventCaption = value,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        ),
      ),
    );
  }
}

class NewEventDescriptionField extends StatelessWidget {

  String eventDescription;
  String hintText;

  NewEventDescriptionField(this.eventDescription, this.hintText);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: new BorderRadius.circular(16.0),
      ),
      child: new TextFormField(
        maxLines: 6,
        maxLength: 300,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        onSaved: (value) => eventDescription = value,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        ),
      ),
    );
  }
}

class NewEventTagField extends StatelessWidget {

  String eventTag;
  String hintText;

  NewEventTagField(this.eventTag, this.hintText);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: new TextFormField(
        style: new TextStyle(color: Colors.white, fontSize: 34.0, fontWeight: FontWeight.w700),
        keyboardType: TextInputType.text,
        autofocus: false,
        validator: (value) => value.isEmpty ? 'Required' : null,
        onSaved: (value) => eventTag = value,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          contentPadding: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
        ),
      ),
    );
  }
}

class NewEventFBSiteField extends StatelessWidget {

  String fbSite;
  String hintText;

  NewEventFBSiteField(this.fbSite, this.hintText);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: new TextFormField(
        style: new TextStyle(color: Colors.white, fontSize: 34.0, fontWeight: FontWeight.w700),
        keyboardType: TextInputType.text,
        autofocus: false,
        validator: (value) => value.isEmpty ? 'Required' : null,
        onSaved: (value) => fbSite = value,
        decoration: InputDecoration(
          icon: new Icon(Icons.web),
          border: InputBorder.none,
          hintText: hintText,
          contentPadding: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
        ),
      ),
    );
  }
}

class NewEventTwitterSiteField extends StatelessWidget {

  String eventCost;
  String hintText;

  NewEventTwitterSiteField(this.eventCost, this.hintText);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: new TextFormField(
        style: new TextStyle(color: Colors.white, fontSize: 34.0, fontWeight: FontWeight.w700),
        keyboardType: TextInputType.text,
        autofocus: false,
        validator: (value) => value.isEmpty ? 'Required' : null,
        onSaved: (value) => eventCost = value,
        decoration: InputDecoration(
          icon: new Icon(Icons.web),
          border: InputBorder.none,
          hintText: hintText,
          contentPadding: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
        ),
      ),
    );
  }
}

class NewEventWebsiteField extends StatelessWidget {

  String eventCost;
  String hintText;

  NewEventWebsiteField(this.eventCost, this.hintText);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: new TextFormField(
        style: new TextStyle(color: Colors.white, fontSize: 34.0, fontWeight: FontWeight.w700),
        keyboardType: TextInputType.text,
        autofocus: false,
        validator: (value) => value.isEmpty ? 'Required' : null,
        onSaved: (value) => eventCost = value,
        decoration: InputDecoration(
          icon: new Icon(Icons.web),
          border: InputBorder.none,
          hintText: hintText,
          contentPadding: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
        ),
      ),
    );
  }
}

class NewEventCostField extends StatelessWidget {

  String eventCost;
  String hintText;

  NewEventCostField(this.eventCost, this.hintText);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: new TextFormField(
        style: new TextStyle(color: Colors.white, fontSize: 34.0, fontWeight: FontWeight.w700),
        keyboardType: TextInputType.text,
        autofocus: false,
        validator: (value) => value.isEmpty ? 'Required' : null,
        onSaved: (value) => eventCost = value,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          contentPadding: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
        ),
      ),
    );
  }
}