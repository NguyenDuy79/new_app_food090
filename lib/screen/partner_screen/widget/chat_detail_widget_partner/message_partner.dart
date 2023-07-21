import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:new_ap/config/app_colors.dart';

import 'package:new_ap/screen/partner_screen/controller/message_partner_controller.dart';
import 'package:new_ap/screen/partner_screen/widget/chat_detail_widget_partner/chat_bubble_partner.dart';
import '../../../../config/app_dimens.dart';

class MessagePartnerWidget extends StatelessWidget {
  const MessagePartnerWidget(this.id, this.image, {super.key});
  final String id;
  final String image;

  @override
  Widget build(BuildContext context) {
    return GetX<MessagePartnerController>(
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
                    return ChatPartnerBubble(
                        controller.chatContent.value[index].content,
                        controller.chatContent.value[index].isMe,
                        controller.chatContent.value[index].seen,
                        controller.chatContent.value[index].id,
                        index,
                        image,
                        controller.chatContent.value[index].type);
                  }),
            ));
      },
    );
  }
}
