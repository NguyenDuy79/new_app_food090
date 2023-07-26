import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/config/app_storage_path.dart';
import 'package:new_ap/screen/partner_screen/controller/message_partner_controller.dart';
import 'package:new_ap/screen/partner_screen/widget/chat_detail_widget_partner/message_partner.dart';
import 'package:new_ap/screen/partner_screen/widget/chat_detail_widget_partner/new_message_partner.dart';

class ChatDetailPartnerScreen extends StatelessWidget {
  const ChatDetailPartnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<MessagePartnerController>(dispose: (state) {
      MessagePartnerController()
          .outChatDetailScreen(MessagePartnerController().chatProfile.value.id);
    }, builder: (controller) {
      return WillPopScope(
        onWillPop: () async {
          if (controller.visibilitySticker) {
            controller.visibilityStickerWidget();
            return false;
          } else if (controller.recording.value) {
            controller.stop().then((value) {
              if (controller.audioFile != null) {
                File(controller.audioFile!.path).delete();
                controller.audioFile == null;
              }
            });

            return false;
          } else {
            controller.resetLimit();
            controller.outChatDetailScreen(controller.chatProfile.value.id);

            return true;
          }
        },
        child: Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: ColorConstants.colorWhite,
                titleSpacing: 0,
                title: Row(children: <Widget>[
                  SizedBox(
                    width: 30,
                    child: IconButton(
                        onPressed: () {
                          if (controller.visibilitySticker) {
                            controller.visibilityStickerWidget();
                          } else if (controller.recording.value) {
                            controller.stop().then((value) {
                              if (controller.audioFile != null) {
                                File(controller.audioFile!.path).delete();
                                controller.audioFile == null;
                              }
                            });
                          } else {
                            controller.resetLimit();
                            controller.outChatDetailScreen(
                                controller.chatProfile.value.id);
                            return Get.back();
                          }
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: ColorConstants.themeColor,
                        )),
                  ),
                  controller.user.value.image != ''
                      ? Padding(
                          padding: const EdgeInsets.all(10),
                          child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(controller.user.value.image)))
                      : const Padding(
                          padding: EdgeInsets.all(10),
                          child: CircleAvatar(
                            backgroundImage: AssetImage(AppStoragePath.user),
                          ),
                        ),
                  Text(
                    controller.chatProfile.value.name,
                    style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.colorBlack),
                  ),
                ]),
                actions: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.call,
                        color: ColorConstants.themeColor,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.video_call_outlined,
                        color: ColorConstants.themeColor,
                      )),
                ]),
            body: Column(
              children: <Widget>[
                Expanded(
                    child: controller.chatContent.value.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : MessagePartnerWidget(
                            controller.chatProfile.value.id,
                            controller.chatProfile.value.image,
                          )),
                NewPartnerMessage(
                    controller.chatProfile.value.id,
                    controller.chatProfile.value.isNotSeenMessage,
                    controller.chatProfile.value.insideChatGroup)
              ],
            )),
      );
    });
  }
}
