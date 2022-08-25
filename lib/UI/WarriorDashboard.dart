import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as qrScanner;
import 'package:vaccine_distribution/BackEnd/BlockChain.dart';
import 'package:vaccine_distribution/BackEnd/Firebase.dart';
import 'package:vaccine_distribution/UI/DisplayVialDetails.dart';
import 'package:vaccine_distribution/main.dart';

final GlobalKey _warriorDashBoardScaffold = GlobalKey<ScaffoldState>();

final PageController _warriorPageCtrl = PageController();
List<Map<String, dynamic>> warriorHistory = [
/*  {
    "dt": DateTime.now().toIso8601String(),
    "patientId": "123412341234",
    "vaccineType": "Pfyzer-2D",
    "vailId": "shtthfkup77tsf7gib",
  }*/
];

class WarriorPageOffset extends ChangeNotifier {
  double _offset = 0, _page = 0;

  double get offset => _offset;

  double get page => _page;

  WarriorPageOffset(PageController pageController) {
    pageController.addListener(() {
      _offset = pageController.offset;
      _page = pageController.page;
      notifyListeners();
    });
  }
}

final warriorPagesOffsetProvider = ChangeNotifierProvider<WarriorPageOffset>(
    (ref) => WarriorPageOffset(_warriorPageCtrl));

class WarriorDashboard extends StatefulWidget {
  @override
  _WarriorDashboardState createState() => _WarriorDashboardState();
}

class _WarriorDashboardState extends State<WarriorDashboard> {
  double ht, wd, notificationBarHeight;
  // int _popupMenuSelection; //ToDo: Remove if Unused
  PageController warriorPageCtrl;

  @override
  void initState() {
    super.initState();
    warriorPageCtrl = PageController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    refreshRecords();

    Size size = MediaQuery.of(context).size;
    ht = size.height;
    wd = size.width;
    notificationBarHeight = MediaQuery.of(context).padding.top;
  }

  @override
  void dispose() {
    super.dispose();
    warriorPageCtrl.dispose();
  }

