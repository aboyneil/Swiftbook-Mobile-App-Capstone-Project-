import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swiftbook/booking/billingForm.dart';
import 'package:swiftbook/booking/passengerForm.dart';
import 'package:swiftbook/globals.dart';
import 'package:swiftbook/styles/size-config.dart';
import 'package:swiftbook/styles/style.dart';

class GenerateRowsCol extends StatefulWidget {
  const GenerateRowsCol({Key key}) : super(key: key);

  @override
  _GenerateRowsColState createState() => _GenerateRowsColState();
}

class _GenerateRowsColState extends State<GenerateRowsCol> {
  final List<GlobalKey<FormState>> formKeyList =
      List.generate(seatCounter, (index) => GlobalKey<FormState>());

  int j = 0;
  int k = 0;
  int m = 0;

  String error = '';

  @override
  Widget build(BuildContext context) {
    print('*** Generate Rows & Col ***');
    print('Left Col Size: ' + '$leftColSize');
    print('Left Row Size: ' + '$leftRowSize');
    print('Right Col Size: ' + '$rightColSize');
    print('Right Row Size: ' + '$rightRowSize');
    print('Bottom Col Size: ' + '$bottomColSize');
    print('List Right Seat: ' + rightSeatList.toString());
    print('Right Seat Status: ' + rightSeatStatus.toString());
    print('List Left Seat: ' + listLeftSeat.toString());
    print('Left Seat Status: ' + leftSeatStatus.toString());
    print('List Bottom Seat: ' + listBottomSeat.toString());
    print('Bottom Seat Status: ' + bottomSeatStatus.toString());
    print('Seat Name All True: ' + seatNameDropdownItem.toString());
    print('Selected Seats: ' + selectedSeats.toString());
    print('Value List: ' + valueList.toString());

    return Scaffold(
      body: SafeArea(
        bottom: false,
        left: false,
        right: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                          //Navigator.of(context).pop();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'PICK A SEAT',
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
              SizedBox(height: 2 * SizeConfig.heightMultiplier),
              Container(
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
                    SizedBox(height: 3 * SizeConfig.heightMultiplier),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        //available
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 0.5 * SizeConfig.widthMultiplier,
                              ),
                              child: Container(
                                width: 6.0 * SizeConfig.widthMultiplier,
                                height: 3.0 * SizeConfig.heightMultiplier,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 1 * SizeConfig.widthMultiplier,
                                    vertical: 0),
                                decoration: BoxDecoration(
                                  color: AppTheme.greenColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Available',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                    fontSize: 1.5 * SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        //taken
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 0.5 * SizeConfig.widthMultiplier,
                              ),
                              child: Container(
                                width: 6.0 * SizeConfig.widthMultiplier,
                                height: 3.0 * SizeConfig.heightMultiplier,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 1 * SizeConfig.widthMultiplier,
                                    vertical: 0),
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Taken',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                    fontSize: 1.5 * SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 2 * SizeConfig.heightMultiplier),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6 * SizeConfig.widthMultiplier,
                      ),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 3 * SizeConfig.heightMultiplier),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Front',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontSize: 2.0 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8 * SizeConfig.widthMultiplier,
                      ),
                      child: Row(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    height: 3 * SizeConfig.heightMultiplier),
                                ListView.separated(
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                          height:
                                              2 * SizeConfig.heightMultiplier),
                                  itemCount: leftRowSize,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          2 * SizeConfig.widthMultiplier,
                                          0,
                                          0,
                                          0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          leftSideSeats(),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    height: 3 * SizeConfig.heightMultiplier),
                                ListView.separated(
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                          height:
                                              2 * SizeConfig.heightMultiplier),
                                  itemCount: rightRowSize,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0,
                                          0 * SizeConfig.widthMultiplier, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          rightSideSeats(),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8 * SizeConfig.heightMultiplier),
                    //bottom seat
                    ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: 3 * SizeConfig.widthMultiplier),
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(
                              0, 0, 0 * SizeConfig.widthMultiplier, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              bottomSeat(),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 3 * SizeConfig.heightMultiplier),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Back',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontSize: 2.0 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    SizedBox(height: 3 * SizeConfig.heightMultiplier),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6 * SizeConfig.widthMultiplier,
                      ),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 2 * SizeConfig.heightMultiplier),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 9 * SizeConfig.widthMultiplier),
                      child: SizedBox(
                        width: 90 * SizeConfig.widthMultiplier,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'NOTE :  Select your seat number below.',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontSize: 1.7 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 3 * SizeConfig.heightMultiplier),
                  ],
                ),
              ),
              SizedBox(height: 5 * SizeConfig.heightMultiplier),
              //passenger dropdown list
              Container(
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
                    SizedBox(height: 4 * SizeConfig.heightMultiplier),
                    ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: seatCounter,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 3 * SizeConfig.heightMultiplier),
                        itemBuilder: (context, index) {
                          print('List View Builder Index: ' + '$index');
                          return Form(
                            key: formKeyList[index],
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                    height: 1 * SizeConfig.heightMultiplier),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          9 * SizeConfig.widthMultiplier),
                                  child: SizedBox(
                                    width: 100 * SizeConfig.widthMultiplier,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Passenger " + (index + 1).toString(),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Poppins',
                                          fontSize:
                                              1.4 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height: 1 * SizeConfig.heightMultiplier),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          5 * SizeConfig.widthMultiplier),
                                  child: DropdownButtonFormField(
                                    onChanged: (val) {
                                      setState(() {
                                        //seatSelected.insert(index, val);
                                        valueList[index] = val;
                                        print('Value List - ' + valueList.toString());
                                      });
                                    },
                                    value: valueList[index], //seatSelected[index],
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Select a field';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (val) {
                                      selectedSeats.insert(index, val);
                                    },
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: AppTheme.greenColor,
                                      size: 7 * SizeConfig.imageSizeMultiplier,
                                    ),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(0, 189, 56, 1.0),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  Colors.red.withOpacity(0.8)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  Colors.red.withOpacity(0.8)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
                                    ),
                                    isExpanded: true,
                                    isDense: true,
                                    items: seatNameDropdownItem.map((item) {
                                      return new DropdownMenuItem<String>(
                                        child: Row(
                                          children: [
                                            Text(item.toString()),
                                          ],
                                        ),
                                        value: item,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                    SizedBox(height: 2.5 * SizeConfig.heightMultiplier),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 9 * SizeConfig.widthMultiplier),
                      child: SizedBox(
                        width: 100 * SizeConfig.widthMultiplier,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            error,
                            style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Poppins',
                              fontSize: 1.4 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 3 * SizeConfig.heightMultiplier),
                  ],
                ),
              ),
              SizedBox(height: 5 * SizeConfig.heightMultiplier),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15 * SizeConfig.widthMultiplier),
                      child: ElevatedButton(
                        onPressed: () {
                          selectedSeats.clear();
                          List<bool> validateForm = [];
                          for (int i = 0; i < formKeyList.length; i++) {
                            formKeyList[i].currentState.save();
                            if (formKeyList[i].currentState.validate()) {
                              validateForm.insert(i, formKeyList[i].currentState.validate());
                            } else {
                              validateForm.insert(i, false);
                            }
                          }
                          print('Selected Seats: ' + selectedSeats.toString());
                          var valFormRes = validateForm.every((element) => element == true);
                          print('Validate - ' + validateForm.toString());
                          print('Validate Form Result - ' + '$valFormRes');

                          if (valFormRes == true) {
                            final noDuplicate = selectedSeats.toSet().toList();
                            print(noDuplicate);

                            if (selectedSeats.length != noDuplicate.length) {
                              setState(() {
                                error =
                                'Duplicate seats are not allowed. Please choose another seat.';
                              });
                              print(error);
                            } else {
                              setState(() {
                                error = '';
                              });
                              print('None');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BillingForm()))
                                  .then((value) {
                                setState(() {});
                              });
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
                    SizedBox(height: 7 * SizeConfig.heightMultiplier),
                  ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget leftSideSeats() {
    List<Widget> list = <Widget>[];
    for (var i = 0; i < leftColSize; i++) {
      list.add(
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 0.5 * SizeConfig.widthMultiplier,
          ),
          child: Container(
            width: 10.0 * SizeConfig.widthMultiplier,
            height: 5.5 * SizeConfig.heightMultiplier,
            margin: EdgeInsets.symmetric(
                horizontal: 1 * SizeConfig.widthMultiplier, vertical: 0),
            decoration: BoxDecoration(
              color: leftSeatStatus[j] == true ? AppTheme.greenColor : Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  listLeftSeat[j].toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 1.8 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      j++;
      if (j == listLeftSeat.length) {
        j = 0;
      }
    }
    return new Row(children: list);
  }

  Widget rightSideSeats() {
    List<Widget> list = <Widget>[];
    for (var i = 0; i < rightColSize; i++) {
      list.add(
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 0.5 * SizeConfig.widthMultiplier,
          ),
          child: Container(
            width: 10.0 * SizeConfig.widthMultiplier,
            height: 5.5 * SizeConfig.heightMultiplier,
            margin: EdgeInsets.symmetric(
                horizontal: 1 * SizeConfig.widthMultiplier, vertical: 0),
            decoration: BoxDecoration(
              color: rightSeatStatus[k] == true
                  ? AppTheme.greenColor
                  : Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  rightSeatList[k].toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 1.8 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      k++;
      if (k == rightSeatList.length) {
        k = 0;
      }
    }
    return new Row(children: list);
  }

  Widget bottomSeat() {
    List<Widget> list = <Widget>[];
    for (var i = 0; i < listBottomSeat.length; i++) {
      list.add(
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 1 * SizeConfig.widthMultiplier,
          ),
          child: Container(
            width: 10.0 * SizeConfig.widthMultiplier,
            height: 5.5 * SizeConfig.heightMultiplier,
            margin: EdgeInsets.symmetric(
                horizontal: 1 * SizeConfig.widthMultiplier, vertical: 0),
            decoration: BoxDecoration(
              color: bottomSeatStatus[m] == true
                  ? AppTheme.greenColor
                  : Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  listBottomSeat[m].toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 1.8 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      m++;
      if (m == listBottomSeat.length) {
        m = 0;
      }
    }
    return new Row(children: list);
  }
}
