import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:swiftbook/globals.dart';
import 'package:swiftbook/models/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  //collection reference
  final CollectionReference infoCollection =
      FirebaseFirestore.instance.collection('mobile users');
  final CollectionReference tripsCollection =
      FirebaseFirestore.instance.collection('all_trips');
  final CollectionReference companyTripsCollection = FirebaseFirestore.instance
      .collection(selectedResBusCompanyName.toString() + '_trips');
  final CollectionReference bookingCollection = FirebaseFirestore.instance
      .collection(selectedResBusCompanyName.toString() + '_bookingForms');
  final CollectionReference allBookingCollection =
      FirebaseFirestore.instance.collection('all_bookingForms');
  final CollectionReference billingCollection = FirebaseFirestore.instance
      .collection(selectedResBusCompanyName.toString() + '_billingForms');
  final CollectionReference allBillingCollection =
      FirebaseFirestore.instance.collection('all_billingForms');

//Register users information to database
  Future updateUserdata(String firstName, String lastName, String email,
      String mobileNum, String username, String birthDate) async {
    return await infoCollection.doc(uid).set({
      'firstName': firstName.toLowerCase(),
      'lastName': lastName.toLowerCase(),
      'email': email,
      'mobileNum': mobileNum,
      'username': username,
      'birthDate': birthDate,
    });
  }

  //Update users information to database
  Future updateUserProfile(String firstName, String lastName, String mobileNum,
      String username, String birthDate) async {
    return await infoCollection.doc(uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'mobileNum': mobileNum,
      'username': username,
      'birthDate': birthDate,
    });
  }

  //Add specific company booking details to database
  Future addCompanyBookingFormDetails(
      String tempPassengerType,
      String tempFirstName,
      String tempLastName,
      String tempEmailAddress,
      String tempMobileNum,
      String tempDiscountID,
      String tempExtraBaggage,
      String tempExtraBaggagePrice,
      String tempTotalBaggageNum,
      String tempDiscount,
      String tempPercentageDiscount,
      String tempSubtotal,
      String tempTotal,
      String tempTicketID,
      String tempSelectSeats) async {
    String storeUid = FirebaseAuth.instance.currentUser.uid.toString();
    bookingCollection.add({
      'UID': storeUid,
      'Trip ID': selectedResTripID,
      'Origin Route': selectedResOriginRoute,
      'Destination Route': selectedResDestinationRoute,
      'Departure Date': selectedResDepartureDateGenFormat,
      'Departure Time': selectedResDepartureTimeGenFormat,
      'Bus Type': selectedResBusType,
      'Bus Class': selectedResBusClass,
      'Company Name': selectedResBusCompanyName,
      'Bus Seats': selectedResSeats,
      'Terminal Name': selectedResTerminalName,
      'Bus Code': selectedResBusCode,
      'Bus Plate Number': selectedResBusPlateNumber,
      'Base Fare': baseFare,
      'Subtotal': tempSubtotal,
      'Discount': tempDiscount,
      'Extra Baggage': tempExtraBaggage.toString(),
      'Extra Baggage Price': tempExtraBaggagePrice.toString(),
      'Total Baggage': tempTotalBaggageNum.toString(),
      'Total Price': tempTotal,
      'Percentage Discount': tempPercentageDiscount,
      'First Name': tempFirstName.toString().toUpperCase(),
      'Last Name': tempLastName.toString().toUpperCase(),
      'Email': tempEmailAddress,
      'Mobile Num': tempMobileNum,
      'Seat Number': tempSelectSeats,
      'Ticket ID': tempTicketID,
      'Driver ID': selectedResDriverID,
      'Booking Status': bookingStatus,
      'Present': present,
      'Passenger Category': tempPassengerType,
      'ID': tempDiscountID,
    });
  }

  //Add to all booking details database
  Future addAllBookingFormDetails(
      String tempPassengerType,
      String tempFirstName,
      String tempLastName,
      String tempEmailAddress,
      String tempMobileNum,
      String tempDiscountID,
      String tempExtraBaggage,
      String tempExtraBaggagePrice,
      String tempTotalBaggageNum,
      String tempDiscount,
      String tempPercentageDiscount,
      String tempSubtotal,
      String tempTotal,
      String tempTicketID,
      String tempSelectSeats) async {
    String storeUid = FirebaseAuth.instance.currentUser.uid.toString();
    allBookingCollection.doc(companyBookingFormsDocUid).set({
      'UID': storeUid,
      'Trip ID': selectedResTripID,
      'Origin Route': selectedResOriginRoute,
      'Destination Route': selectedResDestinationRoute,
      'Departure Date': selectedResDepartureDateGenFormat,
      'Departure Time': selectedResDepartureTimeGenFormat,
      'Bus Type': selectedResBusType,
      'Bus Class': selectedResBusClass,
      'Company Name': selectedResBusCompanyName,
      'Bus Seats': selectedResSeats,
      'Terminal Name': selectedResTerminalName,
      'Bus Code': selectedResBusCode,
      'Bus Plate Number': selectedResBusPlateNumber,
      'Base Fare': baseFare,
      'Subtotal': tempSubtotal,
      'Discount': tempDiscount,
      'Extra Baggage': tempExtraBaggage.toString(),
      'Extra Baggage Price': tempExtraBaggagePrice.toString(),
      'Total Baggage': tempTotalBaggageNum.toString(),
      'Total Price': tempTotal,
      'Percentage Discount': tempPercentageDiscount,
      'First Name': tempFirstName.toString().toUpperCase(),
      'Last Name': tempLastName.toString().toUpperCase(),
      'Email': tempEmailAddress,
      'Mobile Num': tempMobileNum,
      'Seat Number': tempSelectSeats,
      'Ticket ID': tempTicketID,
      'Driver ID': selectedResDriverID,
      'Booking Status': bookingStatus,
      'Present': present,
      'Passenger Category': tempPassengerType,
      'ID': tempDiscountID,
    });
  }

  //add specific company billing form to database
  Future addCompanyBillingFormDetails(String tempTicketID) async {
    var now = new DateTime.now();
    var formatter = new DateFormat('MMMM d y');
    String formattedDate = formatter.format(now);
    billingCollection.add({
      'Name': billingFormName.toString().toUpperCase(),
      'Email': billingFormEmail,
      'Phone Number': billingFormMobileNum,
      'Address': billingFormAddress.toString().toLowerCase(),
      'Total Price': totalPrice,
      'Mode of Payment': paymentMode,
      'Date of Payment': formattedDate,
      'Ticket ID': tempTicketID,
      'Subtotal': subTotal,
      'Discount': totalDiscount,
      'Qty': seatCounter,
      'Extra Baggage': totalExtraBaggage,
      'Rebooking Fee': 0,
    });
  }

  //add to all billing form database
  Future addAllBillingFormDetails(String tempTicketID) async {
    var now = new DateTime.now();
    var formatter = new DateFormat('MMMM d y');
    String formattedDate = formatter.format(now);
    allBillingCollection.doc(companyBillingFormsDocUid).set({
      'Name': billingFormName.toString().toUpperCase(),
      'Email': billingFormEmail,
      'Phone Number': billingFormMobileNum,
      'Address': billingFormAddress.toString().toLowerCase(),
      'Total Price': totalPrice,
      'Mode of Payment': paymentMode,
      'Date of Payment': formattedDate,
      'Ticket ID': tempTicketID,
      'Subtotal': subTotal,
      'Discount': totalDiscount,
      'Qty': seatCounter,
      'Extra Baggage': totalExtraBaggage,
      'Rebooking Fee': 0,
    });
  }

  //add specific company rebook billing form to database
  Future addRebookingCompanyBillingFormDetails() async {
    var now = new DateTime.now();
    var formatter = new DateFormat('MMMM d y');
    String formattedDate = formatter.format(now);
    FirebaseFirestore.instance
        .collection(selectedRebookCompanyName.toString() + '_billingForms')
        .add({
      'Name': rebookBillingFormName.toString().toUpperCase(),
      'Email': rebookBillingFormEmail,
      'Phone Number': rebookBillingFormMobileNum,
      'Address': rebookBillingFormAddress.toString().toLowerCase(),
      'Total Price': totalPrice,
      'Mode of Payment': paymentMode,
      'Date of Payment': formattedDate,
      'Ticket ID': rebookTicketID,
      'Subtotal': selectedRebookPrice,
      'Discount': '0',
      'Qty': 1,
      'Extra Baggage': toRebookTotalExtraBaggage,
      'Rebooking Fee': companyRebookingFee,
    });
  }

  //add specific company rebook billing form to database
  Future addRebookingAllBillingFormDetails(String uidGet) async {
    var now = new DateTime.now();
    var formatter = new DateFormat('MMMM d y');
    String formattedDate = formatter.format(now);
    FirebaseFirestore.instance.collection('all_billingForms').doc(uidGet).set({
      'Name': rebookBillingFormName.toString().toUpperCase(),
      'Email': rebookBillingFormEmail,
      'Phone Number': rebookBillingFormMobileNum,
      'Address': rebookBillingFormAddress.toString().toLowerCase(),
      'Total Price': totalPrice,
      'Mode of Payment': paymentMode,
      'Date of Payment': formattedDate,
      'Ticket ID': rebookTicketID,
      'Subtotal': selectedRebookPrice,
      'Discount': '0',
      'Qty': 1,
      'Extra Baggage': toRebookTotalExtraBaggage,
      'Rebooking Fee': companyRebookingFee,
    });
  }

  //update rebook all trips collection
  Future updateRebookAllBookingForms() async {
    return await FirebaseFirestore.instance
        .collection('all_bookingForms')
        .doc(rebookBookingFormID)
        .update({
      'Departure Date': selectedRebookDepartureDate,
      'Departure Time': selectedRebookDepartureTime,
      'Ticket ID': rebookTicketID,
    });
  }

  //update rebook company trips collection
  Future updateRebookCompanyBookingForms() async {
    return await FirebaseFirestore.instance
        .collection('$selectedRebookCompanyName' + '_bookingForms')
        .doc(rebookBookingFormID)
        .update({
      'Departure Date': selectedRebookDepartureDate,
      'Departure Time': selectedRebookDepartureTime,
      'Ticket ID': rebookTicketID,
    });
  }

  //update all trips collection
  Future updateBusAvailabilitySeatAllTrips() async {
    return await tripsCollection.doc(selectedResBusTripID).update({
      'Bus Availability Seat': selectedResBusAvailabilitySeat - seatCounter,
    });
  }

  //update company trips collection
  Future updateBusAvailabilitySeatCompanyTrips() async {
    return await companyTripsCollection.doc(selectedResBusTripID).update({
      'Bus Availability Seat': selectedResBusAvailabilitySeat - seatCounter,
    });
  }

  //add one bus availability seat all trips collection
  Future addOneBusAvailabilitySeatAllTrips() async {
    return await tripsCollection.doc(selectedTripsID).update({
      'Bus Availability Seat': busAvailabilitySeat + seatCounter,
    });
  }

  //add one bus availability seat company trips collection
  Future addOneBusAvailabilitySeatCompanyTrips() async {
    return await FirebaseFirestore.instance
        .collection('$travelHxBusCompanyName' + '_trips')
        .doc(selectedTripsID)
        .update({
      'Bus Availability Seat': busAvailabilitySeat + 1,
    });
  }

  //update all bookings form - booking status
  Future updateAllBookingStatus() async {
    allBookingCollection.doc(selectedTicketDocID).update({
      'Booking Status': 'Cancelled',
    });
  }

  //update company bookings form - booking status
  Future updateCompanyBookingStatus() async {
    return await FirebaseFirestore.instance
        .collection('$travelHxBusCompanyName' + '_bookingForms')
        .doc(selectedTicketDocID)
        .update({
      'Booking Status': 'Cancelled',
    });
  }

  //update ticket counter - all trips
  Future updateAllTicketCounter() async {
    return await tripsCollection.doc(selectedResTripID).update({
      'counter': selectedResCounter + seatCounter,
    });
  }

  //update ticket counter - company trips
  Future updateCompanyTicketCounter() async {
    return await companyTripsCollection.doc(selectedResTripID).update({
      'counter': selectedResCounter + seatCounter,
    });
  }

  //update rebook ticket counter - all trips
  Future updateAllRebookTicketCounter() async {
    return await tripsCollection.doc(selectedResTripID).update({
      'counter': selectedRebookCounter + 1,
    });
  }

  //update rebook ticket counter - company trips
  Future updateCompanyRebookTicketCounter() async {
    return await companyTripsCollection.doc(selectedResTripID).update({
      'counter': selectedRebookCounter + 1,
    });
  }

  //update all seat status
  Future updateAllSeatStatus() async {
    return await FirebaseFirestore.instance
        .collection('all_trips')
        .doc(selectedResTripID)
        .update({
      'Left Seat Status': updateLeftSeatStatus,
      'Right Seat Status': updateRightSeatStatus,
      'Bottom Seat Status': updateBottomSeatStatus,
    });
  }

  //update company seat status
  Future updateCompanySeatStatus() async {
    return await FirebaseFirestore.instance
        .collection('$selectedResBusCompanyName' + '_trips')
        .doc(selectedResTripID)
        .update({
      'Left Seat Status': updateLeftSeatStatus,
      'Right Seat Status': updateRightSeatStatus,
      'Bottom Seat Status': updateBottomSeatStatus,
    });
  }

  //update all seat status to true - cancel booking
  Future setTrueAllSeatStatus() async {
    return await FirebaseFirestore.instance
        .collection('all_trips')
        .doc(travelHxTripID)
        .update({
      'Left Seat Status': setTrueLeftSeatStatus,
      'Right Seat Status': setTrueRightSeatStatus,
      'Bottom Seat Status': setTrueBottomSeatStatus,
    });
  }

  //update company seat status to true - cancel booking
  Future setTrueCompanySeatStatus() async {
    return await FirebaseFirestore.instance
        .collection('$travelHxCompanyName' + '_trips')
        .doc(travelHxTripID)
        .update({
      'Left Seat Status': setTrueLeftSeatStatus,
      'Right Seat Status': setTrueRightSeatStatus,
      'Bottom Seat Status': setTrueBottomSeatStatus,
    });
  }

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      email: snapshot['email'],
      firstName: snapshot['firstName'],
      lastName: snapshot['lastName'],
      mobileNum: snapshot['mobileNum'],
      username: snapshot['username'],
      birthDate: snapshot['birthDate'],
    );
  }

  // get user doc stream
  Stream<UserData> get userData {
    return infoCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
