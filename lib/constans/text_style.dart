import 'package:flutter/material.dart';

class MyTextStyle {
  MyTextStyle._();

  static TextStyle bottomstyle = const TextStyle(
    fontFamily: 'dona',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle lebelMap = TextStyle(
    fontFamily: 'dona',
    fontSize: 11,
    overflow: TextOverflow.ellipsis,
    color: Colors.grey[800],
    fontWeight: FontWeight.w500,
  );

  static TextStyle textBlak12 = TextStyle(
    fontFamily: 'dona',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: Colors.grey[700],
  );
  static TextStyle textSmall12 = TextStyle(
    fontFamily: 'dona',
    fontSize: 12,
    overflow: TextOverflow.ellipsis,
    color: Colors.grey[600],
  );
  static TextStyle textBlack16 = const TextStyle(
    fontFamily: 'dona',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Color(0xFF1F2937),
  );

  static TextStyle checkboxFont = TextStyle(
    fontFamily: 'dona',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.grey[800],
  );

  static TextStyle appBarStyle = const TextStyle(
    fontFamily: 'dona',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Color(0xFF1F2937),
  );

  static TextStyle headlineMedium = const TextStyle(
    fontFamily: 'dona',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFF1F2937),
  );

  static TextStyle caption = TextStyle(
    fontFamily: 'dona',
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: Colors.grey[500],
  );
}
