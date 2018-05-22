import 'package:flutter/material.dart';
import './home_page.dart';

void main() => runApp(new WeeklyApp());

class WeeklyApp extends StatefulWidget {
  WeeklyApp({Key key }) : super(key: key);

  @override
  WeeklyAppState createState() => new WeeklyAppState();
}

class WeeklyAppState extends State<WeeklyApp> {
  final String title = "奇舞周刊";
  
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: title,
      home: new HomePage(
        title: title
      )
    );
  }
}
