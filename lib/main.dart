import 'package:device_preview/device_preview.dart';
import 'package:edu_vista/blocs/course/course_bloc.dart';
import 'package:edu_vista/blocs/lecture/lecture_bloc.dart';
import 'package:edu_vista/cubit/auth_cubit.dart';
import 'package:edu_vista/firebase_options.dart';
import 'package:edu_vista/pages/cart/cart_page.dart';
import 'package:edu_vista/pages/cart/checkout_page.dart';
import 'package:edu_vista/pages/categories/categories_page.dart';
import 'package:edu_vista/pages/categories/category_courses_page.dart';
import 'package:edu_vista/pages/chat/chat_page.dart';
import 'package:edu_vista/pages/course/course_details_page.dart';
import 'package:edu_vista/pages/course/top_rated_courses_page.dart';
import 'package:edu_vista/pages/course/top_seller_courses_page.dart';
import 'package:edu_vista/pages/home/homepage_view.dart';
import 'package:edu_vista/pages/onboarding/onboarding_page.dart';
import 'package:edu_vista/pages/onboarding/splash_page.dart';
import 'package:edu_vista/pages/profile/profile_page.dart';
import 'package:edu_vista/pages/search/search_page.dart';
import 'package:edu_vista/services/pref.service.dart';
import 'package:edu_vista/utils/color.utility.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:ui';

import 'package:edu_vista/pages/home/home_page.dart';
import 'package:edu_vista/pages/auth/login_page.dart';
import 'package:edu_vista/pages/auth/reset_password_page.dart';
import 'package:edu_vista/pages/auth/signup_page.dart';
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
      onGenerateRoute: (settings) {
        final String routeName = settings.name ?? '';
        final dynamic data = settings.arguments;
        switch (routeName) {
          case LoginPage.id:
            return MaterialPageRoute(builder: (context) => const LoginPage());
          case SignUpPage.id:
            return MaterialPageRoute(builder: (context) => const SignUpPage());
          case ResetPasswordPage.id:
            return MaterialPageRoute(
                builder: (context) => const ResetPasswordPage());
          case OnBoardingPage.id:
            return MaterialPageRoute(
                builder: (context) => const OnBoardingPage());
          case HomePage.id:
            return MaterialPageRoute(builder: (context) => const HomePage());
          case HomePageView.id:
            return MaterialPageRoute(
                builder: (context) => const HomePageView());
          case CategoriesPage.id:
            return MaterialPageRoute(
                builder: (context) => const CategoriesPage());
          case ChatPage.id:
            return MaterialPageRoute(builder: (context) => const ChatPage());
          case ProfilePage.id:
            return MaterialPageRoute(builder: (context) => const ProfilePage());
          case SearchPage.id:
            return MaterialPageRoute(builder: (context) => const SearchPage());
          case TopSellerCoursesPage.id:
            return MaterialPageRoute(
                builder: (context) => const TopSellerCoursesPage());
          case TopRatedCoursesPage.id:
            return MaterialPageRoute(
                builder: (context) => const TopRatedCoursesPage());
          case CheckoutPage.id:
            return MaterialPageRoute(
                builder: (context) => const CheckoutPage());
          case CartPage.id:
            return MaterialPageRoute(builder: (context) => const CartPage());
          case CourseDetailsPage.id:
            return MaterialPageRoute(
                builder: (context) => CourseDetailsPage(
                      course: data,
                    ));
          case CategoryCoursesPage.id:
            return MaterialPageRoute(
                builder: (context) => CategoryCoursesPage(
                      categoryData: data,
                    ));

          default:
            return MaterialPageRoute(builder: (context) => const SplashPage());
        }
      },
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
