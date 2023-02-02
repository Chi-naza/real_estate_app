import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../common_widget/UpdatePrice.dart';
import '../components/AppVerifyLogin.dart';
import '../utils/Constants.dart';
import '../utils/Urls.dart';
import '../utils/get_cookie.dart';
import '../utils/httpProxy.dart';
// import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_money/flutter_money.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:intl/intl.dart';

import 'ProductDetailScreen.dart';

class ShoppingCartScreen extends StatefulWidget {
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  final plugin = PaystackPlugin();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: (() async {
          var checkLogin = await AppVerifyLogin.checkLogin();
          if (checkLogin['isLoggedIn'] == false) return {'products': []};
          var usefulResponseHeaders = await getSessionCookie();
          var userVerified =
              (await SharedPreferences.getInstance()).getString(USER_VERIFIED);
          var response = await useHttpProxy()
              .get('${Urls.ROOT_URL}/api/app/userCartItemsApp', headers: {
            'Cookie':
                '$SESSION_COOKIE_NAME=${usefulResponseHeaders[SESSION_COOKIE_NAME]}; $USER_VERIFIED=$userVerified'
          });

          return {'user': checkLogin, 'products': json.decode(response.body)};
        }()),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            if ((snapshot.data as Map)['products'].length == 0)
              return EmptyShoppingCartScreen();
            else {
              return UserCartItems(data: snapshot.data, plugin: plugin);
            }
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        });
  }
}

class EmptyShoppingCartScreen extends StatefulWidget {
  @override
  _EmptyShoppingCartScreenState createState() =>
      _EmptyShoppingCartScreenState();
}

