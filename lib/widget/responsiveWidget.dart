import 'package:flutter/material.dart';

class ResponsiveWidget{
  static bool isLargeScreen(BuildContext context){
    return MediaQuery.of(context).size.width > 700;
  }
  static bool isSmallScreen(BuildContext context){
    return MediaQuery.of(context).size.width < 300;
  }
  static bool isMediumScreen(BuildContext context){
    return MediaQuery.of(context).size.width > 300 &&
    MediaQuery.of(context).size.width < 700;
  }
}