// ignore_for_file: prefer_ _ ructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

Center mybutton(context, String pagestr, String text, double wid) {
  return Center(
    child: ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, pagestr);
      },
      child: SizedBox(
          height: 40,
          width: wid,
          child: Center(
            child: Text(
              text,
              style: TextStyle(fontFamily: "Times New Roman", fontSize: 20),
            ),
          )),
    ),
  );
}

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
          children: [
            SizedBox(
              height: 10,
            ),
            mybutton(context, "/acc", "Acceleration", 150),
            mybutton(context, "/genshin", "Genshin", 120),
            mybutton(context, "/blue", "Blue", 100),
          ],
        ),
      ),
    );
  }
}
