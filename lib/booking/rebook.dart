import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swiftbook/booking/rebookBillingForm.dart';
import 'package:swiftbook/shared/loading.dart';
import 'package:swiftbook/styles/size-config.dart';
import 'package:swiftbook/styles/style.dart';
import 'package:swiftbook/globals.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swiftbook/booking/passengerForm.dart';
import 'package:swiftbook/string_extension.dart';

class Rebook extends StatefulWidget {
  const Rebook({Key key}) : super(key: key);

  @override
  _RebookState createState() => _RebookState();
}

class _RebookState extends State<Rebook> {

  int ticketCounter = 0;
  void generateTicketID() {
    print(selectedResCounter);
    ticketCounter = 0;
    ticketCounter = selectedRebookCounter;
    DateTime dateFormat = DateTime.parse(selectedRebookDepartureDate);
    String dateFormatter = DateFormat('MMddy').format(dateFormat).toString();
    DateTime timeFormat = DateTime.parse(selectedRebookDepartureTime);
    String timeFormatter = DateFormat('HHmm').format(timeFormat).toString();


    rebookTicketID = dateFormatter +
          timeFormatter +
          '-' +
          ticketCounter.toString() +
          selectedRebookCompanyName.toUpperCase() +
          selectedRebookBusCode +
          '-' +
          toRebookSeatNumber;
      ticketCounter++;

    print('Rebook Ticket ID ' + '$rebookTicketID');
  }

