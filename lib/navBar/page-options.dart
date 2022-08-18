import 'package:flutter/material.dart';
import 'package:swiftbook/styles/size-config.dart';
import 'package:swiftbook/navBar/tabNavigator.dart';
import 'package:swiftbook/styles/style.dart';

class PageOptions extends StatefulWidget {
  @override
  _PageOptionsState createState() => _PageOptionsState();
}

class _PageOptionsState extends State<PageOptions> {
  String currentPage = "Search";
  List<String> pageKeys = ["Home", "Search", "Ticket", "Profile"];
  Map<String, GlobalKey<NavigatorState>> navigatorKeys = {
    "Home": GlobalKey<NavigatorState>(),
    "Search": GlobalKey<NavigatorState>(),
    "Ticket": GlobalKey<NavigatorState>(),
    "Profile": GlobalKey<NavigatorState>(),
  };

  int selectedIndex = 1;

  void selectTab(String tabItem, int index) {
    if (tabItem == currentPage) {
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        currentPage = pageKeys[index];
        selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final isFirstRouteInCurrentTab =
              !await navigatorKeys[currentPage].currentState.maybePop();
          if (isFirstRouteInCurrentTab) {
            if (currentPage != "Search") {
              selectTab("Search", 2);

              return false;
            }
          }
          // let system handle back button if we're on the first route
          return isFirstRouteInCurrentTab;
        },
        child: Scaffold(
          body: Stack(children: <Widget>[
            buildOffstageNavigator("Home"),
            buildOffstageNavigator("Search"),
            buildOffstageNavigator("Ticket"),
            buildOffstageNavigator("Profile"),
          ]),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined,
                    size: 7 * SizeConfig.imageSizeMultiplier),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded,
                    size: 7 * SizeConfig.imageSizeMultiplier),
                label: "Search",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_activity_outlined,
                    size: 7 * SizeConfig.imageSizeMultiplier),
                label: "Ticket",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded,
                    size: 7 * SizeConfig.imageSizeMultiplier),
                label: "Profile",
              ),
            ],
            selectedItemColor: AppTheme.greenColor,
            elevation: 5.0,
            unselectedItemColor: AppTheme.iconsColor,
            backgroundColor: Colors.white,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: selectedIndex,
            onTap: (int index) {
              selectTab(pageKeys[index], index);
            },
          ),
        ));
  }

  Widget buildOffstageNavigator(String tabItem) {
    return Offstage(
      offstage: currentPage != tabItem,
      child: TabNavigator(
        navigatorKey: navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }
}
