import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/screen/partner_screen/controller/message_partner_controller.dart';
import 'package:new_ap/screen/partner_screen/view/chat_detail_partner_screen.dart';

import '../../../../config/app_dimens.dart';

// ignore: must_be_immutable
class ChatGroupPartnerItem extends StatelessWidget {
  ChatGroupPartnerItem(this.imageUrl, this.name, this.id, {super.key});
  final String id;
  final String name;
  final String imageUrl;
  MessagePartnerController controller = Get.find<MessagePartnerController>();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.colorWhite10,
          elevation: AppDimens.dimens_0),
      onPressed: () {
        Get.to(() => ChatDetailPartnerScreen(name, id, imageUrl));
      },
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: AppDimens.dimens_10),
          height: AppDimens.dimens_90,
          width: double.infinity,
          child: Row(
            children: <Widget>[
              SizedBox(
                height: AppDimens.dimens_70,
                width: AppDimens.dimens_70,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.dimens_10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name,
                        style: const TextStyle(
                            fontSize: AppDimens.dimens_20,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.colorBlack),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppDimens.dimens_8),
                          child: GetX<MessagePartnerController>(
                            initState: (state) =>
                                FirebaseAuth.instance.currentUser != null
                                    ? state.controller!.chatContent.bindStream(
                                        controller.getChatContent(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            id,
                                            controller.limit))
                                    : null,
                            builder: (controller) {
                              if (controller.chatContent.value.isNotEmpty) {
                                var dateTime = DateTime.parse(controller
                                    .chatContent.value[0].id
                                    .toDate()
                                    .toString());

                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(
                                        controller.getContentChatInChatScreen(
                                            controller
                                                .chatContent.value[0].type,
                                            controller
                                                .chatContent.value[0].content,
                                            name,
                                            controller
                                                .chatContent.value[0].isMe),
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: ColorConstants.colorBlack),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: AppDimens.dimens_30,
                                    ),
                                    Text(
                                      DateFormat('kk:mm').format(dateTime),
                                      style: const TextStyle(
                                          color: ColorConstants.colorBlack),
                                    )
                                  ],
                                );
                              } else {
                                return const Text('');
                              }
                            },
                          )),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
