import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:paymongo_sdk/paymongo_sdk.dart';
import 'package:swiftbook/globals.dart';
import 'package:swiftbook/styles/size-config.dart';
import 'package:swiftbook/styles/style.dart';
import 'package:swiftbook/payment/event_handler.dart';
import 'package:swiftbook/services/database.dart';
import 'package:swiftbook/string_extension.dart';

class BillingForm extends StatefulWidget {
  @override
  _BillingFormState createState() => _BillingFormState();
}

final DatabaseService db = DatabaseService();

class _BillingFormState extends State<BillingForm> with PaymongoEventHandler {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var billing = PayMongoBilling(
      name: '', email: '', phone: '', address: PayMongoAddress(line1: ''));

  int radioButtonVal = 0;

  //passenger type
  var mapPassengerType = Map();
  List passengerTypeCount = [];

  //passenger type discount
  var mapPassengerTypeDiscount = Map();
  List passengerTypeDiscountList = [];
  int ticketCounter = 0;

  void computeEachSubTotal(){
    eachSubTotal.clear();
    for (int i = 0; i < listDiscount.length; i++) {
      var temp = baseFare + eachExtraBaggagePriceList[i];
      eachSubTotal.insert(i, temp.toInt());
    }
    print('Each Subtotal - ' + eachSubTotal.toString());
  }

  void computeEachDiscount() {
    eachTotal.clear();
    eachDiscount.clear();
    for (int i = 0; i < listDiscount.length; i++) {
      var discountTemp = baseFare * (int.parse(listDiscount[i].toString()) / 100 );
      eachDiscount.insert(i, discountTemp.toStringAsFixed(0));
      var temp = (baseFare - discountTemp) + eachExtraBaggagePriceList[i];
      eachTotal.add(temp.toStringAsFixed(0));
    }
    print('Each Discount - ' + eachDiscount.toString());
    print('Each Total - ' + eachTotal.toString());
  }


  void computeTotalDiscount() {
    totalDiscount = 0;
    for (int i = 0; i < eachDiscount.length; i++) {
      totalDiscount += int.parse(eachDiscount[i].toString());
    }
    print('Total Discount: ' + totalDiscount.toStringAsFixed(2));
  }

  void computeEachExtraBaggage(){
    eachExtraBaggageList.clear();
    for(int i = 0; i < baggageNumberList.length; i ++){
      eachExtraBaggageList.insert(i, int.parse(baggageNumberList[i].toString()) - minBaggage);
    }
    print('Each Extra Baggage: ' + eachExtraBaggageList.toString());
  }

  void computeEachExtraBaggagePrice(){
    eachExtraBaggagePriceList.clear();
    for(int i = 0; i < baggageNumberList.length; i ++){
      int num = eachExtraBaggageList[i] * pesoPerBaggage;
      eachExtraBaggagePriceList.insert(i, num);
    }
    print('Each Extra Baggage Price: ' + eachExtraBaggagePriceList.toString());
  }

  void computeEachTotalBaggageNum(){
    eachTotalBaggageNum.clear();
    for(int i = 0; i < baggageNumberList.length; i ++){
      int num = eachExtraBaggageList[i] + minBaggage;
      eachTotalBaggageNum.insert(i, num);
    }
    print('Each Total Baggage Number: ' + eachTotalBaggageNum.toString());
  }

  void computeTotalExtraBaggage(){
    totalExtraBaggage = 0;
    for (int i = 0; i < eachExtraBaggagePriceList.length; i++) {
      totalExtraBaggage += int.parse(eachExtraBaggagePriceList[i].toString());
    }
    print('Total Extra Baggage: ' + totalExtraBaggage.toStringAsFixed(2));
  }

  void getTotalPrice() {
    for (int i = 0; i < eachTotal.length; i++) {
      totalPrice = totalPrice + double.parse(eachTotal[i]);
    }
  }

  void generateTicketID() {
    print(selectedResCounter);
    ticketCounter = 0;
    ticketCounter = selectedResCounter;
    ticketIDList.clear();
    DateTime dateFormat = DateTime.parse(selectedResDepartureDateGenFormat);
    String dateFormatter = DateFormat('MMddy').format(dateFormat).toString();
    DateTime timeFormat = DateTime.parse(selectedResDepartureTimeGenFormat);
    String timeFormatter = DateFormat('HHmm').format(timeFormat).toString();

    for (int i = 0; i < selectedSeats.length; i++) {
      ticketIDList.add(dateFormatter +
          timeFormatter +
          '-' +
          ticketCounter.toString() +
          selectedResBusCompanyName.toUpperCase() +
          selectedResBusCode +
          '-' +
          selectedSeats[i]);
      ticketCounter++;
    }
    print('Ticket ID ' + ticketIDList.toString());
  }

  var distinctPassengerType = passengerType.toSet().toList();

  Future<void> getListRightSeat() async {
    rightSeatList.clear();
    final CollectionReference busCollection = FirebaseFirestore.instance
        .collection('$selectedResBusCompanyName' + '_bus');

    var docSnapshot = await busCollection.doc(busDocID).get();
    if (docSnapshot.exists){
      Map<String, dynamic> data = docSnapshot.data();
      rightSeatList = List.from(data['List Right Seat']);
    }
   // Navigator.of(context).pop();
    //Navigator.popAndPushNamed(context, '/chooseSeats', (Route<dynamic> route) => true));
  }


