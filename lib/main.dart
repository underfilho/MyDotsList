import 'package:flutter/material.dart';
import 'package:mydotslist/dot.dart';
import 'package:mydotslist/dots_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.black,
          child: Center(
            child: DotsList(
              dots: [
                Dot(name: "1", color: Colors.blue),
                Dot(name: "2", color: Colors.red),
                Dot(name: "3", color: Colors.pink),
                Dot(name: "4", color: Colors.green),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
