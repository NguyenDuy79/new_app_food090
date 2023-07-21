import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/config/app_storage_path.dart';
import 'package:new_ap/screen/Login_screen/controller/auth_controller.dart';

import '../../../config/app_dimens.dart';

// ignore: must_be_immutable
class AuthWidgetLogin extends StatelessWidget {
  AuthWidgetLogin(this.isLogin, this.width, {super.key});

  final RxBool isLogin;
  final double width;
  LoginController controller = Get.find<LoginController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
          padding: const EdgeInsets.all(AppDimens.dimens_20),
          child: Form(
              key: controller.loginFormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    key: const ValueKey('email_login'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    enabled: !controller.isLoading.value,
                    focusNode: controller.emailLoginFocus,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(controller.passWorkLoginFocus);
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        hintText: 'Email ID',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: ColorConstants.colorTransparent),
                            borderRadius: BorderRadius.all(
                                Radius.circular(AppDimens.dimens_10))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(AppDimens.dimens_10)),
                            borderSide: BorderSide(
                                color: ColorConstants.colorTransparent)),
                        filled: true,
                        fillColor: ColorConstants.colorGrey2),
                    onSaved: (value) {
                      controller.email = value!;
                    },
                  ),
                  const SizedBox(
                    height: AppDimens.dimens_30,
                  ),
                  TextFormField(
                    key: const ValueKey('password_login'),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty || value.length <= 6) {
                        return 'Passwork must be at least 6 characters long.';
                      }
                      return null;
                    },
                    focusNode: controller.passWorkLoginFocus,
                    onFieldSubmitted: (_) {
                      controller.onSave(context, isLogin.value);
                    },
                    enabled: !controller.isLoading.value,
                    decoration: const InputDecoration(
                        hintText: 'Pass Word',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: ColorConstants.colorTransparent),
                            borderRadius: BorderRadius.all(
                                Radius.circular(AppDimens.dimens_10))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(AppDimens.dimens_10)),
                            borderSide: BorderSide(
                                color: ColorConstants.colorTransparent)),
                        filled: true,
                        fillColor: ColorConstants.colorGrey2),
                    onSaved: (value) {
                      controller.password = value!;
                    },
                  ),
                  const SizedBox(
                    height: AppDimens.dimens_30,
                  ),
                  SizedBox(
                      width: (width - AppDimens.dimens_20 * 2) * 0.5,
                      height: AppDimens.dimens_50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorConstants.themeColor,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppDimens.dimens_9))),
                        onPressed: () {
                          controller.onSave(context, isLogin.value);
                        },
                        child: controller.isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : const Text('Log in',
                                style: TextStyle(
                                    color: ColorConstants.colorWhite)),
                      )),
                  const SizedBox(
                    height: AppDimens.dimens_15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                          onPressed: () {
                            controller.signInWithGoogle();
                          },
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(0),
                              backgroundColor: ColorConstants.colorWhite),
                          child: SizedBox(
                            height: AppDimens.dimens_40,
                            width: AppDimens.dimens_40,
                            child: Image.asset(
                              AppStoragePath.google,
                              fit: BoxFit.cover,
                            ),
                          )),
                      const SizedBox(
                        width: AppDimens.dimens_5,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            controller.signInWithGoogle();
                          },
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(0),
                              backgroundColor: ColorConstants.colorWhite),
                          child: SizedBox(
                            height: AppDimens.dimens_40,
                            width: AppDimens.dimens_40,
                            child: Image.asset(
                              AppStoragePath.facebook1,
                              fit: BoxFit.cover,
                            ),
                          )),
                    ],
                  ),
                  TextButton(
                      onPressed: () {
                        if (!controller.isLoading.value) {
                          controller.isLogin.value = false;
                        }
                      },
                      child: const Text('Sign Up')),
                ],
              ))),
    );
  }
}
