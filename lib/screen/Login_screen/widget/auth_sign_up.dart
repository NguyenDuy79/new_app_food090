import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/screen/Login_screen/controller/auth_controller.dart';

import '../../../config/app_dimens.dart';

// ignore: must_be_immutable
class AuthSignUp extends StatelessWidget {
  AuthSignUp(this.isLogin, this.width, {super.key});
  final RxBool isLogin;
  final double width;
  LoginController controller = Get.find<LoginController>();
  RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(AppDimens.dimens_20),
        child: Form(
          key: controller.signInFormKey,
          child: Column(children: <Widget>[
            TextFormField(
              key: const ValueKey('email'),
              validator: (value) {
                if (value!.isEmpty || !value.contains('@')) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
              focusNode: controller.emailSigninFocus,
              enabled: !controller.isLoading.value,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(controller.fullNameFocus);
              },
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  hintText: 'Email ID',
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: ColorConstants.colorTransparent),
                      borderRadius: BorderRadius.all(
                          Radius.circular(AppDimens.dimens_10))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(AppDimens.dimens_10)),
                      borderSide:
                          BorderSide(color: ColorConstants.colorTransparent)),
                  filled: true,
                  fillColor: ColorConstants.colorGrey2),
              onSaved: (newValue) {
                controller.emailSignIn = newValue!;
              },
            ),
            const SizedBox(
              height: AppDimens.dimens_30,
            ),
            TextFormField(
              key: const ValueKey('fullname'),
              validator: (value) {
                var index = value!.trim().indexOf(' ');
                if (value.isEmpty) {
                  return 'Please enter a valid full name';
                } else if (!(index > 0) ||
                    ((index + 1) > value.length) ||
                    !(value[index + 1].isAlphabetOnly)) {
                  return 'Please enter a full name';
                }
                return null;
              },
              enabled: !controller.isLoading.value,
              focusNode: controller.fullNameFocus,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(controller.mobileFocus);
              },
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  hintText: 'Full name',
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: ColorConstants.colorTransparent),
                      borderRadius: BorderRadius.all(
                          Radius.circular(AppDimens.dimens_10))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(AppDimens.dimens_10)),
                      borderSide:
                          BorderSide(color: ColorConstants.colorTransparent)),
                  filled: true,
                  fillColor: ColorConstants.colorGrey2),
              onSaved: (newValue) {
                controller.fullName = newValue!;
              },
            ),
            const SizedBox(
              height: AppDimens.dimens_30,
            ),
            TextFormField(
              key: const ValueKey('mobile'),
              validator: (value) {
                if (value!.isEmpty || !value.isPhoneNumber) {
                  return 'Please enter a valid mobile number';
                } else if (value.length != 10) {
                  return 'Nhập đúng số điện thoại';
                }
                return null;
              },
              enabled: !controller.isLoading.value,
              focusNode: controller.mobileFocus,
              onFieldSubmitted: (_) {
                FocusScope.of(context)
                    .requestFocus(controller.passworkSigninFocus);
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: 'Mobile',
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: ColorConstants.colorTransparent),
                      borderRadius: BorderRadius.all(
                          Radius.circular(AppDimens.dimens_10))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(AppDimens.dimens_10)),
                      borderSide:
                          BorderSide(color: ColorConstants.colorTransparent)),
                  filled: true,
                  fillColor: ColorConstants.colorGrey2),
              onSaved: (newValue) {
                controller.mobile = newValue!;
              },
            ),
            const SizedBox(
              height: AppDimens.dimens_30,
            ),
            TextFormField(
              key: const ValueKey('password'),
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty || value.length <= 6) {
                  return 'Passwork must be at least 6 characters long.';
                } else if (!regex.hasMatch(value)) {
                  return 'Enter valid password';
                }
                return null;
              },
              enabled: !controller.isLoading.value,
              focusNode: controller.passworkSigninFocus,
              onFieldSubmitted: (_) {
                controller.onSave(context, isLogin.value);
              },
              decoration: const InputDecoration(
                  hintText: 'Pass Word',
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: ColorConstants.colorTransparent),
                      borderRadius: BorderRadius.all(
                          Radius.circular(AppDimens.dimens_10))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(AppDimens.dimens_10)),
                      borderSide:
                          BorderSide(color: ColorConstants.colorTransparent)),
                  filled: true,
                  fillColor: ColorConstants.colorGrey2),
              onSaved: (newValue) {
                controller.passwordSignIn = newValue!;
              },
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: (width - AppDimens.dimens_20 * 2) * 0.5,
              height: AppDimens.dimens_50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.themeColor,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppDimens.dimens_20))),
                  onPressed: () {
                    controller.onSave(context, isLogin.value);
                  },
                  child: Obx(() {
                    return controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : const Text('Sign up',
                            style: TextStyle(color: ColorConstants.colorWhite));
                  })),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Joined us before?'),
                TextButton(
                    onPressed: () {
                      if (!controller.isLoading.value) {
                        controller.isLogin.value = true;
                      }
                    },
                    child: const Text('Log in'))
              ],
            )
          ]),
        ),
      ),
    );
  }
}
