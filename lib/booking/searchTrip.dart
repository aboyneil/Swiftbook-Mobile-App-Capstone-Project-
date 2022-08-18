import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swiftbook/booking/busResult.dart';
import 'package:swiftbook/logins/login.dart';
import 'package:swiftbook/logins/signup.dart';
import 'package:swiftbook/shared/loading.dart';
import 'package:swiftbook/styles/size-config.dart';
import 'package:swiftbook/styles/style.dart';
import 'package:intl/intl.dart';
import 'package:swiftbook/globals.dart';

class SearchTrip extends StatefulWidget {
  @override
  _SearchTripState createState() => _SearchTripState();
}

class _SearchTripState extends State<SearchTrip> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyDateTime = GlobalKey<FormState>();
  String error = '';

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
                        selectedDepartureDateGenFormat =
                            DateFormat("yyyy-MM-dd").format(value) +
                                " " +
                                '00:00:00';
                        selectedDepartureDate =
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

  //increment number of seats
  void incrementSeat() {
    setState(() {
      seatCounter++;
    });
  }

  //decrement number of seats
  void decrementSeat() {
    if (seatCounter > 1) {
      setState(() {
        seatCounter--;
      });
    }
  }

  //bus type
  List<bool> isSelected = [true, false, false];

  @override
  Widget build(BuildContext context) {
    print(selectedDepartureDate);
    return loading
        ? Loading()
        : Scaffold(
            body: SafeArea(
              bottom: false,
              left: false,
              right: false,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: 4 * SizeConfig.heightMultiplier),
                      Text(
                        'SEARCH BUS TRIP',
                        textAlign: TextAlign.center,
                        style: AppTheme.pageTitleText,
                      ),
                      SizedBox(height: 2.5 * SizeConfig.heightMultiplier),
                      Container(
                        padding: EdgeInsets.only(
                          right: 6 * SizeConfig.widthMultiplier,
                        ),
                        margin: EdgeInsets.symmetric(
                            horizontal: 5 * SizeConfig.widthMultiplier,
                            vertical: 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 6,
                              offset:
                                  Offset(0, 1.5), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(height: 3.5 * SizeConfig.heightMultiplier),
                            //origin
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 11 * SizeConfig.widthMultiplier),
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('all_origin')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: CupertinoActivityIndicator(),
                                      );
                                    } else {
                                      return DropdownButtonFormField(
                                        value: selectedOrigin,
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please select a location';
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                            labelText: selectedOrigin == null
                                                ? ''
                                                : 'From:',
                                            labelStyle: AppTheme.formLabelText,
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 2 *
                                                        SizeConfig
                                                            .widthMultiplier),
                                            icon: Icon(
                                              Icons.near_me_sharp,
                                              color: AppTheme.greenColor
                                                  .withOpacity(0.3),
                                              size: 9 *
                                                  SizeConfig
                                                      .imageSizeMultiplier,
                                            )),
                                        isExpanded: true,
                                        isDense: true,
                                        iconSize: 0,
                                        hint: Text(
                                          "Select your origin",
                                          style: AppTheme.formLabelText,
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedOrigin = value;
                                          });
                                        },
                                        items: snapshot.data.docs
                                            .map((DocumentSnapshot docs) {
                                          return new DropdownMenuItem<String>(
                                            value: docs['location'],
                                            child: new Text(
                                              docs['location'].toUpperCase(),
                                              style:
                                                  AppTheme.selectedBusDeetsText,
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    }
                                  }),
                            ),
                            //reverse location
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 18,
                                  //flex: 10,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 8 * SizeConfig.widthMultiplier),
                                    child: Divider(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.all(0),
                                    padding: EdgeInsets.all(0),
                                  ),
                                ),
                                //)
                              ],
                            ),
                            SizedBox(height: 1 * SizeConfig.heightMultiplier),
                            //destination
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 11 * SizeConfig.widthMultiplier),
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('all_destination')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: CupertinoActivityIndicator(),
                                      );
                                    } else {
                                      return DropdownButtonFormField(
                                        value: selectedDestination,
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please select a location';
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                            labelText:
                                                selectedDestination == null
                                                    ? ''
                                                    : "To:",
                                            labelStyle: AppTheme.formLabelText,
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 2 *
                                                        SizeConfig
                                                            .widthMultiplier),
                                            icon: Icon(
                                              Icons.location_on_sharp,
                                              color: AppTheme.greenColor,
                                              size: 9 *
                                                  SizeConfig
                                                      .imageSizeMultiplier,
                                            )),
                                        isExpanded: true,
                                        isDense: true,
                                        iconSize: 0,
                                        hint: Text(
                                          "Select your destination",
                                          style: AppTheme.formLabelText,
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedDestination = value;
                                          });
                                        },
                                        items: snapshot.data.docs
                                            .map((DocumentSnapshot docs) {
                                          return new DropdownMenuItem<String>(
                                            value: docs['location'],
                                            child: new Text(
                                              docs['location'].toUpperCase(),
                                              style:
                                                  AppTheme.selectedBusDeetsText,
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    }
                                  }),
                            ),
                            SizedBox(height: 2.5 * SizeConfig.heightMultiplier),
                          ],
                        ),
                      ),
                      //date
                      SizedBox(height: 3 * SizeConfig.heightMultiplier),
                      InkWell(
                        onTap: () {
                          date = dateTimeNow;
                          print(date.toString());
                          selectedDepartureDateGenFormat =
                              DateFormat("yyyy-MM-dd").format(date) +
                                  " " +
                                  '00:00:00';
                          selectedDepartureDate =
                              DateFormat('MMMM d y').format(date);
                          showDatePicker(context);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 5 * SizeConfig.widthMultiplier,
                              vertical: 0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 6,
                                offset: Offset(
                                    0, 1.5), // changes position of shadow
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
                                          "Choose departure date",
                                          style: AppTheme.formHintText,
                                        )
                                      // :  date == dateTimeNow
                                      //   ? RichText(
                                      //     text: TextSpan(
                                      //         text: "Departure Date\n",
                                      //         style: TextStyle(
                                      //           color: AppTheme.textColor,
                                      //           fontFamily: 'Poppins',
                                      //           fontSize: 1.4 *
                                      //               SizeConfig.textMultiplier,
                                      //           fontWeight: FontWeight.w400,
                                      //         ),
                                      //         children: <TextSpan>[
                                      //         TextSpan(
                                      //           text: dateTimeNow.toString(),
                                      //           style: AppTheme
                                      //               .selectedBusDeetsText,
                                      //         )
                                      //       ]))
                                      : RichText(
                                          text: TextSpan(
                                              text: "Departure Date\n",
                                              style: TextStyle(
                                                color: AppTheme.textColor,
                                                fontFamily: 'Poppins',
                                                fontSize: 1.4 *
                                                    SizeConfig.textMultiplier,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                text: selectedDepartureDate
                                                    .toString(),
                                                style: AppTheme
                                                    .selectedBusDeetsText,
                                              )
                                            ]))),
                              Padding(
                                padding: EdgeInsets.only(
                                  right: 2 * SizeConfig.widthMultiplier,
                                ),
                                child: date == null
                                    ? Container(
                                        width:
                                            12.5 * SizeConfig.widthMultiplier,
                                        height:
                                            11.5 * SizeConfig.widthMultiplier,
                                        margin: EdgeInsets.all(0),
                                        padding: EdgeInsets.all(0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: AppTheme.lightGreen
                                              .withOpacity(1.0),
                                        ),
                                        child: Center(
                                          child: IconButton(
                                              icon: new Icon(
                                                Icons.calendar_today_outlined,
                                                size: 6 *
                                                    SizeConfig
                                                        .imageSizeMultiplier,
                                              ),
                                              color: AppTheme.greenColor,
                                              onPressed: () {}),
                                        ),
                                      )
                                    : Container(
                                        width:
                                            12.5 * SizeConfig.widthMultiplier,
                                        height:
                                            15.5 * SizeConfig.widthMultiplier,
                                        margin: EdgeInsets.all(0),
                                        padding: EdgeInsets.all(0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: AppTheme.lightGreen
                                              .withOpacity(1.0),
                                        ),
                                        child: Center(
                                          child: IconButton(
                                              icon: new Icon(
                                                Icons.calendar_today_outlined,
                                                size: 6 *
                                                    SizeConfig
                                                        .imageSizeMultiplier,
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
                      SizedBox(height: 2 * SizeConfig.heightMultiplier),
                      //number of seats
                      Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 5 * SizeConfig.widthMultiplier,
                              vertical: 0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 6,
                                offset: Offset(
                                    0, 1.5), // changes position of shadow
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
                                child: Text(
                                  "Number of Seats",
                                  style: AppTheme.formLabelText,
                                ),
                              ),
                              //add number of seat
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  //minus number of seat
                                  Padding(
                                      padding: EdgeInsets.only(
                                        right: 0 * SizeConfig.widthMultiplier,
                                      ),
                                      child: Center(
                                          child: IconButton(
                                        icon: Icon(Icons.remove_rounded),
                                        iconSize:
                                            8 * SizeConfig.imageSizeMultiplier,
                                        color: AppTheme.greenColor,
                                        onPressed: () {
                                          decrementSeat();
                                          selectedNumSeats = seatCounter;
                                        },
                                      ))),

                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: 0 * SizeConfig.widthMultiplier,
                                    ),
                                    child: Container(
                                      width: 15 * SizeConfig.widthMultiplier,
                                      height: 11.5 * SizeConfig.widthMultiplier,
                                      margin: EdgeInsets.all(0),
                                      padding: EdgeInsets.all(0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: AppTheme.lightGreen
                                            .withOpacity(1.0),
                                      ),
                                      child: Center(
                                          child: Text(
                                        seatCounter.toString(),
                                        style: TextStyle(
                                          color: AppTheme.greenColor,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              3 * SizeConfig.textMultiplier,
                                          letterSpacing: 2,
                                        ),
                                      )),
                                    ),
                                  ),
                                  //add number of seat
                                  Padding(
                                      padding: EdgeInsets.only(
                                        right: 2 * SizeConfig.widthMultiplier,
                                      ),
                                      child: Center(
                                          child: IconButton(
                                        icon: Icon(Icons.add_rounded),
                                        iconSize:
                                            7 * SizeConfig.imageSizeMultiplier,
                                        color: AppTheme.greenColor,
                                        onPressed: () {
                                          incrementSeat();
                                          selectedNumSeats = seatCounter;
                                        },
                                      ))),
                                ],
                              ),
                            ],
                          )),
                      // bus type
                      SizedBox(height: 2 * SizeConfig.heightMultiplier),
                      //bus type
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 5 * SizeConfig.widthMultiplier,
                            vertical: 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 6,
                              offset:
                                  Offset(0, 1.5), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 5 * SizeConfig.widthMultiplier,
                                  top: 5 * SizeConfig.widthMultiplier,
                                ),
                                child: Text(
                                  "Bus Type",
                                  style: AppTheme.formLabelText,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  //ac
                                  Center(
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                3 * SizeConfig.widthMultiplier,
                                            vertical:
                                                3 * SizeConfig.widthMultiplier),
                                        child: ToggleButtons(
                                          children: <Widget>[
                                            Text(
                                              "AC",
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 1.8 *
                                                    SizeConfig.textMultiplier,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              "Non-AC",
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 1.8 *
                                                    SizeConfig.textMultiplier,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              "Sleeper",
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 1.8 *
                                                    SizeConfig.textMultiplier,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                          isSelected: isSelected,
                                          //isSelected: btAc,
                                          onPressed: (int index) {
                                            setState(() {
                                              for (int indexBtn = 0;
                                                  indexBtn < isSelected.length;
                                                  indexBtn++) {
                                                if (indexBtn == index) {
                                                  isSelected[indexBtn] = true;
                                                  //isSelected[indexBtn] = !isSelected[indexBtn];
                                                  //selectedBusType = isSelected[indexBtn].toString();
                                                } else {
                                                  isSelected[indexBtn] = false;
                                                }
                                              }

                                              if (isSelected[0] == true) {
                                                selectedBusType = "AC";
                                              } else if (isSelected[1] ==
                                                  true) {
                                                selectedBusType = "Non-AC";
                                              } else if (isSelected[2] ==
                                                  true) {
                                                selectedBusType = "Sleeper";
                                              } else {
                                                selectedBusType = "AC";
                                              }
                                            });
                                          },
                                          constraints: BoxConstraints(
                                              minWidth: 25 *
                                                  SizeConfig.widthMultiplier,
                                              minHeight: 4.5 *
                                                  SizeConfig.heightMultiplier),
                                          color: Color.fromRGBO(
                                              112, 112, 112, 1.0),
                                          selectedColor: AppTheme.greenColor,
                                          fillColor: AppTheme.lightGreen,
                                          //borderColor: Colors.transparent,
                                          borderColor:
                                              Colors.grey.withOpacity(0.4),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          selectedBorderColor:
                                              AppTheme.lightGreen,
                                        )),
                                  ),
                                ],
                              ),
                              SizedBox(height: 1 * SizeConfig.heightMultiplier),
                            ]),
                      ),
                      SizedBox(height: 1.5 * SizeConfig.heightMultiplier),
                      //selected bus type error text
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            8 * SizeConfig.widthMultiplier, 0, 0, 0),
                        child: Text(
                          error,
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'Poppins',
                            fontSize: 1.5 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      SizedBox(height: 2 * SizeConfig.heightMultiplier),
                      //search button
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15 * SizeConfig.widthMultiplier),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    //fill in null values
                                    if (selectedDepartureDate == null) {
                                      selectedDepartureDate = dateNow;
                                      selectedDepartureDateGenFormat =
                                          DateFormat("yyyy-MM-dd")
                                                  .format(datetimeNow) +
                                              " " +
                                              '00:00:00';
                                    }
                                    print(selectedDepartureDate);
                                    print(selectedDepartureDateGenFormat);

                                    if (selectedBusType == null) {
                                      selectedBusType = 'AC';
                                    }

                                    print(selectedOrigin);
                                    print(selectedDestination);
                                    print(selectedNumSeats);
                                    print(selectedBusType);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return BusRes();
                                      }),
                                    );
                                  }
                                  // if (_formKey.currentState.validate()) {
                                  //   //Get all UID inside all_trips collection
                                  //   var result = await FirebaseFirestore
                                  //       .instance
                                  //       .collection('all_trips')
                                  //       .get();
                                  //
                                  //   //Inserting all UID to List
                                  //   List uidResult = [''];
                                  //   result.docs.forEach((res) {
                                  //     int i = 0;
                                  //     uidResult.insert(i, res.id);
                                  //     //print(uidResult[i]);
                                  //     i++;
                                  //   });
                                  //   //
                                  //   //fill in null values
                                  //   if (selectedDepartureDate == null) {
                                  //     selectedDepartureDate = dateNow;
                                  //     selectedDepartureDateGenFormat = DateFormat("yyyy-MM-dd").format(datetimeNow) + " " + '00:00:00';
                                  //   }
                                  //   print(selectedDepartureDate);
                                  //   print(selectedDepartureDateGenFormat);
                                  //
                                  //   if (selectedBusType == null){
                                  //     selectedBusType = 'AC';
                                  //   }
                                  //
                                  //   print(selectedOrigin);
                                  //   print(selectedDestination);
                                  //   print(selectedNumSeats);
                                  //   print(selectedBusType);
                                  //   //
                                  //   //
                                  //   //
                                  //   //Compare Data inside a specific document for searching
                                  //   for (int i = 0; i < result.docs.length; i++) {
                                  //     var documentData = await FirebaseFirestore
                                  //         .instance
                                  //         .collection('all_trips')
                                  //         .doc(uidResult[i])
                                  //         .get();
                                  //     //Temporary variables for comparison
                                  //     String tempOrigin;
                                  //     String tempDestination;
                                  //     String tempDepartureDateGenFormat;
                                  //     String tempBusType;
                                  //     //Assign variables
                                  //     setState(() {
                                  //       tempOrigin =
                                  //       documentData['Origin Route'].toString().toUpperCase();
                                  //       tempDestination =
                                  //       documentData['Destination Route'].toString().toUpperCase();
                                  //       tempDepartureDateGenFormat =
                                  //       documentData['Departure Date'];
                                  //       tempBusType = documentData['Bus Type'];
                                  //     });
                                  //
                                  //     //Compare Variables
                                  //     if (tempOrigin == selectedOrigin.toUpperCase() &&
                                  //         tempDestination == selectedDestination.toUpperCase() &&
                                  //         tempDepartureDateGenFormat ==
                                  //             selectedDepartureDateGenFormat &&
                                  //         tempBusType == selectedBusType) {
                                  //       //Push if found
                                  //       Navigator.push(
                                  //         context,
                                  //         MaterialPageRoute(builder: (context) {
                                  //           return BusRes();
                                  //         }),
                                  //       );
                                  //       break;
                                  //     }
                                  //     //Error if none are found.
                                  //     else {
                                  //       if (i == result.docs.length - 1) {
                                  //         noTripShowDialog();
                                  //       }
                                  //     }
                                  //   }
                                  // }
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(0, 45),
                                  primary: AppTheme.greenColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: BorderSide(
                                          color: Colors.transparent)),
                                ),
                                child: Text(
                                  'Search',
                                  style: AppTheme.buttonText,
                                ),
                              ),
                            ),
                            SizedBox(height: 2 * SizeConfig.heightMultiplier),
                          ]),
                      SizedBox(height: 3 * SizeConfig.heightMultiplier),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
