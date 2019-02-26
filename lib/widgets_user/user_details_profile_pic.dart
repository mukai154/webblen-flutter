import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/utils/image_caching.dart';
import 'dart:io';

class UserDetailsProfilePic extends StatefulWidget {

  final String userPicUrl;
  final double size;

  UserDetailsProfilePic({this.userPicUrl, this.size});

  @override
  _UserDetailsProfilePicState createState() => _UserDetailsProfilePicState();
}


class _UserDetailsProfilePicState extends State<UserDetailsProfilePic> {

  bool loadingUserImage = true;
  File cachedUserImage;

  @override
  void initState() {
    super.initState();
    ImageCachingService().getCachedImage(widget.userPicUrl).then((file){
      cachedUserImage = file;
      loadingUserImage = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: widget.size,
      width: widget.size,
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
        borderRadius: BorderRadius.circular(widget.size/2),
        child: loadingUserImage
            ? CustomCircleProgress(20.0, 20.0, 20.0, 20.0, FlatColors.blueGrayLowOpacity)
            : cachedUserImage != null
              ? Image.file(cachedUserImage, fit: BoxFit.contain)

            : CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: widget.userPicUrl,
                placeholder: Container(
                  height: widget.size,
                  width: widget.size,
                  color: Colors.white,
                  child: CustomCircleProgress(20.0, 20.0, 20.0, 20.0, FlatColors.blueGrayLowOpacity),
                ),
                errorWidget: Container(
                  height: widget.size,
                  width: widget.size,
                  color: Colors.white,
                  child: Image.asset('assets/images/user_image_placeholder.png', fit: BoxFit.contain),
                ),
              ),
      ),
    );
  }
}

