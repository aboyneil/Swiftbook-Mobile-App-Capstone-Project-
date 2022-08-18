import 'package:flutter/material.dart';
import 'package:swiftbook/booking/rebookTicket.dart';
import 'package:swiftbook/globals.dart';
import 'package:swiftbook/styles/size-config.dart';
import 'package:swiftbook/styles/style.dart';
import 'package:swiftbook/booking/ticket.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RebookTicketPage extends StatefulWidget {
  const RebookTicketPage({Key key}) : super(key: key);

  @override
  _RebookTicketPageState createState() => _RebookTicketPageState();
}

class _RebookTicketPageState extends State<RebookTicketPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        left: false,
        right: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 4 * SizeConfig.heightMultiplier),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'TICKET',
                      textAlign: TextAlign.center,
                      style: AppTheme.pageTitleText,
                    ),
                  ),
                ],
              ),
              RebookTicket(),
              SizedBox(height: 3 * SizeConfig.heightMultiplier),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15 * SizeConfig.widthMultiplier),
                      child: ElevatedButton(
                        onPressed: () {
                          seatCounter = 1;
                          totalPrice = 0;
                          selectedOrigin = null;
                          selectedDestination = null;
                          selectedPassengerCategory = null;
                          selectedPercentageDiscount = 0;
                          selectedSeats.clear();
                          rebookFlag = 0;

                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/pageOptions', (Route<dynamic> route) => false);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(0, 45),
                          primary: AppTheme.greenColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: Colors.transparent)),
                        ),
                        child: Text(
                          'Book Again',
                          style: AppTheme.buttonText,
                        ),
                      ),
                    ),
                  ]),
              SizedBox(height: 6 * SizeConfig.heightMultiplier),
            ],
          ),
        ),
      ),
    );
  }
}
