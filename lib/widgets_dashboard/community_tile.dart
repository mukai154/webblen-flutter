import 'package:flutter/material.dart';

class CommunityTile extends StatelessWidget {

  final Widget child;
  final VoidCallback onTap;

  CommunityTile({this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: child
    );
  }
}