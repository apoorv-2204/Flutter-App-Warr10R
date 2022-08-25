
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vaccine_distribution/UI/PatientDashboard.dart';
import 'package:vaccine_distribution/BackEnd/Firebase.dart';
import 'package:location/location.dart';

String aadharNumber;

class PatientAuthentication extends StatefulWidget {
  @override
  _PatientAuthenticationState createState() => _PatientAuthenticationState();
}

class _PatientAuthenticationState extends State<PatientAuthentication>
    with SingleTickerProviderStateMixin {
  double ht, wd, notificationBarHeight;
  int _popupMenuSelection;
  AnimationController animCtrl;
  Animation anim;
  bool _otpInput, displayMessage;
  FocusNode aadharNumberNode, otpNode;
  TextEditingController aadharTextCtrl, otpTextCtrl;

  @override
  void initState() {
    super.initState();
    _otpInput = false;
    displayMessage = false;
    animCtrl = AnimationController(
      duration: Duration(milliseconds: 250),
      vsync: this,
    );
    anim = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
      parent: animCtrl,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeOut,
    ))
      ..addListener(() {
        setState(() {});
      });
    aadharNumberNode = FocusNode();
    otpNode = FocusNode();
    aadharTextCtrl = TextEditingController();
    otpTextCtrl = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    Size size = MediaQuery.of(context).size;
    ht = size.height;
    wd = size.width;
    notificationBarHeight = MediaQuery.of(context).padding.top;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    animCtrl.dispose();
    aadharNumberNode.dispose();
    otpNode.dispose();
    aadharTextCtrl.dispose();
    otpTextCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  height: ht * 0.11,
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
                          "Patient Authentication",
                          style: TextStyle(
                            fontSize: 21,
                            fontFamily: "Agus",
                          ),
                        ),
                      ), //Patient Authentication
                      Container(
                        width: wd * 0.15,
                        height: ht * 0.11 - notificationBarHeight,
                        alignment: Alignment.center,
                        child: PopupMenuButton<int>(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          icon: Icon(Icons.more_vert),
                          offset: Offset(0, ht * 0.1),
                          onSelected: (int value) {
                            setState(() {
                              print(value);
                              _popupMenuSelection = value;
                            });
                            switch(value) {
                              case 1:
                                FirebaseCustoms.logOut().then((value) {
                                  Navigator.pop(context);
                                });
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<int>>[
                            const PopupMenuItem<int>(
                              value: 1,
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
              Positioned(
                top: ht * 0.2,
                child: Container(
                  height: ht * 0.15,
                  width: wd,
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: "Agus",
                          fontSize: wd * 0.15,
                          color: Colors.lightBlueAccent.withOpacity(0.75),
                        ),
                        children: <TextSpan>[
                          TextSpan(text: "Warr"),
                          TextSpan(
                            text: "10",
                            style: TextStyle(
                                color: Colors.deepOrangeAccent.withOpacity(0.75)),
                          ),
                          TextSpan(text: "R"),
                        ],
                      ),
                    ),
                  ),
                ),
              ), //Warr10R
              Positioned(
                top: ht * 0.45,
                height: ht * 0.55,
                width: wd,
                child: FadeTransition(
                  opacity: anim,
                  child: Container(
                    height: ht * 0.5,
                    padding: EdgeInsets.symmetric(horizontal: wd * 0.1),
                    // color: Colors.red,
                    child: Padding(
                      padding: EdgeInsets.only(top: ht * 0.05),
                      child: patientAuthenticationInputs(),
                    ),
                  ),
                ),
              ), //OTPInputs
              Positioned(
                top: ht * 0.8,
                child: Visibility(
                  visible: displayMessage,
                  child: Container(
                    width: wd,
                    height: ht * 0.1,
                    // color: Colors.red,
                    alignment: Alignment.center,
                    child: Text(
                      "Updating Location",
                      style: TextStyle(
                        fontFamily: "Agus",
                        fontSize: 18,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget patientAuthenticationInputs() {
    if (_otpInput) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: ht * 0.125,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: wd * 0.2),
            // color: Colors.red,
            child: TextField(
              focusNode: otpNode,
              controller: otpTextCtrl,
              onTap: () {
                FocusScope.of(context).requestFocus(otpNode);
              },
/*
              onSubmitted: (mail) {
                FocusScope.of(context).requestFocus(passwordNode);
              },
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(passwordNode);
              },
*/
              onChanged: (mail) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.black,
                  ),
                ),
                hintStyle: TextStyle(
                  letterSpacing: 1,
                  fontSize: 16,
                ),
                hintText: "OTP",
              ),
              style: TextStyle(
                letterSpacing: 5,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
            ),
          ), //OTP Text Field
          Container(
            height: ht * 0.15,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: ht * 0.055,
                  width: wd * 0.315,
                  margin: EdgeInsets.only(right: 10),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.transparent,
                    elevation: 0,
                    onPressed: () {},
                    child: Text(
                      "Resend OTP",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: ht * 0.055,
                  width: wd * 0.275,
                  color: Colors.transparent,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.lightBlueAccent,
                    disabledColor: Colors.white,
                    onPressed: displayMessage? null :
                        () async {

                      setState(() {
                        displayMessage = true;
                      });

                      await Permission.locationWhenInUse.request();
                      if(await Permission.locationWhenInUse.isGranted) {
                        var location = await Location().getLocation();
                        print(location.latitude);
                        print(location.longitude);

                        setState(() {
                          displayMessage = false;
                        });

                        if(otpTextCtrl.value.text.isNotEmpty) {
                          aadharNumber = aadharTextCtrl.value.text;
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PatientDashboard()));
                        }
                        // print('Patient Dashboard');

                      }

                      /*animCtrl.forward().then((value) {
                        _otpInput = false;
                        animCtrl.reverse();
                      });*/
                    },
                    child: Text("Submit"),
                  ),
                ),
              ],
            ),
          ), //OTP Action Buttons
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: ht * 0.125,
            alignment: Alignment.center,
            child: TextField(
              focusNode: aadharNumberNode,
              controller: aadharTextCtrl,
              onTap: () {
                FocusScope.of(context).requestFocus(aadharNumberNode);
              },
/*              onSubmitted: (mail) {
                FocusScope.of(context).requestFocus(passwordNode);
              },
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(passwordNode);
              },
*/
              onChanged: (mail) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.black,
                  ),
                ),
                hintStyle: TextStyle(
                  // fontSize: 18,
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
          ), //Aadhar Text Field
          Container(
            height: ht * 0.15,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: ht * 0.055,
                  width: wd * 0.275,
                  color: Colors.transparent,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.lightBlueAccent,
                    onPressed: () {
                      if(aadharTextCtrl.value.text.isNotEmpty)  //ToDo: Add Aadhar Input Verification
                        animCtrl.forward().then((value) {
                          _otpInput = true;
                          animCtrl.reverse();
                        });
                    },
                    child: Text("Send OTP"),
                  ),
                ),
              ],
            ),
          ), //Aadhar Action Buttons
        ],
      );
    }
  }
}

