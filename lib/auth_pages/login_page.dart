import 'package:flutter/material.dart';
import 'package:webblen/user_pages/dashboard_page.dart';
import 'package:webblen/auth_buttons/facebook_btn.dart';
import 'package:webblen/auth_buttons/twitter_btn.dart';
import 'package:webblen/widgets_common/common_logo.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/auth_pages/registration_page.dart';
import 'package:webblen/widgets_common/common_button.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'dart:async';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:webblen/services_general/service_page_transitions.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:webblen/utils/strings.dart';

//import 'package:webblen/secrets.dart';


class LoginPage extends StatefulWidget {

  static String tag = "login-page";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final loginScaffoldKey = new GlobalKey<ScaffoldState>();
  final authFormKey = new GlobalKey<FormState>();

  static final FacebookLogin facebookSignIn = new FacebookLogin();
  static final TwitterLogin twitterLogin = new TwitterLogin(consumerKey: Strings.twitterCONSUMERKEY, consumerSecret: Strings.twitterCONSUMERSECRET);

  bool loading = false;
  bool signInWithEmail = false;
  String _email;
  String phoneNo;
  String smsCode;
  String verificationID;
  String _password;
  String uid;


  void transitionToRootPage () => Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (Route<dynamic> route) => false);

  setSignInWithEmailStatus(){
    if (signInWithEmail){
      setState(() {
        signInWithEmail = false;
      });
    } else {
      setState(() {
        signInWithEmail = true;
      });
    }
  }

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
          backgroundColor: FlatColors.darkGray,
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


  void _loginWithTwitter() async {
    setState(() {
      loading = true;
    });
    ScaffoldState scaffold = loginScaffoldKey.currentState;
    twitterLogin.authorize().then((result){
      switch (result.status) {
        case TwitterLoginStatus.loggedIn:
          FirebaseAuth.instance.signInWithTwitter(
              authToken: result.session.token,
              authTokenSecret: result.session.secret
          ).then((signedInUser){
            loading = false;
            transitionToRootPage();
          }).catchError((e){
            scaffold.showSnackBar(new SnackBar(
              content: new Text(e.details),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ));
            setState(() {
              loading = false;
            });
          });
          break;
        case TwitterLoginStatus.cancelledByUser:
          scaffold.showSnackBar(new SnackBar(
            content: new Text("Cancelled Twitter Login"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ));
          setState(() {
            loading = false;
          });
          break;
        case TwitterLoginStatus.error:
          scaffold.showSnackBar(new SnackBar(
            content: new Text("Error: ${result.errorMessage}"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ));
          setState(() {
            loading = false;
          });
          break;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    // **WEBBLEN LOGO
    final logo = Logo(50.0);
    final fillerContainer = Container(height: 16.0);

    final loadingProgressBar = CustomLinearProgress(Colors.white, Colors.transparent);

    // **EMAIL FIELD
    final emailField = Padding(padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: new TextFormField(
        style: TextStyle(color: Colors.white),
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        validator: (value) => value.isEmpty ? 'Email Cannot be Empty' : null,
        onSaved: (value) => _email = value,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.email, color: Colors.white70,),
          hintText: "Email",
          hintStyle: TextStyle(color: Colors.white54),
          errorStyle: TextStyle(color: Colors.white54),
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        ),
      ),
    );

    // **PHONE FIELD
    final phoneField = Padding(padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: new TextFormField(
        style: TextStyle(color: Colors.white),
        keyboardType: TextInputType.number,
        autofocus: false,
        validator: (value) => value.isEmpty ? 'Email Cannot be Empty' : null,
        onSaved: (value) => phoneNo = value,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.phone, color: Colors.white70,),
          hintText: "Phone Number",
          hintStyle: TextStyle(color: Colors.white54),
          errorStyle: TextStyle(color: Colors.white54),
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        ),
      ),
    );

    // **PASSWORD FIELD
    final passwordField = Padding(padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      child: new TextFormField(
        style: TextStyle(color: Colors.white),
        keyboardType: TextInputType.text,
        obscureText: true,
        autofocus: false,
        validator: (value) => value.isEmpty ? 'Password Cannot be Empty' : null,
        onSaved: (value) => _password = value,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.lock, color: Colors.white70,),
          hintText: "Password",
          hintStyle: TextStyle(color: Colors.white54),
          errorStyle: TextStyle(color: Colors.white54),
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
    final twitterButton = TwitterBtn(action: _loginWithTwitter);

    // **EMAIL/PHONE BUTTON
    final signInWithEmailButton = CustomColorButton(
      text: "Sign in With Email",
      textColor: Colors.white,
      backgroundColor: FlatColors.blueGray,
      height: 45.0,
      width: 200.0,
      onPressed: setSignInWithEmailStatus(),
    );
    
    final signInWithPhoneButton = CustomColorButton(
      text: "Sign in With Phone",
      textColor: Colors.white,
      backgroundColor: FlatColors.blueGray,
      height: 45.0,
      width: 200.0,
      onPressed: setSignInWithEmailStatus(),
    );
    
    //** NO ACCOUNT FLAT BTN
    final noAccountButton = FlatButton(
        child: Text("Don't Have an Account?", style: TextStyle(color: Colors.white)),
        onPressed: (){ PageTransitionService(context: context).transitionToRegistrationPage(); }
    );

    //**FORGOT PASSWORD FLAT BTN
//    final forgotPasswordButton = FlatButton(
//        child: Text("Forgot Password?", style: TextStyle(fontWeight: FontWeight.w200, color: Colors.white)),
//        onPressed: (){ PageTransitionService(context: context).transitionToForgotPasswordPage(); }
//    );

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
          SizedBox(height: 15.0),
          emailField,
          passwordField,
          //forgotPasswordButton,
          loginButton
        ],
      ),
    );

    final phoneAuthForm = Form(
      key: authFormKey,
      child: new Column(
        children: <Widget>[
          SizedBox(height: 45.0),
          phoneField,
          loginButton
        ],
      ),
    );

    return Scaffold(
      key: loginScaffoldKey,
      body: Theme(
          data: ThemeData(
              primaryColor: Colors.white,
              accentColor: Colors.white,
              cursorColor: Colors.white
          ),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [FlatColors.webblenRed, FlatColors.webblenOrange]),
              ),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                loading
                  ? loadingProgressBar
                  :fillerContainer,
                  logo,
                  authForm,
                  noAccountButton,
                  orTextLabel,
                  facebookButton,
                  twitterButton,
//                    signInWithEmail
//                        ? signInWithPhoneButton
//                        : signInWithEmailButto
                ],
              ),
            ), 
          )
      ),
    );
  }
}