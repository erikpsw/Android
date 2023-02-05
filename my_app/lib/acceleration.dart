// ignore_for_file: camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, prefer_const_constructors_in_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:fl_chart/fl_chart.dart';

Card mycard(String s1, String s2) {
  // @required
  return Card(
    color: Colors.grey[300],
    child: Container(
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            " a$s1= ",
            style: TextStyle(
                color: Colors.black,
                fontFamily: "Computer Modern",
                fontSize: 20),
          ),
          Text(
            s2,
            style: TextStyle(
                color: Colors.black,
                fontFamily: "Latin Modern Math",
                fontSize: 20),
          ),
        ])),
  );
}

class acc_page extends StatefulWidget {
  acc_page({super.key});

  @override
  State<acc_page> createState() => _acc_pageState();
}

class _acc_pageState extends State<acc_page> {
  List<double> acc = [0.00, 0.00, 0.00];
  List<FlSpot> axlist = [];
  double i = 0.0;
  bool isDraw = true;

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen(
      (AccelerometerEvent event) {
        if (isDraw) {
          setState(
            () {
              acc = <double>[event.x, event.y, event.z];

              i += 1 / 15;
              setState(() {
                axlist.add(FlSpot(i, acc[0]));
              });
            },
          );
        } else {
          i = 0;
          axlist = [];
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorScheme: ColorScheme.light()),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Acceleration",
            style: TextStyle(fontFamily: "Times New Roman"),
          ),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 80,
                ),
                mycard("x", (acc[0]).toStringAsFixed(2)),
                mycard("y", (acc[1]).toStringAsFixed(2)),
                mycard("z", (acc[2]).toStringAsFixed(2)),
              ],
            ),
            SizedBox(
              height: 300,
              child: LineChart(
                swapAnimationDuration: Duration(milliseconds: 50),
                LineChartData(
                    gridData: FlGridData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        // preventCurveOverShooting: true,
                        dotData: FlDotData(
                          show: false,
                        ),
                        isCurved: true,
                        spots: axlist,
                        shadow: Shadow(
                          color: Color.fromARGB(255, 208, 201, 201),
                        ),
                      ),
                    ],
                    minX: 0,
                    borderData: FlBorderData(
                        border: Border.all(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid))),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: CupertinoSwitch(
                  onChanged: (newValue) {
                    setState(() {
                      isDraw = newValue;
                    });
                  },
                  value: isDraw,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
