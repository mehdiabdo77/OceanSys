import 'package:flutter/material.dart';
import 'package:ocean_sys/constans/my_color.dart';

class MyDecorations {
  MyDecorations._();

  static ButtonStyle mainButtom = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    backgroundColor: SolidColors.bootomColor,
    foregroundColor: Colors.white,
    elevation: 2,
    minimumSize: const Size(140, 50),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  );

  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.08),
        spreadRadius: 1,
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static InputDecoration inputDecoration = InputDecoration(
    filled: true,
    fillColor: const Color(0xFFF3F4F6),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: SolidColors.primaryColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
    ),
  );
}
