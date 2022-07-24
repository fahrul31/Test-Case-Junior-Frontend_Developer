import 'package:flutter/material.dart';
import 'package:test_case/pages/detail_page.dart';
import 'package:test_case/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Case Junior Frontend',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/' :(context) => HomePage(),
        '/detail_page': (context) => DetailPage(),
      },
    );
  }
}
