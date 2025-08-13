import 'package:flutter/material.dart';

class AppTextStyle {
  AppTextStyle._();
  static TextStyle textStyleRegular14 = TextStyle(
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.w400,
    fontFamily: 'Inter-Regular',
    height: 1.6,
    letterSpacing: 0,
  );
  static TextStyle textStyleSemiBold14 = TextStyle(
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.w600,
    fontFamily: 'Inter-SemiBold',
    height: 2,
    letterSpacing: 0,
  );

  static TextStyle textStyleSemiBold24 = textStyleSemiBold14.copyWith(fontSize: 24);
  static TextStyle textStyleSemiBold16 = textStyleSemiBold14.copyWith(fontSize: 16);
  static TextStyle textStyleSemiBold12 = textStyleSemiBold14.copyWith(fontSize: 12);
  static TextStyle textStyleSemiBold10 = textStyleSemiBold14.copyWith(fontSize: 10);
  static TextStyle textStyleSemiBold8 = textStyleSemiBold14.copyWith(fontSize: 8);
  static TextStyle textStyleSemiBold6 = textStyleSemiBold14.copyWith(fontSize: 6);
  static TextStyle textStyleSemiBold4 = textStyleSemiBold14.copyWith(fontSize: 4);
  static TextStyle textStyleSemiBold2 = textStyleSemiBold14.copyWith(fontSize: 2);

  static TextStyle textStyleRegular24 = textStyleRegular14.copyWith(fontSize: 24);
  static TextStyle textStyleRegular16 = textStyleRegular14.copyWith(fontSize: 16);
  static TextStyle textStyleRegular12 = textStyleRegular14.copyWith(fontSize: 12);
  static TextStyle textStyleRegular10 = textStyleRegular14.copyWith(fontSize: 10);
  static TextStyle textStyleRegular8 = textStyleRegular14.copyWith(fontSize: 8);
  static TextStyle textStyleRegular6 = textStyleRegular14.copyWith(fontSize: 6);
  static TextStyle textStyleRegular4 = textStyleRegular14.copyWith(fontSize: 4);
  static TextStyle textStyleRegular2 = textStyleRegular14.copyWith(fontSize: 2);
}
