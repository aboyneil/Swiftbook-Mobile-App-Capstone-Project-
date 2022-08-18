import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:swiftbook/profile/userProfile.dart';
import 'package:swiftbook/services/database.dart';
import 'package:swiftbook/shared/loading.dart';
import 'package:swiftbook/styles/style.dart';
import 'package:swiftbook/styles/size-config.dart';
import 'package:swiftbook/globals.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swiftbook/models/user.dart';
import 'package:swiftbook/string_extension.dart';

class EditUserProfile extends StatefulWidget {
  @override
  _EditUserProfileState createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _fname = TextEditingController();
  final TextEditingController _lname = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _mobileNum = TextEditingController();
  final TextEditingController _birthDate = TextEditingController();
  //QuinString email = '';

  String displayEmail = '';
  String displayFirstName = '';
  String displayLastName = '';
  String displayMobileNum = '';
  String displayUsername = '';
  String displayBirthDate = '';

  //get user data
  Future<void> getUserData() async {
    User user = FirebaseAuth.instance.currentUser;
    var userInfo = await FirebaseFirestore.instance
        .collection('mobile users')
        .doc(user.uid)
        .get();
    setState(() {
      displayEmail = userInfo['email'];
      displayFirstName = userInfo['firstName'];
      displayLastName = userInfo['lastName'];
      displayMobileNum = userInfo['mobileNum'];
      displayUsername = userInfo['username'];
      displayBirthDate = userInfo['birthDate'];
    });
  }


  void initState() {
    getUserData();
    super.initState();
  }

