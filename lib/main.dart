import 'package:application_adv3/pages/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Advanced 3',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.blueAccent,
        primaryColor: Colors.blue,
      ),
      home: LoginPage(),
    ),
  );
}
