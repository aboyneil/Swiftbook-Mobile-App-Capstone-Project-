import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:intl/intl.dart';
import 'package:swiftbook/booking/rebook.dart';
import 'package:swiftbook/globals.dart';
import 'package:swiftbook/services/database.dart';
import 'package:swiftbook/styles/size-config.dart';
import 'package:swiftbook/styles/style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swiftbook/travelHistory/travelHistory.dart';
import 'package:swiftbook/string_extension.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TravelHxTicket extends StatefulWidget {
  @override
  _TravelHxTicketState createState() => _TravelHxTicketState();
}

class _TravelHxTicketState extends State<TravelHxTicket> {
  final DatabaseService db = DatabaseService();
  int availabilitySeat = 0;

  String idBaggage;

  Future<void> companyHasBaggage() async {
    var result = await FirebaseFirestore.instance
        .collection('$toRebookCompanyName' + '_Policies')
        .where('category', isEqualTo: "baggage")
        .get();
    result.docs.forEach((val) {
      idBaggage = val.id;
      companyBaggageTravelHx = val.data()['status'];
    });
    print('Company Policies ID - ' +  idBaggage.toString());
    print('Company Baggage - ' + '$companyBaggageTravelHx');
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
              //ticket word
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 6 * SizeConfig.widthMultiplier),
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        icon: SvgPicture.asset(
                          'assets/arrow.svg',
                          color: AppTheme.greenColor,
                          width: 5 * SizeConfig.widthMultiplier,
                        ),
                        onPressed: () {
                          Navigator.pop(context,
                              MaterialPageRoute(builder: (context) {
                            return TravelHistory();
                          }));
                        }, //do something,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'TICKET',
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
                          color: Colors.transparent,
                          onPressed: () {}),
                      //padding: EdgeInsets.all(0),
                    ),
                  ),
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('all_bookingForms')
                      .where('Ticket ID', isEqualTo: selectedTicketID)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return (snapshot.connectionState == ConnectionState.waiting)
                        ? new Center(child: CircularProgressIndicator())
                        : Expanded(
                            flex: 0,
                            child: SizedBox(
                              child: new ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, index) {
                                    companyHasBaggage();
                                    DocumentSnapshot data = snapshot.data.docs[index];
                                    DateTime selectedDateParsed = DateTime.parse(
                                        data['Departure Date']);
                                    DateTime selectedTimeParsed = DateTime.parse(
                                        data['Departure Time']);
                                    double baseFareVar = data['Base Fare'];
                                    double totalFareDouble = double.parse(data['Total Price']);
                                    print('Base Fare: ' '$baseFareVar');
                                    toRebookOrigin = data['Origin Route'];
                                    toRebookDestination = data['Destination Route'];
                                    toRebookCompanyName = data['Company Name'];
                                    toRebookDepartureDate = data['Departure Date'];
                                    toRebookDepartureTime = data['Departure Time'];
                                    toRebookBusType = data['Bus Type'];
                                    toRebookBusClass = data['Bus Class'];
                                    toRebookTicketID = data['Ticket ID'];
                                    toRebookSeatNumber = data['Seat Number'];
                                    toRebookDiscount = data['Discount'];
                                    toRebookTotalExtraBaggage = data['Extra Baggage Price'];
                                    rebookBookingFormID = data.id;
                                    toRebookPriceDouble = data['Base Fare'];
                                    toRebookPrice = toRebookPriceDouble.toStringAsFixed(0);
                                    return Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        //ticket widget
                                        SizedBox(height: 2 * SizeConfig.heightMultiplier),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 6 * SizeConfig.widthMultiplier,
                                              vertical: 0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              //bus name and ticket number
                                              Container(
                                                height: 6 * SizeConfig.heightMultiplier,
                                                decoration: BoxDecoration(
                                                  color: AppTheme.lightGreen,
                                                  borderRadius: BorderRadius.vertical(
                                                      top: Radius.circular(10)),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 6 *
                                                          SizeConfig.widthMultiplier),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .center,
                                                    children: <Widget>[
                                                      Align(
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          data['Company Name']
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
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 2 *
                                                  SizeConfig.heightMultiplier),
                                              //location
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 6 *
                                                      SizeConfig.widthMultiplier,
                                                  vertical: 1 *
                                                      SizeConfig.heightMultiplier,
                                                ),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .spaceBetween,
                                                    children: <Widget>[
                                                      Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Text(
                                                          data['Origin Route']
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                            color: AppTheme.greenColor,
                                                            fontFamily: 'Poppins',
                                                            fontSize: 2.5 *
                                                                SizeConfig.textMultiplier,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment.center,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            Dash(
                                                              dashColor: AppTheme
                                                                  .logoGrey,
                                                              length: 6 * SizeConfig
                                                                  .widthMultiplier,
                                                              dashLength: 3,
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 2 *
                                                                      SizeConfig
                                                                          .widthMultiplier),
                                                              child: Image(
                                                                  image: AssetImage(
                                                                      'assets/bus.png'),
                                                                  height: 3 * SizeConfig
                                                                      .heightMultiplier,
                                                                  color: AppTheme
                                                                      .greenColor),
                                                            ),
                                                            Dash(
                                                              dashColor: AppTheme
                                                                  .logoGrey,
                                                              length: 6 * SizeConfig
                                                                  .widthMultiplier,
                                                              dashLength: 3,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment.centerRight,
                                                        child: Text(
                                                          data['Destination Route']
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                            color: AppTheme.greenColor,
                                                            fontFamily: 'Poppins',
                                                            fontSize: 2.5 *
                                                                SizeConfig.textMultiplier,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                              ),
                                              SizedBox(height: 1 *
                                                  SizeConfig.heightMultiplier),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 4 *
                                                        SizeConfig.widthMultiplier),
                                                child: Divider(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              SizedBox(height: 1 *
                                                  SizeConfig.heightMultiplier),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 6 *
                                                        SizeConfig.widthMultiplier),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Column(
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          //passenger name
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                bottom: 2 * SizeConfig
                                                                    .heightMultiplier),
                                                            child: RichText(
                                                              text: TextSpan(
                                                                text: 'Passenger Name\n',
                                                                style: TextStyle(
                                                                  color: AppTheme.textColor,
                                                                  fontFamily: 'Poppins',
                                                                  fontSize: 1.5 *
                                                                      SizeConfig.textMultiplier,
                                                                  fontWeight: FontWeight.w400,
                                                                ),
                                                                children: <TextSpan>[
                                                                  TextSpan(
                                                                    text: data['First Name'].toString().toLowerCase().titleCase
                                                                        + ' ' + data['Last Name'].toString().toLowerCase().titleCase,
                                                                    style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontFamily: 'Poppins',
                                                                      fontSize: 1.7 * SizeConfig
                                                                          .textMultiplier,
                                                                      fontWeight: FontWeight
                                                                          .w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          //departure date
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                bottom: 2 * SizeConfig
                                                                    .heightMultiplier),
                                                            child: RichText(
                                                              text: TextSpan(
                                                                text: 'Departure Date \n',
                                                                style: TextStyle(
                                                                  color: AppTheme
                                                                      .textColor,
                                                                  fontFamily: 'Poppins',
                                                                  fontSize: 1.5 *
                                                                      SizeConfig
                                                                          .textMultiplier,
                                                                  fontWeight: FontWeight
                                                                      .w400,
                                                                ),
                                                                children: <TextSpan>[
                                                                  TextSpan(
                                                                    text: DateFormat(
                                                                        'MMMM d y')
                                                                        .format(
                                                                        selectedDateParsed),
                                                                    style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontFamily: 'Poppins',
                                                                      fontSize: 1.7 *
                                                                          SizeConfig
                                                                              .textMultiplier,
                                                                      fontWeight: FontWeight
                                                                          .w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          //boarding place
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                bottom: 2 * SizeConfig
                                                                    .heightMultiplier),
                                                            child: RichText(
                                                              text: TextSpan(
                                                                text: 'Boarding Place \n',
                                                                style: TextStyle(
                                                                  color: AppTheme
                                                                      .textColor,
                                                                  fontFamily: 'Poppins',
                                                                  fontSize: 1.5 *
                                                                      SizeConfig
                                                                          .textMultiplier,
                                                                  fontWeight: FontWeight
                                                                      .w400,
                                                                ),
                                                                children: <TextSpan>[
                                                                  TextSpan(
                                                                    text: data['Terminal Name'],
                                                                    style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontFamily: 'Poppins',
                                                                      fontSize: 1.7 *
                                                                          SizeConfig
                                                                              .textMultiplier,
                                                                      fontWeight: FontWeight
                                                                          .w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          //bus class
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                bottom: 2 * SizeConfig
                                                                    .heightMultiplier),
                                                            child: RichText(
                                                              text: TextSpan(
                                                                text: 'Bus Class \n',
                                                                style: TextStyle(
                                                                  color: AppTheme
                                                                      .textColor,
                                                                  fontFamily: 'Poppins',
                                                                  fontSize: 1.5 *
                                                                      SizeConfig
                                                                          .textMultiplier,
                                                                  fontWeight: FontWeight
                                                                      .w400,
                                                                ),
                                                                children: <TextSpan>[
                                                                  TextSpan(
                                                                    text: data['Bus Class']
                                                                        .toString().toLowerCase()
                                                                        .titleCase,
                                                                    style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontFamily: 'Poppins',
                                                                      fontSize: 1.7 *
                                                                          SizeConfig
                                                                              .textMultiplier,
                                                                      fontWeight: FontWeight
                                                                          .w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          //price category
                                                          RichText(
                                                            text: TextSpan(
                                                              text: 'Price Category \n',
                                                              style: TextStyle(
                                                                color: AppTheme.textColor,
                                                                fontFamily: 'Poppins',
                                                                fontSize: 1.5 * SizeConfig
                                                                    .textMultiplier,
                                                                fontWeight: FontWeight
                                                                    .w400,
                                                              ),
                                                              children: <TextSpan>[
                                                                TextSpan(
                                                                  text: data['Passenger Category'],
                                                                  style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontFamily: 'Poppins',
                                                                    fontSize: 1.7 *
                                                                        SizeConfig
                                                                            .textMultiplier,
                                                                    fontWeight: FontWeight
                                                                        .w500,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ]),
                                                    Column(
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          //seat number
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                bottom: 2 * SizeConfig
                                                                    .heightMultiplier),
                                                            child: RichText(
                                                              text: TextSpan(
                                                                text: 'Seat Number \n',
                                                                style: TextStyle(
                                                                  color: AppTheme
                                                                      .textColor,
                                                                  fontFamily: 'Poppins',
                                                                  fontSize: 1.5 *
                                                                      SizeConfig
                                                                          .textMultiplier,
                                                                  fontWeight: FontWeight
                                                                      .w400,
                                                                ),
                                                                children: <TextSpan>[
                                                                  TextSpan(
                                                                    text: data['Seat Number']
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontFamily: 'Poppins',
                                                                      fontSize: 1.7 *
                                                                          SizeConfig
                                                                              .textMultiplier,
                                                                      fontWeight: FontWeight
                                                                          .w500,
                                                                      letterSpacing: 0.7,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          //departure time
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                bottom: 2 * SizeConfig
                                                                    .heightMultiplier),
                                                            child: RichText(
                                                              text: TextSpan(
                                                                text: 'Departure Time \n',
                                                                style: TextStyle(
                                                                  color: AppTheme
                                                                      .textColor,
                                                                  fontFamily: 'Poppins',
                                                                  fontSize: 1.5 *
                                                                      SizeConfig
                                                                          .textMultiplier,
                                                                  fontWeight: FontWeight
                                                                      .w400,
                                                                ),
                                                                children: <TextSpan>[
                                                                  TextSpan(
                                                                    text: DateFormat.jm()
                                                                        .format(
                                                                        selectedTimeParsed),
                                                                    style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontFamily: 'Poppins',
                                                                      fontSize: 1.7 *
                                                                          SizeConfig
                                                                              .textMultiplier,
                                                                      fontWeight: FontWeight
                                                                          .w500,
                                                                      letterSpacing: 0.7,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          //total baggage
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                bottom: 2 * SizeConfig
                                                                    .heightMultiplier),
                                                            child: RichText(
                                                              text: TextSpan(
                                                                text: 'Baggage \n',
                                                                style: TextStyle(
                                                                  color: AppTheme
                                                                      .textColor,
                                                                  fontFamily: 'Poppins',
                                                                  fontSize: 1.5 *
                                                                      SizeConfig
                                                                          .textMultiplier,
                                                                  fontWeight: FontWeight
                                                                      .w400,
                                                                ),
                                                                children: <TextSpan>[
                                                                  TextSpan(
                                                                    text: data['Total Baggage']
                                                                        .toString() + ' kg',
                                                                    style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontFamily: 'Poppins',
                                                                      fontSize: 1.7 *
                                                                          SizeConfig
                                                                              .textMultiplier,
                                                                      fontWeight: FontWeight
                                                                          .w500,
                                                                      letterSpacing: 0.7,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                bottom: 2 * SizeConfig
                                                                    .heightMultiplier),
                                                            child: RichText(
                                                              text: TextSpan(
                                                                text: 'Bus Code \n',
                                                                style: TextStyle(
                                                                  color: AppTheme
                                                                      .textColor,
                                                                  fontFamily: 'Poppins',
                                                                  fontSize: 1.5 *
                                                                      SizeConfig
                                                                          .textMultiplier,
                                                                  fontWeight: FontWeight
                                                                      .w400,
                                                                ),
                                                                children: <TextSpan>[
                                                                  TextSpan(
                                                                    text: data['Bus Code'],
                                                                    style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontFamily: 'Poppins',
                                                                      fontSize: 1.7 *
                                                                          SizeConfig
                                                                              .textMultiplier,
                                                                      fontWeight: FontWeight
                                                                          .w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              text: 'Discount \n',
                                                              style: TextStyle(
                                                                color: AppTheme.textColor,
                                                                fontFamily: 'Poppins',
                                                                fontSize: 1.5 * SizeConfig
                                                                    .textMultiplier,
                                                                fontWeight: FontWeight
                                                                    .w400,
                                                              ),
                                                              children: <TextSpan>[
                                                                TextSpan(
                                                                  text: data['Percentage Discount']
                                                                      .toString() + '%',
                                                                  style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontFamily: 'Poppins',
                                                                    fontSize: 1.7 *
                                                                        SizeConfig
                                                                            .textMultiplier,
                                                                    fontWeight: FontWeight
                                                                        .w500,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ]),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 1 *
                                                  SizeConfig.heightMultiplier),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 4 *
                                                        SizeConfig.widthMultiplier),
                                                child: Divider(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              SizedBox(height: 1 *
                                                  SizeConfig.heightMultiplier),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8 *
                                                      SizeConfig.widthMultiplier,
                                                ),
                                                child: Column(
                                                  children: [
                                                    //subtotal
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .spaceBetween,
                                                      children: <Widget>[
                                                        Text(
                                                          'Base Fare :',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily: 'Poppins',
                                                            fontSize: 1.8 *
                                                                SizeConfig.textMultiplier,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                        Text(
                                                          baseFareVar.toStringAsFixed(2),
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily: 'Poppins',
                                                            fontSize: 2 *
                                                                SizeConfig.textMultiplier,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    //extra baggage
                                                    companyBaggageTravelHx == true
                                                        ? Column(
                                                      children: [
                                                        SizedBox(height: 0.5 *
                                                            SizeConfig.heightMultiplier),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .spaceBetween,
                                                          children: <Widget>[
                                                            Text(
                                                              'Extra Baggage :',
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontFamily: 'Poppins',
                                                                fontSize: 1.8 *
                                                                    SizeConfig.textMultiplier,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                            Text(
                                                              data['Extra Baggage Price'].toString() + '.00',
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontFamily: 'Poppins',
                                                                fontSize: 2 *
                                                                    SizeConfig.textMultiplier,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 0.5 *
                                                            SizeConfig.heightMultiplier),
                                                        //subtotal
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .spaceBetween,
                                                          children: <Widget>[
                                                            Text(
                                                              'Subtotal :',
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontFamily: 'Poppins',
                                                                fontSize: 1.8 *
                                                                    SizeConfig.textMultiplier,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                            Text(
                                                              data['Subtotal'].toString() + '.00',
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontFamily: 'Poppins',
                                                                fontSize: 2 *
                                                                    SizeConfig.textMultiplier,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ) : SizedBox(height: 0 *
                                                        SizeConfig.heightMultiplier),
                                                    SizedBox(height: 1.5 *
                                                        SizeConfig.heightMultiplier),
                                                    //discount
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .spaceBetween,
                                                      children: <Widget>[
                                                        Text(
                                                          'Discount :',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily: 'Poppins',
                                                            fontSize: 1.8 *
                                                                SizeConfig.textMultiplier,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                        Text(
                                                          '- ' + data['Discount'] + '.00',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily: 'Poppins',
                                                            fontSize: 2 *
                                                                SizeConfig.textMultiplier,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 1.2 *
                                                        SizeConfig.heightMultiplier),
                                                    //total fare
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .spaceBetween,
                                                      children: <Widget>[
                                                        Text(
                                                          'Total Fare :',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily: 'Poppins',
                                                            fontSize: 2 *
                                                                SizeConfig.textMultiplier,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          'PHP ' + totalFareDouble.toStringAsFixed(2),
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily: 'Poppins',
                                                            fontSize: 2.3 *
                                                                SizeConfig.textMultiplier,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 1.5 *
                                                  SizeConfig.heightMultiplier),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: SizedBox(
                                                        height: 30,
                                                        width: 15,
                                                        child: DecoratedBox(
                                                          decoration: BoxDecoration(
                                                            color: AppTheme.bgColor,
                                                            borderRadius: BorderRadius
                                                                .only(
                                                                topRight: Radius.circular(
                                                                    18),
                                                                bottomRight: Radius
                                                                    .circular(18)),
                                                          ),
                                                        )),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Dash(
                                                      dashColor: AppTheme.logoGrey,
                                                      length: 78 *
                                                          SizeConfig.widthMultiplier,
                                                      dashLength: 8,
                                                      dashGap: 6,
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.centerRight,
                                                    child: SizedBox(
                                                        height: 30,
                                                        width: 15,
                                                        child: DecoratedBox(
                                                          decoration: BoxDecoration(
                                                            color: AppTheme.bgColor,
                                                            borderRadius: BorderRadius
                                                                .only(
                                                                topLeft: Radius.circular(
                                                                    18),
                                                                bottomLeft: Radius
                                                                    .circular(18)),
                                                          ),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 1 *
                                                  SizeConfig.heightMultiplier),
                                              QrImage(
                                                data: data['Ticket ID'],
                                                size: 30 * SizeConfig.imageSizeMultiplier,
                                                backgroundColor: Colors.white,
                                              ),
                                              Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  data['Ticket ID'],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Poppins',
                                                      fontSize: 1.0 *
                                                          SizeConfig.textMultiplier,
                                                      fontWeight: FontWeight.w500,
                                                      letterSpacing: 1.0
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 3.5 *
                                                  SizeConfig.heightMultiplier),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                          );
                  }),
              SizedBox(height: 4 * SizeConfig.heightMultiplier),
              companyRebooking == true
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15 * SizeConfig.widthMultiplier),
                      child: ElevatedButton(
                        onPressed: () {
                          rebookDialog();
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(0, 45),
                          primary: AppTheme.greenColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: Colors.transparent)),
                        ),
                        child: Text(
                          'Rebook',
                          style: AppTheme.buttonText,
                        ),
                      ),
                    ),
                    SizedBox(height: 4 * SizeConfig.heightMultiplier),
                  ]) : SizedBox(height: 0 * SizeConfig.heightMultiplier),
            ],
          ),
        ),
      ),
    );
  }

void rebookDialog() {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            "Are you sure you want to rebook?",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(30.0 * SizeConfig.widthMultiplier,
                            5.0 * SizeConfig.heightMultiplier),
                        primary: AppTheme.greenColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: AppTheme.greenColor)),
                      ),
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 1.8 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Rebook()))
                            .then((value) {
                          setState(() {});
                        });
                      },
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size(30.0 * SizeConfig.widthMultiplier,
                            5.0 * SizeConfig.heightMultiplier),
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: AppTheme.greenColor)),
                      ),
                      child: Text(
                        "No",
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
                SizedBox(height: 1.5 * SizeConfig.heightMultiplier),
              ],
            ),
          ],
        );
      });
}

  // void cancelBookingDialog() {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           content: Text(
  //             "Are you sure you want to cancel your booking?",
  //             style: TextStyle(
  //               color: Colors.black,
  //               fontFamily: 'Poppins',
  //               fontSize: 2.0 * SizeConfig.textMultiplier,
  //               fontWeight: FontWeight.w500,
  //               letterSpacing: 0.1,
  //             ),
  //           ),
  //           elevation: 30.0,
  //           backgroundColor: Colors.white,
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(15.0))),
  //           actions: [
  //             Column(
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: [
  //                     TextButton(
  //                       style: ElevatedButton.styleFrom(
  //                         minimumSize: Size(30.0 * SizeConfig.widthMultiplier,
  //                             5.0 * SizeConfig.heightMultiplier),
  //                         primary: AppTheme.greenColor,
  //                         shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(10.0),
  //                             side: BorderSide(color: AppTheme.greenColor)),
  //                       ),
  //                       child: Text(
  //                         "Yes",
  //                         style: TextStyle(
  //                           color: Colors.white,
  //                           fontFamily: 'Poppins',
  //                           fontSize: 1.8 * SizeConfig.textMultiplier,
  //                           fontWeight: FontWeight.w500,
  //                           letterSpacing: 0.1,
  //                         ),
  //                       ),
  //                       onPressed: () async {
  //                         var result = await FirebaseFirestore.instance
  //                             .collection('all_trips')
  //                             .where('Trip ID', isEqualTo: travelHxTripID)
  //                             .get();
  //
  //                         result.docs.forEach((element) {
  //                           busAvailabilitySeat =
  //                               element.data()['Bus Availability Seat'];
  //                           travelHxBusCompanyName = element
  //                               .data()['Company Name']
  //                               .toString()
  //                               .toLowerCase();
  //                           selectedTripsID = element.id;
  //                         });
  //                         print(selectedTripsID);
  //                         print(busAvailabilitySeat);
  //                         print(travelHxBusCompanyName);
  //                         //print('Selected Res Company Name: ' + selectedResBusCompanyName);
  //
  //                         db.updateAllBookingStatus();
  //                         db.updateCompanyBookingStatus();
  //                         //
  //                         db.addOneBusAvailabilitySeatAllTrips();
  //                         db.addOneBusAvailabilitySeatCompanyTrips();
  //                         //
  //                         db.setTrueAllSeatStatus();
  //                         db.setTrueCompanySeatStatus();
  //                         Navigator.of(context).pop();
  //                       },
  //                     ),
  //                     TextButton(
  //                       style: TextButton.styleFrom(
  //                         minimumSize: Size(30.0 * SizeConfig.widthMultiplier,
  //                             5.0 * SizeConfig.heightMultiplier),
  //                         primary: Colors.white,
  //                         shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(10.0),
  //                             side: BorderSide(color: AppTheme.greenColor)),
  //                       ),
  //                       child: Text(
  //                         "No",
  //                         style: TextStyle(
  //                           color: Colors.black,
  //                           fontFamily: 'Poppins',
  //                           fontSize: 1.8 * SizeConfig.textMultiplier,
  //                           fontWeight: FontWeight.w500,
  //                           letterSpacing: 0.1,
  //                         ),
  //                       ),
  //                       onPressed: () {
  //                         Navigator.of(context).pop();
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(height: 1.5 * SizeConfig.heightMultiplier),
  //               ],
  //             ),
  //           ],
  //         );
  //       });
  // }
}
