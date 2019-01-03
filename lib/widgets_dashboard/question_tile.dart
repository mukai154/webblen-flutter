import 'package:flutter/material.dart';

class QuestionTile extends StatelessWidget {

  final Widget child;

  QuestionTile({this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(16.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
            child: child
        )
    );
  }
}