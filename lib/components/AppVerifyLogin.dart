import 'dart:convert';

import '../utils/Constants.dart';
import '../utils/Urls.dart';
import '../utils/httpProxy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppVerifyLogin {
  static checkLogin() async {
    var pref = await SharedPreferences.getInstance();
    var userVerified = pref.getString(USER_VERIFIED);
    print(userVerified);
    var sessionCookie = pref.getString(SESSION_COOKIE_NAME);
    print(sessionCookie);
    if (userVerified == null || sessionCookie == null)
      return {'isLoggedIn': false};
    var response = await useHttpProxy()
        .get('${Urls.ROOT_URL}/api/app/checkLoginApp', headers: {
      'Cookie':
          '$SESSION_COOKIE_NAME=$sessionCookie; $USER_VERIFIED=$userVerified'
    });

    print(json.decode(response.body));
    return json.decode(response.body);
  }
}
