import 'package:flutter/material.dart';

class UserProfilePic extends StatelessWidget {

  final double radius;
  final String heroTag;

  UserProfilePic(this.radius, this.heroTag);

  @override
  Widget build(BuildContext context) {
    return Hero (
      tag: heroTag,
      child: Padding(
        padding: EdgeInsets.all(0.0),
        child: CircleAvatar(
          radius: radius,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('assets/images/user_pic_example.jpg'),
        ),
      ),
    );
  }
}