// ignore_for_file: avoid_print

import 'package:device_preview/device_preview.dart';
import 'package:edu_vista/app_routes.dart';
import 'package:edu_vista/blocs/cart/cart_bloc.dart';
import 'package:edu_vista/blocs/course/course_bloc.dart';
import 'package:edu_vista/blocs/lecture/lecture_bloc.dart';
import 'package:edu_vista/cubit/auth_cubit.dart';
import 'package:edu_vista/firebase_options.dart';
import 'package:edu_vista/pages/onboarding/splash_page.dart';
import 'package:edu_vista/services/pref.service.dart';
import 'package:edu_vista/utils/color.utility.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:ui';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesService.init();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }
  await dotenv.load(fileName: "dotenv");
  runApp(
    MultiBlocProvider(providers: [
      BlocProvider(create: (ctx) => AuthCubit()),
      BlocProvider(create: (ctx) => CourseBloc()),
      BlocProvider(create: (ctx) => LectureBloc()),
      BlocProvider(create: (ctx) => CartBloc()),
    ], child: const MyApp()
        // DevicePreview(
        //   enabled: !kReleaseMode,
        //   builder: (context) {
        //     return const MyApp();
        //   },
        // ),
        ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: _CustomScrollBehaviour(),
      debugShowCheckedModeBanner: false,
      title: 'Edu Vista',
      theme: ThemeData(
        scaffoldBackgroundColor: ColorUtility.gbScaffold,
        fontFamily: ' PlusJakartaSans',
        colorScheme: ColorScheme.fromSeed(seedColor: ColorUtility.main),
        useMaterial3: true,
      ),
      onGenerateRoute: generateRoute,
      initialRoute: SplashPage.id,
    );
  }
}

class _CustomScrollBehaviour extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
      };
}
