import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen/styles/flat_colors.dart';

class UserDetailsBadge extends StatelessWidget {

  final String badgeType;
  final double size;

  UserDetailsBadge({this.badgeType, this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: badgeType == "communityBuilder"
            ? FlatColors.casandoraYellow
            : badgeType == "friend"
            ? FlatColors.webblenRed
            : FlatColors.lightAmericanGray,
        shape: BoxShape.circle,
        boxShadow: [new BoxShadow(
          color: Colors.black12,
          blurRadius: 1.5,
          offset: Offset(0.0, 3.0),
        )],
      ),
      child: Center(
        child: badgeType == "communityBuilder"
            ? Icon(FontAwesomeIcons.hammer, size: 16.0, color: Colors.white)
            : badgeType == "friend"
            ? Icon(FontAwesomeIcons.solidHeart, size: 16.0, color: Colors.white)
            : Container(),
      )
    );
  }
}