import 'package:flutter/material.dart';

class ContralModel with ChangeNotifier {
  double _sliderValue = 0;
  Offset _currentPosition = Offset.zero;
  double get sliderValue => _sliderValue;
  Offset get currentPosition => _currentPosition;

  void setSliderValue(double value) {
    _sliderValue = value;
    notifyListeners();
  }

  void setcurrentPosition(Offset position) {
    _currentPosition = position;
    notifyListeners();
  }
}
