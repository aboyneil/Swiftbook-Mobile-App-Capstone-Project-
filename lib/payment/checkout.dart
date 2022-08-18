import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swiftbook/booking/rebookTicket.dart';
import 'package:swiftbook/booking/rebookTicketPage.dart';
import 'package:swiftbook/booking/ticketPage.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:swiftbook/services/database.dart';
import 'package:swiftbook/globals.dart';

final DatabaseService db = DatabaseService();

// ignore: public_member_api_docs
class CheckoutPage extends StatefulWidget {
  // ignore: public_member_api_docs

  const CheckoutPage({
    this.url,
    this.returnUrl,
    this.iFrameMode = false,
  });
  // ignore: public_member_api_docs
  final String url;
  final String returnUrl;
  final bool iFrameMode;
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> with UrlIFrameParser {
  final Completer<WebViewController> _controller = Completer();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        paymentString = 'Payment Expired';
        Navigator.pop(context, false);
        return false;
      },
      child: Scaffold(
          body: SafeArea(
        child: WebView(
          onWebViewCreated: _controller.complete,
          initialUrl:
              widget.iFrameMode ? toCheckoutURL(widget.url) : widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          debuggingEnabled: kDebugMode,
          navigationDelegate: (request) async {
            if (request.url.contains('success')) {
              //add databases();
              if (rebookFlag == 1) {
                await db.addRebookingCompanyBillingFormDetails();
                var now = new DateTime.now();
                var formatter = new DateFormat('MMMM d y');
                String formattedDate = formatter.format(now);

                String tempUID;
                var result = await FirebaseFirestore.instance
                    .collection(
                        selectedRebookCompanyName.toString() + '_billingForms')
                    .where('Name',
                        isEqualTo:
                            rebookBillingFormName.toString().toUpperCase())
                    .where('Email', isEqualTo: rebookBillingFormEmail)
                    .where('Phone Number',
                        isEqualTo: rebookBillingFormMobileNum)
                    .where('Address',
                        isEqualTo:
                            rebookBillingFormAddress.toString().toLowerCase())
                    .where('Total Price', isEqualTo: totalPrice)
                    .where('Mode of Payment', isEqualTo: paymentMode)
                    .where('Date of Payment', isEqualTo: formattedDate)
                    .where('Ticket ID', isEqualTo: rebookTicketID)
                    .where('Subtotal', isEqualTo: selectedRebookPrice)
                    .where('Discount', isEqualTo: '0')
                    .where('Qty', isEqualTo: 1)
                    .where('Extra Baggage',
                        isEqualTo: toRebookTotalExtraBaggage)
                    .where('Rebooking Fee', isEqualTo: companyRebookingFee)
                    .get();

                result.docs.forEach((val) {
                  tempUID = val.id;
                });

                await db.addRebookingAllBillingFormDetails(tempUID);
                db.updateRebookAllBookingForms();
                db.updateRebookCompanyBookingForms();
                db.updateAllRebookTicketCounter();
                db.updateCompanyRebookTicketCounter();

                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return RebookTicketPage();
                }));
              } else {
                for (int i = 0; i < seatCounter; i++) {
                  //Add to company booking form details
                  db.addCompanyBookingFormDetails(
                      passengerType[i],
                      passengerFirstName[i],
                      passengerLastName[i],
                      passengerEmailAddress[i],
                      passengerMobileNum[i],
                      passengerDiscountID[i],
                      eachExtraBaggageList[i].toString(),
                      eachExtraBaggagePriceList[i].toString(),
                      eachTotalBaggageNum[i].toString(),
                      eachDiscount[i],
                      listDiscount[i],
                      eachSubTotal[i].toString(),
                      eachTotal[i].toString(),
                      ticketIDList[i],
                      selectedSeats[i]);

                  var resultBookingForms = await FirebaseFirestore.instance
                      .collection(selectedResBusCompanyName.toLowerCase() +
                          "_bookingForms")
                      .where('Ticket ID', isEqualTo: ticketIDList[i])
                      .get();

                  resultBookingForms.docs.forEach((res) {
                    companyBookingFormsDocUid = res.id;
                  });

                  print('Company Booking Forms Doc ID: ' +
                      companyBookingFormsDocUid);
                  //Add to all booking form details
                  db.addAllBookingFormDetails(
                      passengerType[i],
                      passengerFirstName[i],
                      passengerLastName[i],
                      passengerEmailAddress[i],
                      passengerMobileNum[i],
                      passengerDiscountID[i],
                      eachExtraBaggageList[i].toString(),
                      eachExtraBaggagePriceList[i].toString(),
                      eachTotalBaggageNum[i].toString(),
                      eachDiscount[i],
                      listDiscount[i],
                      eachSubTotal[i].toString(),
                      eachTotal[i].toString(),
                      ticketIDList[i],
                      selectedSeats[i]);

                  //Add billing form details
                  db.addCompanyBillingFormDetails(ticketIDList[i]);

                  var resultBillingForms = await FirebaseFirestore.instance
                      .collection(selectedResBusCompanyName.toLowerCase() +
                          "_billingForms")
                      .where('Ticket ID', isEqualTo: ticketIDList[i])
                      .get();

                  resultBillingForms.docs.forEach((res) {
                    companyBillingFormsDocUid = res.id;
                  });

                  print('Company Billing Forms Doc ID: ' +
                      companyBookingFormsDocUid);

                  db.addAllBillingFormDetails(ticketIDList[i]);
                }
                db.updateBusAvailabilitySeatAllTrips();
                db.updateBusAvailabilitySeatCompanyTrips();
                db.updateAllTicketCounter();
                db.updateCompanyTicketCounter();
                db.updateAllSeatStatus();
                db.updateCompanySeatStatus();
                //
                // db.addCompanyBookingFormDetails();
                // db.addCompanyBillingFormDetails();

                Navigator.pop(context, true);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return TicketPage();
                }));
              }
            }
            if (request.url.contains('failed')) {
              paymentString = 'Payment Failed';
              Navigator.pop(context, false);

              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          javascriptChannels: {
            JavascriptChannel(
                name: 'Paymongo',
                onMessageReceived: (JavascriptMessage message) {
                  if (message.message == '3DS-authentication-complete') {
                    Navigator.pop(context, true);
                  }
                }),
          },
          onWebResourceError: (error) async {
            final dialog = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Something went wrong'),
                  content: Text('$error'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text('close'),
                    )
                  ],
                );
              },
            );
            if (dialog) {
              Navigator.pop(context, false);
            }
          },
        ),
      )),
    );
  }
}

mixin UrlIFrameParser<T extends StatefulWidget> on State<T> {
  String toCheckoutURL(String url) {
    return Uri.dataFromString('''
    <html>

<head>
    <style>
        body {
            overflow: hidden
        }

        .embed-paymongo {
            position: relative;
            padding-bottom: 56.25%;
            padding-top: 0px;
            height: 0px;
            overflow: hidden;
        }

        .embed-paymongo iframe,
        .embed-paymongo object,
        .embed-paymongo embed {
            border: 0;
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }
    </style>
</head>

<body>

    <iframe style="width:100%;height:100%;top:0;left:0;position:absolute;" frameborder="0" allowfullscreen="1"
        allow="accelerometer;  encrypted-media;" webkitallowfullscreen mozallowfullscreen allowfullscreen
        src="${url}"></iframe>
</body>
<script>
    window.addEventListener('message', ev => {
        Paymongo.postMessage(ev.data);
        return;
    })
</script>

</html>
    
    
    ''', mimeType: 'text/html').toString();
  }
}
