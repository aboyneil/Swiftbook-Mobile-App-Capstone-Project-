import 'package:swiftbook/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:paymongo_sdk/paymongo_sdk.dart';
import 'package:swiftbook/styles/size-config.dart';
import 'package:swiftbook/globals.dart';

import 'checkout.dart';

const publicKey = String.fromEnvironment(
  'PUBLIC_KEY',
  defaultValue: 'pk_test_UyeMgiRhUWcn8kf7c9Q6YzGz',
);
const secretKey = String.fromEnvironment(
  'SECRET_KEY',
  defaultValue: 'sk_test_wXhckiGsx834NMYHmfzqAK35',
);
mixin PaymongoEventHandler<T extends StatefulWidget> on State<T> {
  final publicClient = const PaymongoClient<PaymongoPublic>(publicKey);
  final secretClient = const PaymongoClient<PaymongoSecret>(secretKey);

  Future<void> cardPayment(PayMongoBilling billing) async {
    try {
      final _amount = totalPrice;
      final payment = await publicClient.instance.paymentMethod
          .create(PaymentMethodAttributes(
        billing: billing,
        details: PaymentMethodDetails(
          cardNumber: '4120000000000007',
          expMonth: 2,
          expYear: 27,
          cvc: "123",
        ),
      ));
      final intent = PaymentIntentAttributes(
          amount: _amount.toDouble(),
          description: "Test payment",
          statementDescriptor: "Test payment descriptor",
          metadata: {
            "environment": kReleaseMode ? "LIVE" : "DEV",
          });
      final result =
          await secretClient.instance.paymentIntent.onPaymentListener(
              attributes: intent,
              paymentMethod: payment.id,
              onRedirect: (url) async {
                debugPrint("${url}");
                final res = await Navigator.push<bool>(context,
                    CupertinoPageRoute(builder: (context) {
                  return CheckoutPage(
                    url: url,
                    iFrameMode: true,
                  );
                }));
                return res ?? false;
              });
      debugPrint("${result?.status}");
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> gcashPayment(PayMongoBilling billing) async {
    final _amount = totalPrice;
    final url = 'google.com';
    final _source = SourceAttributes(
      type: "gcash",
      amount: _amount.toDouble(),
      currency: 'PHP',
      redirect: Redirect(
        success: "https://m.gcash.com/gcash-login-web/index.html#/success",
        failed: "https://$url/failed",
      ),
      billing: billing,
    );
    final result = await publicClient.instance.source.create(_source);
    final paymentUrl = result.attributes.redirect.checkoutUrl ?? '';
    final successLink = result.attributes.redirect.success ?? '';
    if (paymentUrl.isNotEmpty) {
      final response = await Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => CheckoutPage(
            url: paymentUrl,
            returnUrl: successLink,
          ),
        ),
      );
      if (response) {
        final paymentSource = PaymentSource(id: result.id, type: "source");
        final paymentAttr = CreatePaymentAttributes(
          amount: _amount.toDouble(),
          currency: 'PHP',
          description: "test gcash",
          source: paymentSource,
        );
        final createPayment =
            await secretClient.instance.payment.create(paymentAttr);
        debugPrint("==============================");
        debugPrint("||${createPayment}||");
        debugPrint("==============================");
      } else {
        showDialog(
          context: context,
          builder: (context) {
            print(paymentString);
            return AlertDialog(
              content: Text(
                '\n' + paymentString,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 2.0 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                ),
              ),
              elevation: 30.0,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              actions: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 4 * SizeConfig.widthMultiplier),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(70.0 * SizeConfig.widthMultiplier,
                                5.0 * SizeConfig.heightMultiplier),
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Colors.white),
                            ),
                          ),
                          child: Text(
                            "OK",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontSize: 1.8 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.1,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }
    }
  }
}
