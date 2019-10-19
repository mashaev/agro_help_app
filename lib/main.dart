import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/cupertino.dart';

import './Screens/categories.dart';
import 'package:agro_help_app/resources/session.dart';
import 'helpers/database_helper.dart';
//import './Screens/testPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  session = await SharedPreferences.getInstance();
  runApp(AgroHelp());
}

class AgroHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroHelp',
      //home: Categories(null),
      //home: TestPage(),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/Categories': (BuildContext context) => Categories(null),
      },

      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('ru', 'RU'),
      ],
      // home: DBControl(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  DatabaseHelper dbHelper = DatabaseHelper();
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/Categories');
  }

  @override
  void initState() {
    super.initState();
    dbHelper.fake();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 150, horizontal: 100),
            child: new Image.asset('assets/images/label.png')),
      ),
    );
  }
}
