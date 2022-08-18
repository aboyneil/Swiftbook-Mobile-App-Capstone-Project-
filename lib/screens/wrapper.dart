import 'package:swiftbook/authenticate/authenticate.dart';
import 'package:swiftbook/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swiftbook/navBar/page-options.dart';
import 'package:swiftbook/services/verify_email.dart';

class Wrapper extends StatelessWidget {
  Wrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //accesing the user data from the provider
    //<Users> - Users is what they are receiving from StreamProvider (main.dart)
    //so, in this file, we access the data (Users) every time we get a new value
    final user = Provider.of<Users>(context);

    //return either Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return VerifyEmail();
    }
  }
}
