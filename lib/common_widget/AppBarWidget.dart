//@dart=2.9
import 'dart:convert';

import 'package:flutter/material.dart';
import '../components/AppLogOut.dart';
import '../components/AppVerifyLogin.dart';
import '../components/login.dart';
import '../screens/ProductDetailScreen.dart';
import '../screens/ProductsPage.dart';
import '../utils/Urls.dart';
import '../utils/httpProxy.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class appBarWidget extends StatefulWidget with PreferredSizeWidget {
  const appBarWidget({Key key}) : super(key: key);

  @override
  _appBarWidgetState createState() => _appBarWidgetState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _appBarWidgetState extends State<appBarWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      title: Text('NaxTrust RealEstate'),
      actions: <Widget>[
        IconButton(
          onPressed: () async {
            showSearch(context: context, delegate: SearchProduct());
          },
          icon: Icon(FontAwesomeIcons.search),
          color: Color(0xFfffffff),
        ),
        FutureBuilder(future: (() async {
          return AppVerifyLogin.checkLogin();
        })(), builder: (context, snapshot) {
          if (snapshot.hasData) {
            return IconButton(
              onPressed: () async {
                if (snapshot.data['isLoggedIn'])
                  AppLogout.logOut(context);
                else
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => login()),
                  );
              },
              icon: Icon(snapshot.data['isLoggedIn']
                  ? FontAwesomeIcons.signOutAlt
                  : FontAwesomeIcons.user),
              color: Color(0xFfffffff),
            );
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        })
      ],
    );
    ;
  }
}

class SearchProduct extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(
        Icons.arrow_back,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
        future: (() async {
          return json.decode(await getResults(query: query))['products'];
        }()),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: createListView(context, snapshot),
            );
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        });
  }

  Future<String> getResults({query}) async {
    var request = await useHttpProxy().get(
        '${Urls.ROOT_URL}/api/search?page=1&query=/api/search?page=1&query=${Uri.encodeComponent(query.trim())}');
    return request.body;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(future: (() async {
      return await getResults(query: query);
    })(), builder: (context, snapshot) {
      if (snapshot.hasData) {
        var products = jsonDecode(snapshot.data)['products'];
        if (products.length == 0)
          return Center(
            child: Text(
              'No result Found',
              style: TextStyle(fontSize: 20),
            ),
          );

        return query.isEmpty
            ? Center(
                child: Text(
                  'Enter a query',
                  style: TextStyle(fontSize: 20),
                ),
              )
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(
                            slug: products[index],
                          ),
                        ),
                      );
                    },
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(products[index]['title']), Divider()],
                    ),
                  );
                });
      } else
        return Center(
          child: CircularProgressIndicator(),
        );
    });
  }
}
