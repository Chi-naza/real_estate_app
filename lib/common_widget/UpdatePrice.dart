//@dart=2.9
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/Constants.dart';
import '../utils/Urls.dart';
import '../utils/get_cookie.dart';
import '../utils/httpProxy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdatePrice extends StatefulWidget {
  var userId;
  var data;
  var onUpdate;
  UpdatePrice({Key key, this.userId, this.data, this.onUpdate})
      : super(key: key);

  @override
  _UpdatePriceState createState() => _UpdatePriceState();
}

class _UpdatePriceState extends State<UpdatePrice> {
  var itemQuantity;

  callApiToUpdateQuantity({quantity}) async {
    var usefulResponseHeaders = await getSessionCookie();
    var userVerified =
        (await SharedPreferences.getInstance()).getString(USER_VERIFIED);
    var response =
        await useHttpProxy().put('${Urls.ROOT_URL}/api/update_quantity',
            body: json.encode({
              'csrfToken': usefulResponseHeaders[CSRF_TOKEN_HEADER_NAME],
              'itemId': widget.data['id'],
              'userId': widget.userId,
              'quantity': quantity
            }),
            headers: {
          'Cookie':
              '$SESSION_COOKIE_NAME=${usefulResponseHeaders[SESSION_COOKIE_NAME]}; $USER_VERIFIED=$userVerified'
        });

    try {
      widget.onUpdate(quantity);
    } catch (e) {}
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.grey[200],
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: IconButton(
                color: Colors.black,
                padding: EdgeInsets.all(2),
                iconSize: 15,
                icon: Icon(Icons.remove),
                onPressed: () async {
                  if (int.parse(itemQuantity) != 1)
                    callApiToUpdateQuantity(
                        quantity: int.parse(itemQuantity) - 1);
                }),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        FutureBuilder(
            future: (() async {
              return json.decode((await useHttpProxy().post(
                '${Urls.ROOT_URL}/api/app/getProductQuantity',
                body: json.encode(
                  {"userId": widget.userId, "itemId": widget.data['id']},
                ),
              ))
                  .body)['quantity'];
            }()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                itemQuantity = snapshot.data.toString();
                return SizedBox(
                    width: 50,
                    height: 50,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        itemQuantity = value;
                      },
                      controller: TextEditingController()..text = itemQuantity,
                    ));
              } else
                return Center(
                  child: CircularProgressIndicator(),
                );
            }),
        SizedBox(
          width: 10,
        ),
        CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey[200],
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: IconButton(
                  color: Colors.black,
                  padding: EdgeInsets.all(2),
                  iconSize: 15,
                  icon: Icon(
                    Icons.add,
                  ),
                  onPressed: () async {
                    callApiToUpdateQuantity(
                        quantity: int.parse(itemQuantity) + 1);
                  }),
            )),
      ],
    );
  }
}
