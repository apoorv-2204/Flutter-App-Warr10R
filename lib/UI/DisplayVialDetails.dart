import 'package:flutter/material.dart';
import 'package:vaccine_distribution/BackEnd/BlockChain.dart';
import 'package:vaccine_distribution/main.dart';

final _vialDetailsScaffoldKey = GlobalKey<ScaffoldState>();

class DisplayVialDetails extends StatefulWidget {
  @override
  _DisplayVialDetailsState createState() => _DisplayVialDetailsState();
}

class _DisplayVialDetailsState extends State<DisplayVialDetails> {
  double ht, wd, notificationBarHeight;
  bool searchData = false;
  TextEditingController vialIdCtrl;
  FocusNode vialIdNode;

  SnackBar _displaySnackBar(String message, Color color, Duration duration) {
    _vialDetailsScaffoldKey.currentState.removeCurrentSnackBar();
    return SnackBar(
      content: Container(
        height: 30,
        child: Center(
          child: Text(
            message.toUpperCase(),
            style: TextStyle(
              fontSize: 21,
              fontFamily: "Agus",
            ),
          ),
        ),
      ),
      backgroundColor: color,
      duration: duration,
    );
  }

  @override
  void initState() {
    super.initState();

    vialIdCtrl = TextEditingController();
    vialIdNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ht = MediaQuery.of(context).size.height;
    wd = MediaQuery.of(context).size.width;
    notificationBarHeight = MediaQuery.of(context).padding.top;
  }

  @override
  void dispose() {
    vialIdCtrl.dispose();
    vialIdNode.dispose();

    super.dispose();
  }

  Future<List<Map<String, dynamic>>> vialIdFuture(String vialId) async {
    if (!searchData) return null;

    if ((vialId == null || vialId.isEmpty)) {
      _vialDetailsScaffoldKey.currentState.showSnackBar(
        _displaySnackBar(
          "Invalid Vial Id",
          Colors.deepOrange,
          Duration(seconds: 10),
        ),
      );
      searchData = false;
      return null;
    }


    List<Map<String, dynamic>> vialDetails = await BlockChain.getDetails(vialId, 'v');

    if (vialDetails == null || vialDetails.isEmpty) {
      _vialDetailsScaffoldKey.currentState.showSnackBar(
        _displaySnackBar(
          "Data Unavailable",
          Colors.deepOrange,
          Duration(seconds: 10),
        ),
      );
      searchData = false;
      return null;
    }

    _vialDetailsScaffoldKey.currentState.removeCurrentSnackBar();
    return vialDetails;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        key: _vialDetailsScaffoldKey,
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
                        "VIAL DETAILS",
                        style: TextStyle(
                          fontSize: 21,
                          fontFamily: "Agus",
                        ),
                      ),
                    ), //Patient DashBoard
                    GestureDetector(
                      onTap: (){
                        if(searchData)  {
                          _vialDetailsScaffoldKey.currentState.showSnackBar(
                            _displaySnackBar(
                              "Refreshing",
                              Colors.lightBlueAccent,
                              Duration(seconds: 5),
                            ),
                          );
                          setState(() {});
                        }
                      },
                      child: Container(
                        width: wd * 0.15,
                        height: ht * 0.11 - notificationBarHeight,
                        alignment: Alignment.center,
                        child: Icon(Icons.refresh),
/*                      child: PopupMenuButton<int>(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          icon: Icon(Icons.more_vert),
                          offset: Offset(0, ht * 0.1),
                          onSelected: (int value) {
                            print(value);
                            switch (value) {
                              case 1:
                                _vialDetailsScaffoldKey.currentState.showSnackBar(
                                  _displaySnackBar(
                                    "Refreshing",
                                    Colors.lightBlueAccent,
                                    Duration(seconds: 5),
                                  ),
                                );
                                vialIdFuture(vialIdCtrl.value.text);
                                break;
                              case 2:
                                //ToDo: Implement Details ShowCase
                                break;
                              case 3:
                                FirebaseCustoms.logOut().then((value) {
                                  Navigator.pop(context);
                                });
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
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
                              value: 1,
                              child: Text('Details'),
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontFamily: "Agus",
                                fontSize: 16,
                              ),
                            ), //Details
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
                        ),*/
                      ),
                    ),
                  ],
                ), //AppBar
              ),
            ), //AppBar
            Positioned(
              top: ht * 0.13,
              child: FutureBuilder(
                future: vialIdFuture(vialIdCtrl.value.text),
                builder: (context, dataSnap) {
                  print(dataSnap.data.runtimeType);

                  List<Map<String, dynamic>> vialDetailsList = dataSnap.data;

                  if (dataSnap.hasData) {
                    return Visibility(
                      visible: dataSnap.hasData,
                      child: Container(
                        height: ht * 0.8,
                        width: wd,
                        child: ListView(
                          children: vialDetailsList.map((transaction) {
                            return VialDetailsTile(transaction);
                          }).toList(),
                        ),
                      ),
                    );
                  } else
                    return Container();
                },
              ),
            ), //Details List
            Positioned(
              top: ht * 0.35,
              left: wd * 0.1,
              height: ht * 0.1,
              width: wd * 0.8,
              child: Visibility(
                visible: !searchData,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: vialIdCtrl,
                    focusNode: vialIdNode,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
                      ),
                      hintText: "Vial ID",
                    ),
                  ),
                ),
              ),
            ), //Vial Id Input
            Positioned(
              top: ht * 0.55,
              left: wd * 0.35,
              child: Visibility(
                visible: !searchData,
                child: Container(
                  height: ht * 0.06,
                  width: wd * 0.3,
                  child: RaisedButton(
                    onPressed: () async {
                      _vialDetailsScaffoldKey.currentState.showSnackBar(
                        _displaySnackBar(
                          "Searching",
                          Colors.lightBlueAccent,
                          Duration(minutes: 5),
                        ),
                      );

                      searchData = true;
                      await vialIdFuture(vialIdCtrl.value.text);
                      setState(() {});
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Search",
                      style: TextStyle(
                        fontSize: 18,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    color: Colors.lightBlueAccent,
                    elevation: 10,
                    splashColor: Colors.white,
                  ),
                ),
              ),
            ), //Action Button
          ],
        ),
      ),
    );
  }
}

class VialDetailsTile extends StatelessWidget {
  VialDetailsTile(this.transaction);

  final Map<String, dynamic> transaction;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      maintainState: false,
      title: Text(
        transaction["reciever"].toString().toUpperCase(),
        style: TextStyle(
          fontFamily: "Agus",
          fontSize: 21,
        ),
      ),
      subtitle: Text(
        transaction["sender"].toString().toUpperCase(),
        style: TextStyle(
          fontFamily: "Agus",
          fontSize: 15,
        ),
      ),
      expandedAlignment: Alignment.centerLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      childrenPadding: EdgeInsets.only(left: 8.0,),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
          child: Text(
            dateFormatter(transaction["time"]),
            style: TextStyle(
              fontFamily: "Agus",
            ),
          ),
        ),
        Divider(
          indent: 0.0,
          endIndent: 8.0,
          color: Colors.black,
          thickness: 0.5,
        ),

      ],
    );
  }
}
