import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class UserDetailsProfilePic extends StatelessWidget {

  final String userPicUrl;
  final double size;

  UserDetailsProfilePic({this.userPicUrl, this.size});

  @override
  Widget build(BuildContext context) {

    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [new BoxShadow(
          color: Colors.black45,
          blurRadius: 4.5,
          offset: Offset(0.0, 3.0),
        )],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size/2),
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: userPicUrl,
          placeholder: (context, url) => Icon(FontAwesomeIcons.user),
          errorWidget: (context, url, error) => Icon(FontAwesomeIcons.user),
        ),
      ),
    );
  }
}

