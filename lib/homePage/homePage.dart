// ignore_for_file: close_sinks
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swiftbook/booking/generateRowsCol.dart';
import 'package:swiftbook/booking/passengerForm.dart';
import 'package:swiftbook/styles/size-config.dart';
import 'package:swiftbook/styles/style.dart';
import 'package:swiftbook/string_extension.dart';

import '../globals.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //increment number of seats
  void incrementSeat() {
    //setState(() {
    seatCounter++;
    //});
  }

  //decrement number of seats
  void decrementSeat() {
    if (seatCounter > 1) {
      //setState(() {
      seatCounter--;
      //});
    }
  }

  String idBaggage;

  Future<void> getBusDocID() async {
    var result = await FirebaseFirestore.instance
        .collection('$selectedResBusCompanyName' + '_bus')
        .where('Bus Plate Number', isEqualTo: selectedResBusPlateNumber)
        .get();
    result.docs.forEach((val) {
      busDocID = val.id;
    });
  }

  Future<void> companyHasBaggage() async {
    var result = await FirebaseFirestore.instance
        .collection('$selectedResBusCompanyName' + '_Policies')
        .where('category', isEqualTo: "baggage")
        .get();
    result.docs.forEach((val) {
      idBaggage = val.id;
      companyBaggage = val.data()['status'];
    });
    print('Company Policies ID - ' +  idBaggage.toString());
    print('Company Baggage - ' + '$companyBaggage');
  }


  Future<void> getMinBaggage() async {
    var result = await FirebaseFirestore.instance
        .collection('$selectedResBusCompanyName' + '_bus')
        .where('Bus Plate Number', isEqualTo: selectedResBusPlateNumber)
        .get();
    result.docs.forEach((val) {
      baggageLimitID = val.id;
      maxBaggage = int.parse(val.data()['Maximum Baggage']);
      minBaggage = int.parse(val.data()['Minimum Baggage']);
      pesoPerBaggage = int.parse(val.data()['Peso Per Baggage']);
    });
    print('Baggage Limit ID - ' + '$baggageLimitID');
    print('Max Baggage - ' + '$maxBaggage');
    print('Min Baggage - ' + '$minBaggage');
    print('Peso Per Baggage - ' + '$pesoPerBaggage');
    baggageNumberList.clear();
    for (int i = 0; i < seatCounter; i++){
      baggageNumberList.insert(i, minBaggage);
    }
    print('List of Baggage - ' + baggageNumberList.toString());
    navPush();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
    final String dateNowFormatted = dateFormatter.format(now);
    print(dateNowFormatted);

    final DateFormat timeFormatter = DateFormat('HH:mm:ss');
    final String timeNowFormatted = timeFormatter.format(now);
    print(timeNowFormatted);

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
              Text(
                'BUS TRIPS',
                textAlign: TextAlign.center,
                style: AppTheme.pageTitleText,
              ),
              SizedBox(height: 2.5 * SizeConfig.heightMultiplier),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('all_trips')
                    .where('Trip Status', isEqualTo: true)
                    .where('Travel Status', isEqualTo: 'Upcoming')
                    .where("Departure Date",
                        isGreaterThanOrEqualTo: dateNowFormatted + ' 00:00:00')
                    .orderBy('Departure Date', descending: false)
                    .orderBy('Departure Time', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  return (snapshot.connectionState == ConnectionState.waiting ||
                          snapshot.data == null)
                      ? new Center(child: CircularProgressIndicator())
                      : Expanded(
                          flex: 0,
                          child: SizedBox(
                            child: new ListView.separated(
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 2.5 * SizeConfig.heightMultiplier),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot data =
                                    snapshot.data.docs[index];
                                DateTime selectedDateParsed =
                                    DateTime.parse(data['Departure Date']);
                                DateTime selectedTimeParsed =
                                    DateTime.parse(data['Departure Time']);
                                return Column(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              1 * SizeConfig.heightMultiplier),
                                      width: 90 * SizeConfig.widthMultiplier,
                                      margin: EdgeInsets.symmetric(
                                          horizontal:
                                              3 * SizeConfig.widthMultiplier,
                                          vertical:
                                              0 * SizeConfig.heightMultiplier),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 3,
                                            blurRadius: 6,
                                            offset: Offset(0,
                                                1.5), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 8 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                    top: 1 *
                                                        SizeConfig
                                                            .heightMultiplier),
                                                child: Text(
                                                  data['Company Name']
                                                      .toString()
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    color: AppTheme.greenColor,
                                                    fontFamily: 'Poppins',
                                                    fontSize: 2 *
                                                        SizeConfig
                                                            .textMultiplier,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: 8 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                    top: 1 *
                                                        SizeConfig
                                                            .heightMultiplier),
                                                child: Text(
                                                  data['Bus Class']
                                                      .toString()
                                                      .toLowerCase()
                                                      .titleCase,
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontFamily: 'Poppins',
                                                      fontSize: 1.8 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 6 *
                                                  SizeConfig.widthMultiplier,
                                            ),
                                            child: Divider(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8 *
                                                    SizeConfig.widthMultiplier,
                                                vertical: 0 *
                                                    SizeConfig
                                                        .heightMultiplier),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Column(
                                                  children: <Widget>[
                                                    //date
                                                    RichText(
                                                      text: TextSpan(
                                                        text: 'Date: ',
                                                        style: TextStyle(
                                                          color: AppTheme
                                                              .textColor,
                                                          fontFamily: 'Poppins',
                                                          fontSize: 1.5 *
                                                              SizeConfig
                                                                  .textMultiplier,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: DateFormat(
                                                                        'MMMM d y')
                                                                    .format(
                                                                        selectedDateParsed) +
                                                                "\n",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 1.5 *
                                                                  SizeConfig
                                                                      .textMultiplier,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              letterSpacing:
                                                                  0.1,
                                                            ),
                                                          ),
                                                          //time
                                                          TextSpan(
                                                            text: 'Time: ',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 1.5 *
                                                                  SizeConfig
                                                                      .textMultiplier,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: DateFormat
                                                                        .jm()
                                                                    .format(
                                                                        selectedTimeParsed) +
                                                                "\n",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 1.5 *
                                                                  SizeConfig
                                                                      .textMultiplier,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              letterSpacing:
                                                                  0.7,
                                                            ),
                                                          ),
                                                          //seats
                                                          TextSpan(
                                                            text: 'Seat/s: ',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 1.5 *
                                                                  SizeConfig
                                                                      .textMultiplier,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: data['Bus Availability Seat']
                                                                    .toString() +
                                                                "\n",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 1.5 *
                                                                  SizeConfig
                                                                      .textMultiplier,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              letterSpacing:
                                                                  0.7,
                                                            ),
                                                          ),
                                                          //bus type
                                                          TextSpan(
                                                            text: 'Bus Type: ',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 1.5 *
                                                                  SizeConfig
                                                                      .textMultiplier,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: data['Bus Type']
                                                                    .toString() +
                                                                '\n',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 1.5 *
                                                                  SizeConfig
                                                                      .textMultiplier,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              letterSpacing:
                                                                  0.5,
                                                            ),
                                                          ),
                                                          //terminal
                                                          TextSpan(
                                                            text: 'Terminal: ',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 1.5 *
                                                                  SizeConfig
                                                                      .textMultiplier,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                data['Terminal']
                                                                    .toString()
                                                                    .titleCase,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 1.5 *
                                                                  SizeConfig
                                                                      .textMultiplier,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              letterSpacing:
                                                                  0.5,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            //child:
                                                            Icon(
                                                              Icons
                                                                  .near_me_sharp,
                                                              color: AppTheme
                                                                  .greenColor
                                                                  .withOpacity(
                                                                      0.3),
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
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      600],
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize: 1.8 *
                                                                      SizeConfig
                                                                          .textMultiplier,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
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
                                                              Icons
                                                                  .location_on_sharp,
                                                              color: AppTheme
                                                                  .greenColor,
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
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      600],
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize: 1.8 *
                                                                      SizeConfig
                                                                          .textMultiplier,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
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
                                              horizontal: 6 *
                                                  SizeConfig.widthMultiplier,
                                            ),
                                            child: Divider(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 7 *
                                                  SizeConfig.widthMultiplier,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                //price
                                                Text(
                                                  "PHP " +
                                                      data['Price Details'] +
                                                      '.00',
                                                  style: TextStyle(
                                                    color: Colors.grey[800],
                                                    fontFamily: 'Poppins',
                                                    fontSize: 2 *
                                                        SizeConfig
                                                            .textMultiplier,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                //book now button
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 0 *
                                                          SizeConfig
                                                              .widthMultiplier),
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      //showSeats();
                                                      //showNumOfSeatsDialog();
                                                      selectedPassengerCategory =
                                                          null;
                                                      if (data[
                                                              'Bus Availability Seat'] !=
                                                          0) {
                                                        DateTime dateFormat =
                                                            DateTime.parse(snapshot
                                                                .data
                                                                .docs[index]
                                                                .get(
                                                                    'Departure Date'));
                                                        String dFormatter =
                                                            DateFormat(
                                                                    'MMMM d y')
                                                                .format(
                                                                    dateFormat)
                                                                .toString();
                                                        print(dateFormat
                                                            .toString());
                                                        print(dFormatter);

                                                        DateTime timeFormat =
                                                            DateTime.parse(snapshot
                                                                .data
                                                                .docs[index]
                                                                .get(
                                                                    'Departure Time'));
                                                        String tFormatter =
                                                            DateFormat.jm()
                                                                .format(
                                                                    timeFormat)
                                                                .toString();
                                                        print(timeFormat
                                                            .toString());
                                                        print(tFormatter);

                                                        selectedResTripID =
                                                            snapshot.data
                                                                .docs[index]
                                                                .get('Trip ID');
                                                        selectedResOriginRoute =
                                                            snapshot.data
                                                                .docs[index]
                                                                .get(
                                                                    'Origin Route');
                                                        selectedResDestinationRoute =
                                                            snapshot.data
                                                                .docs[index]
                                                                .get(
                                                                    'Destination Route');
                                                        selectedResDepartureDate =
                                                            dFormatter;

                                                        DateFormat
                                                            dateFormatterDepartureDate =
                                                            DateFormat(
                                                                'yyyy-MM-dd');
                                                        DateTime
                                                            dtDepartureDate =
                                                            DateTime.parse(snapshot
                                                                .data
                                                                .docs[index]
                                                                .get(
                                                                    'Departure Date'));
                                                        selectedResDepartureDateGenFormat =
                                                            dateFormatterDepartureDate
                                                                    .format(
                                                                        dtDepartureDate)
                                                                    .toString() +
                                                                ' 00:00:00';

                                                        DateFormat
                                                            dateFormatterDepartureTime =
                                                            DateFormat(
                                                                'HH:mm:ss');
                                                        DateTime
                                                            dtDepartureTime =
                                                            DateTime.parse(snapshot
                                                                .data
                                                                .docs[index]
                                                                .get(
                                                                    'Departure Time'));
                                                        selectedResDepartureTimeGenFormat =
                                                            '0000-00-00 ' +
                                                                dateFormatterDepartureTime
                                                                    .format(
                                                                        dtDepartureTime)
                                                                    .toString();
                                                        selectedResDepartureTime =
                                                            tFormatter;
                                                        selectedResBusType =
                                                            snapshot.data
                                                                .docs[index]
                                                                .get(
                                                                    'Bus Type');
                                                        selectedResBusClass =
                                                            snapshot.data
                                                                .docs[index]
                                                                .get(
                                                                    'Bus Class');
                                                        selectedResBusCompanyName =
                                                            snapshot.data
                                                                .docs[index]
                                                                .get(
                                                                    'Company Name')
                                                                .toString()
                                                                .toLowerCase();
                                                        selectedResTerminalName =
                                                            snapshot.data
                                                                .docs[index]
                                                                .get(
                                                                    'Terminal');
                                                        selectedResPriceDetails =
                                                            snapshot.data
                                                                .docs[index]
                                                                .get(
                                                                    'Price Details');
                                                        selectedResBusCode =
                                                            snapshot.data
                                                                .docs[index]
                                                                .get('Bus Code')
                                                                .toString();
                                                        selectedResBusPlateNumber =
                                                            snapshot.data
                                                                .docs[index]
                                                                .get(
                                                                    'Bus Plate Number')
                                                                .toString();
                                                        selectedResBusSeatCapacity =
                                                            snapshot.data
                                                                .docs[index]
                                                                .get(
                                                                    'Bus Seat Capacity')
                                                                .toString();
                                                        selectedResBusAvailabilitySeat =
                                                            snapshot.data
                                                                .docs[index]
                                                                .get(
                                                                    'Bus Availability Seat');

                                                        selectedResTripStatus =
                                                            snapshot.data
                                                                .docs[index]
                                                                .get(
                                                                    'Trip Status');
                                                        selectedResBusTripID =
                                                            snapshot.data
                                                                .docs[index].id;
                                                        selectedResSeats =
                                                            selectedNumSeats
                                                                .toString();
                                                        selectedResDriverID =
                                                            snapshot.data
                                                                .docs[index]
                                                                .get(
                                                                    'Driver ID');
                                                        selectedResCounter =
                                                            snapshot.data
                                                                .docs[index]
                                                                .get('counter');

                                                        print('Bus Trip ID: ' +
                                                            selectedResBusTripID);

                                                        print('Bus Capacity: ' +
                                                            selectedResBusSeatCapacity);
                                                        print('Bus Availability Seat: ' +
                                                            selectedResBusAvailabilitySeat
                                                                .toString());
                                                        print('Selected Number of Seats: ' +
                                                            selectedResSeats);

                                                        //generate ticket id
                                                        String dateFormatter =
                                                            DateFormat('MMddy')
                                                                .format(
                                                                    dateFormat)
                                                                .toString();
                                                        print(
                                                            selectedResDepartureDate +
                                                                ' -> ' +
                                                                dateFormatter);

                                                        String timeFormatter =
                                                            DateFormat('HHmm')
                                                                .format(
                                                                    timeFormat)
                                                                .toString();
                                                        print(
                                                            selectedResDepartureTime +
                                                                ' -> ' +
                                                                timeFormatter);

                                                        String storeUid =
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser
                                                                .uid
                                                                .toString();
                                                        print('User ID: ' +
                                                            storeUid);
                                                        print('Departure Date - ' +
                                                            selectedResDepartureDateGenFormat);
                                                        print('Departure Time - ' +
                                                            selectedResDepartureTimeGenFormat);

                                                        print(
                                                            selectedResBusCompanyName);
                                                        print(
                                                            selectedResBusPlateNumber);
                                                        await getBusDocID();
                                                        await companyHasBaggage();
                                                        print('Bus Doc ID: ' +
                                                            busDocID);
                                                        showNumOfSeatsDialog();
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      minimumSize: Size(
                                                          0,
                                                          4.5 *
                                                              SizeConfig
                                                                  .heightMultiplier),
                                                      primary:
                                                          data['Bus Availability Seat'] ==
                                                                  0
                                                              ? Colors.grey
                                                              : AppTheme
                                                                  .greenColor,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      7.0),
                                                          side: BorderSide(
                                                              color: Colors
                                                                  .transparent)),
                                                    ),
                                                    child: Text(
                                                      data['Bus Availability Seat'] ==
                                                              0
                                                          ? 'FULLY BOOKED'
                                                          : 'BOOK NOW',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'Poppins',
                                                        fontSize: 1.7 *
                                                            SizeConfig
                                                                .textMultiplier,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 0.8 *
                                                SizeConfig.heightMultiplier,
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
              ),
              SizedBox(
                height: 4 * SizeConfig.heightMultiplier,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showNumOfSeatsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        StreamController<String> controlling =
            StreamController<String>.broadcast();
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "\nPlease select a number of seats",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 1.8 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                ),
              ),
              SizedBox(
                height: 4 * SizeConfig.heightMultiplier,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  //add number of seat
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //minus number of seat
                      Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2 * SizeConfig.widthMultiplier,
                          ),
                          child: Center(
                              child: IconButton(
                            icon: Icon(Icons.remove_rounded),
                            iconSize: 8 * SizeConfig.imageSizeMultiplier,
                            color: AppTheme.greenColor,
                            onPressed: () {
                              if (seatCounter > 1) {
                                seatCounter--;
                                controlling.add("$seatCounter");
                                // setState(() {
                                //   seatCounter--;
                                // });
                              }
                              //decrementSeat();
                              //selectedNumSeats = seatCounter;
                            },
                          ))),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 0 * SizeConfig.widthMultiplier,
                        ),
                        child: Container(
                          width: 17 * SizeConfig.widthMultiplier,
                          height: 11.5 * SizeConfig.widthMultiplier,
                          margin: EdgeInsets.all(0),
                          padding: EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppTheme.lightGreen.withOpacity(1.0),
                          ),
                          child: Center(
                            child: StreamBuilder(
                                stream: controlling.stream,
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> snapshot) {
                                  return Text(
                                    snapshot.hasData
                                        ? snapshot.data
                                        : '$seatCounter',
                                    style: TextStyle(
                                      color: AppTheme.greenColor,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 3 * SizeConfig.textMultiplier,
                                      letterSpacing: 2,
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ),
                      //add number of seat
                      Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2 * SizeConfig.widthMultiplier,
                          ),
                          child: Center(
                              child: IconButton(
                            icon: Icon(Icons.add_rounded),
                            iconSize: 7 * SizeConfig.imageSizeMultiplier,
                            color: AppTheme.greenColor,
                            onPressed: () {
                              seatCounter++;
                              controlling.add("$seatCounter");
                              // setState(() {
                              //   seatCounter++;
                              // });
                              //incrementSeat();
                              //selectedNumSeats = seatCounter;
                            },
                          ))),
                    ],
                  ),
                ],
              ),
            ],
          ),
          elevation: 30.0,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          actions: [
            Column(
              mainAxisSize: MainAxisSize.min,
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
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await getMinBaggage();
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

  void navPush() {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => PassengerForm()))
        .then((value) {
      setState(() {});
    });
  }
}
