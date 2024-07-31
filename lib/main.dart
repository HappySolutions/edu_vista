import 'package:edu_vista/pages/on_boarding_page.dart';
import 'package:edu_vista/pages/splash_page.dart';
import 'package:edu_vista/utils/color.utility.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'PlusJakartaSans',
        scaffoldBackgroundColor: ColorUtility.scaffoldBackground,
        colorScheme: ColorScheme.fromSeed(seedColor: ColorUtility.main),
        useMaterial3: true,
      ),
      home: const OnBoardingPage(),
    );
  }
}
