import 'package:flutter/material.dart';
import 'package:webblen/styles/gradients.dart';
import 'package:webblen/custom_widgets/gradient_app_bar.dart';


class PageTemplate extends StatefulWidget {
  static String tag = "template-page";
  @override
  _PageTemplateState createState() => new _PageTemplateState();
}

class _PageTemplateState extends State<PageTemplate> with SingleTickerProviderStateMixin {

  final eventsColor = Gradients.blueMalibuBeach();
  final myEventsColor = Gradients.smartIndigo();



  @override
  Widget build(BuildContext context) {

    // ** APP BAR
    final appBar = GradientAppBar("Title", eventsColor, Colors.white);




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
      body: body,
    );
  }
}