class _EmptyShoppingCartScreenState extends State<EmptyShoppingCartScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 70,
              child: Container(
                color: Color(0xFFFFFFFF),
              ),
            ),
            Container(
              width: double.infinity,
              height: 250,
              child: Image.asset(
                "assets/images/empty_shopping_cart.png",
                height: 250,
                width: double.infinity,
              ),
            ),
            SizedBox(
              height: 40,
              child: Container(
                color: Color(0xFFFFFFFF),
              ),
            ),
            Container(
              width: double.infinity,
              child: Text(
                "You haven't anything to cart",
                style: TextStyle(
                  color: Color(0xFF67778E),
                  fontFamily: 'Roboto-Light.ttf',
                  fontSize: 20,
                  fontStyle: FontStyle.normal,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UserCartItems extends StatefulWidget {
  var data;
  var plugin;
  UserCartItems({this.data, this.plugin});

  @override
  _UserCartItemsState createState() => _UserCartItemsState();
}

class _UserCartItemsState extends State<UserCartItems> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    int total = 0;
    List productsArray = widget.data['products'];

    var totalItems = productsArray.length + 1;

    for (int index = 0; index < productsArray.length; index++)
      total += (productsArray[index]['price'] *
          productsArray[index]['product_quantity']) as int;

    List<Widget> widgets = [];

    for (int index = 0; index < totalItems; index++) {
      if (index == totalItems - 1) {
        widgets.add(Column(
          children: [
            Container(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
              color: Color(0xFFFFFFFF),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('TOTAL'),
                  Text(
                    '\$${FlutterMoney(amount: total + 0.0).output.nonSymbol.split('.')[0]}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFeb0028),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
              color: Color(0xFFFFFFFF),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFff665e),
                    foregroundColor: Colors.white,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.all(
                          Radius.circular(
                            10,
                          ),
                        ),
                        side: BorderSide(color: Color(0xFFff665e))
                      ),
                    ),                    
                    onPressed: () async {
                      try {
                        Widget cryptoButton = TextButton(
                          child: Text("Crypto"),
                          onPressed: () async {
                            var instancePref =
                                await SharedPreferences.getInstance();
                            var response = jsonDecode((await post(
                                    Uri.parse(
                                        'https://api.commerce.coinbase.com/charges/'),
                                    headers: {
                                      'Content-Type': 'application/json',
                                      'X-CC-Api-Key':
                                          '76668e58-4186-46a5-8478-5b16cd96d3c6',
                                      'X-CC-Version': '2018-03-22',
                                    },
                                    body: jsonEncode({
                                      'name': 'Deposit',
                                      'description': 'Buying House',
                                      'local_price': {
                                        'amount': total,
                                        'currency': 'USD'
                                      },
                                      "metadata": {
                                        'userId':
                                            instancePref.getString('userId'),
                                        'methodOfPayment':
                                            'Buying house, at ${new DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())},my id is ${(await SharedPreferences.getInstance()).getString('userId')}',
                                        'sellingMethod': 'nottrade',
                                        'phone': '',
                                        'dollarRate': 1,
                                        'currencyExchange': 'house purchased',
                                        'currency': 'usd',
                                      },
                                      'pricing_type': 'fixed_price'
                                    })))
                                .body);

                            Navigator.pop(context);

                            setState(() {
                              instancePref.remove('bet');
                            });

                            await launch(response['data']['hosted_url']);
                          },
                        );
                        Widget fiatButton = TextButton(
                          child: Text("Fiat"),
                          onPressed: () async {
                            var instancePref =
                                await SharedPreferences.getInstance();
                            var response = jsonDecode((await post(
                                    Uri.parse(
                                        'https://naxtrust.com/ntc/trading/saveToDb'),
                                    body: jsonEncode({
                                      'amount': total,
                                      'description': 'Selling ${total}',
                                      'userId':
                                          instancePref.getString('userId'),
                                      'phone': '',
                                      'methodOfPayment':
                                          'Buying House, at ${new DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())},my id is ${instancePref.getString('userId')}',
                                      'sellingMethod': 'nottrade',
                                      'dollarRate': 1,
                                      'currencyExchange': 'house purchased',
                                      'currency': 'usd',
                                    })))
                                .body);

                            if (response['success']) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content:
                                      Text('Property purchased Successfull')));
                              setState(() {
                                instancePref.remove('bet');
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Property purchased Failed, ${response['error']}')));
                            }
                            Navigator.pop(context);
                          },
                        );

                        // set up the AlertDialog
                        AlertDialog alert = AlertDialog(
                          title: Text("Choose Method"),
                          content: Text("Crypto or Fiat"),
                          actions: [
                            cryptoButton,
                            fiatButton,
                          ],
                        );

                        // show the dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      } catch (e) {
                        print(e);
                      }
                    },                    
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 5, right: 5, top: 15, bottom: 15),
                      child: Text("Check Out".toUpperCase(),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFFFFFFF))),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ));
      } else
        widgets.add(Column(
          children: [
            Container(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
              color: Color(0xFFFFFFFF),
              child: Column(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder(
                          future: (() async {
                            return (await useHttpProxy().get(
                                    '${Urls.ROOT_URL}${productsArray[index]['image']}'))
                                .bodyBytes;
                          }()),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return GestureDetector(
                                child: Image.memory(
                                  snapshot.data as Uint8List,
                                  fit: BoxFit.contain,
                                  width: 120,
                                  height: 120,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailScreen(
                                        slug: productsArray[index],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      Text(productsArray[index]['title'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700)),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '\$${FlutterMoney(amount: productsArray[index]['price'] + 0.0).output.nonSymbol.split('.')[0]}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFeb0028),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          productsArray[index]['category'] == 'Landed Property'
                              ? UpdatePrice(
                                  userId: widget.data['user']['userId'],
                                  data: productsArray[index],
                                  onUpdate: (quantity) {
                                    setState(() {
                                      productsArray[index]['product_quantity'] =
                                          quantity;
                                    });
                                  },
                                )
                              : Container(),
                          GestureDetector(
                            child:
                                Icon(Icons.delete, color: Colors.red, size: 30),
                            onTap: () async {
                              var usefulResponseHeaders =
                                  await getSessionCookie();
                              var userVerified =
                                  (await SharedPreferences.getInstance())
                                      .getString(USER_VERIFIED);

                              var customHttpRequest = Request(
                                  'DELETE',
                                  Uri.parse(
                                      '${Urls.ROOT_URL}/api/delete_product'));
                              customHttpRequest.body = json.encode({
                                'csrfToken': usefulResponseHeaders[
                                    CSRF_TOKEN_HEADER_NAME],
                                'itemId': productsArray[index]['id'],
                                'userId': widget.data['user']['userId'],
                              });

                              customHttpRequest.headers.addAll({
                                'Cookie':
                                    '$SESSION_COOKIE_NAME=${usefulResponseHeaders[SESSION_COOKIE_NAME]}; $USER_VERIFIED=$userVerified'
                              });

                              var response =
                                  await useHttpProxy().send(customHttpRequest);

                              var responseBody = await response.stream
                                  .transform(utf8.decoder)
                                  .join();

                              if (jsonDecode(responseBody)['status'] ==
                                  'success')
                                setState(() {
                                  try {
                                    productsArray.removeAt(index);
                                  } catch (e) {}
                                });
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider()
          ],
        ));
    }

    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          children: widgets,
        ),
      ),
    );
  }
}
