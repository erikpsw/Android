// ignore_for_file: prefer_ _ ructors, prefer_const_constructors

import 'package:flutter/material.dart';

void main() => runApp(Myapp()); //从这个main widget开始(all application)

//启动app

class Myapp extends StatefulWidget {
  const Myapp({super.key});

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  Color backgroundcolor = Colors.white;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: backgroundcolor,
            appBar: AppBar(
              title: Text(
                "Erikpsw",
                style: TextStyle(fontFamily: "Times New Roman"),
              ),
              backgroundColor: Colors.blueGrey[300],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center, //拉长
              children: [
                Container(
                  width: 300,
                  height: 300, //正方形
                  margin: EdgeInsets.only(left: 0, top: 20),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: NetworkImage(
                          "https://link.jscdn.cn/1drv/aHR0cHM6Ly8xZHJ2Lm1zL3UvcyFBb3pmeXJKV0dUMHVoTVJFazVoTnRJX0dKa1FWNnc_ZT1tV3VHemE.png",
                        ),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  color: Color.fromARGB(255, 134, 176, 248),
                  child: ListTile(
                    leading: Padding(
                      padding: EdgeInsets.only(top: 3),
                      child: Icon(Icons.phone),
                    ),
                    title: Text(
                      "13026205006",
                      style: TextStyle(fontFamily: "Pacifico", fontSize: 30),
                    ),
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        backgroundcolor = Colors.yellow;
                      });
                    },
                    child: SizedBox(
                      width: 20,
                      height: 20,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ]),
              ],
            )));
  }
}

// Row(children:   [
//                     SizedBox(
//                       width: 15,
//                     ),
//                     Icon(Icons.phone),
//                     SizedBox(
//                       width: 15,
//                     ),
//                     Text(
//                       "13026205006",
//                       style: TextStyle(fontFamily: "", fontSize: 20),
//                     )
//                   ]),