  //date
  DateTime date;
  DateTime dateTimeNow = DateTime.now();
  DateTime initialBirthDate;
  void showDatePicker(BuildContext context) {

    String stringMaxYear = DateFormat('yyyy').format(dateTimeNow);
    int maxYear = int.parse(stringMaxYear);

    int minYear = maxYear - 100;
    print(minYear);

    //birthdate
    String tempBday = displayBirthDate.toString();
    print(tempBday);

    DateFormat format = new DateFormat("MMMM d y");

    var tempBdayDateTime = format.parse(tempBday);
    print(tempBdayDateTime);

    initialBirthDate = DateTime.parse(tempBdayDateTime.toString());

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
                    //initialDateTime: DateTime.now().subtract(Duration(seconds: 30)),
                    initialDateTime: initialBirthDate,
                    maximumDate: DateTime.now(),
                    minimumYear: minYear,
                    maximumYear: maxYear,
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (value) {
                      setState(() {
                        date = value;
                        selectedBirthDate = DateFormat('MMMM d y').format(date);
                        _birthDate.text = selectedBirthDate.toString();
                        birthDate = selectedBirthDate.toString();
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
    final user = Provider.of<Users>(context);
    print(displayFirstName);
    print(displayLastName);
    print(displayBirthDate);
    print(displayMobileNum);

    // //birthdate
    // String tempBday = displayBirthDate.toString();
    // print(tempBday);
    //
    // DateFormat format = new DateFormat("MMMM d y");
    //
    // var tempBdayDateTime = format.parse(tempBday);
    // print(tempBdayDateTime);
    //
    // initialBirthDate = DateTime.parse(tempBdayDateTime.toString());

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Scaffold(
              body: SafeArea(
                bottom: false,
                left: false,
                right: false,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    //autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 3 * SizeConfig.heightMultiplier),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            //back button
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    4 * SizeConfig.widthMultiplier,
                                    0 * SizeConfig.heightMultiplier,
                                    2 * SizeConfig.widthMultiplier,
                                    0),
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
                                      return UserProfile();
                                    }));
                                  },
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'EDIT PROFILE',
                                textAlign: TextAlign.center,
                                style: AppTheme.pageTitleText,
                              ),
                            ),
                            //save button
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    2 * SizeConfig.widthMultiplier,
                                    0,
                                    4 * SizeConfig.widthMultiplier,
                                    0 * SizeConfig.heightMultiplier),
                                child: IconButton(
                                    icon: new Icon(
                                      Icons.file_download_done,
                                      size: 8 * SizeConfig.imageSizeMultiplier,
                                    ),
                                    color: AppTheme.greenColor,
                                    onPressed: () async {
                                      await DatabaseService(uid: user.uid)
                                          .updateUserdata(
                                        fname ?? userData.firstName,
                                        lname ?? userData.lastName,
                                        email ?? userData.email,
                                        mobileNum ?? userData.mobileNum,
                                        username ?? userData.username,
                                        birthDate ?? userData.birthDate,
                                      );
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              '/userProfile',
                                              ModalRoute.withName(
                                                  '/pageOptions'));
                                    }),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3 * SizeConfig.heightMultiplier),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 5 * SizeConfig.widthMultiplier),
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
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(
                                    height: 5 * SizeConfig.heightMultiplier),
                                //First name
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          5 * SizeConfig.widthMultiplier),
                                  child: TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    //controller: _fname,
                                    initialValue: displayFirstName.titleCase,
                                    keyboardType: TextInputType.name,
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return "Please enter your first name";
                                      } else {
                                        return null;
                                      }
                                    },
                                    onChanged: (val) {
                                      setState(() => fname = val);
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
                                          horizontal:
                                              5 * SizeConfig.widthMultiplier,
                                          vertical:
                                              2 * SizeConfig.heightMultiplier),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  Colors.grey.withOpacity(0.8)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  0, 189, 56, 1.0)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
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
                                  ),
                                ),
                                SizedBox(
                                    height: 3.5 * SizeConfig.heightMultiplier),
                                //Last name
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          5 * SizeConfig.widthMultiplier),
                                  child: TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    //controller: _lname,
                                    initialValue: displayLastName.titleCase,
                                    keyboardType: TextInputType.name,
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return "Please enter your last name";
                                      } else {
                                        return null;
                                      }
                                    },
                                    onChanged: (val) {
                                      setState(() => lname = val);
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
                                          horizontal:
                                              5 * SizeConfig.widthMultiplier,
                                          vertical:
                                              2 * SizeConfig.heightMultiplier),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  Colors.grey.withOpacity(0.8)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  0, 189, 56, 1.0)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
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
                                  ),
                                ),
                                SizedBox(
                                    height: 3.5 * SizeConfig.heightMultiplier),
                                //birth date
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          5 * SizeConfig.widthMultiplier),
                                  child: TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: _birthDate,
                                    //initialValue: displayBirthDate,
                                    readOnly: true,
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return "Please enter your birth date";
                                      } else {
                                        return null;
                                      }
                                    },
                                    onChanged: (val) {
                                      setState(() => birthDate = val);
                                    },
                                    onTap: () {
                                      showDatePicker(context);
                                      InputDecoration(
                                        hintText: 'Date of Birth',
                                        hintStyle: AppTheme.formHintText,
                                      );
                                    },
                                    style: AppTheme.formInputText,
                                    decoration: InputDecoration(
                                      labelText: 'Date of Birth',
                                      labelStyle: AppTheme.formLabelText,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal:
                                              5 * SizeConfig.widthMultiplier,
                                          vertical:
                                              2 * SizeConfig.heightMultiplier),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  Colors.grey.withOpacity(0.8)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  0, 189, 56, 1.0)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
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
                                  ),
                                ),
                                SizedBox(
                                    height: 3.5 * SizeConfig.heightMultiplier),
                                //mobile number
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          5 * SizeConfig.widthMultiplier),
                                  child: TextFormField(
                                    inputFormatters: [
                                      new LengthLimitingTextInputFormatter(11),
                                    ],
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    //controller: _mobileNum,
                                    initialValue: displayMobileNum,
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
                                      setState(() => mobileNum = val);
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
                                        fontSize: 1.7* SizeConfig.textMultiplier,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 3.0,
                                      ),
                                      labelText: 'Mobile Number',
                                      labelStyle: AppTheme.formLabelText,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal:
                                              5 * SizeConfig.widthMultiplier,
                                          vertical:
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
                                  ),
                                ),
                                SizedBox(
                                    height: 5 * SizeConfig.heightMultiplier),
                              ]),
                        ),
                        SizedBox(height: 3 * SizeConfig.heightMultiplier),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
