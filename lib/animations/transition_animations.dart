import 'package:flutter/material.dart';

class ScaleRoute extends PageRouteBuilder {
  final Widget widget;
  ScaleRoute({this.widget})
      : super(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return widget;
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return new ScaleTransition(
          scale: new Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Interval(
                0.00,
                0.80,
                curve: Curves.easeIn,
              ),
            ),
          ),
          child: child,
//          child: ScaleTransition(
//            scale: Tween<double>(
//              begin: 1.5,
//              end: 1.0,
//            ).animate(
//              CurvedAnimation(
//                parent: animation,
//                curve: Interval(
//                  0.50,
//                  1.00,
//                  curve: Curves.linear,
//                ),
//              ),
//            ),
//            child: child,
//          ),
        );
      }
  );
}

class ScaleAndPopRoute extends PageRouteBuilder {
  final Widget widget;
  ScaleAndPopRoute({this.widget})
      : super(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return widget;
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return new ScaleTransition(
          scale: new Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Interval(
                0.00,
                0.75,
                curve: Curves.easeIn,
              ),
            ),
          ),
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 1.5,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Interval(
                  0.75,
                  1.00,
                  curve: Curves.linear,
                ),
              ),
            ),
            child: child,
          ),
        );
      }
  );
}

class SlideFromRightRoute extends PageRouteBuilder {
  final Widget widget;
  SlideFromRightRoute({this.widget})
      : super(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return widget;
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return new SlideTransition(
          position: new Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      }
  );
}