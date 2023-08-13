import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/screen/partner_screen/controller/message_partner_controller.dart';
import 'package:new_ap/screen/partner_screen/view/pages/chat_detail_partner_screen.dart';
import 'package:new_ap/screen/partner_screen/widget/message_widget/calls_partner_widget.dart';

import '../../../../../config/app_dimens.dart';
import '../../../../config/app_another.dart';
import '../../../../config/app_font.dart';
import '../../widget/message_widget/chat_partner_widget.dart';

// ignore: must_be_immutable
class MessagePartnerScreen extends StatelessWidget {
  MessagePartnerScreen({super.key});
  MessagePartnerController controller = Get.find<MessagePartnerController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: ColorConstants.colorWhite,
          appBar: AppBar(
            title: const Text(
              'Message',
              style: TextStyle(
                  fontSize: AppDimens.dimens_24,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.colorBlack),
            ),
            backgroundColor: ColorConstants.colorWhite,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  onPressed: () {
                    showSearch(context: context, delegate: CustomSearch());
                  },
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

class CustomSearch extends SearchDelegate {
  final MessagePartnerController controller =
      Get.find<MessagePartnerController>();
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          color: ColorConstants.themeColor,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
      itemCount: controller.getSearchChatSuggestions(query).length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            controller.chatContent.value = [];
            controller.chatContent.bindStream(controller.getChatContent(
                AppAnother.userAuth!.uid,
                controller.getSearchChatSuggestions(query)[index].id,
                controller.limit));
            controller.chatProfile.bindStream(controller.getChatGroupProfile(
                controller.getSearchChatSuggestions(query)[index].id));
            Get.to(() => const ChatDetailPartnerScreen());
            controller.getChatDetailScreen(
                controller.getSearchChatSuggestions(query)[index].id, context);

            if (controller
                    .getSearchChatSuggestions(query)[index]
                    .myNotSeenMessage >
                0) {
              controller.changeNotSeenValue(
                  controller.getSearchChatSuggestions(query)[index].id,
                  context);

              controller.changeStatusSeenSearch(
                  controller
                      .getSearchChatSuggestions(query)[index]
                      .myNotSeenMessage,
                  controller.getSearchChatSuggestions(query)[index].id,
                  context);
            }
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  controller.getSearchChatSuggestions(query)[index].image),
            ),
            title: Text(
              controller.getSearchChatSuggestions(query)[index].name,
              style: const TextStyle(
                  fontWeight: AppFont.semiBold,
                  fontSize: AppDimens.dimens_20,
                  color: ColorConstants.colorBlack),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
      itemCount: controller.getSearchChatSuggestions(query).length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            controller.chatContent.value = [];
            controller.chatContent.bindStream(controller.getChatContent(
                AppAnother.userAuth!.uid,
                controller.getSearchChatSuggestions(query)[index].id,
                controller.limit));
            controller.chatProfile.bindStream(controller.getChatGroupProfile(
                controller.getSearchChatSuggestions(query)[index].id));
            Get.to(() => const ChatDetailPartnerScreen());
            controller.getChatDetailScreen(
                controller.getSearchChatSuggestions(query)[index].id, context);

            if (controller
                    .getSearchChatSuggestions(query)[index]
                    .myNotSeenMessage >
                0) {
              controller.changeNotSeenValue(
                  controller.getSearchChatSuggestions(query)[index].id,
                  context);

              controller.changeStatusSeenSearch(
                  controller
                      .getSearchChatSuggestions(query)[index]
                      .myNotSeenMessage,
                  controller.getSearchChatSuggestions(query)[index].id,
                  context);
            }
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  controller.getSearchChatSuggestions(query)[index].image),
            ),
            title: Text(
              controller.getSearchChatSuggestions(query)[index].name,
              style: const TextStyle(
                  fontWeight: AppFont.semiBold,
                  fontSize: AppDimens.dimens_20,
                  color: ColorConstants.colorBlack),
            ),
          ),
        );
      },
    );
  }
}
