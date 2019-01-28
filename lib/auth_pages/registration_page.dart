import 'package:flutter/material.dart';
import 'package:webblen/styles/fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/widgets_common/common_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/widgets_common/common_header_row.dart';
import 'dart:async';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:webblen/utils/form_validators.dart';
import 'package:webblen/widgets_common/common_button.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class RegistrationPage extends StatefulWidget {

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

  String _email;
  bool signUpWithPhone = true;
  String phoneNo;
  String smsCode;
  String verificationID;
  String _confirmPassword;
  String _password;
  String uid;
  bool loading = false;
  var maskedTextController = new MaskedTextController(mask: '(000)-000-0000');

  showLoadingIndicator(){
    setState(() {
      loading = true;
    });
  }

  hideLoadingIndicator(){
    setState(() {
      loading = false;
    });
  }

  final authFormKey = new GlobalKey<FormState>();
  final registrationsScaffoldKey = new GlobalKey<ScaffoldState>();
  void transitionToRootPage() => Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (Route<dynamic> route) => false);
  void transitionToLoginPage() => Navigator.pop(context);


  setSignUpWithPhoneStatus(){
    if (signUpWithPhone){
      setState(() {
        signUpWithPhone = false;
      });
    } else {
      setState(() {
        signUpWithPhone = true;
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

  Future<void> validatePhone() async {
    print(phoneNo);
//    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verID){
//      this.verificationID = verID;
//    };
//
//    final PhoneCodeSent smsCodeSent = (String verID, [int forceCodeResend]){
//      this.verificationID = verID;
//      smsCodeMessage(context);
//    };
//
//    final PhoneVerificationCompleted verificationCompleted = (FirebaseUser user){
//
//    };
//
//    await FirebaseAuth.instance.verifyPhoneNumber(
//        phoneNumber: this.phoneNo,
//        timeout: const Duration(seconds: 10),
//        verificationCompleted: verificationCompleted,
//        verificationFailed: null,
//        codeSent: smsCodeSent,
//        codeAutoRetrievalTimeout: autoRetrievalTimeout
//    );
  }

  Widget smsCodeFieldWidget(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: new TextFormField(
        style: TextStyle(color: Colors.white),
        keyboardType: TextInputType.number,
        autofocus: false,
        validator: (value) => value.isEmpty ? 'Code Cannot be Empty' : null,
        onSaved: (value) => smsCode = value,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.email, color: Colors.white70),
          hintText: "SMS Code",
          hintStyle: TextStyle(color: Colors.white54),
          errorStyle: TextStyle(color: Colors.white54),
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        ),
      ),
    );
  }

  Future<bool> smsCodeMessage(BuildContext context) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) { return PhoneVerificationDialog(textFieldWidget: smsCodeFieldWidget(), submitSMSAction: signInWithPhone());});
  }

  signInWithPhone(){
    showLoadingIndicator();
    ScaffoldState scaffold = registrationsScaffoldKey.currentState;
    FirebaseAuth.instance.signInWithPhoneNumber(verificationId: verificationID, smsCode: smsCode).then((user){
      hideLoadingIndicator();
      transitionToRootPage();
    }).catchError((e){
      hideLoadingIndicator();
      scaffold.showSnackBar(new SnackBar(
        content: new Text(e.details),
        backgroundColor: FlatColors.darkGray,
        duration: Duration(seconds: 2),
      ));
    });
  }

  Future<Null> validateAndRegister() async {
    showLoadingIndicator();
    ScaffoldState scaffold = registrationsScaffoldKey.currentState;
    if (validateAndSave()) {
      String error;
      error = FormValidators().validateEmail(_email);
      if (error.isNotEmpty){
        hideLoadingIndicator();
        scaffold.showSnackBar(new SnackBar(
          content: new Text(error),
          backgroundColor: FlatColors.darkGray,
          duration: Duration(seconds: 2),
        ));
      } else {
        error = FormValidators().validatePassword(_password, _confirmPassword);
        if (error.isNotEmpty){
          hideLoadingIndicator();
          scaffold.showSnackBar(new SnackBar(
            content: new Text(error),
            backgroundColor: FlatColors.darkGray,
            duration: Duration(seconds: 2),
          ));
        } else {
          try {
            uid = await BaseAuth().createUser(_email, _password);
            transitionToRootPage();
          } catch (e) {
            hideLoadingIndicator();
            String error = e.details;
            scaffold.showSnackBar(new SnackBar(
              content: new Text(error),
              backgroundColor: FlatColors.darkGray,
              duration: Duration(seconds: 2),
            ));
          }
        }
      }
    } else {
      hideLoadingIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {

    final loadingProgressBar = CustomLinearProgress(Colors.white, Colors.transparent);

    // **PHONE FIELD
    final phoneField = Padding(padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: new TextFormField(
        controller: maskedTextController,
        style: TextStyle(color: Colors.white),
        keyboardType: TextInputType.number,
        autofocus: false,
        validator: (value) => value.isEmpty ? 'Phone Cannot be Empty' : null,
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

    final registerButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Material(
        elevation: 5.0,
        color: FlatColors.darkGray,
        borderRadius: BorderRadius.circular(20.0),
        child: InkWell(
          onTap: () {
            validatePhone();
          },
          child: Container(
            height: 45.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Verify Phone Number", style: Fonts.bodyTextStyleWhite),
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
      onPressed: () {
        Navigator.of(context).pop();
      },
    );


    final phoneAuthForm = Form(
      key: authFormKey,
      child: new Column(
        children: <Widget>[
          SizedBox(height: 50.0),
          phoneField,
          registerButton
        ],
      ),
    );

    return Scaffold(
      key: registrationsScaffoldKey,
      body: Theme(
        data: ThemeData(
            primaryColor: Colors.white,
            accentColor: Colors.white,
            cursorColor: Colors.white),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [FlatColors.webblenOrange, FlatColors.webblenRed]),
          ),
          child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
              child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        loading ? loadingProgressBar : HeaderRowCentered(16.0, 16.0, "Register"),
//                  signUpWithPhone
//                    ? phoneAuthForm
                        phoneAuthForm,
//                  signUpWithPhone
//                    ? signInWithEmailButton
//                    : signInWithPhoneButton,
                        hasAccountLabel
                      ],
                    ),
                  ),
              )
          ),

    );
  }
}