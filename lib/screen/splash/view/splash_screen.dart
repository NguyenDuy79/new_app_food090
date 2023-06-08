import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/screen/splash/controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final controller = Get.find<SplashController>();
  final appBar = AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar,
        body: Center(
          child: Image.asset('assets/image/chef.png'),
        ));
  }
}
