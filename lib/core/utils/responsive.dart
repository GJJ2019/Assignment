import 'package:flutter/material.dart';

class Responsive {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double devicePixelRatio;
  static late double textScaleFactor;

  // Design dimensions (base resolution: e.g. iPhone X / 11)
  static const double _designWidth = 375.0;
  static const double _designHeight = 812.0;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    devicePixelRatio = _mediaQueryData.devicePixelRatio;
    textScaleFactor = _mediaQueryData.textScaler.scale(1.0);
  }

  // Get scaled width relative to design layout
  static double getWidth(double width) {
    double widthScale = screenWidth / _designWidth;
    double heightScale = screenHeight / _designHeight;
    double scale = widthScale > heightScale * 1.2 ? heightScale : widthScale;
    return width * scale;
  }

  // Get scaled height relative to design layout
  static double getHeight(double height) {
    return (height / _designHeight) * screenHeight;
  }

  // Get scaled font size (scaled by screen width to keep proportions)
  static double getSp(double fontSize) {
    double widthScale = screenWidth / _designWidth;
    double heightScale = screenHeight / _designHeight;
    double scale = widthScale > heightScale * 1.2 ? heightScale : widthScale;
    return fontSize * scale;
  }

  // Safe area metrics
  static double get safeAreaTop => _mediaQueryData.padding.top;
  static double get safeAreaBottom => _mediaQueryData.padding.bottom;
}

// Extension methods for clean syntax
extension ResponsiveNumExtension on num {
  double get w => Responsive.getWidth(toDouble());
  double get h => Responsive.getHeight(toDouble());
  double get sp => Responsive.getSp(toDouble());
}
