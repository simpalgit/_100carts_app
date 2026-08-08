import 'dart:async';

class BottomNavigiationController {
  static final BottomNavigiationController _singleton =
      BottomNavigiationController._internal();

  factory BottomNavigiationController() {
    return _singleton;
  }

  BottomNavigiationController._internal();

  final navListener = StreamController<int>.broadcast();
}
