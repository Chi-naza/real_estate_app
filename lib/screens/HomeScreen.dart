import 'package:flutter/material.dart';
import '../screens/ProductsPage.dart';
import '../common_widget/PopularMenu.dart';
import '../common_widget/TopPromoSlider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        TopPromoSlider(),
        PopularMenu(),
        SizedBox(
          height: 10,
          child: Container(
            color: Color(0xFFf5f6f7),
          ),
        ),
        PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: TabBar(
            labelColor: Colors.black,
            tabs: [
              Tab(
                text: 'Trending',
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
          child: Container(
            color: Color(0xFFf5f6f7),
          ),
        ),
        ProductsPage()
      ],
    );
  }
}