  @override
  Widget build(BuildContext context) {
    print('$toRebookPriceDouble');
    print('$toRebookPrice');
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2 * SizeConfig.widthMultiplier),
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          icon: SvgPicture.asset(
                            'assets/arrow.svg',
                            color: AppTheme.greenColor,
                            width: 5 * SizeConfig.widthMultiplier,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'TRIP REBOOKING',
                        textAlign: TextAlign.center,
                        style: AppTheme.pageTitleText,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 0 * SizeConfig.widthMultiplier),
                        child: IconButton(
                            icon: new Icon(
                              Icons.filter_list_rounded,
                              size: 0 * SizeConfig.imageSizeMultiplier,
                            ),
                            color: AppTheme.greenColor,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Rebook()))
                                  .then((value) {
                                setState(() {});
                              });
                            }),
                        //padding: EdgeInsets.all(0),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.5 * SizeConfig.heightMultiplier),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 5.5 * SizeConfig.widthMultiplier, vertical: 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 4,
                        offset: Offset(0, 1.5), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //from
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 10 * SizeConfig.widthMultiplier,
                            top: 2.5 * SizeConfig.widthMultiplier,
                            bottom: 2.5 * SizeConfig.widthMultiplier,
                          ),
                          child: RichText(
                            text: TextSpan(
                              text: "From: \n",
                              style: AppTheme.formLabelText,
                              children: <TextSpan>[
                                TextSpan(
                                  text: toRebookOrigin.toString().toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //arrow icon
                      Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: AppTheme.greenColor,
                          size: 9 * SizeConfig.imageSizeMultiplier,
                        ),
                      ),
                      //to
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: 10 * SizeConfig.widthMultiplier,
                            top: 2.5 * SizeConfig.widthMultiplier,
                            bottom: 2.5 * SizeConfig.widthMultiplier,
                          ),
                          child: RichText(
                            text: TextSpan(
                              text: "To: \n",
                              style: AppTheme.formLabelText,
                              children: <TextSpan>[
                                TextSpan(
                                  text: toRebookDestination.toString().toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.5 * SizeConfig.heightMultiplier),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 0 * SizeConfig.widthMultiplier, vertical: 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 4,
                        offset: Offset(0, 1.5), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 3.5 * SizeConfig.heightMultiplier,
                      ),
                      busListView(),
                      SizedBox(height: 3.5 * SizeConfig.heightMultiplier),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Widget busListView() =>
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('all_trips')
            .where("Origin Route", isEqualTo: toRebookOrigin.toUpperCase())
            .where("Destination Route", isEqualTo: toRebookDestination.toUpperCase())
            .where('Bus Type', isEqualTo: toRebookBusType)
            .where('Bus Class', isEqualTo: toRebookBusClass)
            .where('Company Name', isEqualTo: toRebookCompanyName.toLowerCase())
            .where('Departure Date', isGreaterThan: toRebookDepartureDate)
            .where('Price Details', isEqualTo: toRebookPrice)
            .where('Travel Status', isEqualTo: 'Upcoming')
            .where("Trip Status", isEqualTo: true)
            .orderBy('Departure Date', descending: false)
            .orderBy('Departure Time', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? new Center(child:Loading())
              : snapshot.data.docs.isEmpty
              ? Text(
            'No Trip Available',
            style: TextStyle(
                letterSpacing: 1.2,
                color: Colors.black,
                fontFamily: 'Poppins',
                fontSize: 1.8 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.w500),
          ) : Expanded(
            flex: 0,
            child: SizedBox(
              child: new ListView.separated(
                separatorBuilder: (context, index) =>
                    SizedBox(height: 2.5 * SizeConfig.heightMultiplier),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  print(selectedDepartureDateGenFormat);
                  DocumentSnapshot data = snapshot.data.docs[index];
                  DateTime selectedDateParsed = DateTime.parse(
                      data['Departure Date']);
                  DateTime selectedTimeParsed = DateTime.parse(
                      data['Departure Time']);
                  selectedRebookDepartureDate = data['Departure Date'];
                  selectedRebookDepartureTime = data['Departure Time'];
                  selectedRebookCounter = data['counter'];
                  selectedRebookCompanyName = data['Company Name'];
                  selectedRebookBusCode = data['Bus Code'];
                  selectedRebookPrice = data['Price Details'];
                  selectedRebookTripID = data['Trip ID'];
                  return Column(
                    children: <Widget>[
                      Container(
                        width: 90 * SizeConfig.widthMultiplier,
                        margin: EdgeInsets.symmetric(
                            horizontal: 3 * SizeConfig.widthMultiplier,
                            vertical: 0 * SizeConfig.heightMultiplier),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: AppTheme.logoGrey.withOpacity(0.4)),
                        ),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                      8 * SizeConfig.widthMultiplier,
                                      top: 1 *
                                          SizeConfig.heightMultiplier),
                                  child: Text(
                                    data['Company Name']
                                        .toString()
                                        .toUpperCase(),
                                    style: TextStyle(
                                      color: AppTheme.greenColor,
                                      fontFamily: 'Poppins',
                                      fontSize:
                                      2 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      right:
                                      8 * SizeConfig.widthMultiplier,
                                      top: 1 *
                                          SizeConfig.heightMultiplier),
                                  child: Text(
                                    data['Bus Class'].toString().toLowerCase().titleCase,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontFamily: 'Poppins',
                                        fontSize: 1.8 *
                                            SizeConfig.textMultiplier,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                6 * SizeConfig.widthMultiplier,
                              ),
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                  8 * SizeConfig.widthMultiplier,
                                  vertical:
                                  0 * SizeConfig.heightMultiplier),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      //date
                                      RichText(
                                        text: TextSpan(
                                          text: 'Date: ',
                                          style: TextStyle(
                                            color: AppTheme.textColor,
                                            fontFamily: 'Poppins',
                                            fontSize: 1.5 *
                                                SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                              DateFormat('MMMM d y').format(
                                                  selectedDateParsed) +
                                                  "\n",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Poppins',
                                                fontSize: 1.5 *
                                                    SizeConfig
                                                        .textMultiplier,
                                                fontWeight:
                                                FontWeight.w500,
                                                letterSpacing: 0.1,
                                              ),
                                            ),
                                            //time
                                            TextSpan(
                                              text: 'Time: ',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'Poppins',
                                                fontSize: 1.5 *
                                                    SizeConfig
                                                        .textMultiplier,
                                                fontWeight:
                                                FontWeight.w500,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                              DateFormat.jm().format(
                                                  selectedTimeParsed) +
                                                  //data['Departure Time'] +
                                                  "\n",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Poppins',
                                                fontSize: 1.5 *
                                                    SizeConfig
                                                        .textMultiplier,
                                                fontWeight:
                                                FontWeight.w500,
                                                letterSpacing: 0.7,
                                              ),
                                            ),
                                            //seats
                                            TextSpan(
                                              text: 'Seat/s: ',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'Poppins',
                                                fontSize: 1.5 *
                                                    SizeConfig
                                                        .textMultiplier,
                                                fontWeight:
                                                FontWeight.w500,
                                              ),
                                            ),
                                            TextSpan(
                                              text: data['Bus Availability Seat']
                                                  .toString() +
                                                  "\n",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Poppins',
                                                fontSize: 1.5 *
                                                    SizeConfig
                                                        .textMultiplier,
                                                fontWeight:
                                                FontWeight.w500,
                                                letterSpacing: 0.7,
                                              ),
                                            ),
                                            //bus type
                                            TextSpan(
                                              text: 'Bus Type: ',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'Poppins',
                                                fontSize: 1.5 *
                                                    SizeConfig.textMultiplier,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            TextSpan(
                                              text: data['Bus Type']
                                                  .toString() + '\n',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Poppins',
                                                fontSize: 1.5 *
                                                    SizeConfig
                                                        .textMultiplier,
                                                fontWeight:
                                                FontWeight.w500,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            //terminal
                                            TextSpan(
                                              text: 'Terminal: ',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'Poppins',
                                                fontSize: 1.5 *
                                                    SizeConfig.textMultiplier,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            TextSpan(
                                              text: data['Terminal']
                                                  .toString().titleCase,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Poppins',
                                                fontSize: 1.5 *
                                                    SizeConfig
                                                        .textMultiplier,
                                                fontWeight:
                                                FontWeight.w500,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              //child:
                                              Icon(
                                                Icons.near_me_sharp,
                                                color: AppTheme.greenColor
                                                    .withOpacity(0.3),
                                                size: 6 *
                                                    SizeConfig
                                                        .imageSizeMultiplier,
                                              ),

                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 2 *
                                                        SizeConfig
                                                            .widthMultiplier),
                                                child: Text(
                                                  data['Origin Route']
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    color:
                                                    Colors.grey[600],
                                                    fontFamily: 'Poppins',
                                                    fontSize: 1.8 *
                                                        SizeConfig
                                                            .textMultiplier,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 2 *
                                                SizeConfig
                                                    .heightMultiplier,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              //child:
                                              Icon(
                                                Icons.location_on_sharp,
                                                color:
                                                AppTheme.greenColor,
                                                size: 6 *
                                                    SizeConfig
                                                        .imageSizeMultiplier,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 2 *
                                                        SizeConfig
                                                            .widthMultiplier),
                                                child: Text(
                                                  data['Destination Route']
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    color:
                                                    Colors.grey[600],
                                                    fontFamily: 'Poppins',
                                                    fontSize: 1.8 *
                                                        SizeConfig
                                                            .textMultiplier,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                6 * SizeConfig.widthMultiplier,
                              ),
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                7 * SizeConfig.widthMultiplier,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  //price
                                  Text(
                                    "PHP " + data['Price Details'] + '.00',
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontFamily: 'Poppins',
                                      fontSize:
                                      2 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  //book now button
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0 *
                                            SizeConfig.widthMultiplier),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        print('Rebook Departure Date - ' + '$selectedRebookDepartureDate');
                                        print('Rebook Departure Time - ' + '$selectedRebookDepartureTime');
                                        generateTicketID();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => RebookBillingForm()))
                                            .then((value) {
                                          setState(() {});
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(
                                            0,
                                            4.5 *
                                                SizeConfig
                                                    .heightMultiplier),
                                        primary: data['Bus Availability Seat'] == 0
                                            ? Colors.grey
                                            : AppTheme.greenColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                7.0),
                                            side: BorderSide(
                                                color:
                                                Colors.transparent)),
                                      ),
                                      child: Text(
                                        data['Bus Availability Seat'] == 0
                                            ? 'FULLY BOOKED'
                                            : 'BOOK NOW',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Poppins',
                                          fontSize: 1.7 *
                                              SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 0.8 * SizeConfig.heightMultiplier,
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      );
}
