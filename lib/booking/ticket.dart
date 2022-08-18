import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:swiftbook/globals.dart';
import 'package:swiftbook/styles/size-config.dart';
import 'package:swiftbook/styles/style.dart';
import 'package:swiftbook/string_extension.dart';

class Ticket extends StatefulWidget {
  @override
  _TicketState createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        //ticket widget
        SizedBox(height: 2 * SizeConfig.heightMultiplier),
        Expanded(
          flex: 0,
          child: SizedBox(
            child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
                separatorBuilder: (context, index) => SizedBox(height: 4 * SizeConfig.heightMultiplier),
            itemCount: ticketIDList.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('all_bookingForms')
                          .where('Ticket ID', isEqualTo: ticketIDList[index])
                          .snapshots(),
                      builder: (context, snapshot) {
                        return (snapshot.connectionState == ConnectionState.waiting)
                            ? new Center(child: CircularProgressIndicator())
                            : Expanded(
                          flex: 0,
                          child: SizedBox(
                            child: new ListView.separated(
                              separatorBuilder: (context, index) => SizedBox(height: 4 * SizeConfig.heightMultiplier),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot data = snapshot.data.docs[index];
                                  DateTime selectedDateParsed = DateTime.parse(
                                      data['Departure Date']);
                                  DateTime selectedTimeParsed = DateTime.parse(
                                      data['Departure Time']);
                                  double baseFareVar = data['Base Fare'];
                                  double totalFareDouble = double.parse(data['Total Price']);
                                  print('Base Fare: ' '$baseFareVar');
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
                                                  companyBaggage == true
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
                                }
                            ),
                          ),
                        );
                      }
                  ),
                ],
              );
            }
            ),
          ),
        ),
        SizedBox(height: 3 * SizeConfig.heightMultiplier),
      ],
    );
  }
}
