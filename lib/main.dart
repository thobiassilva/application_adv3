import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';

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
      routes: {
        '/': (_) => LoginPage(),
        '/home-page': (_) => HomePage(),
      },
    ),
  );
}
