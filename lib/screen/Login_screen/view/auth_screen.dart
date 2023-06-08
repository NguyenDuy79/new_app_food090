import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/screen/Login_screen/controller/authController.dart';
import 'package:new_ap/screen/Login_screen/widget/auth_login.dart';
import 'package:new_ap/screen/Login_screen/widget/auth_sign_up.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});
  final appBar = AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
  );
  final LoginController controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  height: height * 0.4,
                  child: Obx(() {
                    return controller.isLogin.value
                        ? Image.asset(
                            'assets/image/13.png',
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/image/sign_up.png',
                            fit: BoxFit.cover,
                          );
                  })),
              Container(
                child: Obx(() {
                  return controller.isLogin.isTrue
                      ? AuthWidgetLogin(controller.isLogin, width)
                      : AuthSignUp(controller.isLogin, height);
                }),
              )
            ])));
  }
}
