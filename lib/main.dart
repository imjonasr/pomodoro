import 'package:flutter/material.dart';
import 'package:pomodoro/home.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      brightness: Brightness.dark,
      accentColor: Colors.deepPurpleAccent,
      primaryColor: Colors.deepPurple,
    ),
    debugShowCheckedModeBanner: false,
  ));
}