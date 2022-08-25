import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:vaccine_distribution/UI/BootUp.dart';
import 'package:vaccine_distribution/UI/DisplayVialDetails.dart';
import 'package:vaccine_distribution/UI/PatientAuthentication.dart';
import 'package:vaccine_distribution/UI/WarriorDashboard.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      title: 'Warr10r',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        accentColor: Colors.lightBlueAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android :FadeTransitionBuilder(),
          },
        ),
      ),
      home: BootUp(),
    );
  }
}

class FadeTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(_, __, animation, ___, child) => FadeTransition(opacity: animation, child: child);
}

String dateFormatter(String datetimeString) {
  DateTime dateTime = DateTime.parse(datetimeString.substring(0, 26));
  return '${dateTime.year}'
      '/${(dateTime.month).toString().padLeft(2, '0')}'
      '/${(dateTime.day).toString().padLeft(2, '0')}'
      ' - '
      '${(dateTime.hour).toString().padLeft(2, '0')}'
      ':${(dateTime.minute).toString().padLeft(2, '0')}'
      ':${(dateTime.second).toString().padLeft(2, '0')}';
}

/*
vailId: '123456',
manufacturer: "Pfyzer",
name: 'B6HG84',
batch: 'B001',
timeStamp: '2021-01-16T18:32:23+0000',

 */