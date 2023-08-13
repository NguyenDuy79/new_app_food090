import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/screen/Login_screen/controller/auth_controller.dart';
import 'package:new_ap/screen/Login_screen/widget/auth_login.dart';
import 'package:new_ap/screen/Login_screen/widget/auth_sign_up.dart';

import '../../../config/app_dimens.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  final LoginController controller = Get.find<LoginController>();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: ColorConstants.colorWhite,
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  height: AppDimens.dimens_350,
                  child: Obx(() {
                    return controller.isLogin.value
                        ? Image.asset(
                            'assets/image/login.png',
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/image/sign_up.png',
                            fit: BoxFit.cover,
                          );
                  })),
              Obx(() {
                return controller.isLogin.value == true
                    ? AuthWidgetLogin(controller.isLogin, width)
                    : AuthSignUp(controller.isLogin, height);
              }),
            ])));
  }
}
