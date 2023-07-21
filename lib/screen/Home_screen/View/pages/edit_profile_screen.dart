import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/config/app_dimens.dart';
import 'package:new_ap/screen/Home_screen/View/pages/change_passwork.dart';
import 'package:new_ap/screen/Home_screen/controllers/profile_controller.dart';

// ignore: must_be_immutable
class EditProfile extends StatelessWidget {
  EditProfile({super.key});
  ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.isNewPasswordObscure.value = true;
        controller.isOldPasswordObscure.value = true;
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorConstants.colorWhite,
            elevation: AppDimens.dimens_0,
            automaticallyImplyLeading: false,
            leading: IconButton(
                onPressed: () {
                  Get.back();
                  controller.isNewPasswordObscure.value = true;
                  controller.isOldPasswordObscure.value = true;
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: ColorConstants.colorBlack,
                )),
            title: const Text(
              'Edit Profile',
              style: TextStyle(
                  fontSize: AppDimens.dimens_25,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.colorBlack),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    controller.onSave();
                  },
                  icon: const Icon(
                    Icons.done,
                    color: ColorConstants.colorBlack,
                  ))
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: AppDimens.dimens_20),
                  child: GetBuilder<ProfileController>(
                    builder: (controller) => Stack(
                      children: <Widget>[
                        SizedBox(
                          width: AppDimens.dimens_130,
                          height: AppDimens.dimens_130,
                          child: CircleAvatar(
                              backgroundColor: ColorConstants.colorBlue1,
                              backgroundImage: controller.getImage()),
                        ),
                        Positioned(
                          right: AppDimens.dimens_0,
                          bottom: AppDimens.dimens_0,
                          child: Container(
                            width: AppDimens.dimens_30,
                            height: AppDimens.dimens_30,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(AppDimens.dimens_14),
                                color: ColorConstants.colorGrey1),
                            child: IconButton(
                                onPressed: () {
                                  controller.takePictureCamera();
                                },
                                padding:
                                    const EdgeInsets.all(AppDimens.dimens_2),
                                icon: const Icon(Icons.camera_alt_outlined)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(AppDimens.dimens_20),
                    child: Form(
                        key: controller.editProfile,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: AppDimens.dimens_5),
                                child: Text(
                                  'Email',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: AppDimens.dimens_22),
                                ),
                              ),
                              TextFormField(
                                initialValue: controller.user.email,
                                key: const ValueKey('email'),
                                validator: (value) {
                                  if (value!.isEmpty || !value.contains('@')) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                    hintText: 'Nhập tại đây',
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ColorConstants
                                                .colorTransparent),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                AppDimens.dimens_10))),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                AppDimens.dimens_10)),
                                        borderSide: BorderSide(
                                            color: ColorConstants.themeColor)),
                                    filled: true,
                                    fillColor: ColorConstants.colorGrey1),
                                onSaved: (newValue) {
                                  controller.updateUser.email = newValue!;
                                },
                              ),
                              const SizedBox(
                                height: AppDimens.dimens_10,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: AppDimens.dimens_5),
                                child: Text(
                                  'Full name',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: AppDimens.dimens_22),
                                ),
                              ),
                              TextFormField(
                                initialValue: controller.user.userName,
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
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    hintText: 'Nhập tại đây',
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                AppDimens.dimens_10))),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                AppDimens.dimens_10)),
                                        borderSide: BorderSide(
                                            color: ColorConstants.themeColor)),
                                    filled: true,
                                    fillColor: ColorConstants.colorGrey1),
                                onSaved: (newValue) {
                                  controller.updateUser.userName = newValue!;
                                },
                              ),
                              const SizedBox(
                                height: AppDimens.dimens_10,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: AppDimens.dimens_5),
                                child: Text(
                                  'Mobile phone',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: AppDimens.dimens_22),
                                ),
                              ),
                              TextFormField(
                                initialValue: controller.user.mobile == '0'
                                    ? ''
                                    : controller.user.mobile.toString(),
                                key: const ValueKey('mobile'),
                                validator: (value) {
                                  if (value!.isEmpty || !value.isPhoneNumber) {
                                    return 'Please enter a valid mobile number';
                                  } else if (value.length != 10) {
                                    return 'Nhập đúng số điện thoại';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    hintText: 'Nhập tại đây',
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ColorConstants
                                                .colorTransparent),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                AppDimens.dimens_10))),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                AppDimens.dimens_10)),
                                        borderSide: BorderSide(
                                            color: ColorConstants.themeColor)),
                                    filled: true,
                                    fillColor: ColorConstants.themeColor),
                                onSaved: (newValue) {
                                  controller.updateUser.mobile = newValue!;
                                },
                              ),
                              const SizedBox(
                                height: AppDimens.dimens_10,
                              ),
                            ]))),
                Container(
                  height: AppDimens.dimens_54,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.dimens_20),
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstants.colorTransparent,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDimens.dimens_15))),
                      onPressed: () {
                        Get.to(() => ChangePassWord());
                      },
                      child: const Text(
                        'Thay đổi mật khẩu',
                        style: TextStyle(
                            fontSize: AppDimens.dimens_24,
                            fontWeight: FontWeight.bold),
                      )),
                )
              ],
            ),
          )),
    );
  }
}
