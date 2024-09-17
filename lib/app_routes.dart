import 'package:edu_vista/pages/chat/messages_page.dart';
import 'package:flutter/material.dart';
import 'package:edu_vista/pages/auth/login_page.dart';
import 'package:edu_vista/pages/auth/reset_password_page.dart';
import 'package:edu_vista/pages/auth/signup_page.dart';
import 'package:edu_vista/pages/cart/cart_page.dart';
import 'package:edu_vista/pages/cart/checkout_page.dart';
import 'package:edu_vista/pages/categories/categories_page.dart';
import 'package:edu_vista/pages/categories/category_courses_page.dart';
import 'package:edu_vista/pages/chat/chat_page.dart';
import 'package:edu_vista/pages/course/course_details_page.dart';
import 'package:edu_vista/pages/course/courses_page.dart';
import 'package:edu_vista/pages/home/home_page.dart';
import 'package:edu_vista/pages/home/homepage_view.dart';
import 'package:edu_vista/pages/onboarding/onboarding_page.dart';
import 'package:edu_vista/pages/onboarding/splash_page.dart';
import 'package:edu_vista/pages/profile/edit_settings_page.dart';
import 'package:edu_vista/pages/profile/profile_page.dart';
import 'package:edu_vista/pages/search/search_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final String routeName = settings.name ?? '';
  final dynamic data = settings.arguments;
  switch (routeName) {
    case LoginPage.id:
      return MaterialPageRoute(builder: (context) => const LoginPage());
    case SignUpPage.id:
      return MaterialPageRoute(builder: (context) => const SignUpPage());
    case ResetPasswordPage.id:
      return MaterialPageRoute(builder: (context) => const ResetPasswordPage());
    case OnBoardingPage.id:
      return MaterialPageRoute(builder: (context) => const OnBoardingPage());
    case HomePage.id:
      return MaterialPageRoute(builder: (context) => const HomePage());
    case HomePageView.id:
      return MaterialPageRoute(builder: (context) => const HomePageView());
    case CategoriesPage.id:
      return MaterialPageRoute(builder: (context) => const CategoriesPage());
    case ChatPage.id:
      return MaterialPageRoute(builder: (context) => const ChatPage());
    case MessagesPage.id:
      return MaterialPageRoute(
          builder: (context) => MessagesPage(
                user: data,
              ));
    case ProfilePage.id:
      return MaterialPageRoute(builder: (context) => const ProfilePage());
    case SearchPage.id:
      return MaterialPageRoute(builder: (context) => const SearchPage());
    case CheckoutPage.id:
      return MaterialPageRoute(
          builder: (context) => CheckoutPage(
                totalPrice: data,
              ));
    case CartPage.id:
      return MaterialPageRoute(builder: (context) => const CartPage());
    case EditSettings.id:
      return MaterialPageRoute(builder: (context) => const EditSettings());
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
    case CoursesPage.id:
      if (data is Map<String, dynamic>) {
        return MaterialPageRoute(
          builder: (context) => CoursesPage(
            query: data['query'] as String,
            selectedQuery: data['selectedQuery'] as String,
            showAppbar: data['showAppbar'] as bool,
          ),
        );
      }
      return _errorRoute();
    default:
      return MaterialPageRoute(builder: (context) => const SplashPage());
  }
}

Route<dynamic> _errorRoute() {
  return MaterialPageRoute(
    builder: (context) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: const Center(child: Text('Page not found')),
    ),
  );
}
