import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:webblen/styles/flat_colors.dart';

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
          blurRadius: 5.0,
          offset: Offset(0.0, 3.0),
        )],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size/2),
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: userPicUrl,
          placeholder: Container(
            height: size,
            width: size,
            color: Colors.white,
            child: CustomCircleProgress(20.0, 20.0, 20.0, 20.0, FlatColors.blueGrayLowOpacity),
          ),
          errorWidget:Container(
            height: size,
            width: size,
            color: Colors.white,
            child: Image.asset('assets/images/user_image_placeholder.png', fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}

