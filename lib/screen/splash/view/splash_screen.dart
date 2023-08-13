import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/screen/splash/controller/splash_controller.dart';

import '../../../config/app_dimens.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final controller = Get.find<SplashController>();
  final appBar = AppBar(
    backgroundColor: ColorConstants.colorWhite,
    elevation: AppDimens.dimens_0,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.colorWhite,
        appBar: appBar,
        body: Center(
          child: Image.asset('assets/image/chef.png'),
        ));
  }
}
