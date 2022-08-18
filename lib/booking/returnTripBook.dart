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

class ReturnTripBook extends StatefulWidget {
  const ReturnTripBook({Key key}) : super(key: key);

  @override
  _ReturnTripBookState createState() => _ReturnTripBookState();
}

class _ReturnTripBookState extends State<ReturnTripBook> {
  final GlobalKey<FormState> _formKeyDateTime = GlobalKey<FormState>();

  String returnTripIdBaggage;
  String returnTripIdRoundTrip;

  Future<void> getBusDocID() async {
    var result = await FirebaseFirestore.instance
        .collection('$selectedReturnTripBusCompanyName' + '_bus')
        .where('Bus Plate Number', isEqualTo: selectedReturnTripBusPlateNumber)
        .get();
    result.docs.forEach((val) {
      returnTripBusDocID = val.id;
    });
  }

  Future<void> companyHasBaggage() async {
    var result = await FirebaseFirestore.instance
        .collection('$selectedReturnTripBusCompanyName' + '_Policies')
        .where('category', isEqualTo: "baggage")
        .get();
    result.docs.forEach((val) {
      returnTripIdBaggage = val.id;
      returnTripCompanyBaggage = val.data()['status'];
    });
    print('Company Policies ID - ' +  returnTripIdBaggage.toString());
    print('Company Baggage - ' + '$returnTripCompanyBaggage');
  }


  Future<void> getMinBaggage() async {
    var result = await FirebaseFirestore.instance
        .collection('$selectedReturnTripBusCompanyName' + '_bus')
        .where('Bus Plate Number', isEqualTo: selectedReturnTripBusPlateNumber)
        .get();
    result.docs.forEach((val) {
      returnTripBaggageLimitID = val.id;
      returnTripMaxBaggage = int.parse(val.data()['Maximum Baggage']);
      returnTripMinBaggage = int.parse(val.data()['Minimum Baggage']);
      returnTripPesoPerBaggage = int.parse(val.data()['Peso Per Baggage']);
    });
    print('Baggage Limit ID - ' + '$returnTripBaggageLimitID');
    print('Max Baggage - ' + '$returnTripMaxBaggage');
    print('Min Baggage - ' + '$returnTripMinBaggage');
    print('Peso Per Baggage - ' + '$returnTripPesoPerBaggage');
    returnTripBaggageNumberList.clear();
    for (int i = 0; i < seatCounter; i++){
      returnTripBaggageNumberList.insert(i, returnTripMinBaggage);
    }
    print('List of Baggage - ' + returnTripBaggageNumberList.toString());
  }

  //date
  DateTime date;
  DateTime dateTimeNow = DateTime.now();

