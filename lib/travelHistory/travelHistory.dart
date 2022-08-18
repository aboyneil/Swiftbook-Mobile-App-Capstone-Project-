import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:swiftbook/models/user.dart';
import 'package:swiftbook/styles/size-config.dart';
import 'package:swiftbook/styles/style.dart';
import 'package:swiftbook/travelHistory/travelHx_ticket.dart';

import '../globals.dart';

class TravelHistory extends StatefulWidget {
  @override
  _TravelHistoryState createState() => _TravelHistoryState();
}

class _TravelHistoryState extends State<TravelHistory> {
  String storeUid = FirebaseAuth.instance.currentUser.uid.toString();

  String idRebooking;
  String companyName;

  Future<void> companyHasRebooking() async {
    var result = await FirebaseFirestore.instance
        .collection('$companyName' + '_Policies')
        .where('category', isEqualTo: "rebooking")
        .get();
    result.docs.forEach((val) {
      idRebooking = val.id;
      companyRebooking = val.data()['status'];
      companyRebookingFee = int.parse(val.data()['fee'].toString());
    });
    print('Company Policies ID - ' +  idRebooking.toString());
    print('Company Rebooking - ' + '$companyRebooking');
    print('Company Rebooking Fee - ' '$companyRebookingFee');
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TravelHxTicket();
    }));
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
              Text(
                'TRAVEL HISTORY',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.greenColor,
                  fontFamily: 'Poppins',
                  fontSize: 2.5 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 4 * SizeConfig.heightMultiplier),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('all_bookingForms')
                .where('UID', isEqualTo: storeUid)
                .orderBy('Booking Status')
                .orderBy('Departure Date')
                .orderBy('Departure Time')
                .snapshots(),
            builder: (context, snapshot) {
              return (snapshot.connectionState == ConnectionState.waiting)
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
                        DocumentSnapshot data = snapshot.data.docs[index];
                        DateTime selectedDateParsed = DateTime.parse(
                            data['Departure Date']);
                        DateTime selectedTimeParsed = DateTime.parse(
                            data['Departure Time']);
                        companyName = data['Company Name'].toString().toLowerCase();
                        return Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                selectedTicketID = data['Ticket ID'];
                                await companyHasRebooking();
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  right: 4.5 * SizeConfig.widthMultiplier,
                                  left: 4.5 * SizeConfig.widthMultiplier,
                                ),
                                padding: EdgeInsets.fromLTRB(
                                    3 * SizeConfig.widthMultiplier,
                                    2 * SizeConfig.heightMultiplier,
                                    3 * SizeConfig.widthMultiplier,
                                    2 * SizeConfig.heightMultiplier,
                                ),
                                width: 100 * SizeConfig.widthMultiplier,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 0.2,
                                      blurRadius: 5,
                                      offset: Offset(0, 1.5), // changes position of shadow
                                    ),
                                  ],
                                ),
                                //travel date and bus/ticket num
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 2 * SizeConfig.widthMultiplier),
                                         child: Icon(
                                           data['Booking Status'] == 'Active'
                                               ? Icons.radio_button_checked_rounded
                                               : data['Booking Status'] == 'Cancelled'
                                               ? Icons.block_rounded
                                               : data['Booking Status'] == 'Absent'
                                               ? Icons.highlight_off_rounded
                                               : Icons.check_circle_outline_rounded,
                                           color: data['Booking Status'] == 'Active'
                                               ?  AppTheme.greenColor
                                               : data['Booking Status'] == 'Cancelled'
                                               ? Colors.red
                                               : data['Booking Status'] == 'Absent'
                                               ? Colors.amber[500]
                                               : Colors.grey,
                                           size: 10 * SizeConfig.imageSizeMultiplier,
                                            ),
                                          ),
                                        SizedBox(
                                          height: 0.5 * SizeConfig.heightMultiplier,
                                        ),
                                        Text(
                                          data['Booking Status'] == 'Active'
                                              ? 'Active'
                                              : data['Booking Status'] == 'Cancelled'
                                              ? 'Cancelled'
                                              : data['Booking Status'] == 'Absent'
                                              ? 'Absent'
                                              : 'Done',
                                          style: TextStyle(
                                            color: Colors.black.withOpacity(0.7),
                                            fontFamily: 'Poppins',
                                            fontSize: 1.2 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    //divider
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        1.5 * SizeConfig.widthMultiplier,
                                        0 * SizeConfig.heightMultiplier,
                                        3 * SizeConfig.widthMultiplier,
                                        0 * SizeConfig.heightMultiplier,
                                      ),
                                      child: SizedBox(
                                        height: 8 * SizeConfig.heightMultiplier,
                                        child: VerticalDivider(
                                          color: Colors.grey[300],
                                          thickness: 1,
                                          indent: 0,
                                          endIndent: 0,
                                          width: 2 * SizeConfig.widthMultiplier,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        //date and time
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                            0 * SizeConfig.widthMultiplier,
                                            0 * SizeConfig.heightMultiplier,
                                            2 * SizeConfig.widthMultiplier,
                                            0 * SizeConfig.heightMultiplier,
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                DateFormat('MMMM d y').format(selectedDateParsed),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Poppins',
                                                  fontSize: 1.6 * SizeConfig.textMultiplier,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.1,
                                                ),
                                              ),
                                              Text(
                                                DateFormat.jm().format(selectedTimeParsed),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Poppins',
                                                  fontSize: 1.6 * SizeConfig.textMultiplier,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 1.5 * SizeConfig.heightMultiplier),
                                        //location
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                            0 * SizeConfig.widthMultiplier,
                                            0 * SizeConfig.heightMultiplier,
                                            2 * SizeConfig.widthMultiplier,
                                            0 * SizeConfig.heightMultiplier,
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    data['Origin Route'].toString().toUpperCase(),
                                                  style: TextStyle(
                                                    color: AppTheme.greenColor,
                                                    fontFamily: 'Poppins',
                                                    fontSize: 2.2 * SizeConfig.textMultiplier,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 1.5 * SizeConfig.widthMultiplier),
                                              Align(
                                                alignment: Alignment.center,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Dash(
                                                      dashColor: AppTheme.logoGrey,
                                                      length: 4 * SizeConfig.widthMultiplier,
                                                      dashLength: 1,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: 2 * SizeConfig.widthMultiplier),
                                                      child: Image(
                                                          image: AssetImage('assets/bus.png'),
                                                          height: 3 * SizeConfig.heightMultiplier,
                                                          color: AppTheme.greenColor),
                                                    ),
                                                    Dash(
                                                      dashColor: AppTheme.logoGrey,
                                                      length: 4 * SizeConfig.widthMultiplier,
                                                      dashLength: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 1.5 * SizeConfig.widthMultiplier),
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: Text(
                                                    data['Destination Route'].toString().toUpperCase(),
                                                  style: TextStyle(
                                                    color: AppTheme.greenColor,
                                                    fontFamily: 'Poppins',
                                                    fontSize: 2.2 * SizeConfig.textMultiplier,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                  ),
                                    ),
                                  ],
                                ),
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
              SizedBox(height: 4 * SizeConfig.heightMultiplier),
            ],
          ),
        ),
      ),
    );
  }
}