  Future<void> getListLeftSeatList() async {
    listLeftSeat.clear();
    final CollectionReference busCollection = FirebaseFirestore.instance
        .collection('$selectedResBusCompanyName' + '_bus');

    var docSnapshot = await busCollection.doc(busDocID).get();
    if (docSnapshot.exists){
      Map<String, dynamic> data = docSnapshot.data();
      listLeftSeat = List.from(data['List Left Seat']);
    }
  }

  Future<void> getLeftSeatStatus() async {
    leftSeatStatus.clear();
    final CollectionReference busCollection = FirebaseFirestore.instance
        .collection('$selectedResBusCompanyName' + '_bus');

    var docSnapshot = await busCollection.doc(busDocID).get();
    if (docSnapshot.exists){
      Map<String, dynamic> data = docSnapshot.data();
      leftSeatStatus = List.from(data['Left Seat Status']);
    }
  }

  Future<void> getRightSeatStatus() async {
    rightSeatStatus.clear();
    final CollectionReference busCollection = FirebaseFirestore.instance
        .collection('$selectedResBusCompanyName' + '_bus');

    var docSnapshot = await busCollection.doc(busDocID).get();
    if (docSnapshot.exists){
      Map<String, dynamic> data = docSnapshot.data();
      rightSeatStatus = List.from(data['Right Seat Status']);
    }
  }

  Future<void> getRowColSize() async {
    final CollectionReference busCollection = FirebaseFirestore.instance
        .collection('$selectedResBusCompanyName' + '_bus');

    //var docSnapshot = await busCollection.doc(busDocID).get();
    var docSnapshot = await busCollection.doc(busDocID).get();

    if (docSnapshot.exists){
      Map<String, dynamic> data = docSnapshot.data();
      leftColSize = data['Left Col Size'];
      leftRowSize = data['Left Row Size'];
      rightColSize = data['Right Col Size'];
      rightRowSize = data['Right Row Size'];
    }
  }

  Future<void> getListBottomSeat() async {
    listBottomSeat.clear();
    final CollectionReference busCollection = FirebaseFirestore.instance
        .collection('$selectedResBusCompanyName' + '_bus');

    var docSnapshot = await busCollection.doc(busDocID).get();
    if (docSnapshot.exists){
      Map<String, dynamic> data = docSnapshot.data();
      listBottomSeat = List.from(data['List Bottom Seat']);
    }
  }

  Future<void> getBottomSeatStatus() async {
    bottomSeatStatus.clear();
    final CollectionReference busCollection = FirebaseFirestore.instance
        .collection('$selectedResBusCompanyName' + '_bus');

    var docSnapshot = await busCollection.doc(busDocID).get();
    if (docSnapshot.exists){
      Map<String, dynamic> data = docSnapshot.data();
      bottomSeatStatus = List.from(data['Bottom Seat Status']);
    }

  }

