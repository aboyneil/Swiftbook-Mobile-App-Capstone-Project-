import 'package:flutter/material.dart';
import 'package:swiftbook/booking/searchTrip.dart';
import 'package:swiftbook/travelHistory/travelHistory.dart';
import 'package:swiftbook/homePage/homePage.dart';
import 'package:swiftbook/profile/userProfile.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigator extends StatelessWidget {
  TabNavigator({this.navigatorKey, this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (tabItem == "Home")
      child = HomePage();
    else if (tabItem == "Search")
      child = SearchTrip();
    else if (tabItem == "Ticket")
      child = TravelHistory();
    else if (tabItem == "Profile")
      child = UserProfile();

    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => child);
      },
    );
  }
}
