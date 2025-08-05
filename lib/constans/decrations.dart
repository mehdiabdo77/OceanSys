import 'package:flutter/material.dart';
import 'package:ocean_sys/constans/my_color.dart';

class MyDecorations {
  MyDecorations._();

  static ButtonStyle mainButtom = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero, // square corners
    ),
    backgroundColor: SolidColors.bootomColor, // use program theme color
    minimumSize: Size(140, 40), // fixed size for square-like button
  );
}
