import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swiftbook/booking/returnTripBook.dart';
import 'package:swiftbook/shared/loading.dart';
import 'package:swiftbook/styles/size-config.dart';
import 'package:swiftbook/styles/style.dart';
import 'package:swiftbook/globals.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swiftbook/booking/passengerForm.dart';
import 'package:swiftbook/string_extension.dart';

import 'generateRowsCol.dart';


class BusRes extends StatefulWidget {
  final String uid;
  BusRes({this.uid});

  @override
  _BusResState createState() => _BusResState();
}

class _BusResState extends State<BusRes> {
  final GlobalKey<FormState> _formKeyDateTime = GlobalKey<FormState>();

  //date
  DateTime date;
  DateTime dateTimeNow = DateTime.now();

  String idBaggage;
  String idRoundTrip;

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



  Future<void> companyHasRoundTrip() async {
    var result = await FirebaseFirestore.instance
        .collection('$selectedResBusCompanyName' + '_Policies')
        .where('category', isEqualTo: "round-trip")
        .get();
    result.docs.forEach((val) {
      idRoundTrip = val.id;
      companyRoundTrip = val.data()['status'];
    });
    print('Company Policies ID - ' +  idRoundTrip.toString());
    print('Company Round Trip - ' + '$companyRoundTrip');
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
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PassengerForm()))
        .then((value) {
      setState(() {});
    });
  }

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
                      'CHOOSE YOUR TRIP',
                      textAlign: TextAlign.center,
                      style: AppTheme.pageTitleText,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2 * SizeConfig.widthMultiplier),
                      child: IconButton(
                          icon: new Icon(
                            Icons.filter_list_rounded,
                            size: 0 * SizeConfig.imageSizeMultiplier,
                          ),
                          color: AppTheme.greenColor,
                          onPressed: () {}),
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
                                text: selectedOrigin.toString().toUpperCase(),
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
                                text: selectedDestination.toString().toUpperCase(),
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
              SizedBox(height: 2 * SizeConfig.heightMultiplier),
              //date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  //date
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 5 * SizeConfig.widthMultiplier, right: 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset:
                            Offset(0, 1.5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          //date
                          Padding(
                            padding: EdgeInsets.only(
                              right: 2 * SizeConfig.widthMultiplier,
                              left: 1 * SizeConfig.widthMultiplier,
                              top: 0.5 * SizeConfig.heightMultiplier,
                              bottom: 0.5 * SizeConfig.heightMultiplier,
                            ),
                            child: Container(
                              height: 11.5 * SizeConfig.widthMultiplier,
                              margin: EdgeInsets.all(0),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2 * SizeConfig.widthMultiplier),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppTheme.lightGreen.withOpacity(1.0),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                      1 * SizeConfig.widthMultiplier),
                                  child: Text(
                                    selectedDepartureDate,
                                    style: TextStyle(
                                      color: AppTheme.greenColor,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 1.8 * SizeConfig.textMultiplier,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //date text
                          Padding(
                            padding: EdgeInsets.only(
                              right: 3 * SizeConfig.widthMultiplier,
                              top: 0.5 * SizeConfig.heightMultiplier,
                              bottom: 0.5 * SizeConfig.heightMultiplier,
                            ),
                            child: Text(
                              "Departure Date",
                              style: TextStyle(
                                  letterSpacing: 1.2,
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontSize: 1.8 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 0,
                      child: SizedBox(width: 3 * SizeConfig.widthMultiplier)),
                  Expanded(
                    flex: 0,
                    child: Container(
                      //width: 30 * SizeConfig.widthMultiplier,
                      margin: EdgeInsets.only(
                          right: 2 * SizeConfig.widthMultiplier,
                          left: 0 * SizeConfig.widthMultiplier),
                    ),
                  ),
                ],
              ),
              //bus results
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
            ],
          ),
        ),
      ),
    );
  }

  Widget busListView() =>
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('all_trips')
            .where("Origin Route", isEqualTo: selectedOrigin.toUpperCase())
            .where("Destination Route", isEqualTo: selectedDestination.toUpperCase())
            .where("Departure Date", isEqualTo: selectedDepartureDateGenFormat)
            .where("Bus Type", isEqualTo: selectedBusType)
            .where('Travel Status', isEqualTo: 'Upcoming')
            .where("Trip Status", isEqualTo: true)
            .orderBy('Departure Time', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? new Center(child: Loading())
              : snapshot.data.docs.isEmpty
          ? Text(
              'No Trip Available',
            style: TextStyle(
                letterSpacing: 1.2,
                color: Colors.black,
                fontFamily: 'Poppins',
                fontSize: 1.8 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.w500),
          )
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
                  print(selectedDepartureDateGenFormat);
                  DocumentSnapshot data = snapshot.data.docs[index];
                  DateTime selectedDateParsed = DateTime.parse(
                      data['Departure Date']);
                  DateTime selectedTimeParsed = DateTime.parse(
                      data['Departure Time']);
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
                                      onPressed: () async {
                                        //showSeats();
                                        //showNumOfSeatsDialog();
                                        selectedPassengerCategory =
                                        null;
                                        selectedResBusCompanyName =
                                            snapshot.data
                                                .docs[index]
                                                .get(
                                                'Company Name')
                                                .toString()
                                                .toLowerCase();
                                        await companyHasRoundTrip();
                                        if (data[
                                        'Bus Availability Seat'] !=
                                            0) {
                                          DateTime dateFormat =
                                          DateTime
                                              .parse(
                                              snapshot
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
                                          print(
                                              dateFormat
                                                  .toString());
                                          print(
                                              dFormatter);

                                          DateTime timeFormat =
                                          DateTime
                                              .parse(
                                              snapshot
                                                  .data
                                                  .docs[index]
                                                  .get(
                                                  'Departure Time'));
                                          String tFormatter =
                                          DateFormat
                                              .jm()
                                              .format(
                                              timeFormat)
                                              .toString();
                                          print(
                                              timeFormat
                                                  .toString());
                                          print(
                                              tFormatter);

                                          selectedResTripID =
                                              snapshot
                                                  .data
                                                  .docs[index]
                                                  .get(
                                                  'Trip ID');
                                          selectedResOriginRoute =
                                              snapshot
                                                  .data
                                                  .docs[index]
                                                  .get(
                                                  'Origin Route');
                                          selectedResDestinationRoute =
                                              snapshot
                                                  .data
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
                                          DateTime
                                              .parse(
                                              snapshot
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
                                          DateTime
                                              .parse(
                                              snapshot
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
                                              snapshot
                                                  .data
                                                  .docs[index]
                                                  .get(
                                                  'Bus Type');
                                          selectedResBusClass =
                                              snapshot
                                                  .data
                                                  .docs[index]
                                                  .get(
                                                  'Bus Class');
                                          selectedResTerminalName =
                                              snapshot
                                                  .data
                                                  .docs[index]
                                                  .get(
                                                  'Terminal');
                                          selectedResPriceDetails =
                                              snapshot
                                                  .data
                                                  .docs[index]
                                                  .get(
                                                  'Price Details');
                                          selectedResBusCode =
                                              snapshot
                                                  .data
                                                  .docs[index]
                                                  .get(
                                                  'Bus Code')
                                                  .toString();
                                          selectedResBusPlateNumber =
                                              snapshot
                                                  .data
                                                  .docs[index]
                                                  .get(
                                                  'Bus Plate Number')
                                                  .toString();
                                          selectedResBusSeatCapacity =
                                              snapshot
                                                  .data
                                                  .docs[index]
                                                  .get(
                                                  'Bus Seat Capacity')
                                                  .toString();
                                          selectedResBusAvailabilitySeat =
                                              snapshot
                                                  .data
                                                  .docs[index]
                                                  .get(
                                                  'Bus Availability Seat');

                                          selectedResTripStatus =
                                              snapshot
                                                  .data
                                                  .docs[index]
                                                  .get(
                                                  'Trip Status');
                                          selectedResBusTripID =
                                              snapshot
                                                  .data
                                                  .docs[index]
                                                  .id;
                                          selectedResSeats =
                                              selectedNumSeats
                                                  .toString();
                                          selectedResDriverID =
                                              snapshot
                                                  .data
                                                  .docs[index]
                                                  .get(
                                                  'Driver ID');
                                          selectedResCounter =
                                              snapshot
                                                  .data
                                                  .docs[index]
                                                  .get(
                                                  'counter');

                                          print(
                                              'Bus Trip ID: ' +
                                                  selectedResBusTripID);

                                          print(
                                              'Bus Capacity: ' +
                                                  selectedResBusSeatCapacity);
                                          print(
                                              'Bus Availability Seat: ' +
                                                  selectedResBusAvailabilitySeat
                                                      .toString());
                                          print(
                                              'Selected Number of Seats: ' +
                                                  selectedResSeats);

                                          //generate ticket id
                                          String dateFormatter =
                                          DateFormat(
                                              'MMddy')
                                              .format(
                                              dateFormat)
                                              .toString();
                                          print(
                                              selectedResDepartureDate +
                                                  ' -> ' +
                                                  dateFormatter);

                                          String timeFormatter =
                                          DateFormat(
                                              'HHmm')
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
                                          print(
                                              'User ID: ' +
                                                  storeUid);
                                          print(
                                              'Departure Date - ' +
                                                  selectedResDepartureDateGenFormat);
                                          print(
                                              'Departure Time - ' +
                                                  selectedResDepartureTimeGenFormat);

                                          print(
                                              selectedResBusCompanyName);
                                          print(
                                              selectedResBusPlateNumber);
                                          await getBusDocID();
                                          await companyHasBaggage();
                                          await getMinBaggage();
                                          print(
                                              'Bus Doc ID: ' +
                                                  busDocID);
                                          Navigator.of(
                                              context)
                                              .pop();
                                          Navigator
                                              .push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (
                                                      context) =>
                                                      PassengerForm()))
                                              .then((
                                              value) {
                                            setState(() {});
                                          });
                                         /* if (companyRoundTrip == true) {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize
                                                          .min,
                                                      children: [
                                                        SizedBox(
                                                          height: 2 *
                                                              SizeConfig
                                                                  .heightMultiplier,
                                                        ),
                                                        Text(
                                                          "Select your type of trip",
                                                          textAlign: TextAlign
                                                              .center,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily: 'Poppins',
                                                            fontSize: 2.0 *
                                                                SizeConfig
                                                                    .textMultiplier,
                                                            fontWeight: FontWeight
                                                                .w500,
                                                            letterSpacing: 0.1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    elevation: 30.0,
                                                    backgroundColor: Colors
                                                        .white,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .all(
                                                            Radius.circular(
                                                                15.0))),
                                                    actions: [
                                                      Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .spaceEvenly,
                                                            children: [
                                                              TextButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  minimumSize: Size(
                                                                      30.0 *
                                                                          SizeConfig
                                                                              .widthMultiplier,
                                                                      5.0 *
                                                                          SizeConfig
                                                                              .heightMultiplier),
                                                                  primary: Colors
                                                                      .white,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius
                                                                          .circular(
                                                                          10.0),
                                                                      side: BorderSide(
                                                                          color: AppTheme
                                                                              .greenColor)),
                                                                ),
                                                                child: Text(
                                                                  "One-way",
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily: 'Poppins',
                                                                    fontSize: 1.8 *
                                                                        SizeConfig
                                                                            .textMultiplier,
                                                                    fontWeight: FontWeight
                                                                        .w500,
                                                                    letterSpacing: 0.1,
                                                                  ),
                                                                ),
                                                                onPressed: () async {
                                                                  DateTime dateFormat =
                                                                  DateTime
                                                                      .parse(
                                                                      snapshot
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
                                                                  print(
                                                                      dateFormat
                                                                          .toString());
                                                                  print(
                                                                      dFormatter);

                                                                  DateTime timeFormat =
                                                                  DateTime
                                                                      .parse(
                                                                      snapshot
                                                                          .data
                                                                          .docs[index]
                                                                          .get(
                                                                          'Departure Time'));
                                                                  String tFormatter =
                                                                  DateFormat
                                                                      .jm()
                                                                      .format(
                                                                      timeFormat)
                                                                      .toString();
                                                                  print(
                                                                      timeFormat
                                                                          .toString());
                                                                  print(
                                                                      tFormatter);

                                                                  selectedResTripID =
                                                                      snapshot
                                                                          .data
                                                                          .docs[index]
                                                                          .get(
                                                                          'Trip ID');
                                                                  selectedResOriginRoute =
                                                                      snapshot
                                                                          .data
                                                                          .docs[index]
                                                                          .get(
                                                                          'Origin Route');
                                                                  selectedResDestinationRoute =
                                                                      snapshot
                                                                          .data
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
                                                                  DateTime
                                                                      .parse(
                                                                      snapshot
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
                                                                  DateTime
                                                                      .parse(
                                                                      snapshot
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
                                                                      snapshot
                                                                          .data
                                                                          .docs[index]
                                                                          .get(
                                                                          'Bus Type');
                                                                  selectedResBusClass =
                                                                      snapshot
                                                                          .data
                                                                          .docs[index]
                                                                          .get(
                                                                          'Bus Class');
                                                                  selectedResTerminalName =
                                                                      snapshot
                                                                          .data
                                                                          .docs[index]
                                                                          .get(
                                                                          'Terminal');
                                                                  selectedResPriceDetails =
                                                                      snapshot
                                                                          .data
                                                                          .docs[index]
                                                                          .get(
                                                                          'Price Details');
                                                                  selectedResBusCode =
                                                                      snapshot
                                                                          .data
                                                                          .docs[index]
                                                                          .get(
                                                                          'Bus Code')
                                                                          .toString();
                                                                  selectedResBusPlateNumber =
                                                                      snapshot
                                                                          .data
                                                                          .docs[index]
                                                                          .get(
                                                                          'Bus Plate Number')
                                                                          .toString();
                                                                  selectedResBusSeatCapacity =
                                                                      snapshot
                                                                          .data
                                                                          .docs[index]
                                                                          .get(
                                                                          'Bus Seat Capacity')
                                                                          .toString();
                                                                  selectedResBusAvailabilitySeat =
                                                                      snapshot
                                                                          .data
                                                                          .docs[index]
                                                                          .get(
                                                                          'Bus Availability Seat');

                                                                  selectedResTripStatus =
                                                                      snapshot
                                                                          .data
                                                                          .docs[index]
                                                                          .get(
                                                                          'Trip Status');
                                                                  selectedResBusTripID =
                                                                      snapshot
                                                                          .data
                                                                          .docs[index]
                                                                          .id;
                                                                  selectedResSeats =
                                                                      selectedNumSeats
                                                                          .toString();
                                                                  selectedResDriverID =
                                                                      snapshot
                                                                          .data
                                                                          .docs[index]
                                                                          .get(
                                                                          'Driver ID');
                                                                  selectedResCounter =
                                                                      snapshot
                                                                          .data
                                                                          .docs[index]
                                                                          .get(
                                                                          'counter');

                                                                  print(
                                                                      'Bus Trip ID: ' +
                                                                          selectedResBusTripID);

                                                                  print(
                                                                      'Bus Capacity: ' +
                                                                          selectedResBusSeatCapacity);
                                                                  print(
                                                                      'Bus Availability Seat: ' +
                                                                          selectedResBusAvailabilitySeat
                                                                              .toString());
                                                                  print(
                                                                      'Selected Number of Seats: ' +
                                                                          selectedResSeats);

                                                                  //generate ticket id
                                                                  String dateFormatter =
                                                                  DateFormat(
                                                                      'MMddy')
                                                                      .format(
                                                                      dateFormat)
                                                                      .toString();
                                                                  print(
                                                                      selectedResDepartureDate +
                                                                          ' -> ' +
                                                                          dateFormatter);

                                                                  String timeFormatter =
                                                                  DateFormat(
                                                                      'HHmm')
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
                                                                  print(
                                                                      'User ID: ' +
                                                                          storeUid);
                                                                  print(
                                                                      'Departure Date - ' +
                                                                          selectedResDepartureDateGenFormat);
                                                                  print(
                                                                      'Departure Time - ' +
                                                                          selectedResDepartureTimeGenFormat);

                                                                  print(
                                                                      selectedResBusCompanyName);
                                                                  print(
                                                                      selectedResBusPlateNumber);
                                                                  await getBusDocID();
                                                                  await companyHasBaggage();
                                                                  await getMinBaggage();
                                                                  print(
                                                                      'Bus Doc ID: ' +
                                                                          busDocID);
                                                                  Navigator.of(
                                                                      context)
                                                                      .pop();
                                                                  Navigator
                                                                      .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (
                                                                              context) =>
                                                                              PassengerForm()))
                                                                      .then((
                                                                      value) {
                                                                    setState(() {});
                                                                  });
                                                                },
                                                              ),
                                                              TextButton(
                                                                style: TextButton
                                                                    .styleFrom(
                                                                  minimumSize: Size(
                                                                      30.0 *
                                                                          SizeConfig
                                                                              .widthMultiplier,
                                                                      5.0 *
                                                                          SizeConfig
                                                                              .heightMultiplier),
                                                                  primary: Colors
                                                                      .white,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius
                                                                          .circular(
                                                                          10.0),
                                                                      side: BorderSide(
                                                                          color: AppTheme
                                                                              .greenColor)),
                                                                ),
                                                                child: Text(
                                                                  "Round-trip",
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily: 'Poppins',
                                                                    fontSize: 1.8 *
                                                                        SizeConfig
                                                                            .textMultiplier,
                                                                    fontWeight: FontWeight
                                                                        .w500,
                                                                    letterSpacing: 0.1,
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  returnTripDepartureDateGenFormat = null;
                                                                  Navigator.of(
                                                                      context)
                                                                      .pop();
                                                                  navPush();
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 2.0 *
                                                              SizeConfig
                                                                  .heightMultiplier),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                });
                                          } else if (companyRoundTrip == false){
                                            DateTime dateFormat =
                                            DateTime
                                                .parse(
                                                snapshot
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
                                            print(
                                                dateFormat
                                                    .toString());
                                            print(
                                                dFormatter);

                                            DateTime timeFormat =
                                            DateTime
                                                .parse(
                                                snapshot
                                                    .data
                                                    .docs[index]
                                                    .get(
                                                    'Departure Time'));
                                            String tFormatter =
                                            DateFormat
                                                .jm()
                                                .format(
                                                timeFormat)
                                                .toString();
                                            print(
                                                timeFormat
                                                    .toString());
                                            print(
                                                tFormatter);

                                            selectedResTripID =
                                                snapshot
                                                    .data
                                                    .docs[index]
                                                    .get(
                                                    'Trip ID');
                                            selectedResOriginRoute =
                                                snapshot
                                                    .data
                                                    .docs[index]
                                                    .get(
                                                    'Origin Route');
                                            selectedResDestinationRoute =
                                                snapshot
                                                    .data
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
                                            DateTime
                                                .parse(
                                                snapshot
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
                                            DateTime
                                                .parse(
                                                snapshot
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
                                                snapshot
                                                    .data
                                                    .docs[index]
                                                    .get(
                                                    'Bus Type');
                                            selectedResBusClass =
                                                snapshot
                                                    .data
                                                    .docs[index]
                                                    .get(
                                                    'Bus Class');
                                            selectedResTerminalName =
                                                snapshot
                                                    .data
                                                    .docs[index]
                                                    .get(
                                                    'Terminal');
                                            selectedResPriceDetails =
                                                snapshot
                                                    .data
                                                    .docs[index]
                                                    .get(
                                                    'Price Details');
                                            selectedResBusCode =
                                                snapshot
                                                    .data
                                                    .docs[index]
                                                    .get(
                                                    'Bus Code')
                                                    .toString();
                                            selectedResBusPlateNumber =
                                                snapshot
                                                    .data
                                                    .docs[index]
                                                    .get(
                                                    'Bus Plate Number')
                                                    .toString();
                                            selectedResBusSeatCapacity =
                                                snapshot
                                                    .data
                                                    .docs[index]
                                                    .get(
                                                    'Bus Seat Capacity')
                                                    .toString();
                                            selectedResBusAvailabilitySeat =
                                                snapshot
                                                    .data
                                                    .docs[index]
                                                    .get(
                                                    'Bus Availability Seat');

                                            selectedResTripStatus =
                                                snapshot
                                                    .data
                                                    .docs[index]
                                                    .get(
                                                    'Trip Status');
                                            selectedResBusTripID =
                                                snapshot
                                                    .data
                                                    .docs[index]
                                                    .id;
                                            selectedResSeats =
                                                selectedNumSeats
                                                    .toString();
                                            selectedResDriverID =
                                                snapshot
                                                    .data
                                                    .docs[index]
                                                    .get(
                                                    'Driver ID');
                                            selectedResCounter =
                                                snapshot
                                                    .data
                                                    .docs[index]
                                                    .get(
                                                    'counter');

                                            print(
                                                'Bus Trip ID: ' +
                                                    selectedResBusTripID);

                                            print(
                                                'Bus Capacity: ' +
                                                    selectedResBusSeatCapacity);
                                            print(
                                                'Bus Availability Seat: ' +
                                                    selectedResBusAvailabilitySeat
                                                        .toString());
                                            print(
                                                'Selected Number of Seats: ' +
                                                    selectedResSeats);

                                            //generate ticket id
                                            String dateFormatter =
                                            DateFormat(
                                                'MMddy')
                                                .format(
                                                dateFormat)
                                                .toString();
                                            print(
                                                selectedResDepartureDate +
                                                    ' -> ' +
                                                    dateFormatter);

                                            String timeFormatter =
                                            DateFormat(
                                                'HHmm')
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
                                            print(
                                                'User ID: ' +
                                                    storeUid);
                                            print(
                                                'Departure Date - ' +
                                                    selectedResDepartureDateGenFormat);
                                            print(
                                                'Departure Time - ' +
                                                    selectedResDepartureTimeGenFormat);

                                            print(
                                                selectedResBusCompanyName);
                                            print(
                                                selectedResBusPlateNumber);
                                            await getBusDocID();
                                            await companyHasBaggage();
                                            await getMinBaggage();
                                            print(
                                                'Bus Doc ID: ' +
                                                    busDocID);
                                            Navigator.of(
                                                context)
                                                .pop();
                                            Navigator
                                                .push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (
                                                        context) =>
                                                        PassengerForm()))
                                                .then((
                                                value) {
                                              setState(() {});
                                            });
                                          }*/

                                        } else {
                                          return null;
                                        }
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

  void navPush() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ReturnTripBook()))
        .then((value) {
      setState(() {});
    });
  }
}