import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/screen/Home_screen/controllers/profile_controller.dart';

// ignore: must_be_immutable
class ChangePassWord extends StatelessWidget {
  ChangePassWord({super.key});
  ProfileController controller = Get.find<ProfileController>();
  RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.colorWhite,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: ColorConstants.colorBlack,
            )),
        backgroundColor: Colors.white,
        title: const Text(
          'Change Password',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: controller.isOldPassword.value
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Nhập mật khẩu cũ',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: controller.oldPasswordKey,
                    child: Obx(
                      () => TextFormField(
                        key: const ValueKey('oldPassword'),
                        obscureText: controller.isOldPasswordObscure.value,
                        validator: (value) {
                          if (value!.isEmpty || value.length <= 6) {
                            return 'Passwork must be at least 6 characters long.';
                          } else if (!regex.hasMatch(value)) {
                            return 'Enter valid password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: 'Nhập tại đây',
                            suffixIcon: IconButton(
                                onPressed: () {
                                  controller.changeStatusOld();
                                },
                                icon: controller.isOldPasswordObscure.value
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off)),
                            enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: ColorConstants.themeColor)),
                            filled: true,
                            fillColor: ColorConstants.colorWhite),
                        onSaved: (newValue) {
                          controller.oldPassword = newValue!;
                        },
                      ),
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                Container(
                  width: double.infinity,
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstants.themeColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        controller.onSaveOldPassword(context);
                      },
                      child: controller.isChangePasswordLoading.value
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Submit',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                )
              ],
            )
          : Column(
              children: <Widget>[
                const Text(
                  'Nhập mật khẩu mới',
                  style: TextStyle(),
                ),
                Form(
                  key: controller.newPasswordKey,
                  child: Obx(
                    () => TextFormField(
                      key: const ValueKey('newPassword'),
                      obscureText: controller.isNewPasswordObscure.value,
                      validator: (value) {
                        if (value!.isEmpty || value.length <= 6) {
                          return 'Passwork must be at least 6 characters long.';
                        } else if (!regex.hasMatch(value)) {
                          return 'Enter valid password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: 'Nhập tại đây',
                          suffixIcon: IconButton(
                              onPressed: () {
                                controller.changeStatusNew();
                              },
                              icon: controller.isNewPasswordObscure.value
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off)),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: ColorConstants.themeColor)),
                          filled: true,
                          fillColor: ColorConstants.colorWhite),
                      onSaved: (newValue) {
                        controller.newPassword = newValue!;
                      },
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                Container(
                  width: double.infinity,
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstants.themeColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {},
                      child: controller.isChangePasswordLoading.value
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Submit',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
