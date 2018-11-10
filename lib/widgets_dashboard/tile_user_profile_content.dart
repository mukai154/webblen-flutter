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
                  Container(
                    height: 70.0,
                    width: 70.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(35.0),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: "https://images.unsplash.com/photo-1531206715517-5c0ba140b2b8?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=044e5d85cd16e79671287971a06be066&auto=format&fit=crop&w=800&q=60",
                        placeholder: CustomCircleProgress(20.0, 20.0, 20.0, 20.0, FlatColors.londonSquare),
                        errorWidget: Image(image: AssetImage('images/user_image_placeholder.png')),
                      ),
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