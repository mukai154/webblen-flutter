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

  static final dashboardTitleStyle =  new TextStyle(fontSize: 20.0, letterSpacing: 1.0, fontWeight: FontWeight.w600, color: FlatColors.blackPearl);

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

  static final bodyTextStyleBlue =  new TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: FlatColors.electronBlue);

  static final bodyTextStyleWhite =  new TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.white);

  static final bodyTextStyleWhiteSmall =  new TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: Colors.white);

  static final subHeadTextStyleWhite =  new TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.white);

  static final flushbarTextTitleLight =  new TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.white);

  static final flushbarTextBodyLight =  new TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: Colors.white);

  static final flushbarTextTitleDark =  new TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: FlatColors.blackPearl);

  static final flushbarTextBodyDark =  new TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: FlatColors.blackPearl);

  static final alertDialogHeader =  new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: FlatColors.blackPearl);

  static final alertDialogBody =  new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: FlatColors.londonSquare);

  static final alertDialogAction =  new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: FlatColors.blackPearl);

  static final noEventsFont =  new TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: FlatColors.blueInneundo);

  static final onboardingHeaderTextStyleWhite =  new TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700, color: Colors.white);

  static final onboardingSubHeaderTextStyleWhite =  new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300, color: Colors.white);

  static final boldBodyTextStyle =  new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: FlatColors.blackPearl);

  static final appBarTextStyle =  new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300, color: FlatColors.londonSquare);

  static final appBarWalletTextStyle =  new TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.white);

  static final pointStatStyle = TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: FlatColors.londonSquare);

  static final walletHeadTextStyle = TextStyle(fontSize: 40.0, fontWeight: FontWeight.w500, color: FlatColors.londonSquare);

  static final walletSubHeadTextStyleDark = TextStyle(fontSize: 30.0, fontWeight: FontWeight.w500, color: FlatColors.blackPearl);

  static final guideHeaderTextStyle =  new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: FlatColors.blackPearl);

  static final guideBodyTextStyle =  new TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, color: FlatColors.londonSquare);

  static final noticeWhiteTextStyle =  new TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.white);

  static final dashboardQuestionTextStyleWhite =  new TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300, color: Colors.white);

  static final dashboardQuestionTextStyleGray =  new TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300, color: FlatColors.lightAmericanGray);

}