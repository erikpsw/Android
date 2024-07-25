// ignore_for_file: prefer_ _ ructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'acceleration.dart';
import 'main_page.dart';
import 'genshin.dart';

void main() => runApp(Myapp()); //从这个main widget开始(all application)

//启动app

class Myapp extends StatefulWidget {
  const Myapp({super.key});

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/main": (context) => Screen(),
        '/acc': (context) => acc_page(),
        '/genshin': (context) => genshin(),
      },
      theme: ThemeData(colorScheme: ColorScheme.light()),
      initialRoute: "/main",
    );
  }
}
