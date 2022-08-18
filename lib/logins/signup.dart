import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swiftbook/services/verify_email.dart';
import 'package:swiftbook/styles/style.dart';
import 'package:swiftbook/styles/size-config.dart';
import 'package:swiftbook/globals.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:swiftbook/services/auth.dart';
import 'package:swiftbook/shared/loading.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;

  SignUp({this.toggleView});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  bool showPassText = true; //show password
  bool showConfirmPassText = true;

  void togglePasswordView() {
    setState(() {
      showPassText = !showPassText;
    });
  }

  void toggleConfirmPasswordView() {
    setState(() {
      showConfirmPassText = !showConfirmPassText;
    });
  }

  final TextEditingController _fname = TextEditingController();
  final TextEditingController _lname = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _mobileNum = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final TextEditingController _birthDate = TextEditingController();

  //date
  DateTime date;
  DateTime dateTimeNow = DateTime.now();

  void showDatePicker(BuildContext context) {
    String stringMaxYear = DateFormat('yyyy').format(dateTimeNow);
    int maxYear = int.parse(stringMaxYear);

    int minYear = maxYear - 100;
    print(minYear);

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
                    initialDateTime:
                        DateTime.now().subtract(Duration(seconds: 30)),
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

  /*
  //validate inputs
  void validateInputs() {
    if (_formKey.currentState.validate()) {
      fname = _fname.text;
      lname = _lname.text;
      username = _username.text;
      email = _email.text;
      mobileNum = _mobileNum.text;
      pass = _pass.text;
      confirmPass = _confirmPass.text;
      birthDate = _birthDate.text;
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        left: false,
        right: false,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                            widget.toggleView();
                          },
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'SIGN UP',
                        textAlign: TextAlign.center,
                        style: AppTheme.pageTitleText,
                      ),
                    ),
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
                              Icons.save_alt_rounded,
                              size: 0 * SizeConfig.imageSizeMultiplier,
                            ),
                            color: AppTheme.greenColor,
                            onPressed: () {}),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2 * SizeConfig.heightMultiplier),
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
                        offset: Offset(0, 1.5), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: 5 * SizeConfig.heightMultiplier),
                        //First name
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5 * SizeConfig.widthMultiplier),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.words,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _fname,
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
                        SizedBox(height: 3.5 * SizeConfig.heightMultiplier),
                        //Last name
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5 * SizeConfig.widthMultiplier),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.words,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _lname,
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
                        SizedBox(height: 3.5 * SizeConfig.heightMultiplier),
                        //birth date
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5 * SizeConfig.widthMultiplier),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _birthDate,
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
                        SizedBox(height: 3.5 * SizeConfig.heightMultiplier),
                        //email
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5 * SizeConfig.widthMultiplier),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _email,
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
                                email = val;
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
                        SizedBox(height: 3.5 * SizeConfig.heightMultiplier),
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
                            controller: _mobileNum,
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
                        SizedBox(height: 3.5 * SizeConfig.heightMultiplier),
                        //username
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5 * SizeConfig.widthMultiplier),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _username,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "Please enter a username";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (val) {
                              setState(() => username = val);
                            },
                            keyboardType: TextInputType.name,
                            onTap: () {
                              InputDecoration(
                                hintText: 'Usernames',
                                hintStyle: AppTheme.formHintText,
                              );
                            },
                            style: AppTheme.formInputText,
                            decoration: InputDecoration(
                              labelText: 'Username',
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
                        SizedBox(height: 3.5 * SizeConfig.heightMultiplier),
                        //password
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5 * SizeConfig.widthMultiplier),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _pass,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "Please enter your password";
                              } else {
                                return null;
                              }
                            },
                            onTap: () {
                              InputDecoration(
                                hintText: 'Password',
                                hintStyle: AppTheme.formHintText,
                              );
                            },
                            style: AppTheme.formInputText,
                            decoration: InputDecoration(
                              labelText: 'Password',
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
                              //show or hide password
                              suffixIcon: IconButton(
                                color: Colors.grey,
                                onPressed: (togglePasswordView),
                                icon: showPassText
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                              ),
                            ),
                            obscureText: showPassText,
                            enableSuggestions: false,
                            autocorrect: false,
                          ),
                        ),

                        SizedBox(height: 3.5 * SizeConfig.heightMultiplier),
                        //confirm password
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5 * SizeConfig.widthMultiplier),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _confirmPass,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "Please re-enter your password";
                              }
                              if (value != _pass.value.text) {
                                return "Password do not match";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                            onTap: () {
                              InputDecoration(
                                hintText: 'Confirm Password',
                                hintStyle: AppTheme.formHintText,
                              );
                            },
                            style: AppTheme.formInputText,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
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
                              //show or hide password
                              suffixIcon: IconButton(
                                color: Colors.grey,
                                onPressed: (toggleConfirmPasswordView),
                                icon: showConfirmPassText
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                              ),
                            ),
                            obscureText: showConfirmPassText,
                            enableSuggestions: false,
                            autocorrect: false,
                          ),
                        ),
                        SizedBox(height: 5 * SizeConfig.heightMultiplier),
                      ]),
                ),
                SizedBox(height: 4 * SizeConfig.heightMultiplier),
                //sign up button
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15 * SizeConfig.widthMultiplier),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);

                              await _auth.registerWithEmailAndPass(
                                  email, password);

                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => VerifyEmail()));

                              // dynamic result =
                              //     await _auth.registerWithEmailAndPass(
                              //         email, password);
                              //
                              // if (result == null) {
                              //   setState(() {
                              //     error = 'Please supply a valid email';
                              //     loading = false;
                              //   });
                              // }
                            }
                            //validateInputs();
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(0, 45),
                            primary: AppTheme.greenColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                side: BorderSide(color: Colors.transparent)),
                          ),
                          child: Text(
                            'Sign Up',
                            style: AppTheme.buttonText,
                          ),
                        ),
                      ),
                    ]),
                SizedBox(height: 7 * SizeConfig.heightMultiplier),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
