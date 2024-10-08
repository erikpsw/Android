import 'package:flutter/material.dart';
import 'page/gyroscope.dart';
import 'page/blue.dart';
import 'page/control.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    _pageController.jumpToPage(
      index,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page: $_selectedIndex'),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: <Widget>[
          Container(
            color: Colors.red,
            child: const Center(
              child: Text(
                'Home',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
          // WebSocketPage(),
          const GyroPage(), // 你的加速度页面
          const HomeScreen(),
          const NewPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore),
            label: 'Gyroscope',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'BLE',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

String ip = "192.168.0.102";

class NewPage extends StatelessWidget {
  const NewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _showSetIpDialog(context);
              },
              child: const Text('Set IP'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebSocketPage(ip: ip),
                  ),
                );
              },
              child: const Text('Start Control'),
            ),
          ],
        ),
      ),
    );
  }
}

void _showSetIpDialog(BuildContext context) {
  TextEditingController ipController = TextEditingController(text: ip);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Set IP Address'),
        content: TextField(
          controller: ipController,
          decoration: const InputDecoration(hintText: "Enter IP Address"),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              // Handle IP address update logic here
              ip = ipController.text;
              print("New IP Address: $ip");

              // Close the dialog
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
