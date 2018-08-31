import 'package:flutter/material.dart';
import 'package:webblen/user_pages/dashboard_page.dart';
import 'package:webblen/buttons/facebook_btn.dart';
import 'package:webblen/buttons/twitter_btn.dart';
import 'package:webblen/common_widgets/common_logo.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/auth_pages/registration_page.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'dart:async';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginPage extends StatefulWidget {

  static String tag = "login-page";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  static final FacebookLogin facebookSignIn = new FacebookLogin();

  bool loading = false;
  String _email;
  String _password;
  String uid;

  final loginScaffoldKey = new GlobalKey<ScaffoldState>();
  final authFormKey = new GlobalKey<FormState>();

  void transitionToDashboardPage () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DashboardPage()));
  void transitionToRegistrationPage () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => RegistrationPage()));
  void transitionToRootPage () => Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (Route<dynamic> route) => false);

  bool validateAndSave() {
    final form = authFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<Null> validateAndSubmit() async {
    setState(() {
      loading = true;
    });
    ScaffoldState scaffold = loginScaffoldKey.currentState;
    if (validateAndSave()) {
      try {
        uid = await BaseAuth().signIn(_email, _password);
        setState(() {
          loading = false;
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

  Future<Null> _loginWithFacebook() async {
    setState(() {
      loading = true;
    });
    ScaffoldState scaffold = loginScaffoldKey.currentState;
    final FacebookLoginResult result = await facebookSignIn.logInWithReadPermissions(['email', 'public_profile']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        await FirebaseAuth.instance.signInWithFacebook(accessToken: accessToken.token);
        loading = false;
        transitionToRootPage();
        break;
      case FacebookLoginStatus.cancelledByUser:
        scaffold.showSnackBar(new SnackBar(
          content: new Text("Cancelled Facebook Login"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ));
        setState(() {
          loading = false;
        });
        break;
      case FacebookLoginStatus.error:
        scaffold.showSnackBar(new SnackBar(
          content: new Text("There was an Issue Logging Into Facebook"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ));
        setState(() {
          loading = false;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

    final logo = Logo(50.0);
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

    // **EMAIL FIELD
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

    // **PASSWORD FIELD
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

    // **LOGIN BUTTON
    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Material(
        elevation: 5.0,
        color: FlatColors.goodNight,
        borderRadius: BorderRadius.circular(25.0),
        child: InkWell(
          onTap: () { validateAndSubmit(); },
          child: Container(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Login', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );

    // **FACEBOOK BUTTON
    final facebookButton = FacebookBtn(action: _loginWithFacebook);

    // **TWITTER BUTTON
    final twitterButton = TwitterBtn();

    //** NO ACCOUNT FLAT BTN
    final noAccountLabel = FlatButton(
      child: Text(
        "Don't Have an Account?",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: (){
        transitionToRegistrationPage();
      },
    );

    final orTextLabel = Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: new Text(
        'or',
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );



    final authForm = Form(
      key: authFormKey,
      child: new Column(
        children: <Widget>[
          SizedBox(height: 50.0),
          emailField,
          passwordField,
          loginButton
        ],
      ),
    );

    return Scaffold(
      key: loginScaffoldKey,
      body: new Stack(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(image: new AssetImage('assets/images/sunkist_gradient.png'), fit: BoxFit.cover,),
            ),
          ),
          new Center(
            child: new ListView(
              shrinkWrap: false,
              children: <Widget>[
                loading ? loadingProgressBar
                :fillerContainer,
                logo,
                authForm,
                noAccountLabel,
                orTextLabel,
                facebookButton,
                //twitterButton
              ],
            ),
          ),
        ],
      ),
    );

  }
}
