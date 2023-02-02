//@dart=2.9
import 'dart:convert';

import 'package:flutter/material.dart';
import '../components/AppVerifyLogin.dart';
import '../main.dart';
import '../utils/Constants.dart';
import '../utils/Urls.dart';
import '../utils/get_cookie.dart';
import '../utils/httpProxy.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavBarWidget extends StatefulWidget {
  Function navigateToScreens;
  BottomNavBarWidget(this.navigateToScreens);

  @override
  _BottomNavBarWidgetState createState() => _BottomNavBarWidgetState();
}

class _BottomNavBarWidgetState extends State<BottomNavBarWidget> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      widget.navigateToScreens(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          // title: Text(
          //   'Home',
          //   style: TextStyle(color: Color(0xFF545454)),
          // ),
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag), label: 'Open Shop'
            // title: Text(
            //   'Open Shop',
            //   style: TextStyle(color: Color(0xFF545454)),
            // ),
            ),
        BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(FontAwesomeIcons.shoppingBag),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6)),
                    constraints: BoxConstraints(minWidth: 12, minHeight: 12),
                    child: FutureBuilder(
                      future: (() async {
                        var checkLogin = await AppVerifyLogin.checkLogin();
                        if (checkLogin['isLoggedIn'] == false) return [];
                        var usefulResponseHeaders = await getSessionCookie();
                        var userVerified =
                            (await SharedPreferences.getInstance())
                                .getString(USER_VERIFIED);
                        var response = await useHttpProxy().get(
                            '${Urls.ROOT_URL}/api/app/userCartItemsApp',
                            headers: {
                              'Cookie':
                                  '$SESSION_COOKIE_NAME=${usefulResponseHeaders[SESSION_COOKIE_NAME]}; $USER_VERIFIED=$userVerified'
                            });

                        return jsonDecode(response.body);
                      }()),
                      builder: (context, snapshot) {
                        if (snapshot.hasData)
                          return Text(
                            snapshot.data.length.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                            textAlign: TextAlign.center,
                          );
                        else
                          return Text(
                            '0',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                            textAlign: TextAlign.center,
                          );
                      },
                    ),
                  ),
                )
              ],
            ),
            label: 'Cart'

            // title: Text(
            //   'Cart',
            //   style: TextStyle(color: Color(0xFF545454)),
            // ),
            ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Color(0xFFAA292E),
      onTap: (index) {
        if (index == 2) setState(() {});
        _onItemTapped(index);
      },
    );
  }
}
