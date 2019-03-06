import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';

class DashboardTile extends StatelessWidget {

  final Widget child;
  final VoidCallback onTap;
  final String tileType;

  DashboardTile({this.child, this.onTap, this.tileType});

  @override
  Widget build(BuildContext context) {
     return Padding(
       padding: EdgeInsets.symmetric(horizontal: 8.0),
       child: Container(

         decoration: BoxDecoration(
           gradient: tileType == 'calendar'
              ? LinearGradient(
                  colors: [FlatColors.webblenDarkBlue, FlatColors.webblenLightBlue]
                )
              : tileType == 'checkIn'
                ? LinearGradient(
                    colors: [FlatColors.webblenRed, FlatColors.pinkGlamour]
                  )
                : tileType == 'communityActivity'
                  ? LinearGradient(
                     colors: [ FlatColors.exodusPurple, FlatColors.webblenPurple,]
                    )
                  : LinearGradient(
                     colors: [Colors.white, Colors.white]
                    ),

             borderRadius: BorderRadius.circular(24.0),
             boxShadow: ([
               BoxShadow(
                 color: Colors.black12,
                 blurRadius: 2.0,
                 spreadRadius: 1.0,
                 offset: Offset(0.0, 3.0),
               ),
             ])),
         child: InkWell(
             borderRadius: BorderRadius.circular(12.0),
             // Do onTap() if it isn't null, otherwise do print()
             onTap: onTap != null ? () => onTap() : () { print('Not set yet'); },
             child: child
         ),
       ),
     );
  }
}