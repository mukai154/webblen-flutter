import 'package:flutter/material.dart';

class DashboardTile extends StatelessWidget {

  final Widget child;
  final VoidCallback onTap;

  DashboardTile({this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
     return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(16.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null ? () => onTap() : () { print('Not set yet'); },
            child: child
        )
    );
  }
}