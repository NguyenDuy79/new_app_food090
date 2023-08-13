import 'dart:async';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/config/app_storage_path.dart';
import 'package:new_ap/model/chat_model.dart';

import 'package:new_ap/screen/Home_screen/View/pages/image_screen.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../config/app_dimens.dart';
import '../../controllers/message_controller.dart';

// ignore: must_be_immutable
class NewMessage extends StatelessWidget {
  NewMessage(this.id, this.isNotSeen, this.insideChatGroup, {super.key});
  final String id;
  final int isNotSeen;

  final bool insideChatGroup;
  MessageController controller = Get.find<MessageController>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double paddingTop = MediaQuery.of(context).padding.top;

    return Obx(() => SizedBox(
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
                                              await controller
                                                  .stop()
                                                  .then((value) {
                                                controller.getBottomSheet(
                                                    context,
                                                    id,
                                                    isNotSeen,
                                                    insideChatGroup);
                                              });
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
                                      isNotSeen,
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
                          if (controller.isExtend)
                            SizedBox(
                              width: AppDimens.dimens_40,
                              child: IconButton(
                                onPressed: () {
                                  controller.getFalseExtend();
                                },
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: ColorConstants.themeColor,
                                ),
                                padding:
                                    const EdgeInsets.all(AppDimens.dimens_0),
                              ),
                            ),
                          if (!controller.isExtend)
                            SizedBox(
                              width: AppDimens.dimens_40,
                              child: IconButton(
                                onPressed: () {
                                  controller.focusNode.unfocus();
                                  controller.focusNode.canRequestFocus;
                                  if (controller.visibilitySticker) {
                                    controller.getFalseShowImagePicker();
                                  } else {
                                    controller.getTrueVisibility();
                                  }
                                },
                                icon: const Icon(
                                  Icons.sentiment_satisfied_alt_sharp,
                                  color: ColorConstants.themeColor,
                                ),
                                padding:
                                    const EdgeInsets.all(AppDimens.dimens_0),
                              ),
                            ),
                          if (!controller.isExtend)
                            SizedBox(
                              width: 30,
                              child: IconButton(
                                  onPressed: () {
                                    controller.getFalseVisibility();
                                    controller
                                        .takePictureCamera()
                                        .then((value) {
                                      if (controller.storeImage == null) {
                                        return;
                                      } else {
                                        Get.to(() => ImageViewScreen(
                                            isNotSeen,
                                            id,
                                            TypeMessage.image,
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
                          // is here
                          if (!controller.isExtend)
                            SizedBox(
                              width: AppDimens.dimens_40,
                              child: IconButton(
                                  onPressed: () {
                                    controller.focusNode.unfocus();
                                    controller.focusNode.canRequestFocus;
                                    controller.getFalseVisibility();
                                    controller.getAllData(RequestType.common);
                                    controller.showImagePicker(
                                        context,
                                        height,
                                        paddingTop,
                                        id,
                                        isNotSeen,
                                        insideChatGroup);
                                  },
                                  icon: const Icon(
                                    Icons.photo,
                                    color: ColorConstants.themeColor,
                                  ),
                                  padding:
                                      const EdgeInsets.all(AppDimens.dimens_0)),
                            ),
                          if (!controller.isExtend)
                            SizedBox(
                              width: AppDimens.dimens_30,
                              child: IconButton(
                                  onPressed: () async {
                                    controller.getFalseVisibility();
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
                              autofocus: true,
                              onChanged: (value) {
                                controller.checkEmtyTextField(value.trim());
                                controller.getTrueExtend();
                                Timer(const Duration(seconds: 5), () {
                                  if (controller.messageController.text == '') {
                                    controller.getFalseExtend();
                                  }
                                });
                              },
                              style: const TextStyle(
                                  fontSize: AppDimens.dimens_19),
                              onTap: () {
                                controller.getTrueExtend();
                                controller.getFalseVisibility();
                                Timer(const Duration(seconds: 5), () {
                                  if (controller.messageController.text == '') {
                                    controller.getFalseExtend();
                                  }
                                });
                              },
                              maxLines: null,
                              onSubmitted: (_) {
                                if (controller.checkEmty == true) {
                                  controller.submitNewMessage(
                                      id,
                                      context,
                                      controller.messageController.text
                                          .trim()
                                          .replaceAll('\n', ''),
                                      TypeMessage.text,
                                      isNotSeen,
                                      insideChatGroup);
                                }
                              },
                            ),
                          ),
                          controller.checkEmty == true
                              ? IconButton(
                                  onPressed: () {
                                    controller.submitNewMessage(
                                        id,
                                        context,
                                        controller.messageController.text
                                            .trim(),
                                        TypeMessage.text,
                                        isNotSeen,
                                        insideChatGroup);
                                  },
                                  icon: const Icon(
                                    Icons.send,
                                    size: AppDimens.dimens_30,
                                    color: ColorConstants.themeColor,
                                  ))
                              : SizedBox(
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
                                            isNotSeen,
                                            insideChatGroup);
                                      },
                                      child: Image.asset(
                                        AppStoragePath.like,
                                      )),
                                ),
                        ],
                      ),
                    ),
              if (controller.isShowImage)
                SizedBox(
                  height: controller.heightSheet < height * 0.3
                      ? controller.heightSheet
                      : height * 0.3,
                ),
              if (controller.visibilitySticker)
                Container(
                  height: AppDimens.dimens_195,
                  padding: const EdgeInsets.all(20),
                  color: ColorConstants.colorWhite,
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
                                isNotSeen,
                                insideChatGroup);
                          },
                          child: Image.asset(
                              AppStoragePath.sticker.values.toList()[index]))),
                ),
            ],
          ),
        ));
  }
}
