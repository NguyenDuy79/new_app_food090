import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/screen/partner_screen/controller/message_partner_controller.dart';
import 'package:new_ap/screen/partner_screen/view/pages/chat_detail_partner_screen.dart';

import '../../../../config/app_another.dart';
import '../../../../config/app_dimens.dart';
import '../../../../config/firebase_api.dart';

// ignore: must_be_immutable
class ChatGroupPartnerItem extends StatelessWidget {
  ChatGroupPartnerItem(
      this.myNotSeen, this.isNotSeen, this.imageUrl, this.name, this.id,
      {super.key});
  final String id;
  final String name;
  final int isNotSeen;
  final int myNotSeen;
  final String imageUrl;

  MessagePartnerController controller = Get.find<MessagePartnerController>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AppAnother.userAuth != null
            ? FirebaseApi()
                .chatCollectionPartner(AppAnother.userAuth!.uid, id)
                .limit(myNotSeen == 0 ? 1 : myNotSeen)
                .orderBy('timestamp', descending: true)
                .snapshots()
            : null,
        builder: (contex, snapshot) {
          if (snapshot.hasData) {
            DateTime dateTime =
                (snapshot.data!.docs[0]['timestamp'] as Timestamp).toDate();

            var document = snapshot.data!.docs;

            return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.colorWhite10,
                    elevation: AppDimens.dimens_0),
                onPressed: () async {
                  controller.chatContent.value = [];
                  controller.chatContent.bindStream(controller.getChatContent(
                      AppAnother.userAuth!.uid, id, controller.limit));
                  controller.chatProfile
                      .bindStream(controller.getChatGroupProfile(id));
                  controller.getChatDetailScreen(id, contex);
                  controller.changeNotSeenValue(id, contex);

                  controller.changeStatusSeen(document, id, contex);
                  Get.to(() => const ChatDetailPartnerScreen());
                },
                child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: AppDimens.dimens_10),
                    height: AppDimens.dimens_90,
                    width: double.infinity,
                    child: Row(children: <Widget>[
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
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Flexible(
                                              child: Text(
                                                controller
                                                    .getContentChatInChatScreen(
                                                        snapshot.data!.docs[0]
                                                            ['type'],
                                                        snapshot.data!.docs[0]
                                                            ['content'],
                                                        name,
                                                        snapshot.data!.docs[0]
                                                            ['isMe']),
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: ColorConstants
                                                        .colorBlack),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: AppDimens.dimens_30,
                                            ),
                                            Text(
                                              DateFormat('kk:mm')
                                                  .format(dateTime),
                                              style: const TextStyle(
                                                  color: ColorConstants
                                                      .colorBlack),
                                            )
                                          ],
                                        ))
                                  ])))
                    ])));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
