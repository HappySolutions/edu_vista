// ignore_for_file: library_private_types_in_public_api

import 'package:edu_vista/pages/auth/login_page.dart';
import 'package:edu_vista/services/pref.service.dart';
import 'package:edu_vista/utils/color.utility.dart';
import 'package:edu_vista/utils/image_utility.dart';
import 'package:edu_vista/widgets/general/custom_elevated_button.dart';
import 'package:edu_vista/widgets/onboarding/elevated_button_rounded.dart';
import 'package:edu_vista/widgets/onboarding/onboard_indicator.dart';
import 'package:edu_vista/widgets/onboarding/onboard_item_widget.dart';
import 'package:flutter/material.dart';

class OnBoardingPage extends StatefulWidget {
  static const String id = 'OnBoardingPage';

  const OnBoardingPage({super.key});
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  PageController _pageController = PageController();
  int currentIndex = 0;

  final _kDuration = const Duration(milliseconds: 300);
  final _kCurve = Curves.ease;

  void onChangedFunction(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                currentIndex == 3
                    ? TextButton(
                        onPressed: () {
                          _skipFunction(2);
                        },
                        child: const Text(
                          'Back',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ))
                    : TextButton(
                        onPressed: () {
                          _skipFunction(3);
                        },
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        )),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Expanded(
              flex: 3,
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: onChangedFunction,
                children: const <Widget>[
                  OnBoardItemWidget(
                    title: 'Certification and Badges',
                    image: ImageUtility.badges,
                    description:
                        'Earn a certificate after completion of every course',
                  ),
                  OnBoardItemWidget(
                    title: 'Progress Tracking',
                    image: ImageUtility.progresTraking,
                    description: 'Check your Progress of every course',
                  ),
                  OnBoardItemWidget(
                    title: 'Of f line Acc ess',
                    image: ImageUtility.offLine,
                    description: 'Of f line Acc ess',
                  ),
                  OnBoardItemWidget(
                    title: 'Course Catalog',
                    image: ImageUtility.curseCategory,
                    description: 'View in which courses you are enrolled',
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        OnBoardIndicator(
                          positionIndex: 0,
                          currentIndex: currentIndex,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        OnBoardIndicator(
                          positionIndex: 1,
                          currentIndex: currentIndex,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        OnBoardIndicator(
                          positionIndex: 2,
                          currentIndex: currentIndex,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        OnBoardIndicator(
                          positionIndex: 3,
                          currentIndex: currentIndex,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    getButtons
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget get getButtons => currentIndex == 3
      ? CustomElevatedButton(onPressed: () => onLogin(), text: 'Login')
      : Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              currentIndex == 0 || currentIndex == 3
                  ? const Text('')
                  : ElevatedButtonRounded(
                      onPressed: () {
                        previousFunction();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 30,
                      ),
                      backgroundColor: WidgetStateProperty.all<Color>(
                        ColorUtility.grayLight,
                      ),
                    ),
              currentIndex == 3
                  ? const SizedBox.shrink()
                  : ElevatedButtonRounded(
                      onPressed: () {
                        nextFunction();
                      },
                      icon: const Icon(
                        Icons.arrow_forward,
                        size: 30,
                      ),
                      backgroundColor: WidgetStateProperty.all<Color>(
                        ColorUtility.deepYellow,
                      ),
                    ),
            ],
          ),
        );

  nextFunction() {
    _pageController.nextPage(duration: _kDuration, curve: _kCurve);
  }

  previousFunction() {
    _pageController.previousPage(duration: _kDuration, curve: _kCurve);
  }

  _skipFunction(int index) {
    _pageController.jumpToPage(index);
  }

  void onLogin() {
    PreferencesService.isOnBoardingSeen = true;
    Navigator.pushReplacementNamed(context, LoginPage.id);
  }
}
