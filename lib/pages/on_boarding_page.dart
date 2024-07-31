import 'package:edu_vista/pages/home_page.dart';
import 'package:edu_vista/utils/color.utility.dart';
import 'package:edu_vista/utils/image.utility.dart';
import 'package:edu_vista/widgets/onBoarding/on_boarding_item.dart';
import 'package:flutter/material.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = PageController(
      initialPage: 0,
      viewportFraction: 1,
    );
    const int current = 0;
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()));
                  },
                )
              ],
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                scrollDirection: Axis.horizontal,
                children: onboardingItems,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: onboardingItems.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => pageController.animateToPage(entry.key,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.linear),
                    child: Container(
                      width: 20.0,
                      height: 10.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          shape: BoxShape.rectangle,
                          color: (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? ColorUtility.secondry
                                  : ColorUtility.mediumBlack)
                              .withOpacity(current == entry.key ? 0.9 : 0.4)),
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    color: ColorUtility.secondry,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.arrow_back_ios_outlined),
                    onPressed: () => pageController.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.linear),
                  ),
                  MaterialButton(
                    color: ColorUtility.secondry,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.arrow_forward_ios_rounded),
                    onPressed: () => pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.linear),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
