import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

class TopPromoSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Container(
          height: 150.0,
          width: double.infinity,
          child: Carousel(
            images: [
              Image.asset(
                "assets/images/promotion__one.jpg",
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Image.asset(
                "assets/images/promotion_two.jpg",
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Image.asset(
                "assets/images/promotion_three.jpg",
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ],
            dotSize: 4.0,
            dotSpacing: 15.0,
            dotColor: Colors.purple,
            indicatorBgPadding: 5.0,
            dotBgColor: Colors.black54.withOpacity(0.2),
            borderRadius: true,
            radius: Radius.circular(20),
            moveIndicatorFromBottom: 180.0,
            noRadiusForIndicator: true,
          )),
    );
  }
}
