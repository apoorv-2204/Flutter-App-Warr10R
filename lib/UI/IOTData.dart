import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class IOTData extends StatefulWidget {
  const IOTData({Key key}) : super(key: key);

  @override
  _IOTDataState createState() => _IOTDataState();
}

class _IOTDataState extends State<IOTData> {
  double ht, wd, notificationBarHeight;
  TextEditingController urlController;
  FocusNode urlNode;
  String id = '9223372036854775808',
      handler = 'DL313418',
      lat = '37.377166',
      lng = '-122.086966',
      temperature = '';
  var source = Random();


  @override
  void initState() {
    super.initState();
    urlController = TextEditingController();
    temperature = (source.nextDouble() * (source.nextInt(50) - 40 )).toStringAsFixed(2);
  }

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Size size = MediaQuery.of(context).size;
    ht = size.height;
    wd = size.width;
    notificationBarHeight = MediaQuery.of(context).padding.top;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: ht * 0.15,
              width: wd,
              margin:
                  EdgeInsets.only(top: notificationBarHeight + ht * 0.025),
              child: Center(
                child: Text(
                  "IOT Data",
                  style: TextStyle(
                    fontSize: 45,
                    fontFamily: "Agus",
                  ),
                ),
              ),
            ), //IOT Heading
            Container(
              height: ht * 0.6,
              width: wd,
              child: Center(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: ht * 0.045),
                      child: Column(
                        children: [
                          Text(
                            "Id",
                            style: TextStyle(
                              fontSize: 21,
                              fontFamily: "Agus",
                            ),
                          ),
                          Text(
                            id,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Agus",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: ht * 0.045),
                      child: Column(
                        children: [
                          Text(
                            "TimeStamp",
                            style: TextStyle(
                              fontSize: 21,
                              fontFamily: "Agus",
                            ),
                          ),
                          Text(
                            DateTime.now().millisecondsSinceEpoch.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Agus",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: ht * 0.045),
                      child: Column(
                        children: [
                          Text(
                            "Temperature",
                            style: TextStyle(
                              fontSize: 21,
                              fontFamily: "Agus",
                            ),
                          ),
                          Text(
                            temperature + " \u2103",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Agus",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: ht * 0.045),
                      child: Column(
                        children: [
                          Text(
                            "Handler",
                            style: TextStyle(
                              fontSize: 21,
                              fontFamily: "Agus",
                            ),
                          ),
                          Text(
                            handler,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Agus",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: ht * 0.045),
                      child: Column(
                        children: [
                          Text(
                            "Location",
                            style: TextStyle(
                              fontSize: 21,
                              fontFamily: "Agus",
                            ),
                          ),
                          Text(
                            'lat: ' + lat,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Agus",
                            ),
                          ),
                          Text(
                            'lng: ' + lng,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Agus",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ), //Data Fields
            Container(
              width: wd * 0.75,
              child: TextField(
                focusNode: urlNode,
                controller: urlController,
                onTap: () {
                  FocusScope.of(context).requestFocus(urlNode);
                },
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.black,
                    ),
                  ),
                  hintText: "Submission URL",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: RaisedButton(
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Agus",
                    color: Colors.white,
                  ),
                ),
                color: Colors.lightBlue,
                elevation: 5,
                onPressed: () {
                  print(urlController.value.text);
                  submitIOTData(urlController.value.text);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  submitIOTData(String apiURL) async {
    var url = Uri.parse(apiURL),
        body = jsonEncode({
          "id": id,
          "ts": DateTime.now().millisecondsSinceEpoch.toString(),
          "temp": temperature,
          "handler": handler,
          "lat": lat,
          "lng": lng
        }),
        headers = {'Content-Type': 'application/json'};
    var response = await http.post(url, body: body, headers: headers);
    print(response);
  }
}
