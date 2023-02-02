//@dart=2.9
import 'package:flutter/material.dart';
import '../components/AppLogOut.dart';
import '../components/AppVerifyLogin.dart';
import '../components/login.dart';
import '../main.dart';
import '../screens/WishListScreen.dart';
import '../utils/Constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.65,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _createDrawerHeader(),
            _createDrawerItem(
              icon: Icons.home,
              text: 'Home',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(
                    startIndex: 0,
                  ),
                ),
              ),
            ),
            _createDrawerItem(
                icon: Icons.call,
                text: 'Contact Us',
                onTap: () => launch('tel://$COMPANY_PHONE_NUMBER')),
            FutureBuilder(future: (() async {
              return AppVerifyLogin.checkLogin();
            })(), builder: (context, snapshot) {
              if (snapshot.hasData) {
                bool isLoggedIn = snapshot.data['isLoggedIn'];
                return _createDrawerItem(
                    icon: isLoggedIn
                        ? FontAwesomeIcons.signOutAlt
                        : FontAwesomeIcons.user,
                    text: isLoggedIn ? 'Log Out' : 'Sign In',
                    onTap: () async {
                      if (isLoggedIn) {
                        AppLogout.logOut(context);
                      } else
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => login()),
                        );
                    });
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
            _createDrawerItem(
                icon: Icons.business,
                text: '© NaxTrust RealEstate',
                onTap: () {}),
          ],
        ),
      ),
    );
  }
}

Widget _createDrawerHeader() {
  return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Stack(children: <Widget>[
        Container(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Image.asset(
              'assets/images/ic_app_icon.png',
              width: 60,
              height: 60,
            ),
          ),
        ),
      ]));
}

Widget _createDrawerItem(
    {IconData icon, String text, GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(
          icon,
          color: Color(0xFF808080),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Text(
            text,
            style: TextStyle(color: Color(0xFF484848)),
          ),
        )
      ],
    ),
    onTap: onTap,
  );
}
