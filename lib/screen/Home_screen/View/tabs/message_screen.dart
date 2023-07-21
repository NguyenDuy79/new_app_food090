import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/screen/Home_screen/controllers/message_controller.dart';
import 'package:new_ap/screen/Home_screen/widgets/message_widget/calls_widget.dart';
import 'package:new_ap/screen/Home_screen/widgets/message_widget/chat_widget.dart';
import '../../../../config/app_dimens.dart';

// ignore: must_be_immutable
class MessageScreen extends StatelessWidget {
  MessageScreen({super.key});
  MessageController controller = Get.find<MessageController>();

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
            children: const <Widget>[ChatsWidget(), CallsWidget()],
          )),
    );
  }
}
