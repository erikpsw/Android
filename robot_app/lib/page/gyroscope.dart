import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class GyroPage extends StatefulWidget {
  const GyroPage({super.key});

  @override
  State<GyroPage> createState() => GyroPageState();
}

class GyroPageState extends State<GyroPage> {
  List<double> gyro = [0.00, 0.00, 0.00];
  late StreamSubscription<GyroscopeEvent> _streamSubscription;
  List<List<dynamic>> csvData = [
    <String>['Timestamp', 'X', 'Y', 'Z'],
  ];
  bool light0 = false;

  final List<ButtonSegment<String>> _segments = [
    const ButtonSegment<String>(value: 'x', label: Text('x')),
    const ButtonSegment<String>(value: 'y', label: Text('y')),
    const ButtonSegment<String>(value: 'z', label: Text('z')),
  ];
  Set<String> _selected = {'x'};

  @override
  void initState() {
    super.initState();

    _streamSubscription =
        //https://blog.csdn.net/kissgoodbye2012/article/details/107589966
        gyroscopeEventStream(samplingPeriod: SensorInterval.gameInterval)
            .listen(
      (GyroscopeEvent event) {
        setState(
          () {
            gyro = <double>[event.x, event.y, event.z];
          },
        );
        // print(light0);
        if (light0) {
          _saveDataToCsv();
        }
      },
    );
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  Future<PermissionStatus> requestStoragePermission() async {
    return await Permission.manageExternalStorage.request();
  }

  Future<bool> checkStoragePermission() async {
    PermissionStatus permissionStatus =
        await Permission.manageExternalStorage.status;
    return permissionStatus.isGranted;
  }

  void handleStoragePermissionRequestResult(PermissionStatus permissionStatus) {
    switch (permissionStatus) {
      case PermissionStatus.granted:
        _saveDataToCsv();
        break;
      case PermissionStatus.denied:
        _showSnackBar('Storage permission denied', Colors.red);
        break;
      case PermissionStatus.restricted:
        _showSnackBar('Storage permission restricted', Colors.orange);
        break;
      case PermissionStatus.permanentlyDenied:
        _showSnackBar('Storage permission permanently denied', Colors.red);
        openAppSettings();
        break;
      default:
        _showSnackBar('Unknown permission status', Colors.red);
        break;
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  Future<void> _saveDataToCsv() async {
    final DateTime now = DateTime.now();
    final List<dynamic> row = [now.toString(), gyro[0], gyro[1], gyro[2]];
    csvData.add(row);

    String csv = const ListToCsvConverter().convert(csvData);

    final String directory = (await getExternalStorageDirectory())!.path;
    final path = "$directory/gyroscope_data.csv";

    final File file = File(path);
    await file.writeAsString(csv);

    if (!light0) {
      _showSnackBar('Data saved to $path', Colors.green);
    }
  }

  Future<void> _saveToCsv() async {
    bool isPermissionGranted = await checkStoragePermission();
    if (isPermissionGranted) {
      _saveDataToCsv();
    } else {
      PermissionStatus permissionStatus = await requestStoragePermission();
      handleStoragePermissionRequestResult(permissionStatus);
    }
  }

  void _onSelectionChanged(Set<String> selected) {
    setState(() {
      _selected = selected;
    });
  }

  void _clearCsvData() {
    setState(() {
      csvData = [
        <String>['Timestamp', 'X', 'Y', 'Z'],
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        SegmentedButton<String>(
          segments: _segments.map((segment) {
            late String text;
            switch (segment.value) {
              case 'x':
                text = "a${segment.value} = ${gyro[0].toStringAsFixed(2)}";
                break;
              case 'y':
                text = "a${segment.value} = ${gyro[1].toStringAsFixed(2)}";
                break;
              case 'z':
                text = "a${segment.value} = ${gyro[2].toStringAsFixed(2)}";
                break;
              default:
                text = segment.label.toString();
            }
            return ButtonSegment<String>(
              value: segment.value,
              label: Container(
                width: 100, // 固定宽度
                alignment: Alignment.center,
                child: Text(text),
              ),
            );
          }).toList(),
          selected: _selected,
          onSelectionChanged: _onSelectionChanged,
          multiSelectionEnabled: false,
          emptySelectionAllowed: false,
          showSelectedIcon: false, // 禁用选中时的勾号
          style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.all(Colors.transparent), // 禁用背景变化
            shadowColor: WidgetStateProperty.all(Colors.transparent),
            elevation: WidgetStateProperty.all(0),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _saveToCsv,
          child: const Text('Test'),
        ),
        const SizedBox(height: 20),
        Switch(
          value: light0,
          onChanged: (bool value) {
            setState(() {
              light0 = value;
              if (light0) {
                _clearCsvData(); // 清空CSV数据
              }
            });
          },
        ),
      ],
    );
  }
}
