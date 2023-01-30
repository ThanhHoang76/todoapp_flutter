import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dimensions.dart';

const kPrimaryColor = Color(0xFF36558F);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);
const kDefaultPadding = 20.0;
const kPrimaryCol = kPrimaryColor;
const kStickers1 = Color(0xFFFF6B6C);
const kStickers2 = Color(0xFF5B5F97);
const kStickers3 = Color(4294951237);

final TextStyle titleStyle = GoogleFonts.comfortaa(
  textStyle: TextStyle(
    fontSize: Dimensions.font13,
    fontWeight: FontWeight.w400,
  ),
);

final TextStyle subTitleStyle = GoogleFonts.comfortaa(
  textStyle: const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
);
TextStyle notificationScreenHeadingTextStyle = GoogleFonts.lato(
  textStyle: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode ? Colors.white : kContentColorLightTheme),
);
TextStyle get notificationScreenSubHeadingTextStyle => GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w300,
        color: Get.isDarkMode ? Colors.white : kContentColorLightTheme));

TextStyle get notificationScreenBodyTextStyle => GoogleFonts.lato(
    textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w300,
        color: Colors.white));

TextStyle get homeScreenHeadingTextStyle => GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Get.isDarkMode ? Colors.white : kContentColorDarkTheme));

TextStyle get homeScreenSubHeadingTextStyle => GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w300,
        color: Get.isDarkMode ? Colors.white : kContentColorDarkTheme));

TextStyle get taskTileHeadingTextStyle => GoogleFonts.lato(
    textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white));
