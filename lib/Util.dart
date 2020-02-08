import 'package:flutter/material.dart';

class Util {
  static capitalize(String string) {
    return string[0].toUpperCase() + string.substring(1).toLowerCase();
  }

  static double calculateCardWidth(Size size) {
    double cardWidth;

    if (size.width > 1500) {
      cardWidth = size.width * 0.1;
    } else if (size.width > 1200) {
      cardWidth = size.width * 0.15;
    } else if (size.width >= 750) {
      cardWidth = size.width * 0.175;
    } else {
      cardWidth = size.width * 0.35;
    }
    return cardWidth;
  }
}
