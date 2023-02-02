//@dart=2.9
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../components/signup.dart';
import '../utils/Constants.dart';
import '../utils/Urls.dart';
import 'package:http_parser/http_parser.dart';
import '../utils/get_cookie.dart';
import '../utils/httpProxy.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../main.dart';

class WishListScreen extends StatefulWidget {
  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  var featureList = [
    'Movable Asset',
    'Landed Property',
  ];

  var openShopController = {
    'title': TextEditingController(),
    'price': TextEditingController(),
    'feature': TextEditingController(),
    'numberOfHouse': TextEditingController(),
    'location': TextEditingController(),
    'description': TextEditingController(),
  };

  var hidePassword = true;
  var hidePasswordIcon = FontAwesomeIcons.eye;
  var signInKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var isLoading = false;
  var selectedItem;
  File imageFile;
  File imageFile1;
  File imageFile2;
  File imageFile3;
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedItem = featureList[0];
  }

  @override
  Widget build(BuildContext context) {
    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

    var dropDownFeaturesWidget = <DropdownMenuItem>[];

    for (int i = 0; i < featureList.length; i++) {
      dropDownFeaturesWidget.add(
          DropdownMenuItem(child: Text(featureList[i]), value: featureList[i]));
    }

    return Scaffold(
        key: scaffoldKey,
        body: SafeArea(
          child: Container(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: signInKey,
              child: ListView(
                reverse: true,
                shrinkWrap: true,
                padding: EdgeInsets.all(32),
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: openShopController['title'],
                        showCursor: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          fillColor: Color(0xFFF2F3F5),
                          hintStyle: TextStyle(
                              color: Color(0xFF666666),
                              fontFamily: defaultFontFamily,
                              fontSize: defaultFontSize),
                          hintText: "Title",
                        ),
                        validator: MultiValidator([
                          RequiredValidator(
                            errorText: 'Required',
                          ),
                        ]),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () async {
                          showDialog<ImageSource>(
                            context: context,
                            builder: (context) => AlertDialog(
                                content: Text("Choose image source"),
                                actions: [
                                  TextButton(
                                    child: Text("Camera"),
                                    onPressed: () => Navigator.pop(
                                        context, ImageSource.camera),
                                  ),
                                  TextButton(
                                    child: Text("Gallery"),
                                    onPressed: () => Navigator.pop(
                                        context, ImageSource.gallery),
                                  ),
                                ]),
                          ).then((ImageSource source) async {
                            if (source != null) {
                              imageFile = File((await ImagePicker().pickImage(
                                source: source,
                              ))
                                  .path as String);
                              setState(() {});
                            }
                          });
                        },
                        child: Container(
                          child: imageFile != null
                              ? Image.file(
                                  imageFile,
                                )
                              : Center(
                                  child: Text('Upload Image'),
                                ),
                          decoration: BoxDecoration(
                            color: Color(0xFFF2F3F5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: double.infinity,
                          height: 200,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () async {
                          showDialog<ImageSource>(
                            context: context,
                            builder: (context) => AlertDialog(
                                content: Text("Choose image source"),
                                actions: [
                                  TextButton(
                                    child: Text("Camera"),
                                    onPressed: () => Navigator.pop(
                                        context, ImageSource.camera),
                                  ),
                                  TextButton(
                                    child: Text("Gallery"),
                                    onPressed: () => Navigator.pop(
                                        context, ImageSource.gallery),
                                  ),
                                ]),
                          ).then((ImageSource source) async {
                            if (source != null) {
                              imageFile1 = File((await ImagePicker().pickImage(
                                source: source,
                              ))
                                  .path as String);
                              setState(() {});
                            }
                          });
                        },
                        child: Container(
                          child: imageFile1 != null
                              ? Image.file(
                                  imageFile1,
                                )
                              : Center(
                                  child: Text('Upload Image'),
                                ),
                          decoration: BoxDecoration(
                            color: Color(0xFFF2F3F5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: double.infinity,
                          height: 200,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () async {
                          showDialog<ImageSource>(
                            context: context,
                            builder: (context) => AlertDialog(
                                content: Text("Choose image source"),
                                actions: [
                                  TextButton(
                                    child: Text("Camera"),
                                    onPressed: () => Navigator.pop(
                                        context, ImageSource.camera),
                                  ),
                                  TextButton(
                                    child: Text("Gallery"),
                                    onPressed: () => Navigator.pop(
                                        context, ImageSource.gallery),
                                  ),
                                ]),
                          ).then((ImageSource source) async {
                            if (source != null) {
                              imageFile2 = File((await ImagePicker().pickImage(
                                source: source,
                              ))
                                  .path as String);
                              setState(() {});
                            }
                          });
                        },
                        child: Container(
                          child: imageFile2 != null
                              ? Image.file(
                                  imageFile2,
                                )
                              : Center(
                                  child: Text('Upload Image'),
                                ),
                          decoration: BoxDecoration(
                            color: Color(0xFFF2F3F5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: double.infinity,
                          height: 200,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () async {
                          showDialog<ImageSource>(
                            context: context,
                            builder: (context) => AlertDialog(
                                content: Text("Choose image source"),
                                actions: [
                                  TextButton(
                                    child: Text("Camera"),
                                    onPressed: () => Navigator.pop(
                                        context, ImageSource.camera),
                                  ),
                                  TextButton(
                                    child: Text("Gallery"),
                                    onPressed: () => Navigator.pop(
                                        context, ImageSource.gallery),
                                  ),
                                ]),
                          ).then((ImageSource source) async {
                            if (source != null) {
                              imageFile3 = File((await ImagePicker().pickImage(
                                source: source,
                              ))
                                  .path as String);
                              setState(() {});
                            }
                          });
                        },
                        child: Container(
                          child: imageFile3 != null
                              ? Image.file(
                                  imageFile3,
                                )
                              : Center(
                                  child: Text('Upload C of O'),
                                ),
                          decoration: BoxDecoration(
                            color: Color(0xFFF2F3F5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: double.infinity,
                          height: 200,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: openShopController['price'],
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        showCursor: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          fillColor: Color(0xFFF2F3F5),
                          hintStyle: TextStyle(
                            color: Color(0xFF666666),
                            fontFamily: defaultFontFamily,
                            fontSize: defaultFontSize,
                          ),
                          hintText: "Price",
                        ),
                        validator: RequiredValidator(
                          errorText: 'Required',
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: double.infinity,
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                          value: selectedItem,
                          onChanged: (value) {
                            setState(() {
                              selectedItem = value;
                            });
                          },
                          items: dropDownFeaturesWidget,
                        )),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: openShopController['numberOfHouse'],
                        showCursor: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          fillColor: Color(0xFFF2F3F5),
                          hintStyle: TextStyle(
                              color: Color(0xFF666666),
                              fontFamily: defaultFontFamily,
                              fontSize: defaultFontSize),
                          hintText: "Number Of Houses Available",
                        ),
                        validator: MultiValidator([
                          RequiredValidator(
                            errorText: 'Required',
                          ),
                        ]),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: openShopController['location'],
                        showCursor: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          fillColor: Color(0xFFF2F3F5),
                          hintStyle: TextStyle(
                              color: Color(0xFF666666),
                              fontFamily: defaultFontFamily,
                              fontSize: defaultFontSize),
                          hintText: "location",
                        ),
                        validator: MultiValidator([
                          RequiredValidator(
                            errorText: 'Required',
                          ),
                        ]),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: openShopController['description'],
                        showCursor: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          fillColor: Color(0xFFF2F3F5),
                          hintStyle: TextStyle(
                              color: Color(0xFF666666),
                              fontFamily: defaultFontFamily,
                              fontSize: defaultFontSize),
                          hintText: "Description",
                        ),
                        validator: MultiValidator([
                          RequiredValidator(
                            errorText: 'Required',
                          ),
                        ]),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(17.0),
                            backgroundColor: Color(0xFFBC1F26),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: BorderSide(color: Color(0xFFBC1F26))),
                          ),                          
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            await uploadShop();
                            setState(() {
                              isLoading = false;
                            });
                          },
                          child: isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  "SELL",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'Poppins-Medium.ttf',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                        ),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Color(0xFFF2F3F7)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ].reversed.toList(),
              ),
            ),
          ),
        ));
  }

  uploadShop() async {
    if (imageFile != null &&
        openShopController['title'].text.trim() != null &&
        openShopController['price'].text.trim() != null &&
        selectedItem != null &&
        openShopController['numberOfHouse'].text.trim() != null &&
        openShopController['description'].text.trim() != null) {
      try {
        await uploadMultiple(
            [imageFile, imageFile1, imageFile2, imageFile3],
            ['image', 'image_1', 'image_2', 'imageCertificateOfOccupancy'],
            MediaType('image', 'jpeg'),
            'https://naxtrust.com/house/openshop',
            {
              'title': openShopController['title'].text.trim(),
              'price': openShopController['price'].text.trim(),
              'category': selectedItem,
              'no_of_items': openShopController['numberOfHouse'].text.trim(),
              'description': openShopController['description'].text.trim(),
            });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Submitted successfully')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all fields')));
      }
    }
  }
}
