import 'package:flutter/material.dart';

class DashboardTile extends StatelessWidget {

  final Widget child;
  final VoidCallback onTap;

  DashboardTile({this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
     return Padding(
       padding: EdgeInsets.symmetric(horizontal: 8.0),
       child: Container(
         decoration: BoxDecoration(
           color: Colors.white,
             borderRadius: BorderRadius.circular(24.0),
             boxShadow: ([
               BoxShadow(
                 color: Colors.black12,
                 blurRadius: 1.8,
                 spreadRadius: 0.5,
                 offset: Offset(0.0, 3.0),
               ),
             ])
         ),
         child: InkWell(
             borderRadius: BorderRadius.circular(12.0),
             // Do onTap() if it isn't null, otherwise do print()
             onTap: onTap,
             child: child
         ),
       ),
     );
  }
}