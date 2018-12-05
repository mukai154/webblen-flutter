import 'package:flutter/material.dart';
import 'flat_colors.dart';

class Gradients {

  static Color colorFirst;
  static Color colorSecond;

  static cloudyGradient(){
    colorFirst = Color.fromRGBO(253,251,251, 1.0);
    colorSecond = Color.fromRGBO(235,237,238, 1.0);
    return new LinearGradient(
        colors: [
          colorFirst,
          colorSecond,
        ],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp
    );
  }

  static blueMalibuBeach(){
    colorFirst = Color.fromRGBO(79,172,254, 1.0);
    colorSecond = Color.fromRGBO(0,242,254, 1.0);
    return new LinearGradient(
        colors: [
          colorFirst,
          colorSecond,
        ],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp
    );
  }

  static smartIndigo(){
    colorFirst = Color.fromRGBO(178,36,239, 1.0);
    colorSecond = Color.fromRGBO(117,121,255, 1.0);
    return new LinearGradient(
        colors: [
          colorFirst,
          colorSecond,
        ],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp
    );
  }

  static twinkleBlue(){
    colorFirst = Color.fromRGBO(206, 214, 224, 1.0);
    colorSecond = Color.fromRGBO(206, 214, 224, 1.0);
    return new LinearGradient(
        colors: [
          colorFirst,
          colorSecond,
        ],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp
    );
  }

  static midnightCity(){
    colorFirst = Color.fromRGBO(134,143,150, 1.0);
    colorSecond = Color.fromRGBO(89,97,100, 1.0);
    return new LinearGradient(
        colors: [
          colorFirst,
          colorSecond,
        ],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp
    );
  }

  static webblenGradient(){
    colorFirst = FlatColors.webblenRed;
    colorSecond = FlatColors.webblenOrange;
    return new LinearGradient(
        colors: [
          colorFirst,
          colorSecond,
        ],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp
    );
  }

}