  void showDatePicker(BuildContext context) {
    String stringMinYear = DateFormat('yyyy').format(dateTimeNow);
    int minYear = int.parse(stringMinYear);

    int maxYear = minYear + 20;
    print(maxYear);

    DateTime dateNow =
        DateTime(dateTimeNow.year, dateTimeNow.month, dateTimeNow.day);

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      //showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 95 * SizeConfig.widthMultiplier,
              height: 28 * SizeConfig.heightMultiplier,
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 1.8 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                child: CupertinoDatePicker(
                    key: _formKeyDateTime,
                    initialDateTime: dateNow,
                    minimumDate: dateNow,
                    minimumYear: minYear,
                    maximumYear: maxYear,
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (value) {
                      setState(() {
                        date = value;
                        returnTripDepartureDateGenFormat =
                            DateFormat("yyyy-MM-dd").format(value) +
                                " " +
                                '00:00:00';
                        returnTripDepartureDate =
                            DateFormat('MMMM d y').format(date);
                      });
                    }),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 6,
                    offset: Offset(0, 1.5), // changes position of shadow
                  ),
                ],
              ),
            ),
            CupertinoActionSheet(
              actions: [],
              cancelButton: CupertinoActionSheetAction(
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: AppTheme.greenColor,
                    fontFamily: 'Poppins',
                    fontSize: 1.8 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    returnTripOrigin = selectedDestination.toString().toUpperCase();
    returnTripDestination = selectedOrigin.toString().toUpperCase();
    print('SeatCounter - ' + '$seatCounter');
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
                      'RETURN TRIP',
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
                                text: returnTripOrigin.toString().toUpperCase(),
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
                                text: returnTripDestination
                                    .toString()
                                    .toUpperCase(),
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
              InkWell(
                onTap: () {
                  date = dateTimeNow;
                  print(date.toString());
                  // returnTripDepartureDateGenFormat =
                  //     DateFormat("yyyy-MM-dd").format(date) + " " + '00:00:00';
                  // returnTripDepartureDate = DateFormat('MMMM d y').format(date);
                  showDatePicker(context);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 5.0 * SizeConfig.widthMultiplier,
                      vertical: 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 6,
                        offset: Offset(0, 1.5), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                            left: 5 * SizeConfig.widthMultiplier,
                            top: 5 * SizeConfig.widthMultiplier,
                            bottom: 5 * SizeConfig.widthMultiplier,
                          ),
                          child: date == null
                              ? Text(
                                  "Choose return date",
                                  style: AppTheme.formHintText,
                                )
                              : RichText(
                                  text: TextSpan(
                                      text: "Return Date\n",
                                      style: TextStyle(
                                        color: AppTheme.textColor,
                                        fontFamily: 'Poppins',
                                        fontSize:
                                            1.4 * SizeConfig.textMultiplier,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            returnTripDepartureDate.toString(),
                                        style: AppTheme.selectedBusDeetsText,
                                      )
                                    ]))),
                      Padding(
                        padding: EdgeInsets.only(
                          right: 2 * SizeConfig.widthMultiplier,
                        ),
                        child: date == null
                            ? Container(
                                width: 12.5 * SizeConfig.widthMultiplier,
                                height: 11.5 * SizeConfig.widthMultiplier,
                                margin: EdgeInsets.all(0),
                                padding: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppTheme.lightGreen.withOpacity(1.0),
                                ),
                                child: Center(
                                  child: IconButton(
                                      icon: new Icon(
                                        Icons.calendar_today_outlined,
                                        size:
                                            6 * SizeConfig.imageSizeMultiplier,
                                      ),
                                      color: AppTheme.greenColor,
                                      onPressed: () {}),
                                ),
                              )
                            : Container(
                                width: 12.5 * SizeConfig.widthMultiplier,
                                height: 15.5 * SizeConfig.widthMultiplier,
                                margin: EdgeInsets.all(0),
                                padding: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppTheme.lightGreen.withOpacity(1.0),
                                ),
                                child: Center(
                                  child: IconButton(
                                      icon: new Icon(
                                        Icons.calendar_today_outlined,
                                        size:
                                            6 * SizeConfig.imageSizeMultiplier,
                                      ),
                                      color: AppTheme.greenColor,
                                      onPressed: () {}),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              //bus results
              SizedBox(height: 2.5 * SizeConfig.heightMultiplier),
              returnTripDepartureDateGenFormat != null
                  ? Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 0 * SizeConfig.widthMultiplier,
                          vertical: 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 4,
                            offset:
                                Offset(0, 1.5), // changes position of shadow
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
                    )
                  : SizedBox(height: 0 * SizeConfig.heightMultiplier),
            ],
          ),
        ),
      ),
    );
  }

  Widget busListView() => StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('all_trips')
            .where("Origin Route", isEqualTo: returnTripOrigin.toUpperCase())
            .where("Destination Route",
                isEqualTo: returnTripDestination.toUpperCase())
            .where("Departure Date",
                isEqualTo: returnTripDepartureDateGenFormat)
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
                          separatorBuilder: (context, index) => SizedBox(
                              height: 2.5 * SizeConfig.heightMultiplier),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            print(selectedDepartureDateGenFormat);
                            DocumentSnapshot data = snapshot.data.docs[index];
                            DateTime selectedDateParsed =
                                DateTime.parse(data['Departure Date']);
                            DateTime selectedTimeParsed =
                                DateTime.parse(data['Departure Time']);
                            return Column(
                              children: <Widget>[
                                Container(
                                  width: 90 * SizeConfig.widthMultiplier,
                                  margin: EdgeInsets.symmetric(
                                      horizontal:
                                          3 * SizeConfig.widthMultiplier,
                                      vertical:
                                          0 * SizeConfig.heightMultiplier),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                        color:
                                            AppTheme.logoGrey.withOpacity(0.4)),
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
                                                    SizeConfig.widthMultiplier,
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
                                                    SizeConfig.textMultiplier,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: 8 *
                                                    SizeConfig.widthMultiplier,
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
                                                      SizeConfig.textMultiplier,
                                                  fontWeight: FontWeight.w500),
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
                                            vertical: 0 *
                                                SizeConfig.heightMultiplier),
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
                                                        text: DateFormat.jm()
                                                                .format(
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
                                                        text:
                                                            data['Bus Availability Seat']
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
                                                              SizeConfig
                                                                  .textMultiplier,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: data['Bus Type']
                                                                .toString() +
                                                            '\n',
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
                                                              SizeConfig
                                                                  .textMultiplier,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: data['Terminal']
                                                            .toString()
                                                            .titleCase,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                          color: AppTheme
                                                              .greenColor
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
                                                              color: Colors
                                                                  .grey[600],
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
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .grey[600],
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
                                              "PHP " +
                                                  data['Price Details'] +
                                                  '.00',
                                              style: TextStyle(
                                                color: Colors.grey[800],
                                                fontFamily: 'Poppins',
                                                fontSize: 2 *
                                                    SizeConfig.textMultiplier,
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
                                                  selectedPassengerCategory =
                                                      null;
                                                  selectedReturnTripBusCompanyName =
                                                      snapshot.data.docs[index]
                                                          .get('Company Name')
                                                          .toString()
                                                          .toLowerCase();
                                                  if (data[
                                                          'Bus Availability Seat'] !=
                                                      0) {
                                                    DateTime dateFormat =
                                                        DateTime.parse(snapshot
                                                            .data.docs[index]
                                                            .get(
                                                                'Departure Date'));
                                                    String dFormatter =
                                                        DateFormat('MMMM d y')
                                                            .format(dateFormat)
                                                            .toString();
                                                    print(
                                                        dateFormat.toString());
                                                    print(dFormatter);

                                                    DateTime timeFormat =
                                                        DateTime.parse(snapshot
                                                            .data.docs[index]
                                                            .get(
                                                                'Departure Time'));
                                                    String tFormatter =
                                                        DateFormat.jm()
                                                            .format(timeFormat)
                                                            .toString();
                                                    print(timeFormat.toString());
                                                    print(tFormatter);

                                                    selectedReturnTripTripID = snapshot
                                                        .data.docs[index]
                                                        .get('Trip ID');
                                                    returnTripOrigin =
                                                        snapshot
                                                            .data.docs[index]
                                                            .get(
                                                                'Origin Route');
                                                    returnTripDestination =
                                                        snapshot
                                                            .data.docs[index]
                                                            .get(
                                                                'Destination Route');
                                                    selectedReturnTripDepartureDate =
                                                        dFormatter;

                                                    DateFormat
                                                        dateFormatterDepartureDate =
                                                        DateFormat(
                                                            'yyyy-MM-dd');
                                                    DateTime dtDepartureDate =
                                                        DateTime.parse(snapshot
                                                            .data.docs[index]
                                                            .get(
                                                                'Departure Date'));
                                                    selectedReturnTripDepartureDateGenFormat =
                                                        dateFormatterDepartureDate
                                                                .format(
                                                                    dtDepartureDate)
                                                                .toString() +
                                                            ' 00:00:00';

                                                    DateFormat
                                                        dateFormatterDepartureTime =
                                                        DateFormat('HH:mm:ss');
                                                    DateTime dtDepartureTime =
                                                        DateTime.parse(snapshot
                                                            .data.docs[index]
                                                            .get(
                                                                'Departure Time'));
                                                    selectedReturnTripDepartureTimeGenFormat =
                                                        '0000-00-00 ' +
                                                            dateFormatterDepartureTime
                                                                .format(
                                                                    dtDepartureTime)
                                                                .toString();
                                                    selectedReturnTripDepartureTime =
                                                        tFormatter;
                                                    selectedReturnTripResBusType =
                                                        snapshot
                                                            .data.docs[index]
                                                            .get('Bus Type');
                                                    selectedReturnTripBusClass =
                                                        snapshot
                                                            .data.docs[index]
                                                            .get('Bus Class');
                                                    selectedReturnTripTerminalName =
                                                        snapshot
                                                            .data.docs[index]
                                                            .get('Terminal');
                                                    selectedReturnTripPriceDetails =
                                                        snapshot
                                                            .data.docs[index]
                                                            .get(
                                                                'Price Details');
                                                    selectedReturnTripBusCode =
                                                        snapshot
                                                            .data.docs[index]
                                                            .get('Bus Code')
                                                            .toString();
                                                    selectedReturnTripBusPlateNumber =
                                                        snapshot
                                                            .data.docs[index]
                                                            .get(
                                                                'Bus Plate Number')
                                                            .toString();
                                                    selectedReturnTripBusSeatCapacity =
                                                        snapshot
                                                            .data.docs[index]
                                                            .get(
                                                                'Bus Seat Capacity')
                                                            .toString();
                                                    selectedReturnTripBusAvailabilitySeat =
                                                        snapshot
                                                            .data.docs[index]
                                                            .get(
                                                                'Bus Availability Seat');
                                                    selectedReturnTripTripStatus =
                                                        snapshot
                                                            .data.docs[index]
                                                            .get('Trip Status');
                                                    selectedReturnTripTripID =
                                                        snapshot.data
                                                            .docs[index].id;
                                                    selectedReturnTripSeats =
                                                        selectedNumSeats
                                                            .toString();
                                                    selectedReturnTripDriverID =
                                                        snapshot
                                                            .data.docs[index]
                                                            .get('Driver ID');
                                                    selectedReturnTripCounter =
                                                        snapshot
                                                            .data.docs[index]
                                                            .get('counter');

                                                    print('Bus Trip ID: ' +
                                                        selectedReturnTripTripID);

                                                    print('Bus Capacity: ' +
                                                        selectedReturnTripBusSeatCapacity);
                                                    print('Bus Availability Seat: ' +
                                                        selectedReturnTripBusAvailabilitySeat
                                                            .toString());
                                                    print(
                                                        'Selected Number of Seats: ' +
                                                            selectedReturnTripSeats);

                                                    String storeUid =
                                                        FirebaseAuth.instance
                                                            .currentUser.uid
                                                            .toString();
                                                    print(
                                                        'User ID: ' + storeUid);
                                                    print('Departure Date - ' +
                                                        selectedReturnTripDepartureDateGenFormat);
                                                    print('Departure Time - ' +
                                                        selectedReturnTripDepartureTimeGenFormat);

                                                    print(
                                                        selectedReturnTripBusCompanyName);
                                                    print(
                                                        selectedReturnTripBusPlateNumber);
                                                    await getBusDocID();
                                                    await companyHasBaggage();
                                                    await getMinBaggage();
                                                    print('Bus Doc ID: ' +
                                                        returnTripBusDocID);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => PassengerForm()))
                                                        .then((value) {
                                                      setState(() {});
                                                    });
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  minimumSize: Size(
                                                      0,
                                                      4.5 *
                                                          SizeConfig
                                                              .heightMultiplier),
                                                  primary:
                                                      data['Bus Availability Seat'] ==
                                                              0
                                                          ? Colors.grey
                                                          : AppTheme.greenColor,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
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
                                        height:
                                            0.8 * SizeConfig.heightMultiplier,
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
