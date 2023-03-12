import 'package:flutter/material.dart';
import 'package:mobapp/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = TextStyle(
      color: Colors.white,
    );
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.black,
          textTheme: TextTheme(
            bodyText1: defaultTextStyle,
            bodyText2: defaultTextStyle,
            headline1: defaultTextStyle,
            headline2: defaultTextStyle,
          )),
      home: HomeFragment(),
    );
  }
}
