import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/config/app_font.dart';

import 'package:new_ap/screen/image_full_view/image_full_view_screen.dart';
import '../config/app_dimens.dart';
import '../config/app_string.dart';

class CommonWidget {
  static Widget getWidget(
      BuildContext context, int count, IconData icon, String time, String url) {
    return SizedBox(
      height: AppDimens.dimens_130,
      width: double.infinity,
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Icon(
                icon,
                color: ColorConstants.themeColor,
              ),
              Container(
                height: AppDimens.dimens_100,
                width: AppDimens.dimens_5,
                decoration:
                    const BoxDecoration(color: ColorConstants.themeColor),
              )
            ],
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(top: AppDimens.dimens_10),
            child: Column(
              children: <Widget>[
                FittedBox(
                  child: Text(
                    AppString.statusDelivery[count - 1],
                    style: const TextStyle(
                        fontSize: AppDimens.dimens_20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Text(
                  '${time.split(':')[0]}:${time.split(':')[1]}',
                  style: const TextStyle(color: Colors.black),
                ),
                if (count == 1)
                  const FittedBox(
                    child: Text(
                      'Lưu ý khi đơn hàng chuẩn bị bạn không thể hủy',
                      style: TextStyle(fontSize: AppDimens.dimens_18),
                    ),
                  ),
                if (count == 2 && url != '')
                  GestureDetector(
                    onTap: () {
                      Get.to(() => ImageFullViewScreen('progress order', url));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppDimens.dimens_10),
                      height: AppDimens.dimens_80,
                      width: AppDimens.dimens_50,
                      child: Hero(
                        tag: 'progress order',
                        child: Image.network(
                          url,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                const Expanded(child: SizedBox()),
                const Divider(
                    height: AppDimens.dimens_0,
                    thickness: AppDimens.dimens_2,
                    color: ColorConstants.themeColor)
              ],
            ),
          ))
        ],
      ),
    );
  }

  static showDialogLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: AlertDialog(
            backgroundColor: ColorConstants.colorBlack.withOpacity(0.4),
            content: const SizedBox(
              height: AppDimens.dimens_200,
              width: AppDimens.dimens_200,
              child: Center(
                child: CircularProgressIndicator(
                  color: ColorConstants.colorGrey2,
                ),
              ),
            )),
      ),
    );
  }

  static showDialogSuccess(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final Timer _timer = Timer(const Duration(seconds: 2), () {
      Get.back();
    });
    showDialog(
        context: context,
        builder: (context) {
          _timer;
          return AlertDialog(
            backgroundColor: ColorConstants.colorBlack.withOpacity(0.6),
            content: SizedBox(
              width: AppDimens.dimens_100,
              height: AppDimens.dimens_100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Icon(
                    Icons.done,
                    color: ColorConstants.colorWhite,
                    size: AppDimens.dimens_50,
                  ),
                  SizedBox(
                    width: AppDimens.dimens_30,
                  ),
                  Text('Xong',
                      style: TextStyle(
                          fontSize: AppDimens.dimens_25,
                          color: ColorConstants.colorWhite,
                          fontWeight: AppFont.bold)),
                ],
              ),
            ),
          );
        }).then((value) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    });
  }

  static showErrorDialog(
    BuildContext context,
  ) {
    final Timer _timer = Timer(const Duration(seconds: 2), () {
      Get.back();
    });
    showDialog(
        context: context,
        builder: (context) {
          _timer;
          return AlertDialog(
            content: SizedBox(
              height: AppDimens.dimens_100,
              width: AppDimens.dimens_100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Icon(
                    Icons.error_outline,
                    color: ColorConstants.colorRed1,
                    size: AppDimens.dimens_50,
                  ),
                  SizedBox(
                    width: AppDimens.dimens_30,
                  ),
                  Text('Thất bại',
                      style: TextStyle(
                          fontSize: AppDimens.dimens_25,
                          color: ColorConstants.colorRed1,
                          fontWeight: AppFont.bold)),
                ],
              ),
            ),
          );
        }).then((value) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    });
  }
}
