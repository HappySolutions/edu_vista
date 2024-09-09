import 'package:edu_vista/widgets/profile/profile_menu_widget.dart';
import 'package:edu_vista/widgets/profile/profile_pic_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:paymob_payment/paymob_payment.dart';

class ProfilePage extends StatelessWidget {
  static const String id = 'profile';

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const ProfilePic(),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "Edit",
              press: () => {},
            ),
            ProfileMenu(
              text: "Settings",
              press: () async {
                PaymobPayment.instance.initialize(
                  apiKey: dotenv.env[
                      'apiKey']!, // from dashboard Select Settings -> Account Info -> API Key
                  integrationID: int.parse(dotenv.env[
                      'integrationID']!), // from dashboard Select Developers -> Payment Integrations -> Online Card ID
                  iFrameID: int.parse(dotenv.env[
                      'iFrameID']!), // from paymob Select Developers -> iframes
                );

                final PaymobResponse? response =
                    await PaymobPayment.instance.pay(
                  context: context,
                  currency: "EGP",
                  amountInCents: "20000", // 200 EGP
                );

                if (response != null) {
                  print('Response: ${response.transactionID}');
                  print('Response: ${response.success}');
                }
              },
            ),
            ProfileMenu(
              text: "About Us",
              press: () {},
            ),
            ProfileMenu(
              text: "Log Out",
              press: () {},
            ),
          ],
        ),
      ),
    );
  }
}
