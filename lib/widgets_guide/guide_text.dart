import 'package:webblen/styles/fonts.dart';
import 'package:flutter/material.dart';

class GuideHeaderText extends StatelessWidget {

  final String text;

  GuideHeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
      child: Text(text, style: Fonts.boldBodyTextStyle, textAlign: TextAlign.center),
    );
  }
}

class GuideBodyText extends StatelessWidget {

  final String text;

  GuideBodyText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
      child: Text(text, style: Fonts.bodyTextStyleGray, textAlign: TextAlign.center),
    );
  }
}