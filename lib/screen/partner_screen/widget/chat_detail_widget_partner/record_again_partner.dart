import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/model/chat_model.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../config/app_dimens.dart';
import '../../controller/message_partner_controller.dart';

class ListenAgainPartner extends StatefulWidget {
  const ListenAgainPartner(this.notSeen, this.id, this.insideChatGroup,
      {super.key});
  final String id;
  final int notSeen;
  final bool insideChatGroup;
  @override
  State<ListenAgainPartner> createState() => _ListenAgainState();
}

class _ListenAgainState extends State<ListenAgainPartner> {
  MessagePartnerController controller = Get.find<MessagePartnerController>();
  @override
  void initState() {
    controller.audioPlayerAgain.setSourceDeviceFile(controller.audioFile!.path);
    super.initState();
  }

  @override
  void dispose() {
    controller.audioPlayerAgain.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.audioFile != null) {
          File(controller.audioFile!.path).delete();
          controller.audioFile == null;
        }

        return true;
      },
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.dimens_10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Expanded(child: SizedBox()),
            Obx(() => Slider(
                  min: 0,
                  max: controller.totalDurationAgain.value.toDouble(),
                  value: controller.currentDurationAgain.value.toDouble(),
                  onChanged: (value) async {
                    final position = Duration(seconds: value.toInt());
                    await controller.audioPlayerAgain.seek(position);
                    await controller.audioPlayerAgain.resume();
                  },
                )),
            const SizedBox(
              height: 15,
            ),
            Obx(() => Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.dimens_20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(controller.formatTime(Duration(
                          microseconds:
                              controller.currentDurationAgain.value))),
                      Text(controller.formatTime(Duration(
                          microseconds: controller.totalDurationAgain.value -
                              controller.currentDurationAgain.value)))
                    ],
                  ),
                )),
            Obx(() => IconButton(
                padding: const EdgeInsets.all(AppDimens.dimens_0),
                iconSize: AppDimens.dimens_40,
                onPressed: () async {
                  controller.onPressPlayButtonListenAgane(
                      controller.currentDurationAgain.value);
                },
                icon: Icon(
                  controller.isPlayingAgain ? Icons.pause : Icons.play_arrow,
                  color: ColorConstants.themeColor,
                ))),
            const SizedBox(
              height: AppDimens.dimens_15,
            ),
            Row(
              children: <Widget>[
                IconButton(
                    onPressed: () {
                      Get.back();
                      File(controller.audioFile!.path).delete();
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: ColorConstants.colorRed1,
                    )),
                IconButton(
                  onPressed: () async {
                    Get.back();
                    final status = await Permission.microphone.request();
                    if (status != PermissionStatus.granted) {
                      return;
                    } else {
                      if (controller.recording.value == false) {
                        controller.start();
                      }
                    }
                  },
                  icon: const Icon(Icons.replay_outlined),
                  color: ColorConstants.themeColor,
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.themeColor,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppDimens.dimens_20))),
                  onPressed: () {
                    controller.submitData(
                        widget.id,
                        context,
                        TypeMessage.record,
                        widget.notSeen,
                        widget.insideChatGroup);
                  },
                  child: Row(
                    children: const <Widget>[
                      Text(
                        'Send',
                        style: TextStyle(
                            color: ColorConstants.colorWhite,
                            fontSize: AppDimens.dimens_19),
                      ),
                      SizedBox(
                        width: AppDimens.dimens_20,
                      ),
                      Icon(
                        Icons.send,
                        color: ColorConstants.colorWhite,
                        size: AppDimens.dimens_30,
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
