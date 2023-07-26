import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/config/app_storage_path.dart';
import 'package:new_ap/model/chat_model.dart';

import 'package:new_ap/screen/partner_screen/controller/message_partner_controller.dart';
import 'package:new_ap/screen/partner_screen/view/image_partner_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../config/app_dimens.dart';

// ignore: must_be_immutable
class NewPartnerMessage extends StatelessWidget {
  NewPartnerMessage(this.id, this.notSeen, this.insideChatGroup, {super.key});
  final String id;
  final int notSeen;
  final bool insideChatGroup;
  MessagePartnerController controller = Get.find<MessagePartnerController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => SizedBox(
          height: controller.visibilitySticker ? 250 : 55,
          child: Column(
            children: <Widget>[
              controller.recording.value
                  ? Container(
                      height: AppDimens.dimens_54,
                      padding: const EdgeInsets.symmetric(
                          vertical: AppDimens.dimens_5),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: AppDimens.dimens_40,
                            child: IconButton(
                              onPressed: () {
                                controller.stop().then((value) =>
                                    File(controller.audioFile!.path).delete());
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Theme.of(context).primaryColor,
                              ),
                              padding: const EdgeInsets.all(AppDimens.dimens_0),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            width: AppDimens.dimens_30,
                            height: AppDimens.dimens_30,
                            decoration: BoxDecoration(
                                color: ColorConstants.colorGrey3,
                                borderRadius:
                                    BorderRadius.circular(AppDimens.dimens_15)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppDimens.dimens_10),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      SizedBox(
                                        width: AppDimens.dimens_40,
                                        child: IconButton(
                                            padding: const EdgeInsets.all(
                                                AppDimens.dimens_0),
                                            onPressed: () async {
                                              await controller.stop().then(
                                                  (value) =>
                                                      controller.getBottomSheet(
                                                          context,
                                                          id,
                                                          notSeen,
                                                          insideChatGroup));
                                            },
                                            icon: const Icon(
                                              Icons.pause,
                                              color: ColorConstants.themeColor,
                                            )),
                                      ),
                                      Text(
                                        controller.formatTime(
                                            controller.time.value.duration),
                                        style: const TextStyle(
                                            color: ColorConstants.colorBlack,
                                            fontSize: AppDimens.dimens_17),
                                      ),
                                    ]),
                              ),
                            ),
                          )),
                          IconButton(
                              onPressed: () {
                                controller.stop().then((value) async {
                                  controller.submitData(
                                      id,
                                      context,
                                      TypeMessage.record,
                                      notSeen,
                                      insideChatGroup);
                                });
                              },
                              icon: const Icon(
                                Icons.send,
                                size: AppDimens.dimens_30,
                                color: ColorConstants.themeColor,
                              ))
                        ],
                      ),
                    )
                  : Container(
                      height: AppDimens.dimens_54,
                      color: ColorConstants.colorGrey0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 7),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: AppDimens.dimens_40,
                            child: IconButton(
                              onPressed: () {
                                controller.focusNode.unfocus();
                                controller.focusNode.canRequestFocus;
                                controller.visibilityStickerWidget();
                              },
                              icon: const Icon(
                                Icons.sentiment_satisfied_alt_sharp,
                                color: ColorConstants.themeColor,
                              ),
                              padding: const EdgeInsets.all(AppDimens.dimens_0),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                            child: IconButton(
                                onPressed: () {
                                  controller.takePictureCamera().then((value) {
                                    if (controller.storeImage == null) {
                                      return;
                                    } else {
                                      Get.to(() => ImageViewPartnerScreen(
                                          id,
                                          TypeMessage.image,
                                          notSeen,
                                          insideChatGroup));
                                    }
                                  });
                                },
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: ColorConstants.themeColor,
                                ),
                                padding:
                                    const EdgeInsets.all(AppDimens.dimens_0)),
                          ),
                          SizedBox(
                            width: AppDimens.dimens_40,
                            child: IconButton(
                                onPressed: () {
                                  controller.takePictureGallery().then((value) {
                                    controller.submitMultiImage(
                                        id, context, notSeen, insideChatGroup);
                                    log(controller.imageFileList.length
                                        .toString());
                                  });
                                },
                                icon: const Icon(
                                  Icons.photo,
                                  color: ColorConstants.themeColor,
                                ),
                                padding:
                                    const EdgeInsets.all(AppDimens.dimens_0)),
                          ),
                          SizedBox(
                            width: AppDimens.dimens_30,
                            child: IconButton(
                                onPressed: () async {
                                  final status =
                                      await Permission.microphone.request();
                                  if (status != PermissionStatus.granted) {
                                    return;
                                  } else {
                                    if (controller.recording.value == false) {
                                      controller.start();
                                    }
                                  }
                                },
                                icon: const Icon(
                                  Icons.mic,
                                  color: ColorConstants.themeColor,
                                ),
                                padding: const EdgeInsets.only(
                                    right: AppDimens.dimens_5)),
                          ),
                          Expanded(
                            child: TextField(
                              controller: controller.messageController,
                              decoration: const InputDecoration(
                                hintText: 'Aa',
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: AppDimens.dimens_20,
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorConstants.colorTransparent),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(AppDimens.dimens_15))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(AppDimens.dimens_15)),
                                    borderSide: BorderSide(
                                        color:
                                            ColorConstants.colorTransparent)),
                                filled: true,
                                fillColor: ColorConstants.colorGrey2,
                              ),
                              focusNode: controller.focusNode,
                              onChanged: (value) {
                                controller.checkEmtyTextField(value);
                              },
                              onSubmitted: (_) {
                                if (controller.checkEmty == true) {
                                  controller.submitNewMessage(
                                      id,
                                      context,
                                      controller.messageController.text,
                                      TypeMessage.text,
                                      notSeen,
                                      insideChatGroup);
                                }
                              },
                            ),
                          ),
                          Obx(() {
                            if (controller.checkEmty == true) {
                              return IconButton(
                                  onPressed: () {
                                    controller.submitNewMessage(
                                        id,
                                        context,
                                        controller.messageController.text,
                                        TypeMessage.text,
                                        notSeen,
                                        insideChatGroup);
                                  },
                                  icon: const Icon(
                                    Icons.send,
                                    size: AppDimens.dimens_30,
                                    color: ColorConstants.themeColor,
                                  ));
                            } else {
                              return SizedBox(
                                width: 35,
                                height: 35,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: AppDimens.dimens_5),
                                        elevation: 0,
                                        backgroundColor:
                                            ColorConstants.colorGrey0),
                                    onPressed: () {
                                      controller.submitNewMessage(
                                          id,
                                          context,
                                          'like',
                                          TypeMessage.sticker,
                                          notSeen,
                                          insideChatGroup);
                                    },
                                    child: Image.asset(
                                      AppStoragePath.like,
                                    )),
                              );
                            }
                          })
                        ],
                      ),
                    ),
              if (controller.visibilitySticker)
                Container(
                  height: 195,
                  padding: const EdgeInsets.all(20),
                  color: ColorConstants.colorGrey0,
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1),
                      itemCount: AppStoragePath.sticker.length,
                      itemBuilder: (context, index) => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: ColorConstants.colorGrey0),
                          onPressed: () {
                            controller.submitNewMessage(
                                id,
                                context,
                                AppStoragePath.sticker.keys.toList()[index],
                                TypeMessage.sticker,
                                notSeen,
                                insideChatGroup);
                          },
                          child: Image.asset(
                              AppStoragePath.sticker.values.toList()[index]))),
                )
            ],
          ),
        ));
  }
}
