import 'package:flutter/material.dart';
import '../utils/Constants.dart';
import '../utils/Urls.dart';
import '../utils/get_cookie.dart';
import '../utils/httpProxy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class AppLogout {
  static logOut(context) async {
    var logOutPref = await SharedPreferences.getInstance();
    var userVerified = logOutPref.getString(USER_VERIFIED);

    var usefulResponseHeaders = await getSessionCookie();
    await useHttpProxy().get(
        '${Urls.ROOT_URL}/tech/logout?csrf_token=${usefulResponseHeaders[CSRF_TOKEN_HEADER_NAME]}',
        headers: {
          'Cookie':
              '$SESSION_COOKIE_NAME=${usefulResponseHeaders[SESSION_COOKIE_NAME]}; $USER_VERIFIED=$userVerified'
        });
    logOutPref.remove(USER_VERIFIED);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomePage(
          startIndex: 0,
        ),
      ),
    );
  }
}
