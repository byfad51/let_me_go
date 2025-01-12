import 'package:flutter/material.dart';
import 'package:let_me_go/bluetooth.dart';
import 'package:let_me_go/map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Map Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home:  BleHomePage(),
    );
  }
}