/*
class PatientAuthenticationInputs extends StatefulWidget {
  final bool optInput;

  const PatientAuthenticationInputs({Key key, this.optInput}) : super(key: key);

  @override
  _PatientAuthenticationInputsState createState() =>
      _PatientAuthenticationInputsState();
}

class _PatientAuthenticationInputsState
    extends State<PatientAuthenticationInputs> {
  double ht, wd;
  bool optInput;

  @override
  void initState() {
    optInput = widget.optInput;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    ht = MediaQuery.of(context).size.height;
    wd = MediaQuery.of(context).size.width;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (optInput)
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: ht * 0.125,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: wd * 0.2),
            // color: Colors.red,
            child: TextField(
              // focusNode: mailNode,
              // controller: mail,
              // onTap: () {
              //   FocusScope.of(context).requestFocus(mailNode);
              // },
              // onSubmitted: (mail) {
              //   FocusScope.of(context).requestFocus(passwordNode);
              // },
              // onEditingComplete: () {
              //   FocusScope.of(context).requestFocus(passwordNode);
              // },
              onChanged: (mail) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.black,
                  ),
                ),
                hintStyle: TextStyle(
                  letterSpacing: 1,
                  fontSize: 16,
                ),
                hintText: "OTP",
              ),
              style: TextStyle(
                letterSpacing: 5,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
            ),
          ), //OTP Text Field
          Container(
            height: ht * 0.1,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                */
/*Container(
                                height: ht * 0.055,
                                width: wd * 0.315,
                                margin: EdgeInsets.only(right: 10),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: Colors.transparent,
                                  elevation: 0,
                                  onPressed: () {},
                                  child: Text("Resend OTP"),
                                ),
                              ),*/ /*

                Container(
                  height: ht * 0.055,
                  width: wd * 0.275,
                  color: Colors.transparent,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.lightBlueAccent,
                    onPressed: () {},
                    child: Text("Submit"),
                  ),
                ),
              ],
            ),
          ), //OTP Action Buttons
        ],
      );
    else
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: ht * 0.125,
            alignment: Alignment.center,
            child: TextField(
              // focusNode: mailNode,
              // controller: mail,
              // onTap: () {
              //   FocusScope.of(context).requestFocus(mailNode);
              // },
              // onSubmitted: (mail) {
              //   FocusScope.of(context).requestFocus(passwordNode);
              // },
              // onEditingComplete: () {
              //   FocusScope.of(context).requestFocus(passwordNode);
              // },
              onChanged: (mail) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.black,
                  ),
                ),
                hintStyle: TextStyle(
                  // fontSize: 18,
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
          ), //Aadhar Text Field
          Container(
            height: ht * 0.1,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: ht * 0.055,
                  width: wd * 0.315,
                  margin: EdgeInsets.only(right: 10),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.transparent,
                    elevation: 0,
                    onPressed: () {},
                    child: Text(
                      "Resend OTP",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: ht * 0.055,
                  width: wd * 0.275,
                  color: Colors.transparent,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.lightBlueAccent,
                    onPressed: () {},
                    child: Text("Send OTP"),
                  ),
                ),
              ],
            ),
          ), //Aadhar Action Buttons
        ],
      );
  }
}
*/
