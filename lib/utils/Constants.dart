import 'dart:convert';

import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

const SESSION_COOKIE_NAME = 'PHPSESSID';
const CSRF_TOKEN_HEADER_NAME = 'x-csrf-token';
const USER_VERIFIED = 'userVerified';
const PAYSTACK_SECRET_KEY = 'sk_test_f5f5ecdb7e064ad4e9dc119d70761bb0e2c17085';
const COMPANY_PHONE_NUMBER = '';

Upload({required File imageFile, required String uploadURL, required Map? formFields}) async {
  var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  var length = await imageFile.length();

  var uri = Uri.parse(uploadURL);

  var request = http.MultipartRequest("POST", uri);
  for (var key in formFields!.keys) {
    request.fields[key] = formFields[key];
  }

  var multipartFile = http.MultipartFile('image', stream, length,
      filename: basename(imageFile.path));

  request.files.add(multipartFile);
  var response = await request.send();
  print(response.statusCode);
  response.stream.transform(utf8.decoder).listen((value) {
    print(value);
  });
}
