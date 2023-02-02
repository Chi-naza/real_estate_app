import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../common_widget/CircularProgress.dart';
import '../screens/ProductDetailScreen.dart';
import '../utils/Urls.dart';
import '../utils/httpProxy.dart';
// import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_money/flutter_money.dart';
import 'package:http/http.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ProductsPage extends StatefulWidget {
  bool isSubList;

  ProductsPage({this.isSubList = false});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCategoryList(),
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return createListView(context, snapshot);
        else
          return Center(
            child: CircularProgressIndicator(),
          );
      },
    );
  }
}

Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
  if (snapshot.hasData) {
    var response = snapshot.data;
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(1.0),
      childAspectRatio: 8.0 / 9.0,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: List<Widget>.generate(response.length, (index) {
        return InkWell(
          onTap: () {
            print(response[index]);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                  slug: response[index],
                ),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.only(top: 5),
            child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                elevation: 0,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      FutureBuilder(
                          future: (() async {
                            return (await useHttpProxy().get(
                                    '${Urls.ROOT_URL}${response[index]['image']}'))
                                .bodyBytes;
                          }()),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Image.memory(
                                snapshot.data as Uint8List,
                                width: 70,
                                height: 70,
                                fit: BoxFit.contain,
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          }),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 10, right: 10, top: 15),
                        child: Text(
                            (response[index]['title'].length <= 40
                                ? response[index]['title']
                                : response[index]['title'].substring(0, 40)),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color(0xFF444444),
                                fontFamily: 'Roboto-Light.ttf',
                                fontSize: 15,
                                fontWeight: FontWeight.w400)),
                      ),
                      SmoothStarRating(
                        allowHalfRating: true,
                        onRated: (v) {},
                        starCount: 5,
                        rating: response[index]['rating'] + 0.0,
                        size: 20.0,
                        isReadOnly: true,
                        color: Colors.yellow,
                        borderColor: Colors.yellow,
                        spacing: 0.0,
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 10, right: 10, top: 15),
                        child: Text(
                            "\$${(response[index]['price'] != null) ? FlutterMoney(amount: response[index]['price'] + 0.0).output.nonSymbol.split('.')[0] : 'Unavailable'}",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color(0xFFf67426),
                                fontFamily: 'Roboto-Light.ttf',
                                fontSize: 15,
                                fontWeight: FontWeight.w400)),
                      ),
                    ],
                  ),
                )),
          ),
        );
      }),
    );
  } else {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

getCategoryList() async {
  Response response;
  response = await useHttpProxy().get('${Urls.ROOT_URL}/api/products?limit=6');
  print(response);
  int statusCode = response.statusCode;
  final body = json.decode(response.body)['products'];
  if (statusCode == 200) return body;
}
