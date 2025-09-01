import 'package:flutter/material.dart';

import 'my_color.dart';

class MyTextStyle {
  MyTextStyle._();

  static TextStyle bottomstyle = TextStyle(
    fontFamily: 'dona',
    fontSize: 12,
    fontWeight: FontWeight.w200,
    color: Colors.white,
  );

  static TextStyle lebelMap = TextStyle(
    fontFamily: 'dona',
    fontSize: 10,
    overflow: TextOverflow.ellipsis,
    color: Colors.black,
  );

  static TextStyle textBlak12 = TextStyle(
    fontFamily: 'dona',
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: Colors.black,
  );
  static TextStyle textSmall12 = TextStyle(
    fontFamily: 'dona',
    fontSize: 12,
    overflow: TextOverflow.ellipsis,

    color: Colors.black,
  );
  static TextStyle textBlack16 = TextStyle(
    fontFamily: 'dona',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  static TextStyle checkboxFont = TextStyle(
    fontFamily: 'dona',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
}
