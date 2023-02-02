//@dart=2.9

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../api/notification_api.dart';
import '../common_widget/AppBarWidget.dart';
import '../common_widget/BottomNavBarWidget.dart';
import '../common_widget/DrawerWidget.dart';
import '../screens/HomeScreen.dart';
import '../screens/ShoppingCartScreen.dart';
import '../screens/WishListScreen.dart';

import 'components/AppVerifyLogin.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnimatedSplashScreen(
        splash: 'assets/images/ic_app_icon.png',
        nextScreen: MyHomePage(),
        splashTransition: SplashTransition.scaleTransition,
        splashIconSize: 60,
        duration: 1000,
      ),
      theme: ThemeData(
          fontFamily: 'Roboto',
          primaryColor: Colors.white,
          primaryColorDark: Colors.white,
          backgroundColor: Colors.white),
      debugShowCheckedModeBanner: false,
    );
  }
}

int currentIndex = 0;

class MyHomePage extends StatefulWidget {
  var startIndex;
  MyHomePage({this.startIndex});
  @override
  _MyHomePageNewState createState() => _MyHomePageNewState();
}

class _MyHomePageNewState extends State<MyHomePage> {
  final List<Widget> viewContainer = [
    HomeScreen(),
    WishListScreen(),
    ShoppingCartScreen(),
  ];

  void navigateToScreens(int index) {
    setState(() {
      currentIndex = index;
      widget.startIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(Duration(milliseconds: 1))
            .then((value) => setState(() {}));
      },
      child: DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: appBarWidget(),
          drawer: DrawerWidget(),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IndexedStack(
              index: widget.startIndex ?? currentIndex,
              children: viewContainer,
            ),
          ),
          bottomNavigationBar: BottomNavBarWidget(navigateToScreens),
        ),
      ),
    );
  }
}
