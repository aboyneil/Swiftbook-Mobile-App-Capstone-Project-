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

class RebookBillingForm extends StatefulWidget {
  const RebookBillingForm({Key key}) : super(key: key);

  @override
  _RebookBillingFormState createState() => _RebookBillingFormState();
}

class _RebookBillingFormState extends State<RebookBillingForm>
    with PaymongoEventHandler {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var billing = PayMongoBilling(
      name: '', email: '', phone: '', address: PayMongoAddress(line1: ''));

  int radioButtonVal = 0;

  @override
  Widget build(BuildContext context) {
    DateTime selectedDateParsed = DateTime.parse(
        selectedRebookDepartureDate);
    DateTime selectedTimeParsed = DateTime.parse(
        selectedRebookDepartureTime);
    double rebookPriceDouble = 0;
    rebookPriceDouble = double.parse(selectedRebookPrice);
    double rebookingFeeDouble = 0;
    rebookingFeeDouble = double.parse('$companyRebookingFee');
    totalPrice = 0;
    totalPrice = rebookingFeeDouble + (100 - rebookingFeeDouble);
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
                              "Rebook Billing Form".toUpperCase(),
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
                                setState(() => rebookBillingFormName = val);
                              },
                              onSaved: (val) {
                                setState(() => rebookBillingFormName = val);
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
                                  rebookBillingFormEmail = val;
                                });
                              },
                              onSaved: (val) {
                                setState(() {
                                  rebookBillingFormEmail = val;
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
                                  rebookBillingFormMobileNum = val;
                                });
                              },
                              onSaved: (val) {
                                setState(() {
                                  rebookBillingFormMobileNum = val;
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
                                setState(() => rebookBillingFormAddress = val);
                              },
                              onSaved: (val) {
                                setState(() => rebookBillingFormAddress = val);
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
                            "Rebooked Trip Details".toUpperCase(),
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
                                    toRebookOrigin.toString().toUpperCase(),
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
                                    toRebookDestination
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
                        SizedBox(height: 2 * SizeConfig.heightMultiplier),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8 * SizeConfig.widthMultiplier,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Departure Date :',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontSize: 1.8 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('MMMM d y').format(
                                        selectedDateParsed),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontSize: 1.8 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Departure Time :',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontSize: 1.8 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    DateFormat.jm().format(
                                        selectedTimeParsed),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontSize: 1.8 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
                                    rebookPriceDouble.toStringAsFixed(2),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontSize: 1.8 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
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
                                'REBOOKING FEE :',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontSize: 2 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
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
                          formKey.currentState.save();
                          rebookFlag = 1;
                          if (formKey.currentState.validate()) {
                            print(rebookBillingFormName);
                            print(rebookBillingFormEmail);
                            print(rebookBillingFormMobileNum);
                            print(rebookBillingFormAddress);
                            print('Rebook Company Name - ' + '$selectedRebookCompanyName');
                            print('Rebook Booking Form ID - ' + '$rebookBookingFormID');
                            print('Rebook Date - ' + '$selectedRebookDepartureDate');
                            print('Rebook Time - ' + '$selectedRebookDepartureTime');

                            if (radioButtonVal == 1) {
                              print("GCash");
                              //
                              //assign payment method
                              paymentMode = "Gcash";
                              //
                              //Assign Billing forms
                              billing = PayMongoBilling(
                                  name: rebookBillingFormName,
                                  email: rebookBillingFormEmail,
                                  phone: rebookBillingFormMobileNum,
                                  address: PayMongoAddress(
                                      line1: rebookBillingFormAddress));
                              //payment process
                              await gcashPayment(billing);
                            }

                            //seatsList.clear();
                          } else if (radioButtonVal == 2) {
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
}
