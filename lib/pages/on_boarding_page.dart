import 'package:edu_vista/pages/home_page.dart';
import 'package:edu_vista/utils/color.utility.dart';
import 'package:edu_vista/utils/image.utility.dart';
import 'package:edu_vista/widgets/onBoarding/on_boarding_item.dart';
import 'package:flutter/material.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  late PageController pageController;
  int current = 0;
  var onboardingItems = const [
    OnBoardingItemWidget(
        image: ImageUtility.badges,
        title: 'Certification and Badges',
        subTitle: 'Earn a certificate after completion of every course'),
    OnBoardingItemWidget(
        image: ImageUtility.progressTracking,
        title: 'Progress Tracking',
        subTitle: 'Check your Progress of every course'),
    OnBoardingItemWidget(
        image: ImageUtility.offline,
        title: 'Offline Access',
        subTitle: 'Make your course available offline'),
    OnBoardingItemWidget(
        image: ImageUtility.courseCategory,
        title: 'Course Catalog',
        subTitle: 'View in which courses you are enrolled'),
  ];

  final Duration _duration = const Duration(milliseconds: 500);

  final Curve _curve = Curves.ease;

  void onPageChanged(int index) {
    setState(() {
      current = index;
    });
  }

  @override
  void initState() {
    pageController = PageController(
      initialPage: 0,
      viewportFraction: 1,
    );
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    child: const Text(
                      'skip',
                      style: TextStyle(color: ColorUtility.mediumBlack),
                    ),
                    onPressed: () {
                      pageController.animateToPage(4,
                          duration: _duration, curve: _curve);
                    })
              ],
            ),
            Expanded(
              flex: 3,
              child: PageView(
                onPageChanged: onPageChanged,
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                scrollDirection: Axis.horizontal,
                children: onboardingItems,
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: drawIndicators(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        current == 0
                            ? const SizedBox.shrink()
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorUtility.secondry,
                                  foregroundColor: Colors.white,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(15),
                                ),
                                child:
                                    const Icon(Icons.arrow_back_ios_outlined),
                                onPressed: () => pageController.previousPage(
                                    duration: _duration, curve: _curve),
                              ),
                        current == 3
                            ? const SizedBox.shrink()
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorUtility.secondry,
                                  foregroundColor: Colors.white,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(15),
                                ),
                                child:
                                    const Icon(Icons.arrow_forward_ios_rounded),
                                onPressed: () => pageController.nextPage(
                                    duration: _duration, curve: _curve),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Container> drawIndicators() {
    return onboardingItems.asMap().entries.map((entry) {
      return Container(
        width: entry.key == current ? 30 : 20,
        height: 10.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            shape: BoxShape.rectangle,
            color: (entry.key == current
                    ? ColorUtility.secondry
                    : ColorUtility.mediumBlack)
                .withOpacity(current == entry.key ? 0.9 : 0.4)),
      );
    }).toList();
  }
}
