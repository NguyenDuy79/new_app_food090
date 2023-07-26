import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/screen/partner_screen/controller/message_partner_controller.dart';
import 'package:new_ap/screen/partner_screen/widget/message_widget/chat_group_partner_item.dart';
import '../../../../config/app_dimens.dart';

class ChatsPartnerWidget extends StatelessWidget {
  const ChatsPartnerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<MessagePartnerController>(
        init: Get.find<MessagePartnerController>(),
        builder: (controller) => Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.dimens_10,
                  vertical: AppDimens.dimens_20),
              child: ListView.builder(
                  itemCount: controller.chatProfileUser.length,
                  itemBuilder: (context, index) {
                    return ChatGroupPartnerItem(
                        controller.chatProfileUser[index].myNotSeenMessage,
                        controller.chatProfileUser[index].isNotSeenMessage,
                        controller.chatProfileUser[index].image,
                        controller.chatProfileUser[index].name,
                        controller.chatProfileUser[index].id);
                  }),
            ));
  }
}