  void refreshRecords() async {

    var warriorTransactions = await BlockChain.getDetails(FirebaseCustoms.auth.currentUser.uid, 'd');
    if(warriorTransactions != null) {
      warriorHistory = [];
      warriorHistory.addAll(warriorTransactions);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        key: _warriorDashBoardScaffold,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                height: ht * 0.13,
                width: wd,
                padding: EdgeInsets.only(top: notificationBarHeight),
                color: Colors.lightBlueAccent,
                child: Row(
                  children: [
                    Container(
                      width: wd * 0.85,
                      height: ht * 0.11 - notificationBarHeight,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                        left: 20,
                      ),
                      child: Text(
                        "Precisely Random",
                        // FirebaseCustoms.auth.currentUser.displayName ?? "Dashboard",
                        style: TextStyle(
                          fontSize: 21,
                          fontFamily: "Agus",
                        ),
                      ),
                    ), //Patient DashBoard
                    Container(
                      width: wd * 0.15,
                      height: ht * 0.11 - notificationBarHeight,
                      alignment: Alignment.center,
                      child: PopupMenuButton<int>(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        icon: Icon(Icons.more_vert),
                        offset: Offset(0, ht * 0.1),
                        onSelected: (int value) async {
                          print(value);
                          switch (value) {
                            case 1:
                              refreshRecords();
                              break;
                            case 2:
                              await Navigator.of(context).push(MaterialPageRoute(builder: (context) => DisplayVialDetails()));
                              break;
                            case 3:
                              FirebaseCustoms.logOut().then((value) {
                                Navigator.pop(context);
                              });
                              break;
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<int>>[
                          const PopupMenuItem<int>(
                            value: 1,
                            child: Text('Refresh'),
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontFamily: "Agus",
                              fontSize: 16,
                            ),
                          ), //Refresh
                          const PopupMenuItem<int>(
                            value: 2,
                            child: Text('Track Vial'),
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontFamily: "Agus",
                              fontSize: 16,
                            ),
                          ), //Logout
                          const PopupMenuItem<int>(
                            value: 3,
                            child: Text('Logout'),
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontFamily: "Agus",
                              fontSize: 16,
                            ),
                          ), //Logout
                        ], //PopUpMenu
                      ),
                    ),
                  ],
                ), //AppBar
              ),
            ), //AppBar
            WarriorDashboardTabs(context, ht, wd, notificationBarHeight),
            Positioned(
              top: ht * 0.19,
              child: Container(
                height: ht * 0.81,
                width: wd,
                child: PageView(
                  controller: _warriorPageCtrl,
                  pageSnapping: true,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: ht * 0.81,
                          width: wd,
                          color: Colors.white,
                          child: WarriorHistoryList(
                            ht: ht * 0.81,
                            wd: wd,
                            top: ht * 0.19,
                          ),
                        ),
                        Positioned(
                          right: 32.0,
                          bottom: 32.0,
                          child: FloatingActionButton(
                            onPressed: () async {
                              await _warriorPageCtrl.animateToPage(1,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeOut);
                            },
                            child: Icon(Icons.add),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.lightBlueAccent,
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Positioned(
                          top: ht * 0,
                          child: Container(
                            height: ht * 0.81,
                            width: wd,
                            color: Colors.white,
                            child: WarriorNewRecord(
                              top: ht * 0.19,
                              ht: ht * 0.81,
                              wd: wd,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WarriorDashboardTabs extends ConsumerWidget {
  WarriorDashboardTabs(
      this.context, this.ht, this.wd, this.notificationBarHeight);

  final double ht, wd, notificationBarHeight;
  final BuildContext context;

  void dispose() {
    _warriorPageCtrl.dispose();
  }

  @override
  Widget build(BuildContext context, watch) {
    final pageOffset = watch(warriorPagesOffsetProvider);
    final double p1 = (wd - pageOffset._offset) / wd,
        p2 = (pageOffset._offset) / wd;
    final Color c2 = Color.fromRGBO(
        (255 * p1).round(), (255 * p1).round(), (255 * p1).round(), 1);
    final Color c1 = Color.fromRGBO(
        (255 * p2).round(), (255 * p2).round(), (255 * p2).round(), 1);

    return Stack(
      children: [
        Positioned(
          top: ht * 0.13,
          height: ht * 0.06,
          child: Stack(
            children: [
              Container(
                height: ht * 0.05,
                width: wd,
                color: Colors.lightBlueAccent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _warriorPageCtrl.animateToPage(0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeOut);
                      },
                      child: Container(
                        height: ht * 0.03,
                        width: wd / 2,
                        child: Text(
                          "History",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Agus",
                            fontSize: p1 * 5 + 16,
                            color: c1,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _warriorPageCtrl.animateToPage(1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeOut);
                      },
                      child: Container(
                        height: ht * 0.03,
                        width: wd / 2,
                        child: Text(
                          "Add Record",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Agus",
                            fontSize: p2 * 5 + 16,
                            color: c2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: ht * 0.05,
                left: pageOffset._offset / 2,
                child: Container(
                  height: 2.5,
                  width: wd / 2,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ), //Page Tabs
      ],
    );
  }
}

class WarriorHistoryList extends StatefulWidget {
  final double ht, wd, top;

  const WarriorHistoryList({Key key, this.ht, this.wd, this.top})
      : super(key: key);

  @override
  _WarriorHistoryListState createState() => _WarriorHistoryListState();
}

class _WarriorHistoryListState extends State<WarriorHistoryList> {
  double ht, wd, top;

  @override
  void initState() {
    super.initState();
    ht = widget.ht;
    wd = widget.wd;
    top = widget.top;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowGlow();
          return true;
        },
        child: Scrollbar(
          radius: Radius.circular(10),
          child: ListView(
            padding: EdgeInsets.zero,
            children: warriorHistory.map((record) {
              print(record);
              DateTime dt = DateTime.parse(record["time"]);

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: ht * 0.125,
                  ),
                  child: ExpansionTile(
                    childrenPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    title: Text(
                      "${record["reciever"]}",
                      style: TextStyle(
                        fontFamily: "Agus",
                        fontSize: 21,
                      ),
                    ),
                    subtitle:Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        record["type"]??="Unknown",
                        style: TextStyle(
                          fontFamily: "Agus",
                          fontSize: 18,
                        ),
                      ),
                    ),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    expandedAlignment: Alignment.centerLeft,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          "Vial: ${record["id"]}",
                          style: TextStyle(
                            fontFamily: "Agus",
                            fontSize: 18,
                            color: Colors.black.withOpacity(0.55),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                        child: Text(
                          dateFormatter(record["time"]),
                          style: TextStyle(
                            fontFamily: "Agus",
                            fontSize: 18,
                            color: Colors.black.withOpacity(0.55),
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 0.45,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class WarriorNewRecord extends StatefulWidget {
  final double ht, wd, top;

  const WarriorNewRecord({Key key, this.ht, this.wd, this.top})
      : super(key: key);

  @override
  _WarriorNewRecordState createState() => _WarriorNewRecordState();
}

class _WarriorNewRecordState extends State<WarriorNewRecord> {
  double ht, wd, top;
  TextEditingController warriorAadharInputCtrl;
  FocusNode warriorAadharInputFocusNode;
  Map<String, String> vailQRDetails = {};
  Set<String> vailQRKeys = {
    "vailId",
    "manufacturer",
    "name",
    "batch",
    "timeStamp"
  };

  @override
  void initState() {
    super.initState();
    ht = widget.ht;
    wd = widget.wd;
    top = widget.top;

    warriorAadharInputCtrl = TextEditingController();
    warriorAadharInputFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ht,
      width: wd,
      child: Stack(
        children: [
          Positioned(
            top: ht * 0.05,
            child: Container(
              height: ht * 0.25,
              width: wd,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: wd * 0.1),
              child: TextField(
                focusNode: warriorAadharInputFocusNode,
                controller: warriorAadharInputCtrl,
                onTap: () {
                  FocusScope.of(context)
                      .requestFocus(warriorAadharInputFocusNode);
                },
                onChanged: (patientAadhar) {},
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.black,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      width: 2.5,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                  hintStyle: TextStyle(
                    letterSpacing: 1,
                  ),
                  hintText: "Aadhar Number",
                ),
                style: TextStyle(
                  fontSize: 18,
                  letterSpacing: 5.0,
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
              ),
            ),
          ),  //Aadhar Input
          Positioned(
            top: ht * 0.3,
            height: ht * 0.5,
            child: Container(
              height: ht * 0.5,
              width: wd,
              child: Stack(
                children: [
                  Visibility(
                    visible: vailQRDetails.isEmpty,
                    child: Center(
                      child: Container(
                        height: 60,
                        width: 165,
                        child: RaisedButton(
                          onPressed: () async {
                            try {
                              await Permission.camera.request();
                              String vailJSON = await qrScanner.scan();
                              Map<String, dynamic> vailJSONMap =
                                  json.decode(vailJSON);
                              vailJSONMap
                                ..forEach((key, value) {
                                  print(key);
                                  if (vailQRKeys.contains(key))
                                    vailQRDetails.addAll({key: value});
                                  else {
                                    vailQRDetails = {};
                                    return;
                                  }
                                });
                              setState(() {});
                            } on FormatException catch (format) {
                              print('Invalid QR Code');
                              var qrErrorSnack = SnackBar(
                                content: Text("Invalid Input"),
                              );
                              //ToDo: Error for Invalid QR Code.
                              print(format.message);
                            } catch (e) {
                              print(e);
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: Colors.lightBlueAccent,
                          elevation: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.qr_code_scanner,
                                size: 28,
                              ),
                              Text(
                                "Scan",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Agus",
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),  //QR Scanner
                  Visibility(
                    visible: vailQRDetails.isNotEmpty,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: ht * 0.075,
                            width: wd,
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: Text(
                              "${vailQRDetails["manufacturer"]}-${vailQRDetails["name"]}",
                              style: TextStyle(
                                fontFamily: "Agus",
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Container(
                            height: ht * 0.075,
                            width: wd,
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: Text(
                              "Vail Id: ${vailQRDetails["vailId"]}",
                              style: TextStyle(
                                fontFamily: "Agus",
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Container(
                            height: ht * 0.075,
                            width: wd,
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: Text(
                              "Batch: ${vailQRDetails["batch"]}",
                              style: TextStyle(
                                fontFamily: "Agus",
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Container(
                            height: ht * 0.075,
                            width: wd,
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: Text(
                              vailQRDetails["timeStamp"] == null
                                  ? ""
                                  : "${DateTime.parse(vailQRDetails["timeStamp"]).day}/${DateTime.parse(vailQRDetails["timeStamp"]).month}/${DateTime.parse(vailQRDetails["timeStamp"]).year} - ${DateTime.parse(vailQRDetails["timeStamp"]).hour}:${DateTime.parse(vailQRDetails["timeStamp"]).minute}",
                              style: TextStyle(
                                fontFamily: "Agus",
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),  //QR Details
                ],
              ),
            ),
          ),  //QR Scanner + Details
          Positioned(
            top: ht * 0.8,
            height: ht * 0.2,
            width: wd,
            child: Visibility(
              visible: vailQRDetails.isNotEmpty,
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: ht * 0.07,
                      width: wd * 0.315,
                      margin: EdgeInsets.only(right: 15),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.white,
                        elevation: 2,
                        onPressed: () async {
                          try {
                            await Permission.camera.request();
                            String vailJSON = await qrScanner.scan();
                            Map<String, dynamic> vailJSONMap =
                                json.decode(vailJSON);
                            vailJSONMap.forEach((key, value) {
                              if (key == "vailId" ||
                                  key == "manufacturer" ||
                                  key == "name" ||
                                  key == "batch" ||
                                  key == "timeStamp")
                                vailQRDetails.addAll({key: value});
                              else
                                vailQRDetails = {};
                            });
                            setState(() {});

                          /*
                          * vailId: '12345',
                            manufacturer: "Pfyzer",
                            name: 'BLQ45-HJ',
                            batch: 'B001',
                            timeStamp: '2021-01-16T18:32:23+0000',*/

                          } on FormatException catch (format) {
                            print('Invalid QR Code');
                            //ToDo: Error for Invalid QR Code.
                            print(format.message);
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Text(
                          "Re-Scan QR",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Agus",
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: ht * 0.07,
                      width: wd * 0.285,
                      margin: EdgeInsets.only(left: 15),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.lightBlueAccent,
                        elevation: 2,
                        onPressed: () async {
                          warriorHistory.insert(0, {
                            "time": DateTime.now().toIso8601String(),
                            "reciever": warriorAadharInputCtrl.value.text,
                            "type":
                                "${vailQRDetails["manufacturer"]}-${vailQRDetails["name"]}",
                            "id": vailQRDetails["vailId"],
                          });

                          Map<int, String> responseStatus = await BlockChain.addDetails(vailQRDetails["vailId"], FirebaseCustoms.auth.currentUser.uid, warriorAadharInputCtrl.value.text, 'v');

                          print(responseStatus);

                          vailQRDetails = {};
                          warriorAadharInputCtrl.text = "";
                          setState(() {});
                          _warriorPageCtrl.animateToPage(0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.decelerate);

                        },
                        child: Text(
                          "Add",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Agus",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),  //Action Buttons
        ],
      ),
    );
  }
}
