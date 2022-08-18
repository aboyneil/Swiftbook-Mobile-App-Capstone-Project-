import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swiftbook/booking/billingForm.dart';
import 'package:swiftbook/booking/generateRowsCol.dart';
import 'package:swiftbook/services/database.dart';
import 'package:swiftbook/styles/size-config.dart';
import 'package:swiftbook/styles/style.dart';
import 'package:swiftbook/globals.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swiftbook/string_extension.dart';

class PassengerForm extends StatefulWidget {
  @override
  _PassengerFormState createState() => _PassengerFormState();
}

final DatabaseService db = DatabaseService();

class _PassengerFormState extends State<PassengerForm> {
  final List<GlobalKey<FormState>> formKeyList =
      List.generate(seatCounter, (index) => GlobalKey<FormState>());

  List verifiedDiscountID = [];
  List verifiedDiscountIDDocID = [];

  //increment number of baggage
  void incrementSeat() {
    setState(() {
      selectedBaggageNum++;
    });
  }

  //decrement number of baggage
  void decrementSeat() {
    if (selectedBaggageNum > minBaggage) {
      setState(() {
        selectedBaggageNum--;
      });
    }
  }

  //List<String> tempDiscount = [];

  Future<void> getDiscount() async {
    String tempUID;
    for (int i = 0; i < passengerType.length; i++) {
      var result = await FirebaseFirestore.instance
          .collection(
              selectedResBusCompanyName.toLowerCase() + "_priceCategories")
          .where('category', isEqualTo: passengerType[i])
          .get();
      result.docs.forEach((val) {
        tempUID = val.id;
      });
      var dbResult = await FirebaseFirestore.instance
          .collection(
              selectedResBusCompanyName.toLowerCase() + "_priceCategories")
          .doc(tempUID)
          .get();
      setState(() {
        listDiscount.insert(i, dbResult.get('discount'));
      });
    }
    print('List Discount - ' + listDiscount.toString());
  }

  Future<void> getVerifiedDiscountID() async {
    verifiedDiscountIDDocID.clear();
    verifiedDiscountID.clear();
    for (int i = 0; i < formKeyList.length; i++) {
      var result = await FirebaseFirestore.instance
          .collection('all_discountIDs')
          .where('discount ID', isEqualTo: passengerDiscountID[i])
          .get();

      result.docs.forEach((val) {
        verifiedDiscountIDDocID.insert(i, val.id);
        verifiedDiscountID.insert(i, val.data()['discount ID']);
      });
    }
    print('Verified Discount Doc ID - ' + verifiedDiscountIDDocID.toString());
    print('Verified Discount ID - ' + verifiedDiscountID.toString());
  }

