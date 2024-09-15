import 'package:edu_vista/utils/color.utility.dart';
import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: const ColorScheme.dark(
    surface: ColorUtility.gbScaffold,
    primary: ColorUtility.main,
    secondary: ColorUtility.deepYellow,
  ),
);
