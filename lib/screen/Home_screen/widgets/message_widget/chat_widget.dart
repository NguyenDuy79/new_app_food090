import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/screen/Home_screen/controllers/message_controller.dart';
import 'package:new_ap/screen/Home_screen/widgets/message_widget/chat_group_item.dart';

import '../../../../config/app_dimens.dart';

class ChatsWidget extends StatelessWidget {
  const ChatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<MessageController>(
        init: Get.find<MessageController>(),
        builder: (controller) => Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.dimens_10,
                  vertical: AppDimens.dimens_20),
              child: ListView.builder(
                  itemCount: controller.chatProfileUser.length,
                  itemBuilder: (context, index) {
                    return ChatGroupItem(
                        controller.chatProfileUser[index].image,
                        controller.chatProfileUser[index].name,
                        controller.chatProfileUser[index].id);
                  }),
            ));
  }
}
