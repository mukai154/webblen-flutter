import 'package:flutter/material.dart';
import 'package:webblen/styles/gradients.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/styles/fonts.dart';

class InterestRow extends StatelessWidget {

  final String interest;
  final bool isInterested;

  InterestRow({this.interest, this.isInterested});

  @override
  Widget build(BuildContext context) {

    final interestText = Fonts().interestText(
        interest,
        MediaQuery.of(context).size.width * 0.07,
        isInterested ? Colors.white : FlatColors.londonSquare
    );

    final interestCardContent = new Container(
      margin: new EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          interestText
        ],
      ),
    );

    final interestCardDecoration = BoxDecoration(
      color: isInterested ? null : Colors.white,
      gradient: isInterested ? Gradients.webblenGradient() : null,
      shape: BoxShape.rectangle,
      borderRadius: new BorderRadius.circular(8.0),
      boxShadow: <BoxShadow>[
        new BoxShadow(
          color: Colors.black12,
          blurRadius: 10.0,
          offset: new Offset(0.0, 10.0),
        ),
      ],
    );

    final interestCard = new Container(
      width: MediaQuery.of(context).size.width * 0.9,
//      margin: new EdgeInsets.fromLTRB(24.0, 6.0, 8.0, 8.0),
      child: interestCardContent,
      decoration: interestCardDecoration
    );


    return Container(
      child: interestCard,
    );
  }

}