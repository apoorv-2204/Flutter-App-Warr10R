import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vaccine_distribution/UI/IOTData.dart';
import 'package:vaccine_distribution/UI/PatientAuthentication.dart';
import 'package:vaccine_distribution/UI/PatientDashboard.dart';
import 'package:vaccine_distribution/UI/WarriorDashboard.dart';
import 'package:vaccine_distribution/BackEnd/Firebase.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  double ht, wd;
  TextEditingController mail, password;
  FocusNode mailNode, passwordNode;
  AnimationController opacityAnimCtrl;
  Animation opacityAnim;
  bool registrationOptions = false;
  int userCategoryIndex = -1, errorKey = 0;

  Map<int, String> errorMap = {
    0: "",
    1: "Invalid Email Address",
    2: "Registered E-Mail\nLogin To Proceed",
    3: "Unregistered E-Mail\nRegister To Proceed",
    4: "Invalid Password Length\n8 To 32 Characters",
    5: "Invalid Characters In Password\nCharacters, Numbers, ! - \# \$ \@ Only",
    6: "Incorrect Password\nReset Password If Required",
    7: "Select A Category For Registration",
    8: "Reset Link Sent To Mail Successfully",
    9: "Unregistered E-Mail",
    10: "Unknown Error"
  };

  @override
  void initState() {
    mail = TextEditingController();
    password = TextEditingController();

    mailNode = FocusNode();
    passwordNode = FocusNode();

    opacityAnimCtrl = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
      value: 1,
      lowerBound: 0,
      upperBound: 1,
    );
    opacityAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: opacityAnimCtrl,
      curve: Curves.easeOut,
    ))
      ..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    var size = MediaQuery.of(context).size;
    ht = size.height;
    wd = size.width;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    mail.dispose();
    password.dispose();

    mailNode.dispose();
    passwordNode.dispose();

    opacityAnimCtrl.dispose();

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
        body: Stack(
          children: [
            Positioned(
              top: ht * 0.125,
              child: Container(
                height: ht * 0.15,
                width: wd,
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: "Agus",
                        fontSize: wd * 0.15,
                        color: Colors.lightBlueAccent,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: "Warr"),
                        TextSpan(
                          text: "10",
                          style: TextStyle(color: Colors.deepOrangeAccent),
                        ),
                        TextSpan(text: "R"),
                      ],
                    ),
                  ),
                ),
              ),
            ), //Warr10R
            Positioned(
              top: ht * 0.4,
              height: ht * 0.6,
              width: wd,
              child: FadeTransition(
                opacity: opacityAnim,
                child: Visibility(
                  visible: !registrationOptions,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: ht * 0.125,
                          width: wd * 0.8,
                          child: Center(
                            child: TextField(
                              focusNode: mailNode,
                              controller: mail,
                              onTap: () {
                                FocusScope.of(context).requestFocus(mailNode);
                              },
                              onSubmitted: (mail) {
                                FocusScope.of(context).requestFocus(passwordNode);
                              },
                              onEditingComplete: () {
                                FocusScope.of(context).requestFocus(passwordNode);
                              },
                              onChanged: (mail) {
                                setState(() {
                                  errorKey = 0;
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "E-Mail ID",
                              ),
                            ),
                          ),
                        ), //Email Input
                        Container(
                          height: ht * 0.125,
                          width: wd * 0.8,
                          child: Center(
                            child: TextField(
                              focusNode: passwordNode,
                              controller: password,
                              onTap: () {
                                FocusScope.of(context).requestFocus(passwordNode);
                              },
                              onSubmitted: (mail) {
                                FocusScope.of(context).unfocus();
                              },
                              onEditingComplete: () {
                                FocusScope.of(context).unfocus();
                              },
                              onChanged: (password) {
                                setState(() {
                                  errorKey = 0;
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Password",
                              ),
                              obscureText: true,
                            ),
                          ),
                        ), //Password Input
                        Container(
                          height: ht * 0.125,
                          width: wd * 0.8,
                          padding: EdgeInsets.only(
                            top: ht * 0.065,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: ht * 0.06,
                                width: wd * 0.3,
                                child: RaisedButton(
                                  onPressed: () {
                                    int errorCode = validateInputs(1,
                                        mail: mail.value.text,
                                        password: password.value.text);
                                    setState(() {
                                      errorKey = errorCode;
                                    });
                                    if (errorKey == 0)
                                      opacityAnimCtrl.reverse().then((value) {
                                        registrationOptions = true;
                                        opacityAnimCtrl.forward();
                                      });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "Register",
                                    style: TextStyle(
                                      fontSize: 15,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  color: Colors.transparent,
                                  elevation: 0,
                                  splashColor: Colors.white,
                                ),
                              ), //Register
                              Container(
                                height: ht * 0.06,
                                width: wd * 0.3,
                                child: RaisedButton(
                                  onPressed: () async {

                                    // print("noideayettt@gmail.com");
                                    // print("Password");
                                    int errorCode = validateInputs(1,
                                        mail: mail.value.text,
                                        password: password.value.text);
                                    setState(() {
                                      errorKey = errorCode;
                                    });
                                    if (errorKey == 0) {
                                      await FirebaseCustoms.logIn(mail.value.text,
                                              password.value.text)
                                          .then((loginStatus) {
                                        switch (loginStatus) {
                                          case 0:
                                            setState(() {
                                              errorKey = 1;
                                            });
                                            break;
                                          case 1:
                                            dashboard();
                                            break;
                                          case -1:
                                            setState(() {
                                              errorKey = 3;
                                            });
                                            break;
                                          case -2:
                                            setState(() {
                                              errorKey = 6;
                                            });
                                            break;
                                          default:
                                            setState(() {
                                              errorKey = 0;
                                            });
                                        }
                                      });
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "Login",
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
                              ), //LogIn
                            ],
                          ),
                        ), //Action Buttons
                        Container(
                          height: ht * 0.125,
                          width: wd * 0.8,
                          alignment: Alignment.bottomCenter,
                          padding: EdgeInsets.only(bottom: ht * 0.015),
                          child: Text(
                            errorMap[errorKey],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: errorKey == 8
                                  ? Colors.green
                                  : Colors.deepOrangeAccent,
                            ),
                          ),
                        ), //Error
                        Container(
                          height: ht * 0.075,
                          width: wd * 0.8,
                          alignment: Alignment.bottomCenter,
                          child: FlatButton(
                            onPressed: () async {
                              int errorCode =
                                  validateInputs(3, mail: mail.value.text);
                              setState(() {
                                errorKey = errorCode;
                              });
                              if (errorKey == 0) {
                                int resetPasswordStatus =
                                    await FirebaseCustoms.resetPassword(
                                        mail.value.text);
                                if (resetPasswordStatus == 1) {
                                  setState(() {
                                    errorKey = 8;
                                  });
                                  Timer(Duration(seconds: 5), () async {
                                    setState(() {
                                      errorKey = 0;
                                    });
                                  });
                                } else {
                                  setState(() {
                                    resetPasswordStatus == -1
                                        ? errorKey = 9
                                        : errorKey = 10;
                                  });
                                }
                              }
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              "Reset Password",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ), //Forgot Password
                      ],
                    ),
                  ),
                ),
              ),
            ), //Edit Credentials
            Positioned(
              top: ht * 0.3,
              height: ht * 0.7,
              width: wd,
              child: FadeTransition(
                opacity: opacityAnim,
                child: Visibility(
                  visible: registrationOptions,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: ht * 0.35,
                          width: wd * 0.8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: ht * 0.1,
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(bottom: ht * 0.015),
                                child: Text(
                                  mail.text,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: ht * 0.0525,
                                    width: wd * 0.325,
                                    child: RaisedButton(
                                      onPressed: () {
                                        setState(() {
                                          errorKey = 0;
                                          userCategoryIndex = 0;
                                        });
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        "Admin",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Agus",
                                          color: userCategoryIndex == 0
                                              ? Colors.deepOrangeAccent
                                              : Colors.black,
                                          decoration: TextDecoration.none,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      color: Colors.white,
                                      //.lightBlueAccent,
                                      elevation: userCategoryIndex == 0 ? 3 : 1,
                                      splashColor: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    height: ht * 0.0525,
                                    width: wd * 0.325,
                                    child: RaisedButton(
                                      onPressed: () {
                                        setState(() {
                                          errorKey = 0;
                                          userCategoryIndex = 1;
                                        });
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        "Producer",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Agus",
                                          color: userCategoryIndex == 1
                                              ? Colors.deepOrangeAccent
                                              : Colors.black,
                                          decoration: TextDecoration.none,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      color: Colors.white,
                                      elevation: userCategoryIndex == 1 ? 3 : 1,
                                      splashColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: ht * 0.0525,
                                    width: wd * 0.325,
                                    child: RaisedButton(
                                      onPressed: () {
                                        setState(() {
                                          errorKey = 0;
                                          userCategoryIndex = 2;
                                        });
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        "Distributor",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Agus",
                                          color: userCategoryIndex == 2
                                              ? Colors.deepOrangeAccent
                                              : Colors.black,
                                          decoration: TextDecoration.none,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      color: Colors.white,
                                      elevation: userCategoryIndex == 2 ? 3 : 1,
                                      splashColor: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    height: ht * 0.0525,
                                    width: wd * 0.325,
                                    child: RaisedButton(
                                      onPressed: () {
                                        setState(() {
                                          errorKey = 0;
                                          userCategoryIndex = 3;
                                        });
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        "Warrior",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Agus",
                                          color: userCategoryIndex == 3
                                              ? Colors.deepOrangeAccent
                                              : Colors.black,
                                          decoration: TextDecoration.none,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      color: Colors.white,
                                      elevation: userCategoryIndex == 3 ? 3 : 1,
                                      splashColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: ht * 0.0525,
                                width: wd * 0.325,
                                child: RaisedButton(
                                  onPressed: () {
                                    setState(() {
                                      errorKey = 0;
                                      userCategoryIndex = 4;
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "Patient",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Agus",
                                      color: userCategoryIndex == 4
                                          ? Colors.deepOrangeAccent
                                          : Colors.black,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  color: Colors.white,
                                  elevation: userCategoryIndex == 4 ? 3 : 1,
                                  splashColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ), //User Category Options
                        Container(
                          height: ht * 0.125,
                          width: wd * 0.8,
                          padding: EdgeInsets.only(
                            top: ht * 0.065,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: ht * 0.06,
                                width: wd * 0.3,
                                child: RaisedButton(
                                  onPressed: () async {
                                    // print("noideayettt@gmail.com");
                                    // print("Password");
                                    int errorCode = validateInputs(1,
                                        mail: mail.value.text,
                                        password: password.value.text);
                                    setState(() {
                                      errorKey = errorCode;
                                    });
                                    if (errorKey == 0)
                                      await FirebaseCustoms.logIn(mail.value.text,
                                              password.value.text)
                                          .then((loginStatus) {
                                        switch (loginStatus) {
                                          case 0:
                                            setState(() {
                                              errorKey = 1;
                                            });
                                            break;
                                          case 1:
                                            registrationOptions = false;
                                            dashboard();
                                            break;
                                          case -1:
                                            setState(() {
                                              errorKey = 3;
                                            });
                                            break;
                                          case -2:
                                            setState(() {
                                              errorKey = 6;
                                            });
                                            break;
                                          default:
                                            setState(() {
                                              errorKey = 0;
                                            });
                                        }
                                      });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 15,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  color: Colors.transparent,
                                  elevation: 0,
                                  splashColor: Colors.white,
                                ),
                              ), //LogIn
                              Container(
                                height: ht * 0.06,
                                width: wd * 0.3,
                                child: RaisedButton(
                                  onPressed: () async {
                                    //"noideayettt@gmail.com", "Password"
                                    int errorCode = validateInputs(2,
                                        mail: mail.value.text,
                                        password: password.value.text,
                                        userCategoryIndex: userCategoryIndex);
                                    setState(() {
                                      errorKey = errorCode;
                                    });
                                    if (errorKey == 0)
                                      FirebaseCustoms.requestRegistration(
                                              mail.value.text,
                                              password.value.text,
                                              userCategoryIndex)
                                          .then((loginStatus) {
                                        switch (loginStatus) {
                                          case 0:
                                            setState(() {
                                              errorKey = 1;
                                            });
                                            break;
                                          case 1:
                                            registrationOptions = false;
                                            dashboard();
                                            break;
                                          case -1:
                                            setState(() {
                                              errorKey = 4;
                                            });
                                            break;
                                          case -2:
                                            setState(() {
                                              errorKey = 2;
                                            });
                                            break;
                                          case -3:
                                            setState(() {
                                              errorKey = 10;
                                            });
                                            break;
                                          default:
                                            setState(() {
                                              errorKey = 0;
                                            });
                                        }
                                      });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "Register",
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
                              ), //Register
                            ],
                          ),
                        ), //Action Buttons
                        Container(
                          height: ht * 0.125,
                          width: wd * 0.8,
                          alignment: Alignment.bottomCenter,
                          padding: EdgeInsets.only(bottom: ht * 0.015),
                          child: Text(
                            errorMap[errorKey],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: errorKey == 8
                                  ? Colors.green
                                  : Colors.deepOrangeAccent,
                            ),
                          ),
                        ), //Error
                        Container(
                          height: ht * 0.075,
                          width: wd * 0.8,
                          alignment: Alignment.bottomCenter,
                          child: FlatButton(
                            onPressed: () {
                              opacityAnimCtrl.reverse().then((value) {
                                userCategoryIndex = -1;
                                registrationOptions = false;
                                opacityAnimCtrl.forward();
                              });
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              "Edit Credentials",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ), //Edit Credentials
                      ],
                    ),
                  ),
                ),
              ),
            ), //Edit User Categories
          ],
        ),
      ),
    );
  }

  void dashboard() async {
    String userStatus = FirebaseCustoms.auth.currentUser.photoURL;

    switch(userStatus[0]) {
      case '0':
        print('Link Admin Dashboard');
        password.text = "";
        userCategoryIndex = -1;
        Navigator.push(context, MaterialPageRoute(builder: (context) => IOTData()));
        break;
      case '1':
        print('Link Producer Dashboard');
        break;
      case '2':
        print('Link Distributor Dashboard');
        break;
      case '3':
        print('Link Warrior Dashboard');
        password.text = "";
        userCategoryIndex = -1;
        Navigator.push(context, MaterialPageRoute(builder: (context) => WarriorDashboard()));
        break;
      case '4':
        if(userStatus[1] == '0')  {
          print('Patient Authentication');
          password.text = "";
          userCategoryIndex = -1;
          Navigator.push(context, MaterialPageRoute(builder: (context) => PatientAuthentication()));
        }
        else {
          print('Link Patient Dashboard');
          password.text = "";
          userCategoryIndex = -1;
          Navigator.push(context, MaterialPageRoute(builder: (context) => PatientDashboard()));
        }
        break;
    }
  }

  int validateInputs(int action,
      {String mail, String password, int userCategoryIndex}) {
    /// [action]
    ///
    /// 1 =>  Login and Registration (Credential editing Screen)
    /// 2 =>  Register (Category Selection Screen)
    /// 3 =>  Reset Password

    int toReturnError = 0;

    //ToDo: Validate Email with regex.
    if (mail == null || mail.length < 5)
      toReturnError = 1;
    else if ((action == 1 || action == 2) &&
        (password == null || password.length < 8 || password.length > 32))
      toReturnError = 4;
    //ToDo: Validate Password with regex.
    else if (action == 2 && userCategoryIndex == -1) toReturnError = 7;

    return toReturnError;
  }
}

/*

Map<int, String> errorMap = {
  0: "",
  1: "Invalid Email Address",
  2: "Registered E-Mail\nLogin To Proceed",
  3: "Unregistered E-Mail\nRegister To Proceed",
  4: "Invalid Password Length\n8 To 32 Characters",
  5: "Invalid Characters In Password\nCharacters, Numbers, ! - \# \$ \@ Only",
  6: "Incorrect Password\nReset Password If Required",
  7: "Select A Category For Registration"
};

*/


/*
*
*
*                                   // BlockChain.getVialDetails("12345");

                                  // var x = await http.get(Uri.parse('http://achalapoorvashutosh.pythonanywhere.com/get_vial_info/V1'));
                                  // print(x.body);

/*                                  //
                                  var url = Uri.parse('http://achalapoorvashutosh.pythonanywhere.com/vial');
                                  var headers = {
                                    'Content-Type': 'application/json'
                                  };
                                  var body = jsonEncode({"v_id": "Vial2","p_id": "Pat1","d_id": "Doc1","block_index": "0","time": DateTime.now().toIso8601String()});
                                  var resp = await http.post(url, body: body, headers: headers);

                                  print(resp.statusCode);

                                  if(resp.statusCode == 200)  {
                                    print(resp.body);
                                  } else  {
                                    print(resp.reasonPhrase);
                                    print(resp.statusCode);
                                  }*/
/*
                                  var url = Uri.parse('http://achalapoorvashutosh.pythonanywhere.com/transactions/new');
                                  var headers = {
                                    'Content-Type': 'application/json'
                                  };
                                  var body = jsonEncode({"v_id": "Vial2","p_id": "Pat1","d_id": "Doc1","block_index": "0","time": DateTime.now().toIso8601String()});
                                  var resp = await http.post(url, body: body, headers: headers);

                                  print(resp.statusCode);

                                  if(resp.statusCode == 200)  {
                                    print(resp.body);
                                  } else  {
                                    print(resp.reasonPhrase);
                                    print(resp.statusCode);
                                  }
*/

/*                                  var headers = {
                                    'Content-Type': 'application/json'
                                  };

                                  var request = http.Request('POST', Uri.parse('http://achalapoorvashutosh.pythonanywhere.com/transactions/new?v_id=d4ee26eee15148ee92c6cd394edd974e&p_id=someone-other-address&d_id=5&block_index=0&time=23'));
                                  request.body = '''{\r\n     "v_id": "V1",\r\n     "p_id": "P1",\r\n     "d_id": "D1",\r\n     "block_index": "B",\r\n     "time": "T"\r\n}''';
                                  request.headers.addAll(headers);

                                  http.StreamedResponse response = await request.send();

                                  if (response.statusCode == 200) {
                                    print(await response.stream.bytesToString());
                                  }
                                  else {
                                    print(response.reasonPhrase);
                                  }*/


* */