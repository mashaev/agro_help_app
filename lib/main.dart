import 'package:flutter/material.dart';
import 'dart:async';

import './Screens/categories.dart';

void main() => runApp(AgroHelp());

class AgroHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroHelp',
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/Categories': (BuildContext context) => Categories(null)
      },
      // home: DBControl(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
