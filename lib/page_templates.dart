import 'package:flutter/material.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'styles/gradients.dart';


class TemplatePage extends StatefulWidget {

  static String tag = "template-page";

  final BaseAuth auth;
  TemplatePage({this.auth});

  @override
  _TemplatePageState createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage> {



  @override
  Widget build(BuildContext context) {

    final body = Container(
      width: MediaQuery.of(context).size.width,
      decoration: new BoxDecoration(
        gradient: Gradients.twinkleBlue(),
      ),
      child: Column(
        children: <Widget>[
        ],
      ),
    );

    return Scaffold(
       body: body
    );
  }
}

class _StatelessTemplatePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(),
    );
  }
}