  @override
  Widget build(BuildContext context) {
    print('@Billing form Passenger Details:');
    print('Departure Date - ' + selectedResDepartureDateGenFormat);
    print('Departure Time - ' + selectedResDepartureTimeGenFormat);
    print('Seat Number - ' + selectedSeats.toString());
    print('Passenger Type - ' + passengerType.toString());
    print('First Name - ' + passengerFirstName.toString());
    print('Last Name - ' + passengerLastName.toString());
    print('Email - ' + passengerEmailAddress.toString());
    print('Mobile Num - ' + passengerMobileNum.toString());
    print('Discount ID - ' + passengerDiscountID.toString());
    print('List Discount - ' + listDiscount.toString());
    print('Selected Seats: ' + selectedSeats.toString());

    // clear list
    mapPassengerType.clear();
    mapPassengerTypeDiscount.clear();
    passengerTypeDiscountList.clear();
    totalPrice = 0;
    subTotal = 0;

    //passenger type
    //remove duplicate from the list
    //var distinctPassengerType = passengerType.toSet().toList();
    //count duplicate from the list
    //passenger type
    passengerType.forEach((x) => mapPassengerType[x] =
        !mapPassengerType.containsKey(x) ? (1) : (mapPassengerType[x] + 1));
    // print(mapPassengerType);
    //add passenger type count from var to list
    passengerTypeCount.clear();
    mapPassengerType.forEach((key, value) {
      passengerTypeCount.add(value);
    });
    print('Passenger Type Count: ' + passengerTypeCount.toString());
    // print('Passenger Type Count: ' + passengerTypeCount.toString());

    //passenger type discount
    //count duplicate from the list
    //passenger type
    listDiscount.forEach((x) => mapPassengerTypeDiscount[x] =
        !mapPassengerTypeDiscount.containsKey(x)
            ? (1)
            : (mapPassengerTypeDiscount[x] + 1));
    // print(mapPassengerTypeDiscount);
    //add passenger type count from var to list
    mapPassengerTypeDiscount.forEach((key, value) {
      passengerTypeDiscountList.add(key);
    });
    // print('Passenger Type Discount List: ' +
    //     passengerTypeDiscountList.toString());
    
    print('Base Fare: ' + baseFare.toStringAsFixed(2));
    computeEachExtraBaggage();
    computeEachExtraBaggagePrice();
    computeEachTotalBaggageNum();
    computeTotalExtraBaggage();
    computeEachSubTotal();
    computeEachDiscount();
    computeTotalDiscount();
    subTotal = (baseFare * seatCounter) + totalExtraBaggage;
    print('SubTotal: ' + subTotal.toStringAsFixed(2));
    getTotalPrice();
    print('Total Fare: ' + '$totalPrice');
    generateTicketID();

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
                          }, //do something,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'BILLING DETAILS',
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
                //billing form
                Container(
                  //height: 50 * SizeConfig.heightMultiplier,
                  margin: EdgeInsets.symmetric(
                      horizontal: 5 * SizeConfig.widthMultiplier, vertical: 0),
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
                  child: Column(
                    children: [
                      //billing form
                      Form(
                        key: formKey,
                        child: Column(children: <Widget>[
                          SizedBox(height: 1 * SizeConfig.heightMultiplier),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 4 * SizeConfig.widthMultiplier),
                            child: Text(
                              "Billing Form".toUpperCase(),
                              style: TextStyle(
                                  letterSpacing: 1.2,
                                  color: AppTheme.greenColor,
                                  fontFamily: 'Poppins',
                                  fontSize: 2.2 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          SizedBox(height: 0.5 * SizeConfig.heightMultiplier),
                          //Name
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5 * SizeConfig.widthMultiplier),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.words,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              //controller: _billingFormName,
                              //initialValue: bfName,
                              keyboardType: TextInputType.name,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "Please enter your name";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (val) {
                                setState(() => billingFormName = val);
                              },
                              onSaved: (val) {
                                setState(() => billingFormName = val);
                              },
                              onTap: () {
                                InputDecoration(
                                  hintText: 'Full Name',
                                  hintStyle: AppTheme.formHintText,
                                );
                              },
                              style: AppTheme.formInputText,
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                labelStyle: AppTheme.formLabelText,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 5 * SizeConfig.widthMultiplier,
                                    vertical: 2 * SizeConfig.heightMultiplier),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.withOpacity(0.8)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(0, 189, 56, 1.0)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red.withOpacity(0.8)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red.withOpacity(0.8)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                              ),
                            ),
                          ),
                          SizedBox(height: 3.0 * SizeConfig.heightMultiplier),
                          //email
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5 * SizeConfig.widthMultiplier),
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              //controller: _billingFormEmail,
                              //initialValue: bfEmail,
                              keyboardType: TextInputType.emailAddress,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "Please enter an email address";
                                } else if (!RegExp(
                                        "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                    .hasMatch(value)) {
                                  return "Please enter a valid email address";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (val) {
                                setState(() {
                                  billingFormEmail = val;
                                });
                              },
                              onSaved: (val) {
                                setState(() {
                                  billingFormEmail = val;
                                });
                              },
                              onTap: () {
                                InputDecoration(
                                  hintText: 'Email Address',
                                  hintStyle: AppTheme.formHintText,
                                );
                              },
                              style: AppTheme.formInputText,
                              decoration: InputDecoration(
                                labelText: 'Email Address',
                                labelStyle: AppTheme.formLabelText,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 5 * SizeConfig.widthMultiplier,
                                    vertical: 2 * SizeConfig.heightMultiplier),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.8),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(0, 189, 56, 1.0),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                ),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red.withOpacity(0.8)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red.withOpacity(0.8)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                              ),
                            ),
                          ),
                          SizedBox(height: 3.0 * SizeConfig.heightMultiplier),
                          //mobile number
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5 * SizeConfig.widthMultiplier),
                            child: TextFormField(
                              inputFormatters: [
                                new LengthLimitingTextInputFormatter(11),
                              ],
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              //controller: _billingFormMobileNum,
                              //initialValue: bfMobileNum,
                              keyboardType: TextInputType.number,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "Please enter a mobile number";
                                } else if (value.length != 11) {
                                  return "Enter eleven digits";
                                } else {
                                  return null;
                                }
                              },
                              style: AppTheme.formInputText,
                              onChanged: (val) {
                                setState(() {
                                  billingFormMobileNum = val;
                                });
                              },
                              onSaved: (val) {
                                setState(() {
                                  billingFormMobileNum = val;
                                });
                              },
                              onTap: () {
                                InputDecoration(
                                  hintText: 'Mobile Number',
                                  hintStyle: AppTheme.formHintText,
                                );
                              },
                              decoration: InputDecoration(
                                hintText: '09xxxxxxxxx',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Poppins',
                                  fontSize: 1.7 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 3.0,
                                ),
                                labelText: 'Mobile Number',
                                labelStyle: AppTheme.formLabelText,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 5 * SizeConfig.widthMultiplier,
                                    vertical: 2 * SizeConfig.heightMultiplier),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.8),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(0, 189, 56, 1.0),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                ),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red.withOpacity(0.8)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red.withOpacity(0.8)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                              ),
                            ),
                          ),
                          SizedBox(height: 3.0 * SizeConfig.heightMultiplier),
                          //address
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5 * SizeConfig.widthMultiplier),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.words,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              //controller: _billingFormAddress,
                              keyboardType: TextInputType.streetAddress,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "Please enter your address";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (val) {
                                setState(() => billingFormAddress = val);
                              },
                              onSaved: (val) {
                                setState(() => billingFormAddress = val);
                              },
                              onTap: () {
                                InputDecoration(
                                  hintText: 'Address',
                                  hintStyle: AppTheme.formHintText,
                                );
                              },
                              style: AppTheme.formInputText,
                              decoration: InputDecoration(
                                labelText: 'Address',
                                labelStyle: AppTheme.formLabelText,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 5 * SizeConfig.widthMultiplier,
                                    vertical: 2 * SizeConfig.heightMultiplier),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.withOpacity(0.8)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(0, 189, 56, 1.0)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red.withOpacity(0.8)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red.withOpacity(0.8)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                              ),
                            ),
                          ),
                          SizedBox(height: 1.3 * SizeConfig.heightMultiplier),
                        ]),
                      ),
                      SizedBox(height: 2.5 * SizeConfig.heightMultiplier),
                    ],
                  ),
                ),
                //booking details
                SizedBox(height: 3 * SizeConfig.heightMultiplier),
                //bus booking details
                Container(
                  //height: 50 * SizeConfig.heightMultiplier,
                  margin: EdgeInsets.symmetric(
                      horizontal: 5 * SizeConfig.widthMultiplier, vertical: 0),
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
                  child: Column(
                    children: [
                      //billing form
                      Column(children: <Widget>[
                        SizedBox(height: 1 * SizeConfig.heightMultiplier),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 4 * SizeConfig.widthMultiplier),
                          child: Text(
                            "Reservation Details".toUpperCase(),
                            style: TextStyle(
                                letterSpacing: 1.2,
                                color: AppTheme.greenColor,
                                fontFamily: 'Poppins',
                                fontSize: 2.2 * SizeConfig.textMultiplier,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(height: 2.5 * SizeConfig.heightMultiplier),
                        //location
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8 * SizeConfig.widthMultiplier),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    selectedResOriginRoute
                                        .toString()
                                        .toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontSize: 2.5 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Dash(
                                        dashColor: AppTheme.logoGrey,
                                        length: 9 * SizeConfig.widthMultiplier,
                                        dashLength: 2,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                2 * SizeConfig.widthMultiplier),
                                        child: Image(
                                            image: AssetImage('assets/bus.png'),
                                            height:
                                                3 * SizeConfig.heightMultiplier,
                                            color: Colors.black),
                                      ),
                                      Dash(
                                        dashColor: AppTheme.logoGrey,
                                        length: 9 * SizeConfig.widthMultiplier,
                                        dashLength: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    selectedResDestinationRoute
                                        .toString()
                                        .toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontSize: 2.5 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                        SizedBox(height: 1 * SizeConfig.heightMultiplier),
                        //divider
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6 * SizeConfig.widthMultiplier,
                          ),
                          child: Divider(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 1 * SizeConfig.heightMultiplier),
                        //price
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8 * SizeConfig.widthMultiplier,
                          ),
                          child: Column(
                            children: [
                              //fare
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Base Fare :',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontSize: 1.8 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    baseFare.toStringAsFixed(2),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontSize: 1.8 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: 0.5 * SizeConfig.heightMultiplier),
                              //qty
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Qty :',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontSize: 1.8 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '$seatCounter',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontSize: 1.8 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: 0.8 * SizeConfig.heightMultiplier),
                              //subtotal
                              companyBaggage == true
                              ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    ' ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontSize: 1.8 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                      (subTotal-totalExtraBaggage).toStringAsFixed(2),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontSize: 1.8 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ) : SizedBox(height: 0 * SizeConfig.heightMultiplier),
                              SizedBox(height: 1 * SizeConfig.heightMultiplier),
                            ],
                          ),
                        ),
                        companyBaggage == true
                            ? Column(
                          children: [
                            Dash(
                              dashColor: AppTheme.logoGrey,
                              length: 77 * SizeConfig.widthMultiplier,
                              dashLength: 8,
                            ),
                            SizedBox(height: 1 * SizeConfig.heightMultiplier),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8 * SizeConfig.widthMultiplier,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 1 * SizeConfig.heightMultiplier),
                                  //discounts
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Extra Baggage :',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Poppins',
                                          fontSize: 1.8 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        ' + ' + totalExtraBaggage.toStringAsFixed(2),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Poppins',
                                          fontSize: 1.8 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height: 1.5 * SizeConfig.heightMultiplier),
                                  ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: baggageNumberList.length,
                                      itemBuilder: (context, index) {
                                        int baggageNumberListInt = int.parse(baggageNumberList[index].toString());
                                        int eachExtraBaggageNum = baggageNumberListInt - minBaggage;
                                        double pesoPerBaggageDouble = double.parse(pesoPerBaggage.toString());
                                        int eachExtraBaggagePrice = eachExtraBaggageNum * pesoPerBaggage;
                                        double eachExtraBaggagePriceDouble = double.parse(eachExtraBaggagePrice.toString());
                                        totalExtraBaggage = eachExtraBaggagePriceDouble + eachExtraBaggagePriceDouble;
                                        return Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  2 * SizeConfig.widthMultiplier,
                                                  0,
                                                  0,
                                                  0),
                                              child: Text(
                                                //passengerType[index].toLowerCase().titleCase,
                                                eachExtraBaggageList[index].toString() + ' kg' + ' x ' + 'Php ' + pesoPerBaggageDouble.toStringAsFixed(2),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Poppins',
                                                  fontSize: 1.5 *
                                                      SizeConfig.textMultiplier,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                                              child: Text(
                                                eachExtraBaggagePriceList[index].toString() + '.00',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Poppins',
                                                  fontSize: 1.5 *
                                                      SizeConfig.textMultiplier,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                  SizedBox(
                                      height: 2 * SizeConfig.heightMultiplier),
                                  //subtotal
                                ],
                              ),
                            ),
                            Dash(
                              dashColor: AppTheme.logoGrey,
                              length: 77 * SizeConfig.widthMultiplier,
                              dashLength: 8,
                            ),
                            SizedBox(height: 2 * SizeConfig.heightMultiplier),
                          ],
                        ) : SizedBox(height: 0 * SizeConfig.heightMultiplier),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8 * SizeConfig.widthMultiplier,
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Subtotal',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontSize: 1.8 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                subTotal.toStringAsFixed(2),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontSize: 1.8 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        companyBaggage == false
                            ? Column(
                          children: [
                            SizedBox(height: 1 * SizeConfig.heightMultiplier),
                            Dash(
                              dashColor: AppTheme.logoGrey,
                              length: 77 * SizeConfig.widthMultiplier,
                              dashLength: 8,
                            ),
                            SizedBox(height: 0.5 * SizeConfig.heightMultiplier),
                          ],
                        ): SizedBox(height: 0 * SizeConfig.heightMultiplier),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8 * SizeConfig.widthMultiplier,
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 1 * SizeConfig.heightMultiplier),
                              //discounts
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Discount :',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontSize: 1.8 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '- ' + totalDiscount.toStringAsFixed(2),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontSize: 1.8 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: 1.5 * SizeConfig.heightMultiplier),
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: distinctPassengerType.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              2 * SizeConfig.widthMultiplier,
                                              0,
                                              0,
                                              0),
                                          child: Text(
                                            //passengerType[index].toLowerCase().titleCase,
                                            distinctPassengerType[index]
                                                .toLowerCase()
                                                .titleCase,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Poppins',
                                              fontSize: 1.5 *
                                                  SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Text(
                                            passengerTypeCount[index]
                                                    .toString() +
                                                ' x ' +
                                                listDiscount[index]
                                                    .toString() +
                                                '%',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Poppins',
                                              fontSize: 1.5 *
                                                  SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            ],
                          ),
                        ),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier),
                        Dash(
                          dashColor: AppTheme.logoGrey,
                          length: 77 * SizeConfig.widthMultiplier,
                          dashLength: 8,
                        ),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier),
                        //total fare
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8 * SizeConfig.widthMultiplier,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'TOTAL FARE :',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontSize: 2 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                //'PHP ' + totalPrice.toStringAsFixed(2),
                                'PHP ' + totalPrice.toStringAsFixed(2),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontSize: 2.0 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 1 * SizeConfig.heightMultiplier),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6 * SizeConfig.widthMultiplier,
                          ),
                          child: Divider(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 1 * SizeConfig.heightMultiplier),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6 * SizeConfig.widthMultiplier,
                          ),
                          child: Text(
                            "Your personal data will be used to process your order, support your experience throught this website, and for other purposes described in our privacy policy.",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontSize: 1.5 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.1,
                            ),
                          ),
                        ),
                        SizedBox(height: 3 * SizeConfig.heightMultiplier),
                        //gcash
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2 * SizeConfig.widthMultiplier),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 3 * SizeConfig.widthMultiplier,
                                    vertical: 0),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey[400]),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              4 * SizeConfig.widthMultiplier,
                                          vertical:
                                              2 * SizeConfig.heightMultiplier),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 12, 0),
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/gcash_logo.png'),
                                              height: 5 *
                                                  SizeConfig.heightMultiplier,
                                            ),
                                          ),
                                          Text(
                                            'GCash',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Poppins',
                                              fontSize: 1.7 *
                                                  SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              2 * SizeConfig.widthMultiplier,
                                          vertical:
                                              0 * SizeConfig.heightMultiplier),
                                      child: Radio(
                                        value: 1,
                                        groupValue: radioButtonVal,
                                        onChanged: (value) {
                                          print(
                                              '@Billing form Passenger Details:');
                                          print(passengerType);
                                          print(passengerFirstName);
                                          print(passengerLastName);
                                          print(passengerEmailAddress);
                                          print(passengerMobileNum);
                                          setState(() {
                                            radioButtonVal = value;
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3 * SizeConfig.heightMultiplier),
                        //credit or debit card
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2 * SizeConfig.widthMultiplier),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 3 * SizeConfig.widthMultiplier,
                                    vertical: 0),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey[400]),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              4 * SizeConfig.widthMultiplier,
                                          vertical:
                                              2 * SizeConfig.heightMultiplier),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 14, 0),
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/visa-mastercard.png'),
                                              height: 5 *
                                                  SizeConfig.heightMultiplier,
                                            ),
                                          ),
                                          Text(
                                            'Credit/Debit Card',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Poppins',
                                              fontSize: 1.7 *
                                                  SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              2 * SizeConfig.widthMultiplier,
                                          vertical:
                                              0 * SizeConfig.heightMultiplier),
                                      child: Radio(
                                        value: 2,
                                        groupValue: radioButtonVal,
                                        onChanged: (value) {
                                          setState(() {
                                            radioButtonVal = value;
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3 * SizeConfig.heightMultiplier),
                        //paymaya
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2 * SizeConfig.widthMultiplier),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 3 * SizeConfig.widthMultiplier,
                                    vertical: 0),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey[400]),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              4 * SizeConfig.widthMultiplier,
                                          vertical: 2.5 *
                                              SizeConfig.heightMultiplier),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 14, 0),
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/paymaya.png'),
                                              height: 4 *
                                                  SizeConfig.heightMultiplier,
                                            ),
                                          ),
                                          Text(
                                            'PayMaya',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Poppins',
                                              fontSize: 1.7 *
                                                  SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              2 * SizeConfig.widthMultiplier,
                                          vertical:
                                              0 * SizeConfig.heightMultiplier),
                                      child: Radio(
                                        value: 3,
                                        groupValue: radioButtonVal,
                                        onChanged: (value) {
                                          setState(() {
                                            radioButtonVal = value;
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3 * SizeConfig.heightMultiplier),
                        //grabpay
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2 * SizeConfig.widthMultiplier),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 3 * SizeConfig.widthMultiplier,
                                    vertical: 0),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey[400]),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              1.5 * SizeConfig.widthMultiplier,
                                          vertical:
                                              3 * SizeConfig.heightMultiplier),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 0, 6, 0),
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/grabpay.png'),
                                              height: 2.2 *
                                                  SizeConfig.heightMultiplier,
                                            ),
                                          ),
                                          Text(
                                            'GrabPay',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Poppins',
                                              fontSize: 1.7 *
                                                  SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              2 * SizeConfig.widthMultiplier,
                                          vertical:
                                              0 * SizeConfig.heightMultiplier),
                                      child: Radio(
                                        value: 4,
                                        groupValue: radioButtonVal,
                                        onChanged: (value) {
                                          setState(() {
                                            radioButtonVal = value;
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]),
                      SizedBox(height: 4 * SizeConfig.heightMultiplier),
                    ],
                  ),
                ),
                SizedBox(height: 3.5 * SizeConfig.heightMultiplier),
                //pay button
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15 * SizeConfig.widthMultiplier),
                      child: ElevatedButton(
                        onPressed: () async {
                          //get new seat list
                          List newListLeftSeat = [];
                          newListLeftSeat.clear();

                          List newRightSeatList = [];
                          newRightSeatList.clear();

                          List newListBottomSeat = [];
                          newListBottomSeat.clear();

                          List newLeftSeatStatus = [];
                          newLeftSeatStatus.clear();

                          List newRightSeatStatus = [];
                          newRightSeatStatus.clear();

                          List newBottomSeatStatus = [];
                          newBottomSeatStatus.clear();

                          final CollectionReference busCollection =
                              FirebaseFirestore.instance.collection('all_trips');

                          var docSnapshot =
                              await busCollection.doc(selectedResBusTripID).get();
                          if (docSnapshot.exists) {
                            Map<String, dynamic> data = docSnapshot.data();
                            newListLeftSeat = List.from(data['List Left Seat']);
                            newRightSeatList = List.from(data['List Right Seat']);
                            newListBottomSeat = List.from(data['List Bottom Seat']);
                            newLeftSeatStatus = List.from(data['Left Seat Status']);
                            newRightSeatStatus = List.from(data['Right Seat Status']);
                            newBottomSeatStatus = List.from(data['Bottom Seat Status']);
                          }
                          print('*** NEW SEATS ***');
                          print('New List Left Seat - ' +
                              newListLeftSeat.toString());
                          print('New Left Seat Status - ' +
                              newLeftSeatStatus.toString());
                          print('New List Right Seat - ' +
                              newRightSeatList.toString());
                          print('New Right Seat Status - ' +
                              newRightSeatStatus.toString());
                          print('New List Bottom Seat - ' +
                              newListBottomSeat.toString());
                          print('New Bottom Seat Status - ' +
                              newBottomSeatStatus.toString());

                          List newAllSeats = [
                            newListLeftSeat,
                            newRightSeatList,
                            newListBottomSeat
                          ].expand((x) => x).toList();
                          print('New All Seats - ' + newAllSeats.toString());

                          //get index of selected seat from all seats
                          List getIndex = [];
                          getIndex.clear();

                          for (int i = 0; i < selectedSeats.length; i++) {
                            for (int j = 0; j < newAllSeats.length; j++) {
                              if (selectedSeats[i] == newAllSeats[j]) {
                                getIndex.insert(i, j.toString());
                              }
                            }
                          }

                          print('Selected Seat - ' + selectedSeats.toString());
                          print('Index from All Seats - ' + getIndex.toString());

                          //get length of each seat list
                          int newListLeftSeatLength = newListLeftSeat.length;
                          int newRightSeatListLength = newRightSeatList.length;
                          int newListBottomSeatLength =
                              newListBottomSeat.length;

                          List seatPosition = [];
                          seatPosition.clear();
                          for (int i = 0; i < getIndex.length; i++){
                            if (int.parse(getIndex[i]) <= newListLeftSeatLength){
                              seatPosition.insert(i, 'Left');
                            } else if (int.parse(getIndex[i]) <= newRightSeatListLength + newListLeftSeatLength){
                              seatPosition.insert(i, 'Right');
                            } else if (int.parse(getIndex[i]) <= newAllSeats.length){
                              seatPosition.insert(i, 'Bottom');
                            }
                          }

                          print('Seat Position - ' + seatPosition.toString());

                          List getEachIndex = [];
                          getEachIndex.clear();
                          for (int i = 0; i < seatPosition.length; i++){
                            if (seatPosition[i].toString() == 'Left'){
                              for (int j = 0; j < newListLeftSeat.length; j++){
                                if (newListLeftSeat[j] == selectedSeats[i]){
                                  getEachIndex.insert(i, j);
                                }
                              }
                            } else if (seatPosition[i].toString() == 'Right'){
                              for (int k = 0; k < newRightSeatList.length; k++){
                                if (newRightSeatList[k] == selectedSeats[i]){
                                  getEachIndex.insert(i, k);
                                }
                              }
                            } else if (seatPosition[i].toString() == 'Bottom'){
                              for (int m = 0; m < newListBottomSeat.length; m++){
                                if (newListBottomSeat[m] == selectedSeats[i]){
                                  getEachIndex.insert(i, m);
                                }
                              }
                            }
                          }

                          print('Index from Each Position - ' + getEachIndex.toString());

                          List getSeatStatus = [];
                          getSeatStatus.clear();
                          for (int i = 0; i < seatPosition.length; i++){
                            if (seatPosition[i].toString() == 'Left'){
                                getSeatStatus.insert(i, newLeftSeatStatus[getEachIndex[i]]);
                            } else if (seatPosition[i].toString() == 'Right'){
                              getSeatStatus.insert(i, newRightSeatStatus[getEachIndex[i]]);
                            } else if (seatPosition[i].toString() == 'Bottom'){
                              getSeatStatus.insert(i, newBottomSeatStatus[getEachIndex[i]]);
                            }
                          }

                          print('Seat Status of Selected Seat - ' + getSeatStatus.toString());

                          var result = getSeatStatus.contains(false);
                          print('Result - ' + result.toString());

                           // if (billingFormName != null) {

                              generateTicketID();
                              bookingStatus = 'Active';
                              present = false;

                              formKey.currentState.save();
                              if (formKey.currentState.validate()) {
                                print(billingFormName);
                                print(billingFormEmail);
                                print(billingFormMobileNum);
                                print(billingFormAddress);

                                if (radioButtonVal == 1) {
                                  print("GCash");
                                  //
                                  //assign payment method
                                  paymentMode = "Gcash";
                                  //
                                  //Assign Billing forms
                                  billing = PayMongoBilling(
                                      name: billingFormName,
                                      email: billingFormEmail,
                                      phone: billingFormMobileNum,
                                      address: PayMongoAddress(
                                          line1: billingFormAddress));
                                  //
                                  if (result == true){
                                    print('Seat taken. Choose a seat again');

                                    setState(() {
                                      listLeftSeat.clear();
                                      listLeftSeat = List.of(newListLeftSeat);
                                      leftSeatStatus.clear();
                                      leftSeatStatus = List.of(newLeftSeatStatus);

                                      rightSeatList.clear();
                                      rightSeatList = List.of(newRightSeatList);
                                      rightSeatStatus.clear();
                                      rightSeatStatus = List.of(newRightSeatStatus);

                                      listBottomSeat.clear();
                                      listBottomSeat = List.of(newListBottomSeat);
                                      bottomSeatStatus.clear();
                                      bottomSeatStatus = List.of(newBottomSeatStatus);

                                      seatsName.clear();
                                      seatsName =
                                          [listLeftSeat, rightSeatList, listBottomSeat].expand((x) => x).toList();

                                      seatsNameStatus.clear();
                                      seatsNameStatus = [leftSeatStatus, rightSeatStatus, bottomSeatStatus]
                                          .expand((x) => x)
                                          .toList();

                                      seatNameDropdownItem.clear();
                                      for (int i = 0; i < seatsName.length; i++) {
                                        if (seatsNameStatus[i].toString() == 'true') {
                                          seatNameDropdownItem.add(seatsName[i].toString());
                                        }
                                      }

                                      selectedSeats.clear();
                                      for (int i = 0; i < valueList.length; i++){
                                        valueList[i] = null;
                                      }
                                      print('Value List: ' + valueList.toString());
                                      pickSeatAgainDialog();
                                    });

                                  } else {
                                    print('Proceed to payment');


                                    updateLeftSeatStatus.clear();
                                    for (int i = 0; i < newLeftSeatStatus.length; i++){
                                      updateLeftSeatStatus.insert(i, newLeftSeatStatus[i]);
                                    }

                                    updateRightSeatStatus.clear();
                                    for (int i = 0; i < newRightSeatStatus.length; i++){
                                      updateRightSeatStatus.insert(i, newRightSeatStatus[i]);
                                    }

                                    updateBottomSeatStatus.clear();
                                    for (int i = 0; i < newBottomSeatStatus.length; i++){
                                      updateBottomSeatStatus.insert(i, newBottomSeatStatus[i]);
                                    }

                                    for (int i = 0; i < seatPosition.length; i++){
                                      if (seatPosition[i].toString() == 'Left'){
                                        for (int j = 0; j < newLeftSeatStatus.length; j++){
                                          updateLeftSeatStatus[getEachIndex[i]] = false;
                                        }
                                      }
                                      if (seatPosition[i].toString() == 'Right'){
                                        for (int j = 0; j < newRightSeatStatus.length; j++){
                                          updateRightSeatStatus[getEachIndex[i]] = false;
                                        }
                                      }
                                      if (seatPosition[i].toString() == 'Bottom'){
                                        for (int j = 0; j < newBottomSeatStatus.length; j++){
                                          updateBottomSeatStatus[getEachIndex[i]] = false;
                                        }
                                      }
                                    }
                                    print('*** UPDATED SEATS ***');
                                    print('Updated Left Seat Status - ' + updateLeftSeatStatus.toString());
                                    print('Updated Right Seat Status - ' + updateRightSeatStatus.toString());
                                    print('Updated Bottom Seat Status - ' + updateBottomSeatStatus.toString());
                                    //payment process
                                    await gcashPayment(billing);
                                  }

                                  //seatsList.clear();
                                }
                                else if (radioButtonVal == 2) {
                                  print("Credit Card");
                                  showAlertDialog();
                                } else if (radioButtonVal == 3) {
                                  print("PayMaya");
                                  showAlertDialog();
                                } else if (radioButtonVal == 4) {
                                  print("GrabPay");
                                  showAlertDialog();
                                } else {
                                  print("No Payment Method Selected");
                                  showNoPaymentDialog();
                                }
                              }
                            // } else {
                            //   showDialog(
                            //     context: context,
                            //     builder: (context) {
                            //       print(paymentString);
                            //       return AlertDialog(
                            //         content: Text(
                            //           '\n Error! Book Again',
                            //           textAlign: TextAlign.center,
                            //           style: TextStyle(
                            //             color: Colors.black,
                            //             fontFamily: 'Poppins',
                            //             fontSize: 2.0 * SizeConfig.textMultiplier,
                            //             fontWeight: FontWeight.w500,
                            //             letterSpacing: 0.1,
                            //           ),
                            //         ),
                            //         elevation: 30.0,
                            //         backgroundColor: Colors.white,
                            //         shape: RoundedRectangleBorder(
                            //             borderRadius: BorderRadius.all(
                            //                 Radius.circular(15.0))),
                            //         actions: [
                            //           Column(
                            //             children: [
                            //               Padding(
                            //                 padding: EdgeInsets.symmetric(
                            //                     horizontal: 4 *
                            //                         SizeConfig.widthMultiplier),
                            //                 child: Divider(
                            //                   color: Colors.grey,
                            //                 ),
                            //               ),
                            //               Row(
                            //                 mainAxisAlignment:
                            //                     MainAxisAlignment.center,
                            //                 children: [
                            //                   TextButton(
                            //                     style: ElevatedButton.styleFrom(
                            //                       minimumSize: Size(
                            //                           70.0 *
                            //                               SizeConfig
                            //                                   .widthMultiplier,
                            //                           5.0 *
                            //                               SizeConfig
                            //                                   .heightMultiplier),
                            //                       primary: Colors.white,
                            //                       shape: RoundedRectangleBorder(
                            //                         borderRadius:
                            //                             BorderRadius.circular(
                            //                                 10.0),
                            //                         side: BorderSide(
                            //                             color: Colors.white),
                            //                       ),
                            //                     ),
                            //                     child: Text(
                            //                       "OK",
                            //                       style: TextStyle(
                            //                         color: Colors.black,
                            //                         fontFamily: 'Poppins',
                            //                         fontSize: 1.8 *
                            //                             SizeConfig.textMultiplier,
                            //                         fontWeight: FontWeight.w500,
                            //                         letterSpacing: 0.1,
                            //                       ),
                            //                     ),
                            //                     onPressed: () {
                            //                       Navigator.of(context)
                            //                           .pushNamedAndRemoveUntil(
                            //                               '/pageOptions',
                            //                               (Route<dynamic>
                            //                                       route) =>
                            //                                   false);
                            //                     },
                            //                   ),
                            //                 ],
                            //               ),
                            //             ],
                            //           ),
                            //         ],
                            //       );
                            //     },
                            //   );
                            // }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(0, 45),
                          primary: AppTheme.greenColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: Colors.transparent)),
                        ),
                        child: Text(
                          'Pay Now',
                          style: AppTheme.buttonText,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5 * SizeConfig.heightMultiplier),
              ]),
        ),
      ),
    );
  }

  void showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            "\nThis payment method is not yet available",
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
      },
    );
  }

  void showNoPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            "\nPlease select a payment method",
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
                      onPressed: () {
                        Navigator.of(context).pop();
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

  void pickSeatAgainDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            "\nSeat/s already taken. Please pick a seat again.",
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
                      onPressed: () {
                        int count = 0;
                        Navigator.popUntil(context, (route) {
                          return count++ == 2;
                        });
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
}
