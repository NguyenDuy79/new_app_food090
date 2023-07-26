import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_font.dart';
import 'package:new_ap/screen/Home_screen/View/pages/edit_profile_screen.dart';
import 'package:new_ap/screen/Home_screen/controllers/profile_controller.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_dimens.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ProfileController>(
      init: Get.find<ProfileController>(),
      builder: (controller) => controller.user.userName == ''
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              appBar: AppBar(
                elevation: AppDimens.dimens_0,
                backgroundColor: ColorConstants.colorGrey0,
                title: const Text(
                  'Profile',
                  style: TextStyle(
                      fontSize: AppDimens.dimens_22,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.colorBlack),
                ),
                actions: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.settings,
                        color: ColorConstants.colorBlack,
                      ))
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.dimens_15,
                          vertical: AppDimens.dimens_10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            width: AppDimens.dimens_130,
                            height: AppDimens.dimens_130,
                            child: CircleAvatar(
                              backgroundColor: ColorConstants.colorBlue1,
                              backgroundImage: NetworkImage(
                                controller.user.image,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                FittedBox(
                                  child: Text(
                                    '${controller.user.userName[0].toUpperCase()}${controller.user.userName.substring(1).toLowerCase()}',
                                    style: const TextStyle(
                                        fontSize: AppDimens.dimens_20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                FittedBox(
                                  child: Text(
                                    controller.user.email,
                                    style: const TextStyle(
                                        fontSize: AppDimens.dimens_20),
                                  ),
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            ColorConstants.themeColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                AppDimens.dimens_10))),
                                    onPressed: () {
                                      Get.to(() => EditProfile());
                                    },
                                    child: const Text('Edit Profile'))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.all(AppDimens.dimens_15),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppDimens.dimens_15)),
                      color: ColorConstants.colorGrey1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.dimens_10),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: AppDimens.dimens_60,
                              child: GestureDetector(
                                onTap: () {},
                                child: Row(
                                  children: const <Widget>[
                                    SizedBox(
                                      height: AppDimens.dimens_30,
                                      width: AppDimens.dimens_30,
                                      child: Icon(
                                        Icons.contact_page_outlined,
                                        color: ColorConstants.colorPink,
                                      ),
                                    ),
                                    Text(' Khách hàng thân thiết',
                                        style: TextStyle(
                                            fontSize: AppDimens.dimens_24,
                                            fontWeight: FontWeight.bold)),
                                    Expanded(child: SizedBox()),
                                    Icon(Icons.arrow_forward_ios)
                                  ],
                                ),
                              ),
                            ),
                            const Divider(
                              height: AppDimens.dimens_0,
                            ),
                            SizedBox(
                              height: AppDimens.dimens_60,
                              child: GestureDetector(
                                onTap: () {},
                                child: Row(
                                  children: const <Widget>[
                                    SizedBox(
                                      height: AppDimens.dimens_30,
                                      width: AppDimens.dimens_30,
                                      child: Icon(
                                        Icons.favorite,
                                        color: ColorConstants.colorRed1,
                                      ),
                                    ),
                                    Text(' Favorite',
                                        style: TextStyle(
                                            fontSize: AppDimens.dimens_24,
                                            fontWeight: FontWeight.bold)),
                                    Expanded(child: SizedBox()),
                                    Icon(Icons.arrow_forward_ios)
                                  ],
                                ),
                              ),
                            ),
                            const Divider(
                              height: AppDimens.dimens_0,
                            ),
                            SizedBox(
                              height: AppDimens.dimens_60,
                              child: GestureDetector(
                                onTap: () {},
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                        height: AppDimens.dimens_30,
                                        width: AppDimens.dimens_30,
                                        child: Image.asset(
                                            'assets/image/promocode.png')),
                                    const Text(' Promo card for you',
                                        style: TextStyle(
                                            fontSize: AppDimens.dimens_24,
                                            fontWeight: FontWeight.bold)),
                                    const Expanded(child: SizedBox()),
                                    const Icon(Icons.arrow_forward_ios)
                                  ],
                                ),
                              ),
                            ),
                            const Divider(
                              height: AppDimens.dimens_0,
                            ),
                            SizedBox(
                              height: AppDimens.dimens_60,
                              child: GestureDetector(
                                onTap: () {
                                  controller.getPartner(context);
                                },
                                child: Row(
                                  children: const <Widget>[
                                    SizedBox(
                                      height: AppDimens.dimens_30,
                                      width: AppDimens.dimens_30,
                                      child: Icon(
                                        Icons.handshake,
                                        color: ColorConstants.colorYellow,
                                      ),
                                    ),
                                    Text(' Become our partner',
                                        style: TextStyle(
                                            fontSize: AppDimens.dimens_24,
                                            fontWeight: FontWeight.bold)),
                                    Expanded(child: SizedBox()),
                                    Icon(Icons.arrow_forward_ios)
                                  ],
                                ),
                              ),
                            ),
                            const Divider(
                              height: AppDimens.dimens_0,
                            ),
                            SizedBox(
                              height: AppDimens.dimens_60,
                              child: GestureDetector(
                                onTap: () {},
                                child: Row(
                                  children: const <Widget>[
                                    SizedBox(
                                      height: AppDimens.dimens_30,
                                      width: AppDimens.dimens_30,
                                      child: Icon(
                                        Icons.star_border_outlined,
                                        color: ColorConstants.colotBule2,
                                      ),
                                    ),
                                    Text(' Đánh giá của tôi',
                                        style: TextStyle(
                                            fontSize: AppDimens.dimens_24,
                                            fontWeight: FontWeight.bold)),
                                    Expanded(child: SizedBox()),
                                    Icon(Icons.arrow_forward_ios)
                                  ],
                                ),
                              ),
                            ),
                            const Divider(
                              height: AppDimens.dimens_0,
                            ),
                            SizedBox(
                              height: AppDimens.dimens_60,
                              child: GestureDetector(
                                onTap: () {},
                                child: Row(
                                  children: const <Widget>[
                                    SizedBox(
                                      height: AppDimens.dimens_30,
                                      width: AppDimens.dimens_30,
                                      child: Icon(
                                        Icons.add_box_outlined,
                                        color: ColorConstants.themeColor,
                                      ),
                                    ),
                                    Text(' Đang theo dõi',
                                        style: TextStyle(
                                            fontSize: AppDimens.dimens_24,
                                            fontWeight: FontWeight.bold)),
                                    Expanded(child: SizedBox()),
                                    Icon(Icons.arrow_forward_ios)
                                  ],
                                ),
                              ),
                            ),
                            const Divider(
                              height: AppDimens.dimens_0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: AppDimens.dimens_15,
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: Container(
                width: double.infinity,
                height: AppDimens.dimens_65,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.dimens_20,
                    vertical: AppDimens.dimens_10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: AppDimens.dimens_5,
                        backgroundColor: ColorConstants.themeColor,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppDimens.dimens_10))),
                    onPressed: () {
                      FirebaseAuth.instance.signOut().then((value) {
                        Get.offAllNamed('/auth');
                      });
                    },
                    child: const Text(
                      'Log out',
                      style: TextStyle(
                          fontWeight: AppFont.semiBold,
                          fontSize: AppDimens.dimens_25,
                          color: ColorConstants.colorWhite),
                    )),
              ),
            ),
    );
  }
}
