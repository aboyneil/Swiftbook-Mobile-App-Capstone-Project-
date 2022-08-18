import 'package:swiftbook/globals.dart';
import 'package:swiftbook/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swiftbook/services/database.dart';

class AuthService {
  //final - not gonna change in the future
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //creates a user object based on FirebaseUser (User?)
  Users _userFromFirebaseUser(User user) {
    if (user != null) {
      return Users(uid: user.uid);
    } else {
      return null;
    }
  }

  //auth change user stream
  Stream<Users> get user {
    return _auth
        .authStateChanges()
        .map((User user) => _userFromFirebaseUser(user));
    //.map(_userFromFirebaseUser);
  }

  //sign in with email & pass
  Future signInWithEmailAndPass(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      print(_userFromFirebaseUser(user));
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email & pass
  Future registerWithEmailAndPass(String email, String password) async {
    try {

      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      //insert personal info in firestore
      await DatabaseService(uid: _auth.currentUser.uid)
          .updateUserdata(fname, lname, email, mobileNum, username, birthDate);

      // UserCredential result = await _auth.createUserWithEmailAndPassword(
      //     email: email, password: password);
      // User user = result.user;
      //
      // //insert personal info in firestore
      // await DatabaseService(uid: user.uid)
      //     .updateUserdata(fname, lname, email, mobileNum, username, birthDate);
      // return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetPassword(String forgotPass) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      return await auth.sendPasswordResetEmail(email:forgotPass);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

}
