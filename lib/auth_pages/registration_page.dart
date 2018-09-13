import 'package:flutter/material.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/widgets_common/common_header_row.dart';
import 'dart:async';


class RegistrationPage extends StatefulWidget {

  static String tag = "login-page";


  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

  String _email;
  String _confirmPassword;
  String _password;
  String uid;
  bool loading = false;

  final authFormKey = new GlobalKey<FormState>();
  final registrationsScaffoldKey = new GlobalKey<ScaffoldState>();



  bool validateAndSave() {
    final form = authFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void transitionToRootPage () => Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (Route<dynamic> route) => false);
  void transitionToLoginPage () => Navigator.pop(context);

  Future<Null> validateAndRegister() async {
    setState(() {
      loading = true;
    });
    ScaffoldState scaffold = registrationsScaffoldKey.currentState;
    if (validateAndSave()){
      try {
        uid = await BaseAuth().createUser(_email, _password);
        setState(() {
          loading = true;
        });
        transitionToRootPage();
      } catch (e) {
        String error = e.details;
        scaffold.showSnackBar(new SnackBar(
          content: new Text(error),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ));
        setState(() {
          loading = false;
        });
      }
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final fillerContainer = Container(height: 64.0);

    final loadingProgressBar = Container(
      height: 64.0,
      child: Column(
        children: <Widget>[
          SizedBox(height: 28.0),
          SizedBox(
            height: 2.0,
            child: LinearProgressIndicator(backgroundColor: Colors.transparent),
          ),
          SizedBox(height: 28.0),
        ],
      ),
    );

    final emailField = Padding(padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: new TextFormField(
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        validator: (value) => value.isEmpty ? 'Email Cannot be Empty' : null,
        onSaved: (value) => _email = value,
        decoration: InputDecoration(
          icon: Icon(Icons.email, color: Colors.white70,),
          hintText: "Email",
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        ),
      ),
    );

    final passwordField = Padding(padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      child: new TextFormField(
        keyboardType: TextInputType.text,
        obscureText: true,
        autofocus: false,
        validator: (value) => value.isEmpty ? 'Password Cannot be Empty' : null,
        onSaved: (value) => _password = value,
        decoration: InputDecoration(
          icon: Icon(Icons.lock, color: Colors.white70,),
          hintText: "Password",
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        ),
      ),
    );

    final confirmPasswordField = Padding(padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      child: new TextFormField(
        keyboardType: TextInputType.text,
        obscureText: true,
        autofocus: false,
        validator: (value) => value.isEmpty ? 'Password Cannot be Empty' : null,
        onSaved: (value) => _confirmPassword = value,
        decoration: InputDecoration(
          icon: Icon(Icons.lock, color: Colors.white70,),
          hintText: "Confirm Password",
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        ),
      ),
    );

    final registerButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Material(
        color: FlatColors.darkGray,
        borderRadius: BorderRadius.circular(20.0),
        child: InkWell(
          onTap: (){ validateAndRegister(); },
          child: Container(
            height: 45.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Register", style: Fonts.bodyTextStyleWhite),
              ],
            ),
          ),
        ),
      ),
    );

    final hasAccountLabel = FlatButton(
      child: Text(
        "Already Have an Account?",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: (){
        Navigator.of(context).pop();
      },
    );

    final authForm = Form(
      key: authFormKey,
      child: new Column(
        children: <Widget>[
          SizedBox(height: 50.0),
          emailField,
          passwordField,
          confirmPasswordField,
          registerButton
        ],
      ),
    );

    return Scaffold(
      key: registrationsScaffoldKey,
      body: new Stack(
      children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(image: new AssetImage('assets/images/sunkist_gradient.png'), fit: BoxFit.cover,),
          ),
        ),
        new Center(
          child: new ListView(
            children: <Widget>[
              loading ? loadingProgressBar : fillerContainer,
              HeaderRowCentered(16.0, 16.0, "Regsiter"),
              authForm,
              hasAccountLabel,
            ],
          ),
        )
      ],
      ),
    );
  }
}