  Future<void> getListRightSeat() async {
    rightSeatList.clear();
    final CollectionReference busCollection =
        FirebaseFirestore.instance.collection('all_trips');

    var docSnapshot = await busCollection.doc(selectedResBusTripID).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data();
      rightSeatList = List.from(data['List Right Seat']);
    }
  }

  Future<void> getListLeftSeatList() async {
    listLeftSeat.clear();
    final CollectionReference busCollection =
        FirebaseFirestore.instance.collection('all_trips');

    var docSnapshot = await busCollection.doc(selectedResBusTripID).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data();
      listLeftSeat = List.from(data['List Left Seat']);
    }
  }

  Future<void> getLeftSeatStatus() async {
    leftSeatStatus.clear();
    final CollectionReference busCollection =
        FirebaseFirestore.instance.collection('all_trips');

    var docSnapshot = await busCollection.doc(selectedResBusTripID).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data();
      leftSeatStatus = List.from(data['Left Seat Status']);
    }
  }

  Future<void> getRightSeatStatus() async {
    rightSeatStatus.clear();
    final CollectionReference busCollection =
        FirebaseFirestore.instance.collection('all_trips');

    var docSnapshot = await busCollection.doc(selectedResBusTripID).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data();
      rightSeatStatus = List.from(data['Right Seat Status']);
    }
  }

  Future<void> getRowColSize() async {
    final CollectionReference busCollection = FirebaseFirestore.instance
        .collection('$selectedResBusCompanyName' + '_bus');

    var docSnapshot = await busCollection.doc(busDocID).get();

    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data();
      leftColSize = data['Left Col Size'];
      leftRowSize = data['Left Row Size'];
      rightColSize = data['Right Col Size'];
      rightRowSize = data['Right Row Size'];
      bottomColSize = data['Bottom Col Size'];
    }
  }

  Future<void> getListBottomSeat() async {
    listBottomSeat.clear();
    final CollectionReference busCollection =
        FirebaseFirestore.instance.collection('all_trips');

    var docSnapshot = await busCollection.doc(selectedResBusTripID).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data();
      listBottomSeat = List.from(data['List Bottom Seat']);
    }
  }

  Future<void> getBottomSeatStatus() async {
    bottomSeatStatus.clear();
    final CollectionReference busCollection =
        FirebaseFirestore.instance.collection('all_trips');

    var docSnapshot = await busCollection.doc(selectedResBusTripID).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data();
      bottomSeatStatus = List.from(data['Bottom Seat Status']);
    }
  }

  void generateDropdownItem() {
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
    print('Seat Name All True: ' + seatNameDropdownItem.toString());
  }

  double pesoPerBaggageDouble = 0;

  @override
  Widget build(BuildContext context) {
    baseFare = double.parse(selectedResPriceDetails);
    percentageDiscount = 0;
    selectedPercentageDiscount = 0;
    selectedBaggageNum = minBaggage;
    pesoPerBaggageDouble = double.parse('$pesoPerBaggage');

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
                          Navigator.pop(context);
                          selectedPassengerCategory = null;
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'PASSENGER FORM',
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
              //bus booking details
              Column(
                children: [
                  Container(
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
                          blurRadius: 4,
                          offset: Offset(0, 1.5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 1 * SizeConfig.heightMultiplier),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 8 * SizeConfig.widthMultiplier,
                                  top: 1 * SizeConfig.heightMultiplier),
                              child: Text(
                                selectedResBusCompanyName.toUpperCase(),
                                style: TextStyle(
                                  color: AppTheme.greenColor,
                                  fontFamily: 'Poppins',
                                  fontSize: 2 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 8 * SizeConfig.widthMultiplier,
                                  top: 1 * SizeConfig.heightMultiplier),
                              child: Text(
                                selectedResBusClass.toLowerCase().titleCase,
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontFamily: 'Poppins',
                                    fontSize: 1.8 * SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6 * SizeConfig.widthMultiplier,
                          ),
                          child: Divider(
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8 * SizeConfig.widthMultiplier,
                              vertical: 0 * SizeConfig.heightMultiplier),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        fontSize:
                                            1.5 * SizeConfig.textMultiplier,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: selectedResDepartureDate + "\n",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Poppins',
                                            fontSize:
                                                1.5 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.1,
                                          ),
                                        ),
                                        //time
                                        TextSpan(
                                          text: 'Time: ',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'Poppins',
                                            fontSize:
                                                1.5 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: selectedResDepartureTime + "\n",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Poppins',
                                            fontSize:
                                                1.5 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.7,
                                          ),
                                        ),
                                        //seats
                                        TextSpan(
                                          text: 'Seat/s: ',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'Poppins',
                                            fontSize:
                                                1.5 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '$seatCounter' + "\n",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Poppins',
                                            fontSize:
                                                1.5 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.7,
                                          ),
                                        ),
                                        //bus type
                                        //bus type
                                        TextSpan(
                                          text: 'Bus Type: ',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'Poppins',
                                            fontSize:
                                                1.5 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: selectedResBusType + '\n',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Poppins',
                                            fontSize:
                                                1.5 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        //terminal
                                        TextSpan(
                                          text: 'Terminal: ',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'Poppins',
                                            fontSize:
                                                1.5 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: selectedResTerminalName,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Poppins',
                                            fontSize:
                                                1.5 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.w500,
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
                                                SizeConfig.imageSizeMultiplier,
                                          ),

                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 2 *
                                                    SizeConfig.widthMultiplier),
                                            child: Text(
                                              selectedResOriginRoute
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontFamily: 'Poppins',
                                                fontSize: 1.8 *
                                                    SizeConfig.textMultiplier,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 2 * SizeConfig.heightMultiplier,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          //child:
                                          Icon(
                                            Icons.location_on_sharp,
                                            color: AppTheme.greenColor,
                                            size: 6 *
                                                SizeConfig.imageSizeMultiplier,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 2 *
                                                    SizeConfig.widthMultiplier),
                                            child: Text(
                                              selectedResDestinationRoute
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontFamily: 'Poppins',
                                                fontSize: 1.8 *
                                                    SizeConfig.textMultiplier,
                                                fontWeight: FontWeight.bold,
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
                            horizontal: 6 * SizeConfig.widthMultiplier,
                          ),
                          child: Divider(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 1 * SizeConfig.heightMultiplier),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8 * SizeConfig.widthMultiplier,
                          ),
                          child: Column(
                            children: [
                              //subtotal
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
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: 0.5 * SizeConfig.heightMultiplier),
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
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: 0.8 * SizeConfig.heightMultiplier),
                              //total fare
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    //'PHP ' + totalFare.toStringAsFixed(2),
                                    'PHP ' +
                                        (baseFare * seatCounter.toDouble())
                                            .toStringAsFixed(2),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontSize: 2.3 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 1.8 * SizeConfig.heightMultiplier),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4 * SizeConfig.heightMultiplier),
              Column(
                children: [
                  passengerForm(),
                  SizedBox(height: 1.5 * SizeConfig.heightMultiplier),
                ],
              ),
              SizedBox(height: 4 * SizeConfig.heightMultiplier),
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
                  Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 15 * SizeConfig.widthMultiplier),
                  child: ElevatedButton(
                    onPressed: () async {
                      print(
                          'List of Baggage - ' + baggageNumberList.toString());
                      passengerType.clear();
                      passengerFirstName.clear();
                      passengerLastName.clear();
                      passengerEmailAddress.clear();
                      passengerMobileNum.clear();
                      listDiscount.clear();
                      passengerDiscountID.clear();
                      List<bool> validateForm = [];
                      for (int i = 0; i < formKeyList.length; i++) {
                        formKeyList[i].currentState.save();
                        if (formKeyList[i].currentState.validate()) {
                          validateForm.insert(
                              i, formKeyList[i].currentState.validate());
                        } else {
                          validateForm.insert(i, false);
                        }
                      }

                      print('*** PASSENGER DETAILS ***');
                      print('Passenger Type - ' + passengerType.toString());
                      print('Passenger First Name - ' +
                          passengerFirstName.toString());
                      print('Passenger Last Name - ' +
                          passengerLastName.toString());
                      print('Passenger Email Address - ' +
                          passengerEmailAddress.toString());
                      print('Passenger Mobile Num - ' +
                          passengerMobileNum.toString());
                      print('Passenger Discount ID - ' +
                          passengerDiscountID.toString());

                      var valFormRes =
                          validateForm.every((element) => element == true);
                      print('Validate - ' + validateForm.toString());
                      print('Validate Form Result - ' + '$valFormRes');

                      if (valFormRes == true) {
                        valueList = List.generate(seatCounter, (index) => null);
                        await getRowColSize();
                        await getListLeftSeatList();
                        await getLeftSeatStatus();
                        await getListRightSeat();
                        await getRightSeatStatus();
                        await getListBottomSeat();
                        await getBottomSeatStatus();
                        await getVerifiedDiscountID();
                        generateDropdownItem();
                        getDiscount();
                        if (verifiedDiscountID.isNotEmpty) {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GenerateRowsCol()))
                              .then((value) {
                            setState(() {});
                          });
                        } else if (verifiedDiscountID.isEmpty) {
                          discountIDNotVerifiedDialog();
                        }
                      } else {
                        print('Validate Form Result - ' + '$valFormRes');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(0, 45),
                      primary: AppTheme.greenColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(color: Colors.transparent)),
                    ),
                    child: Text(
                      'Next',
                      style: AppTheme.buttonText,
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 4 * SizeConfig.heightMultiplier),
            ],
          ),
        ),
      ),
    );
  }

  Widget passengerForm() {
    return ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: formKeyList.length,
        separatorBuilder: (context, index) =>
            SizedBox(height: 4 * SizeConfig.heightMultiplier),
        itemBuilder: (context, index) {
          //print('List View Builder Index: ' + formKeyList[index].toString());
          //print(selectedResBusCompanyName);
          return Column(
            children: [
              Container(
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
                child: Form(
                  key: formKeyList[index],
                  child: Column(children: <Widget>[
                    SizedBox(height: 2 * SizeConfig.heightMultiplier),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 4 * SizeConfig.widthMultiplier),
                      child: Text(
                        //"PASSENGER",
                        "Passenger " + (index + 1).toString(),
                        style: TextStyle(
                            letterSpacing: 1.2,
                            color: AppTheme.greenColor,
                            fontFamily: 'Poppins',
                            fontSize: 2.2 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(height: 0.5 * SizeConfig.heightMultiplier),
                    //passenger category
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 5 * SizeConfig.widthMultiplier),
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('$selectedResBusCompanyName' +
                                  '_priceCategories')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CupertinoActivityIndicator(),
                              );
                            } else {
                              return DropdownButtonFormField(
                                value: selectedPassengerCategory,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null) {
                                    return 'Select a field';
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.fromLTRB(
                                      5 * SizeConfig.widthMultiplier,
                                      2 * SizeConfig.heightMultiplier,
                                      2.5 * SizeConfig.widthMultiplier,
                                      2 * SizeConfig.heightMultiplier),
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red.withOpacity(0.8)),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                ),
                                isExpanded: true,
                                isDense: true,
                                //iconSize: 5 * SizeConfig.imageSizeMultiplier,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: AppTheme.greenColor,
                                  size: 7 * SizeConfig.imageSizeMultiplier,
                                ),
                                hint: Text(
                                  "Passenger",
                                  style: AppTheme.formLabelText,
                                ),
                                onChanged: (val) async {
                                  print('Passenger Type ' +
                                      '$index' +
                                      ': ' +
                                      '$val');
                                },
                                onSaved: (val) {
                                  passengerType.insert(index, val);
                                },
                                items: snapshot.data.docs
                                    .map((DocumentSnapshot docs) {
                                  return new DropdownMenuItem<String>(
                                    value: docs['category'],
                                    child: new Text(
                                      docs['category'].toUpperCase(),
                                      style: AppTheme.selectedBusDeetsText,
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                          }),
                    ),
                    SizedBox(height: 3.0 * SizeConfig.heightMultiplier),
                    //First name
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 5 * SizeConfig.widthMultiplier),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        //controller: _passengerFname,
                        keyboardType: TextInputType.name,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Please enter your first name";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) {
                          setState(() {
                            passengerFirstName.insert(index, val);
                          });
                        },
                        onTap: () {
                          InputDecoration(
                            hintText: 'First Name',
                            hintStyle: AppTheme.formHintText,
                          );
                        },
                        style: AppTheme.formInputText,
                        decoration: InputDecoration(
                          labelText: 'First Name',
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
                    //Last name
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 5 * SizeConfig.widthMultiplier),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        //controller: _passengerLname,
                        keyboardType: TextInputType.name,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Please enter your last name";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) {
                          setState(() {
                            passengerLastName.insert(index, val);
                          });
                        },
                        onTap: () {
                          InputDecoration(
                            hintText: 'Last Name',
                            hintStyle: AppTheme.formHintText,
                          );
                        },
                        style: AppTheme.formInputText,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        //controller: _passengerEmail,
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
                        // onChanged: (val) {
                        //   setState(() {
                        //     emailAddress.add(val);
                        //   });
                        // },
                        onSaved: (val) {
                          setState(() {
                            passengerEmailAddress.insert(index, val);
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
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(0, 189, 56, 1.0),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        //controller: _passengerMobileNum,
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
                        onSaved: (val) {
                          setState(() {
                            passengerMobileNum.insert(index, val);
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
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(0, 189, 56, 1.0),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
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
                    SizedBox(height: 3 * SizeConfig.heightMultiplier),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8 * SizeConfig.widthMultiplier),
                      child: SizedBox(
                        width: 100 * SizeConfig.widthMultiplier,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '*If you are using the discount ID to book for the first time, kindly book '
                            'through the ticketing clerk at the terminal to verify your ID.\n\n'
                            '*Kindly enter your discount ID if it has already been verified by the ticketing clerk.',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontSize: 1.4 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2 * SizeConfig.heightMultiplier),
                    //discount id
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 5 * SizeConfig.widthMultiplier),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        onSaved: (val) {
                          if (val.isEmpty) {
                            val = 'None';
                            passengerDiscountID.insert(index, val);
                          } else {
                            passengerDiscountID.insert(index, val);
                          }
                        },
                        onTap: () {
                          InputDecoration(
                            hintText: 'Discount ID',
                            hintStyle: AppTheme.formHintText,
                          );
                        },
                        style: AppTheme.formInputText,
                        decoration: InputDecoration(
                          labelText: 'Discount ID',
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
                    SizedBox(height: 4 * SizeConfig.heightMultiplier),
                    //SizedBox(height: 4 * SizeConfig.heightMultiplier),
                  ]),
                ),
              ),
              companyBaggage == true
                  ? Column(
                      children: [
                        SizedBox(height: 2 * SizeConfig.heightMultiplier),
                        Container(
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
                                blurRadius: 4,
                                offset: Offset(
                                    0, 1.5), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5 * SizeConfig.widthMultiplier,
                                  vertical: 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                      height: 2 * SizeConfig.heightMultiplier),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 5 * SizeConfig.widthMultiplier,
                                          top: 5 * SizeConfig.widthMultiplier,
                                          bottom:
                                              5 * SizeConfig.widthMultiplier,
                                        ),
                                        child: Text(
                                          // "Baggage\n PHP " +
                                          //     pesoPerBaggageDouble.toStringAsFixed(2) +
                                          //     '/1 kg',
                                          'Baggage',
                                          style: AppTheme.formInputText,
                                        ),
                                      ),
                                      //add number of seat
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          //minus number of seat
                                          Padding(
                                              padding: EdgeInsets.only(
                                                right: 0 *
                                                    SizeConfig.widthMultiplier,
                                              ),
                                              child: Center(
                                                  child: IconButton(
                                                icon:
                                                    Icon(Icons.remove_rounded),
                                                iconSize: 8 *
                                                    SizeConfig
                                                        .imageSizeMultiplier,
                                                color: AppTheme.greenColor,
                                                onPressed: () {
                                                  if (baggageNumberList[index] >
                                                      minBaggage) {
                                                    setState(() {
                                                      baggageNumberList[
                                                          index]--;
                                                    });
                                                  }
                                                  baggageNumberList[index] =
                                                      baggageNumberList[index];
                                                },
                                              ))),

                                          Padding(
                                            padding: EdgeInsets.only(
                                              right: 0 *
                                                  SizeConfig.widthMultiplier,
                                            ),
                                            child: Container(
                                              width: 18 *
                                                  SizeConfig.widthMultiplier,
                                              height: 11.5 *
                                                  SizeConfig.widthMultiplier,
                                              margin: EdgeInsets.all(0),
                                              padding: EdgeInsets.all(0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: AppTheme.lightGreen
                                                    .withOpacity(1.0),
                                              ),
                                              child: Center(
                                                child: TextFormField(
                                                  readOnly: true,
                                                  //enabled: false,
                                                  //textAlign: TextAlign.center,
                                                  onTap: () {
                                                    InputDecoration(
                                                      //hintText: 'Discount ID',
                                                      hintStyle:
                                                          AppTheme.formHintText,
                                                    );
                                                  },
                                                  style: AppTheme.formInputText,
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        baggageNumberList[index]
                                                                .toString() +
                                                            ' kg',
                                                    labelStyle: TextStyle(
                                                      color:
                                                          AppTheme.greenColor,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 2 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                      //letterSpacing: 2,
                                                    ),
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 2.5 *
                                                          SizeConfig
                                                              .widthMultiplier,
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.0)),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    30))),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Color.fromRGBO(
                                                                    0,
                                                                    189,
                                                                    56,
                                                                    0.0)),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    30))),
                                                    errorBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.red
                                                                .withOpacity(
                                                                    0.0)),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    30))),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Colors
                                                                    .red
                                                                    .withOpacity(
                                                                        0.0)),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            30))),
                                                  ),
                                                ),
                                                // Text(
                                                //   baggageNumberList[index].toString(),
                                                //   style: TextStyle(
                                                //     color: AppTheme.greenColor,
                                                //     fontFamily: 'Poppins',
                                                //     fontWeight: FontWeight.bold,
                                                //     fontSize: 3 * SizeConfig.textMultiplier,
                                                //     letterSpacing: 2,
                                                //   ),
                                                // ),
                                              ),
                                            ),
                                          ),
                                          //add number of seat
                                          Padding(
                                              padding: EdgeInsets.only(
                                                right: 0 *
                                                    SizeConfig.widthMultiplier,
                                              ),
                                              child: Center(
                                                  child: IconButton(
                                                icon: Icon(Icons.add_rounded),
                                                iconSize: 7 *
                                                    SizeConfig
                                                        .imageSizeMultiplier,
                                                color: AppTheme.greenColor,
                                                onPressed: () {
                                                  if (baggageNumberList[index] <
                                                      maxBaggage) {
                                                    setState(() {
                                                      baggageNumberList[
                                                          index]++;
                                                    });
                                                  }
                                                  baggageNumberList[index] =
                                                      baggageNumberList[index];
                                                },
                                              ))),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height: 2 * SizeConfig.heightMultiplier),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            4 * SizeConfig.widthMultiplier),
                                    child: SizedBox(
                                      width: 100 * SizeConfig.widthMultiplier,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '* Minimum Baggage per passenger is ' +
                                              '$minBaggage' +
                                              'kg\n' +
                                              '* Maximum Baggage per passenger is ' +
                                              '$maxBaggage' +
                                              'kg\n' +
                                              '* Extra Baggage = PHP ' +
                                              pesoPerBaggageDouble
                                                  .toStringAsFixed(2) +
                                              '/1 kg',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Poppins',
                                            fontSize:
                                                1.4 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          2.5 * SizeConfig.heightMultiplier),
                                ],
                              )),
                        ),
                      ],
                    )
                  : SizedBox(height: 0 * SizeConfig.heightMultiplier),
            ],
          );
        });
  }

  void discountIDNotVerifiedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            "\nYour discount ID is not yet verified. To verify, kindly go first to the terminal and present your ID to the clerk.",
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
                        Navigator.pop(context);
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
