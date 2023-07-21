import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/screen/partner_screen/controller/message_partner_controller.dart';
import 'package:new_ap/screen/partner_screen/widget/message_widget/calls_partner_widget.dart';

import '../../../../config/app_dimens.dart';
import '../widget/message_widget/chat_partner_widget.dart';

// ignore: must_be_immutable
class MessagePartnerScreen extends StatelessWidget {
  MessagePartnerScreen({super.key});
  MessagePartnerController controller = Get.find<MessagePartnerController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Message',
              style: TextStyle(
                  fontSize: AppDimens.dimens_24,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.colorBlack),
            ),
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    color: ColorConstants.themeColor,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.dehaze,
                    color: ColorConstants.themeColor,
                  ))
            ],
            bottom: TabBar(
              labelStyle: const TextStyle(
                  fontSize: AppDimens.dimens_15, fontWeight: FontWeight.w500),
              unselectedLabelColor: ColorConstants.colorGrey3,
              labelColor: ColorConstants.themeColor,
              controller: controller.controller,
              tabs: controller.myTabs,
            ),
          ),
          body: TabBarView(
            controller: controller.controller,
            children: const <Widget>[
              ChatsPartnerWidget(),
              CallsPartnerWidget()
            ],
          )),
    );
  }
}
