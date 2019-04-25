import 'package:flutter/material.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:webblen/auth_buttons/facebook_btn.dart';
import 'package:webblen/auth_buttons/twitter_btn.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen/widgets_common/common_button.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'dart:async';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:webblen/services_general/service_page_transitions.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:webblen/utils/strings.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:webblen/services_general/services_show_alert.dart';


class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final loginScaffoldKey = new GlobalKey<ScaffoldState>();
  final authFormKey = new GlobalKey<FormState>();

  static final FacebookLogin facebookSignIn = new FacebookLogin();
  static final TwitterLogin twitterLogin = new TwitterLogin(consumerKey: Strings.twitterCONSUMERKEY, consumerSecret: Strings.twitterCONSUMERSECRET);

  bool isLoading = false;
  bool signInWithEmail = false;
  String _email;
  String _password;
  String uid;

  var phoneMaskController = MaskedTextController(mask: '+1 000-000-0000');
  String phoneNo;
  String smsCode;
  String verificationId;

  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      ShowAlertDialogService().showFormWidget(
          context,
          'Enter SMS Code',
          TextField(
            onChanged: (value) {
              this.smsCode = value;
            },
          ),
            () {
          FirebaseAuth.instance.currentUser().then((user) {
            if (user != null) {
              Navigator.of(context).pop();
              PageTransitionService(context: context).transitionToRootPage();
            } else {
              Navigator.of(context).pop();
              signInWithPhone();
            }
          });
        },
      );
    };

    final PhoneVerificationCompleted verifiedSuccess = (FirebaseUser user) {

    };

    final PhoneVerificationFailed veriFailed = (AuthException exception) {
      ShowAlertDialogService().showFailureDialog(context, "Verification Failed", "There was an issue verifying your phone number. Please try again");
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this.phoneNo,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifiedSuccess,
        verificationFailed: veriFailed);
  }


  signInWithPhone() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    FirebaseAuth.instance.signInWithCredential(credential).then((user) {
      if (user != null){
        PageTransitionService(context: context).transitionToRootPage();
      } else {
        ShowAlertDialogService().showFailureDialog(context, 'Oops!', 'There was an issue signing in.. Please Try Again');
      }
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      ShowAlertDialogService().showFailureDialog(context, 'Oops!', 'Invalid Verification Code. Please Try Again.');
    });
  }

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
      isLoading = true;
    });
    ScaffoldState scaffold = loginScaffoldKey.currentState;
    if (validateAndSave()) {
      if (signInWithEmail){
        try {
          uid = await BaseAuth().signIn(_email, _password);
          setState(() {
            isLoading = false;
          });
          PageTransitionService(context: context).transitionToRootPage();
        } catch (e) {
          String error = e.details;
          scaffold.showSnackBar(new SnackBar(
            content: new Text(error),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ));
          setState(() {
            isLoading = false;
          });
        }
      } else {
        verifyPhone();
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Null> _loginWithFacebook() async {
    setState(() {
      isLoading = true;
    });
    ScaffoldState scaffold = loginScaffoldKey.currentState;
    final FacebookLoginResult result = await facebookSignIn.logInWithReadPermissions(['email', 'public_profile']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        final AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: accessToken.token);
        FirebaseAuth.instance.signInWithCredential(credential).then((user){
          if (user != null){
            PageTransitionService(context: context).transitionToRootPage();
          } else {
            setState(() {
              isLoading = false;
            });
            ShowAlertDialogService().showFailureDialog(context, 'Oops!', 'There was an issue signing in with Facebook. Please Try Again');
          }
        });

        break;
      case FacebookLoginStatus.cancelledByUser:
        scaffold.showSnackBar(new SnackBar(
          content: new Text("Cancelled Facebook Login"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ));
        setState(() {
          isLoading = false;
        });
        break;
      case FacebookLoginStatus.error:
        scaffold.showSnackBar(new SnackBar(
          content: new Text("There was an Issue Logging Into Facebook"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ));
        setState(() {
          isLoading = false;
        });
        break;
    }
  }


  void _loginWithTwitter() async {
    setState(() {
      isLoading = true;
    });
    ScaffoldState scaffold = loginScaffoldKey.currentState;
    twitterLogin.authorize().then((result){
      switch (result.status) {
        case TwitterLoginStatus.loggedIn:
          final AuthCredential credential = TwitterAuthProvider.getCredential(authToken: result.session.token, authTokenSecret: result.session.secret);
          FirebaseAuth.instance.signInWithCredential(credential).then((user){
            if (user != null){
              PageTransitionService(context: context).transitionToRootPage();
            } else {
              setState(() {
                isLoading = false;
              });
              ShowAlertDialogService().showFailureDialog(context, 'Oops!', 'There was an issue signing in with Twitter. Please Try Again');
            }
          }).catchError((e){
            scaffold.showSnackBar(new SnackBar(
              content: new Text(e.details),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ));
            setState(() {
              isLoading = false;
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
            isLoading = false;
          });
          break;
        case TwitterLoginStatus.error:
          scaffold.showSnackBar(new SnackBar(
            content: new Text("Error: ${result.errorMessage}"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ));
          setState(() {
            isLoading = false;
          });
          break;
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    // **UI ELEMENTS
    final logo = Image.asset(
      'assets/images/webblen_logo_text.jpg',
      height: 210.0,
      fit: BoxFit.fitHeight,
    );
    final isLoadingProgressBar = CustomLinearProgress(progressBarColor: FlatColors.webblenRed);

    // **EMAIL FIELD
    final emailField = Padding(padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        validator: (value) => value.isEmpty ? 'Email Cannot be Empty' : null,
        onSaved: (value) => _email = value,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.email, color: Colors.black38,),
          hintText: "Email",
          hintStyle: TextStyle(color: Colors.black38),
          errorStyle: TextStyle(color: Colors.redAccent),
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        ),
      ),
    );

    // **PHONE FIELD
    final phoneField = Padding(padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
      child: new TextFormField(
        controller: phoneMaskController,
        style: TextStyle(color: Colors.black),
        keyboardType: TextInputType.number,
        autofocus: false,
        validator: (value) => value.isEmpty ? 'Phone Cannot be Empty' : null,
        onSaved: (value) => phoneNo = value,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.phone, color: Colors.black38,),
          hintText: "Phone Number",
          hintStyle: TextStyle(color: Colors.black38),
          errorStyle: TextStyle(color: Colors.redAccent),
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        ),
      ),
    );

    // **PASSWORD FIELD
    final passwordField = Padding(padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      child: new TextFormField(
        style: TextStyle(color: Colors.black),
        keyboardType: TextInputType.text,
        obscureText: true,
        autofocus: false,
        validator: (value) => value.isEmpty ? 'Password Cannot be Empty' : null,
        onSaved: (value) => _password = value,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.lock, color: Colors.black26,),
          hintText: "Password",
          hintStyle: TextStyle(color: Colors.black26),
          errorStyle: TextStyle(color: Colors.redAccent),
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        ),
      ),
    );

    // **LOGIN BUTTON
    final loginButton = CustomColorButton(
      height: 45.0,
      width: MediaQuery.of(context).size.width * 0.85,
      text: signInWithEmail ? 'Sign In' : 'Send SMS Code',
      textColor: FlatColors.darkGray,
      backgroundColor: Colors.white,
      onPressed: () => validateAndSubmit(),
    );

    // **FACEBOOK BUTTON
    final facebookButton = FacebookBtn(action: _loginWithFacebook);

    // **TWITTER BUTTON
    final twitterButton = TwitterBtn(action: _loginWithTwitter);

    // **EMAIL/PHONE BUTTON
    final signInWithEmailButton = CustomColorIconButton(
      icon: Icon(FontAwesomeIcons.envelope, color: FlatColors.darkGray, size: 18.0),
      text: "Sign in With Email",
      textColor: FlatColors.darkGray,
      backgroundColor: Colors.white,
      height: 45.0,
      width: MediaQuery.of(context).size.width * 0.85,
      onPressed: () => setSignInWithEmailStatus(),
    );
    
    final signInWithPhoneButton = CustomColorIconButton(
      icon: Icon(FontAwesomeIcons.mobileAlt, color: FlatColors.darkGray, size: 18.0),
      text: "Sign in With Phone",
      textColor: FlatColors.darkGray,
      backgroundColor: Colors.white,
      height: 45.0,
      width: MediaQuery.of(context).size.width * 0.85,
      onPressed: () => setSignInWithEmailStatus(),
    );

    //**FORGOT PASSWORD FLAT BTN
//    final forgotPasswordButton = FlatButton(
//        child: Text("Forgot Password?", style: TextStyle(fontWeight: FontWeight.w200, color: Colors.white)),
//        onPressed: (){ PageTransitionService(context: context).transitionToForgotPasswordPage(); }
//    );

    final orTextLabel = Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Fonts().textW400('or', 12.0, Colors.black, TextAlign.center)
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
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
                child:  ListView(
                  children: <Widget>[
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          isLoading ? isLoadingProgressBar : Container(),
                          logo,
                          signInWithEmail ? authForm : phoneAuthForm,
                          orTextLabel,
                          facebookButton,
                          twitterButton,
                          signInWithEmail ? signInWithPhoneButton : signInWithEmailButton
                        ],
                      ),
                    ),
                  ],
                )
            ),
          ),
      ),
    );
  }
}