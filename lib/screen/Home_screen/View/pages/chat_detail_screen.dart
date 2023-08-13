import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/screen/Home_screen/controllers/message_controller.dart';
import 'package:new_ap/screen/Home_screen/widgets/chat_detail_widget/message.dart';
import 'package:new_ap/screen/Home_screen/widgets/chat_detail_widget/new_message.dart';

class ChatDetailScreen extends StatelessWidget {
  ChatDetailScreen({super.key});
  final controller = Get.find<MessageController>();
  @override
  Widget build(BuildContext context) {
    controller.getTrueExtend();
    Timer(const Duration(seconds: 5), () {
      if (controller.messageController.text == '') {
        controller.getFalseExtend();
      }
    });
    return GetX<MessageController>(builder: (controller) {
      return WillPopScope(
        onWillPop: () async {
          if (controller.visibilitySticker) {
            controller.getFalseVisibility();
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
            controller.getFalseExtend();
            controller.messageController.clear();
            controller.outChatDetailScreen(
                controller.chatProfile.value.id, context);
            controller.resetLimit();
            return true;
          }
        },
        child: Scaffold(
            backgroundColor: ColorConstants.colorWhite,
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
                            controller.getFalseVisibility();
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
                                controller.chatProfile.value.id, context);
                            return Get.back();
                          }
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: ColorConstants.themeColor,
                        )),
                  ),
                  controller.chatProfile.value.image != ''
                      ? Padding(
                          padding: const EdgeInsets.all(10),
                          child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  controller.chatProfile.value.image)))
                      : const Padding(
                          padding: EdgeInsets.all(10),
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/image/user.png'),
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
                    child: MessageWidget(controller.chatProfile.value.id,
                        controller.chatProfile.value.image)),
                NewMessage(
                    controller.chatProfile.value.id,
                    controller.chatProfile.value.isNotSeenMessage,
                    controller.chatProfile.value.insideChatGroup)
              ],
            )),
      );
    });
  }
}
