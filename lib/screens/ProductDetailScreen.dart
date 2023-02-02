import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../common_widget/AppBarWidget.dart';
import '../common_widget/UpdatePrice.dart';
import '../components/AppVerifyLogin.dart';
import '../components/login.dart';
import '../screens/ShoppingCartScreen.dart';
import '../utils/Constants.dart';
import '../utils/Urls.dart';
import '../utils/get_cookie.dart';
import '../utils/httpProxy.dart';
// import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_money/flutter_money.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailScreen extends StatefulWidget {
  var slug;

  ProductDetailScreen({@required this.slug});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(Duration(milliseconds: 1))
            .then((value) => setState(() {}));
      },
      child: FutureBuilder(
          future: (() async {
            return AppVerifyLogin.checkLogin();
          }()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Scaffold(
                key: scaffoldKey,
                backgroundColor: Color(0xFFfafafa),
                appBar: appBarWidget(),
                body: createDetailView(widget.slug,
                    userId: (snapshot.data as Map)['userId']),
                bottomNavigationBar: BottomNavBar(
                  scaffoldKey,
                  itemId: widget.slug['id'],
                  userId: (snapshot.data as Map)['userId'],
                ),
              );
            } else {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  var scaffoldKey;
  var itemId;
  var userId;
  BottomNavBar(this.scaffoldKey, {this.itemId, this.userId});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 10),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.favorite_border,
            color: Color(0xFF5e5e5e),
          ),
          Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFfef2f2),
            foregroundColor: Colors.white,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
                side: BorderSide(color: Color(0xFFfef2f2))
              ),
            ),            
            onPressed: () async {
              var isLoggedIn =
                  (await AppVerifyLogin.checkLogin())['isLoggedIn'];
              if (!isLoggedIn) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => login()),
                );
                return;
              }

              var usefulResponseHeaders = await getSessionCookie();
              var userVerified = (await SharedPreferences.getInstance())
                  .getString(USER_VERIFIED);
              var response =
                  await useHttpProxy().post('${Urls.ROOT_URL}/api/add_item',
                      body: json.encode({
                        'csrfToken':
                            usefulResponseHeaders[CSRF_TOKEN_HEADER_NAME],
                        'itemId': this.itemId,
                        'userId': this.userId
                      }),
                      headers: {
                    'Cookie':
                        '$SESSION_COOKIE_NAME=${usefulResponseHeaders[SESSION_COOKIE_NAME]}; $USER_VERIFIED=$userVerified'
                  });

              var responseJson = json.decode(response.body);
              if (responseJson['status'] == 'success')
                scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text(
                      'Item added to Cart',
                    ),
                  ),
                );
              else
                scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text(responseJson['error']),
                  ),
                );
            },
            child: Container(
              padding: EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 15),
              child: Text("Add to cart".toUpperCase(),
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFff665e))),
            ),
          ),
        ],
      ),
    );
  }
}

Widget createDetailView(data, {userId}) {
  return DetailScreen(
    data,
    userId: userId,
  );
}

class DetailScreen extends StatefulWidget {
  var data;
  var userId;
  DetailScreen(this.data, {this.userId});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          FutureBuilder(
              future: (() async {
                return (await useHttpProxy()
                        .get('${Urls.ROOT_URL}${widget.data['image']}'))
                    .bodyBytes;
              }()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Image.memory(
                    snapshot.data as Uint8List,
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  );
                } else
                  return Center(
                    child: CircularProgressIndicator(),
                  );
              }),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: Color(0xFFFFFFFF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("SKU".toUpperCase(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF565656))),
                Text(widget.data['title'],
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFfd0100))),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: Color(0xFFFFFFFF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("View Certificate".toUpperCase(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF565656))),
                InkWell(
                  onTap: () async {
                    await launch(widget.data['certificate']);
                  },
                  child: Text('View',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFfd0100))),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: Color(0xFFFFFFFF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("RATINGS".toUpperCase(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF565656))),
                SmoothStarRating(
                  allowHalfRating: false,
                  onRated: (v) {},
                  starCount: 5,
                  rating: widget.data['rating'] + 0.0,
                  size: 30.0,
                  isReadOnly: true,
                  color: Colors.yellow,
                  borderColor: Colors.yellow,
                  spacing: 0.0,
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          widget.data['category'] != 'Landed Property'
              ? Container(
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
                  color: Color(0xFFFFFFFF),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Quantity".toUpperCase(),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF565656))),
                      UpdatePrice(data: widget.data, userId: widget.userId)
                    ],
                  ),
                )
              : Container(),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: Color(0xFFFFFFFF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Price".toUpperCase(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF565656))),
                Text(
                    "\$${FlutterMoney(amount: widget.data['price'] + 0.0).output.nonSymbol.split('.')[0]}"
                        .toUpperCase(),
                    style: TextStyle(
                        color: Color(0xFFf67426),
                        fontFamily: 'Roboto-Light.ttf',
                        fontSize: 20,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.topLeft,
            width: double.infinity,
            padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: Color(0xFFFFFFFF),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Description",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF565656))),
                SizedBox(
                  height: 15,
                ),
                Text(widget.data['description'] ?? "No description",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF4c4c4c))),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.topLeft,
            width: double.infinity,
            padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: Color(0xFFFFFFFF),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Specification",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF565656))),
                SizedBox(
                  height: 15,
                ),
                Column(
                  children: generateProductSpecification(context),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Widget> generateProductSpecification(BuildContext context) {
    List<Widget> list = [];
    int count = 0;
    ['', ''].forEach((specification) {
      Widget element = Container(
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Weight',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF444444))),
            Text('Weight',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF212121))),
          ],
        ),
      );
      list.add(element);
      count++;
    });
    return list;
  }
}
