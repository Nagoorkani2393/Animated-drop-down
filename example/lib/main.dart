import 'package:animated_drop_down/animated_drop_down_item.dart';
import 'package:animated_drop_down/drop_down.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: const [
          AnimatedDropDown(
            tileColor: Colors.white,
            expandedTileColor: Colors.white,
            borderRadius: 10,
            trailingText: Text(
              "Edit Profile",
              style: TextStyle(color: Colors.red),
            ),
            items: [
              AnimatedDropDownItems(
                title: "Title1",
                subTitle: 'Subtitle1',
                leading: Icon(Icons.ac_unit),
              ),
              AnimatedDropDownItems(
                title: "Title2",
                subTitle: 'Subtitle2',
                leading: Icon(Icons.ac_unit),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
