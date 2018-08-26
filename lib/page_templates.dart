import 'package:flutter/material.dart';
import 'package:webblen/firebase_services/auth.dart';
import 'custom_widgets/gradient_app_bar.dart';
import 'styles/gradients.dart';


class TemplatePage extends StatefulWidget {

  static String tag = "template-page";

  final BaseAuth auth;
  TemplatePage({this.auth});

  @override
  _TemplatePageState createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage> {

  // ** APP BAR
  final appBar = GradientAppBar("Events", Gradients.cloudyGradient() , Colors.white);


  @override
  Widget build(BuildContext context) {

    final body = Container(
      width: MediaQuery.of(context).size.width,
      decoration: new BoxDecoration(
        gradient: Gradients.twinkleBlue(),
      ),
      child: Column(
        children: <Widget>[
          appBar,
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

