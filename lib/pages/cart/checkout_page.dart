// ignore_for_file: avoid_print

import 'package:edu_vista/widgets/general/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:paymob_payment/paymob_payment.dart';

class CheckoutPage extends StatelessWidget {
  static const String id = 'checkout';

  final double totalPrice;

  const CheckoutPage({required this.totalPrice, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Thank you for shopping with us!',
                style: TextStyle(fontSize: 18),
              ),
              const Spacer(),
              Center(
                child: CustomElevatedButton(
                  onPressed: () async {
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
                      amountInCents: totalPrice.toStringAsFixed(0), // 200 EGP
                    );

                    if (response != null) {
                      print('Response: ${response.transactionID}');
                      print('Response: ${response.success}');
                    }
                  },
                  child: const Text('Complete Purchase'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
