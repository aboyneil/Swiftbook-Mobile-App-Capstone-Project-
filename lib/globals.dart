library swiftbook.globals;

import 'package:intl/intl.dart';

int numOfSeats = 2;

//sign up
var fname;
var lname;
var username;
var email;
var mobileNum;
var pass;
var confirmPass;
var birthDate;
var selectedBirthDate;
var forgotPass;

bool loading = false;
int flag = 0;

//passenger's selected values
String selectedOrigin;
String selectedDestination;
String selectedDepartureDate;
String selectedDepartureDateGenFormat;
String selectedBusType;
var selectedNumSeats = 1;

//passenger category
String selectedPassengerCategory;

//passenger's selected bus/trip result
String busDocID;
String selectedResTripID;
String selectedResOriginRoute;
String selectedResDestinationRoute;
String selectedResDepartureDate;
String selectedResDepartureDateGenFormat;
String selectedResDepartureTimeGenFormat;
String selectedResDepartureTime;
String selectedResBusType;
String selectedResBusClass;
String selectedResBusCompanyName;
String selectedResBusCode;
String selectedResBusPlateNumber;
bool selectedResTripStatus;
String selectedResTerminalName;
String selectedResSeats;
String selectedResBusSeatCapacity;
int selectedResBusAvailabilitySeat;
String selectedResPriceDetails;
String selectedResBusTripID;
String selectedResDriverID;
int selectedResCounter;

//date and time
DateTime datetimeNow = DateTime.now();
String dateNow = DateFormat('MMMM d y').format(datetimeNow);
DateTime selectedDateTime;
//String selectedDateGenFormat;

//number of seats
int seatCounter = 1;
List<String> selectedSeats = [];

//passenger form details
List<String> passengerType = [];
List<String> passengerFirstName = [];
List<String> passengerLastName = [];
List<String> passengerEmailAddress = [];
List<String> passengerMobileNum = [];
List<String> passengerDiscountID = [];
List<String> listDiscount = [];
List eachTotal = [];
List eachSubTotal = [];
List eachDiscount = [];
List<String> ticketIDList = [];

//generate rows and col
List rightSeatList = [];
List listLeftSeat = [];
List leftSeatStatus = [];
List rightSeatStatus = [];
List listBottomSeat = [];
List bottomSeatStatus = [];
int leftColSize = 0;
int leftRowSize = 0;
int rightColSize = 0;
int rightRowSize = 0;
int bottomColSize = 0;
List seatNameDropdownItem = [];
List seatsName = [];
List seatsNameStatus = [];
List<String> valueList = [];

//update seat status
List updateLeftSeatStatus = [];
List updateRightSeatStatus = [];
List updateBottomSeatStatus = [];

double baseFare = 0;
double subTotal = 0;
double discountPrice = 0;
double totalPrice = 0;
int totalDiscount = 0;
int percentageDiscount = 0;
int selectedPercentageDiscount;
int seatNumber = 0;

//billing form
var billingFormName;
var billingFormEmail;
var billingFormMobileNum;
var billingFormAddress;
var paymentMode;

int seats = int.parse(selectedResSeats);
//List<String> seatsList = ['1'];
int seatsList = 1;

String getBusPlateNum;
String getBusClass;
String getBusSeatCapacity;
bool getBusStatus = false;
String getBusType;

//edit all trips
int newBusAvailabilitySeat = 0;
String selectedTripsID;
int busAvailabilitySeat = 0;

//booking form
String bookingStatus;
bool present;

//selected ticket ID for travel history
String selectedTicketID;

//selected document ID for booking cancellation
String selectedTicketDocID;

//String Travel History Variables
String travelHxBusCompanyName;

String paymentString = 'Payment Expired';

//ticket counter
int counter;
String ticketCounterDocID;

//get doc id of company booking forms
String companyBookingFormsDocUid;
String companyBillingFormsDocUid;

//cancel booking - set seat status to true
List setTrueLeftSeatStatus =[];
List setTrueRightSeatStatus = [];
List setTrueBottomSeatStatus = [];
String travelHxTripID;
String travelHxCompanyName;

//baggage number
String baggageLimitID;
int maxBaggage = 0;
int minBaggage = 0;
int pesoPerBaggage = 0;
int selectedBaggageNum = 0;
List baggageNumberList = [];
List eachExtraBaggageList = [];
List eachExtraBaggagePriceList = [];
List eachTotalBaggageNum = [];
double totalExtraBaggage = 0;

bool companyBaggage;
bool companyRebooking;
int companyRebookingFee;

//rebook
String toRebookOrigin;
String toRebookDestination;
String toRebookCompanyName;
String toRebookDepartureDate;
String toRebookDepartureTime;
String toRebookBusType;
String toRebookBusClass;
String toRebookTicketID;
String toRebookSeatNumber;
String toRebookDiscount;
String toRebookTotalExtraBaggage;
double toRebookPriceDouble;
String toRebookPrice;
String rebookBookingFormID;

String selectedRebookDepartureDate;
String selectedRebookDepartureTime;
int selectedRebookCounter;
String selectedRebookCompanyName;
String selectedRebookBusCode;
String selectedRebookPrice;
String rebookTicketID;
String selectedRebookTripID;
bool companyBaggageTravelHx;

//rebook billing form
var rebookBillingFormName;
var rebookBillingFormEmail;
var rebookBillingFormMobileNum;
var rebookBillingFormAddress;
var rebookPaymentMode;

int rebookFlag = 0;

//round trip booking
bool companyRoundTrip;
String returnTripOrigin;
String returnTripDestination;
String returnTripDepartureDateGenFormat;
String returnTripDepartureDate;
String returnTripBusDocID;
String selectedReturnTripTripID;
String selectedReturnTripDepartureDateGenFormat;
String selectedReturnTripDepartureDate;
String selectedReturnTripDepartureTimeGenFormat;
String selectedReturnTripDepartureTime;
String selectedReturnTripResBusType;
String selectedReturnTripBusClass;
String selectedReturnTripBusCompanyName;
String selectedReturnTripBusCode;
String selectedReturnTripBusPlateNumber;
bool selectedReturnTripTripStatus;
String selectedReturnTripTerminalName;
String selectedReturnTripSeats;
String selectedReturnTripBusSeatCapacity;
int selectedReturnTripBusAvailabilitySeat;
String selectedReturnTripPriceDetails;
String selectedReturnTripBusTripID;
String selectedReturnTripDriverID;
int selectedReturnTripCounter;
bool returnTripCompanyBaggage;

//return trip baggage number
String returnTripBaggageLimitID;
int returnTripMaxBaggage = 0;
int returnTripMinBaggage = 0;
int returnTripPesoPerBaggage = 0;
//int selectedBaggageNum = 0;
List returnTripBaggageNumberList = [];