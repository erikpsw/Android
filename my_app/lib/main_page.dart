// ignore_for_file: prefer_ _ ructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorScheme: ColorScheme.light()),
      title: "Erikpsw",
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Erikpsw",
            style: TextStyle(fontFamily: "Times New Roman"),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/acc");
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  height: 40,
                  width: 150,
                  alignment: Alignment.center,
                  child: Text(
                    "Acceleration",
                    style:
                        TextStyle(fontFamily: "Times New Roman", fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
