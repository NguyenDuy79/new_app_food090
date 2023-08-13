import 'package:get/get.dart';

class ImageViewController extends GetxController {
  final RxDouble _height = 0.0.obs;
  double get height => _height.value;
  final RxBool _gestureUp = false.obs;
  bool get gestureUp => _gestureUp.value;
  setHeight(double value) {
    _height.value = value;
  }

  reduceHeight(double value) {
    _height.value -= value;
  }

  setFalseGestureUp() {
    _gestureUp.value = false;
  }

  setTrueGestureUp() {
    _gestureUp.value = true;
  }
}
