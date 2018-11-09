import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/widgets_common/common_progress.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TileUserProfileContent extends StatelessWidget {

  final String username;
  final String userImagePath;
  final bool userImageLoaded;

  TileUserProfileContent({this.username, this.userImagePath, this.userImageLoaded});

  @override
  Widget build(BuildContext context) {
    return Padding (
      padding: const EdgeInsets.all(24.0),
      child: Row (
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget> [
            Column (
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [
                Text('Account', style: TextStyle(color: FlatColors.londonSquare)),
                username == null ? new LoadingScreenProgressIndicator()
                    :Text('@' + username, style: TextStyle(color: FlatColors.darkGray, fontWeight: FontWeight.w600, fontSize: 24.0)),
              ],
            ),
            Hero (
              tag: 'profile_pic',
              child: Padding(
                padding: EdgeInsets.all(0.0),
                child: Hero(
                  tag: 'user-profile-pic',
                  child: //userImageLoaded == false ? CustomCircleProgress(60.0, 60.0, 30.0, 30.0, FlatColors.londonSquare)
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 30.0,
                    child: CachedNetworkImage(
                      imageUrl: userImagePath,
                      placeholder: new CircularProgressIndicator(),
                      errorWidget: new Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ),
          ]
      ),
    );
  }
}