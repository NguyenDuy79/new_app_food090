import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/screen/partner_screen/controller/order_now_controller.dart';

import '../../../config/app_dimens.dart';

// ignore: must_be_immutable
class CameraPicker extends StatelessWidget {
  CameraPicker({super.key});
  OrderNowController controller = Get.find<OrderNowController>();

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        controller.getBack();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstants.colorWhite,
          elevation: AppDimens.dimens_5,
          centerTitle: true,
          title: const Text(
            'Bill Picture',
            style: TextStyle(
                fontSize: AppDimens.dimens_24,
                fontWeight: FontWeight.bold,
                color: ColorConstants.colorBlack),
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                controller.getBack();
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: ColorConstants.themeColor,
              )),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: AppDimens.dimens_10),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GetBuilder<OrderNowController>(
                init: Get.find<OrderNowController>(),
                builder: (controller) => Container(
                    width: width * 0.9,
                    height: height * 0.8,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: AppDimens.dimens_2,
                            color: ColorConstants.colorBlack)),
                    child: controller.getImage()),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: AppDimens.dimens_15),
                child: Row(
                  children: <Widget>[
                    GetBuilder(
                      init: Get.find<OrderNowController>(),
                      builder: (controller) => Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: AppDimens.dimens_20),
                        height: AppDimens.dimens_40,
                        width: (width - AppDimens.dimens_80) / 2,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: AppDimens.dimens_2,
                                      color: ColorConstants.themeColor),
                                  borderRadius: BorderRadius.circular(
                                      AppDimens.dimens_15),
                                ),
                                backgroundColor: ColorConstants.colorWhite),
                            onPressed: () {
                              controller.takePictureCamera();
                            },
                            child: controller.storeImage != null
                                ? const Text(
                                    'Chụp lại',
                                    style: TextStyle(
                                        fontSize: AppDimens.dimens_20,
                                        fontWeight: FontWeight.bold,
                                        color: ColorConstants.colorBlack),
                                  )
                                : const Text(
                                    'Chụp ảnh',
                                    style: TextStyle(
                                        fontSize: AppDimens.dimens_20,
                                        fontWeight: FontWeight.bold,
                                        color: ColorConstants.colorBlack),
                                  )),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: AppDimens.dimens_20),
                      height: AppDimens.dimens_40,
                      width: (width - AppDimens.dimens_80) / 2,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppDimens.dimens_15),
                              ),
                              backgroundColor: ColorConstants.themeColor),
                          onPressed: () {
                            controller.getImageBill(context);
                          },
                          child: const Text(
                            'Chọn ảnh',
                            style: TextStyle(
                                fontSize: AppDimens.dimens_20,
                                fontWeight: FontWeight.bold,
                                color: ColorConstants.colorBlack),
                          )),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
