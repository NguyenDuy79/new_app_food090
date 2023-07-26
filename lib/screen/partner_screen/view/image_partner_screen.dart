import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/config/app_dimens.dart';
import 'package:new_ap/model/chat_model.dart';

import '../controller/message_partner_controller.dart';

class ImageViewPartnerScreen extends StatelessWidget {
  ImageViewPartnerScreen(this.id, this.type, this.notSeen, this.insideChatGroup,
      {super.key});
  final String id;
  final int type;
  final int notSeen;
  final bool insideChatGroup;
  final MessagePartnerController controller =
      Get.find<MessagePartnerController>();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        controller.resetImagePicker();
        return true;
      },
      child: Scaffold(
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: <Widget>[
              controller.getImage(),
              Positioned(
                  top: AppDimens.dimens_15,
                  left: AppDimens.dimens_15,
                  child: IconButton(
                      onPressed: () {
                        controller.resetImagePicker();
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: ColorConstants.themeColor,
                      ))),
              Positioned(
                bottom: AppDimens.dimens_30,
                left: AppDimens.dimens_50,
                width: width - AppDimens.dimens_100,
                height: AppDimens.dimens_54,
                child: TextField(
                  controller: controller.messageImageController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          controller.submitData(
                              id, context, type, notSeen, insideChatGroup);
                          if (controller
                              .messageImageController.text.isNotEmpty) {
                            controller.submitNewMessage(
                                id,
                                context,
                                controller.messageImageController.text,
                                TypeMessage.text,
                                notSeen,
                                insideChatGroup);
                          }

                          Get.back();
                        },
                        icon: const Icon(
                          Icons.send,
                          size: AppDimens.dimens_30,
                          color: ColorConstants.themeColor,
                        )),
                    hintText: 'Aa',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.dimens_20,
                    ),
                    enabledBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ColorConstants.colorTransparent),
                        borderRadius: BorderRadius.all(
                            Radius.circular(AppDimens.dimens_15))),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(AppDimens.dimens_15)),
                        borderSide:
                            BorderSide(color: ColorConstants.colorTransparent)),
                    filled: true,
                    fillColor: ColorConstants.colorGrey1,
                  ),
                  onSubmitted: (_) {
                    if (controller.messageImageController.text != '') {
                      controller.submitNewMessage(
                          id,
                          context,
                          controller.messageImageController.text,
                          TypeMessage.text,
                          notSeen,
                          insideChatGroup);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
