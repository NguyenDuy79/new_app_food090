import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/screen/Home_screen/widgets/chat_detail_widget/chat_bubble.dart';
import '../../../../config/app_dimens.dart';
import '../../controllers/message_controller.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget(this.id, this.image, {super.key});
  final String id;
  final String image;

  @override
  Widget build(BuildContext context) {
    return GetX<MessageController>(
      builder: (controller) {
        return RefreshIndicator(
            onRefresh: () {
              return controller.changeLimit(id);
            },
            child: Container(
              padding: const EdgeInsets.all(AppDimens.dimens_5),
              color: ColorConstants.colorWhite,
              child: ListView.builder(
                  reverse: true,
                  addAutomaticKeepAlives: true,
                  itemCount: controller.chatContent.value.length,
                  itemBuilder: (context, index) {
                    controller.setListImage();
                    return ChatBubble(
                        controller.chatContent.value[index].content,
                        controller.chatContent.value[index].isMe,
                        controller.chatContent.value[index].isSeen,
                        controller.chatContent.value[index].timestamp,
                        index,
                        image,
                        controller.chatContent.value[index].type);
                  }),
            ));
      },
    );
  }
}
