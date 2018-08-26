import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';

class Fonts {


  static final baseTextStyle = const TextStyle(
      fontFamily: 'Poppins'
  );

  static final headerTextStyle = baseTextStyle.copyWith(
      color: FlatColors.blackPearl,
      fontSize: 16.0,
      fontWeight: FontWeight.w500
  );

  static final dashboardTitleStyle =  new TextStyle(fontSize: 26.0, letterSpacing: 1.5, fontWeight: FontWeight.w700, color: FlatColors.blackPearl);

  static final regularTextStyle = baseTextStyle.copyWith(
      color: FlatColors.blackPearl,
      fontSize: 9.0,
      fontWeight: FontWeight.w400
  );

  static final subHeaderTextStyle = regularTextStyle.copyWith(
      fontSize: 12.0
  );

  static final subHeaderTextStyle2 = regularTextStyle.copyWith(
      fontSize: 10.0
  );

  static final usernameTextStyle = regularTextStyle.copyWith(
      fontSize: 10.0
  );

  static final headerTextStyleWhite =  new TextStyle(fontSize: 30.0, fontWeight: FontWeight.w500, color: Colors.white);

  static final bodyTextStyleGray =  new TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.grey);

  static final bodyTextStyleWhite =  new TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.white);

  static final subHeadTextStyleWhite =  new TextStyle(fontSize: 30.0, fontWeight: FontWeight.w500, color: Colors.white);

  static final alertDialogHeader =  new TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700, color: FlatColors.blackPearl);

  static final alertDialogBody =  new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: FlatColors.londonSquare);

  static final alertDialogAction =  new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: FlatColors.blackPearl);

  static final noEventsFont =  new TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: FlatColors.blueInneundo);

}