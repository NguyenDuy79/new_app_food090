import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/config/app_storage_path.dart';
import 'package:new_ap/model/chat_model.dart';
import 'package:new_ap/screen/partner_screen/view/pages/chat_image_click_partner_screen.dart';
import '../../../../config/app_dimens.dart';
import '../../controller/message_partner_controller.dart';

class ChatPartnerBubble extends StatefulWidget {
  const ChatPartnerBubble(this.content, this.isMe, this.seen, this.time,
      this.index, this.image, this.type,
      {super.key});
  final String content;
  final bool isMe;
  final bool seen;
  final Timestamp time;
  final int index;
  final int type;

  final String image;

  @override
  State<ChatPartnerBubble> createState() => _ChatPartnerBubbleState();
}

class _ChatPartnerBubbleState extends State<ChatPartnerBubble>
    with AutomaticKeepAliveClientMixin<ChatPartnerBubble> {
  final MessagePartnerController controller =
      Get.find<MessagePartnerController>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (widget.type == TypeMessage.text) {
      return Padding(
        padding: widget.isMe
            ? const EdgeInsets.only(right: AppDimens.dimens_5)
            : const EdgeInsets.only(left: AppDimens.dimens_5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Row(
            mainAxisAlignment:
                widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: <Widget>[
              if (widget.isMe != true &&
                  controller.getCircleAvatar(widget.index, widget.time))
                SizedBox(
                    height: AppDimens.dimens_40,
                    width: AppDimens.dimens_40,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.image),
                    )),
              if (widget.isMe != true &&
                  !controller.getCircleAvatar(widget.index, widget.time))
                const SizedBox(
                  height: AppDimens.dimens_40,
                  width: AppDimens.dimens_40,
                ),
              Container(
                constraints: BoxConstraints(
                    minWidth: AppDimens.dimens_0, maxWidth: width * 0.75),
                decoration: BoxDecoration(
                    color: widget.isMe
                        ? ColorConstants.swatchColor[600]
                        : ColorConstants.colorGrey2,
                    borderRadius: BorderRadius.only(
                        topLeft: controller.getRadiusTopLeft(
                            widget.isMe, widget.index),
                        topRight: controller.getRadiusTopRight(
                            widget.isMe, widget.index),
                        bottomLeft: controller.getRadiusBottomLeft(
                            widget.isMe, widget.index),
                        bottomRight: controller.getRadiusBottomRight(
                            widget.isMe, widget.index))),
                padding: const EdgeInsets.symmetric(
                    vertical: AppDimens.dimens_5,
                    horizontal: AppDimens.dimens_10),
                margin: const EdgeInsets.symmetric(
                    vertical: AppDimens.dimens_2,
                    horizontal: AppDimens.dimens_8),
                child: Text(
                  widget.content,
                  style: TextStyle(
                      fontSize: AppDimens.dimens_20,
                      color: widget.isMe
                          ? ColorConstants.colorWhite
                          : ColorConstants.colorBlack),
                ),
              )
            ],
          ),
          if (controller.getSeenWidget(widget.index) == true)
            Padding(
              padding: const EdgeInsets.only(
                  right: AppDimens.dimens_10,
                  top: AppDimens.dimens_3,
                  bottom: AppDimens.dimens_3),
              child: SizedBox(
                height: AppDimens.dimens_17,
                width: AppDimens.dimens_17,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.image),
                ),
              ),
            )
        ]),
      );
    } else if (widget.type == TypeMessage.image) {
      return widget.content.contains('"')
          ? Padding(
              padding: widget.isMe
                  ? const EdgeInsets.only(right: AppDimens.dimens_5)
                  : const EdgeInsets.only(left: AppDimens.dimens_5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: widget.isMe
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: <Widget>[
                      if (widget.isMe != true &&
                          controller.getCircleAvatar(widget.index, widget.time))
                        SizedBox(
                            height: AppDimens.dimens_40,
                            width: AppDimens.dimens_40,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(widget.image),
                            )),
                      if (widget.isMe != true &&
                          !controller.getCircleAvatar(
                              widget.index, widget.time))
                        const SizedBox(
                          height: AppDimens.dimens_40,
                          width: AppDimens.dimens_40,
                        ),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: width * 0.75,
                          maxHeight: controller.getHeight(
                              widget.content.split('"').length, width),
                        ),
                        decoration: BoxDecoration(
                            color: ColorConstants.colorWhite,
                            borderRadius: BorderRadius.only(
                                topLeft: controller.getRadiusTopLeft(
                                    widget.isMe, widget.index),
                                topRight: controller.getRadiusTopRight(
                                    widget.isMe, widget.index),
                                bottomLeft: controller.getRadiusBottomLeft(
                                    widget.isMe, widget.index),
                                bottomRight: controller.getRadiusBottomRight(
                                    widget.isMe, widget.index))),
                        padding: const EdgeInsets.symmetric(
                            vertical: AppDimens.dimens_2,
                            horizontal: AppDimens.dimens_8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: controller.getRadiusTopLeft(
                                  widget.isMe, widget.index),
                              topRight: controller.getRadiusTopRight(
                                  widget.isMe, widget.index),
                              bottomLeft: controller.getRadiusBottomLeft(
                                  widget.isMe, widget.index),
                              bottomRight: controller.getRadiusBottomRight(
                                  widget.isMe, widget.index)),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: GridView.builder(
                                itemCount: widget.content.split('"').length,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: controller
                                            .getCrossCount(widget.content
                                                .split('"')
                                                .length),
                                        crossAxisSpacing: AppDimens.dimens_5,
                                        mainAxisSpacing: AppDimens.dimens_5,
                                        childAspectRatio: 1),
                                itemBuilder: (context, index) => ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          AppDimens.dimens_10),
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(() =>
                                              ChatImageClickPartnerScreen(widget
                                                  .content
                                                  .split('"')[index]));
                                        },
                                        child: Hero(
                                          tag: widget.content.split('"')[index],
                                          child: Image.network(
                                              widget.content.split('"')[index],
                                              fit: BoxFit.cover, loadingBuilder:
                                                  (context, child,
                                                      loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }),
                                        ),
                                      ),
                                    )),
                          ),
                        ),
                      )
                    ],
                  ),
                  if (controller.getSeenWidget(widget.index) == true)
                    Padding(
                      padding: const EdgeInsets.only(
                          right: AppDimens.dimens_10,
                          top: AppDimens.dimens_3,
                          bottom: AppDimens.dimens_3),
                      child: SizedBox(
                        height: AppDimens.dimens_17,
                        width: AppDimens.dimens_17,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(widget.image),
                        ),
                      ),
                    )
                ],
              ))
          : Padding(
              padding: widget.isMe
                  ? const EdgeInsets.only(right: AppDimens.dimens_5)
                  : const EdgeInsets.only(left: AppDimens.dimens_5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: widget.isMe
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: <Widget>[
                      if (widget.isMe != true &&
                          controller.getCircleAvatar(widget.index, widget.time))
                        SizedBox(
                            height: AppDimens.dimens_40,
                            width: AppDimens.dimens_40,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(widget.image),
                            )),
                      if (widget.isMe != true &&
                          !controller.getCircleAvatar(
                              widget.index, widget.time))
                        const SizedBox(
                          height: AppDimens.dimens_40,
                          width: AppDimens.dimens_40,
                        ),
                      Container(
                          constraints: BoxConstraints(
                              maxWidth: width * 0.65, maxHeight: height * 0.5),
                          decoration: BoxDecoration(
                              color: ColorConstants.colorWhite,
                              borderRadius: BorderRadius.only(
                                  topLeft: controller.getRadiusTopLeft(
                                      widget.isMe, widget.index),
                                  topRight: controller.getRadiusTopRight(
                                      widget.isMe, widget.index),
                                  bottomLeft: controller.getRadiusBottomLeft(
                                      widget.isMe, widget.index),
                                  bottomRight: controller.getRadiusBottomRight(
                                      widget.isMe, widget.index))),
                          margin: const EdgeInsets.symmetric(
                              vertical: AppDimens.dimens_2,
                              horizontal: AppDimens.dimens_8),
                          child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: controller.getRadiusTopLeft(
                                      widget.isMe, widget.index),
                                  topRight: controller.getRadiusTopRight(
                                      widget.isMe, widget.index),
                                  bottomLeft: controller.getRadiusBottomLeft(
                                      widget.isMe, widget.index),
                                  bottomRight: controller.getRadiusBottomRight(widget.isMe, widget.index)),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() => ChatImageClickPartnerScreen(
                                      widget.content));
                                },
                                child: Hero(
                                  tag: widget.content,
                                  child: Image.network(widget.content,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }),
                                ),
                              ))),
                    ],
                  ),
                  if (controller.getSeenWidget(widget.index) == true)
                    Padding(
                      padding: const EdgeInsets.only(
                          right: AppDimens.dimens_10,
                          top: AppDimens.dimens_3,
                          bottom: AppDimens.dimens_3),
                      child: SizedBox(
                        height: AppDimens.dimens_17,
                        width: AppDimens.dimens_17,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(widget.image),
                        ),
                      ),
                    )
                ],
              ));
    } else if (widget.type == TypeMessage.sticker) {
      return Padding(
          padding: widget.isMe
              ? widget.content == 'like'
                  ? const EdgeInsets.symmetric(horizontal: 5, vertical: 15)
                  : const EdgeInsets.only(right: AppDimens.dimens_5)
              : widget.content == 'like'
                  ? const EdgeInsets.symmetric(horizontal: 5, vertical: 15)
                  : const EdgeInsets.only(left: AppDimens.dimens_5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: widget.isMe
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: <Widget>[
                  if (widget.isMe != true &&
                      controller.getCircleAvatar(widget.index, widget.time))
                    SizedBox(
                        height: AppDimens.dimens_40,
                        width: AppDimens.dimens_40,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(widget.image),
                        )),
                  if (widget.isMe != true &&
                      !controller.getCircleAvatar(widget.index, widget.time))
                    const SizedBox(
                      height: AppDimens.dimens_40,
                      width: AppDimens.dimens_40,
                    ),
                  Container(
                    width:
                        widget.content == 'like' ? width * 0.1 : width * 0.25,
                    height:
                        widget.content == 'like' ? width * 0.1 : width * 0.25,
                    decoration: BoxDecoration(
                        color: ColorConstants.colorWhite,
                        borderRadius: BorderRadius.only(
                            topLeft: controller.getRadiusTopLeft(
                                widget.isMe, widget.index),
                            topRight: controller.getRadiusTopRight(
                                widget.isMe, widget.index),
                            bottomLeft: controller.getRadiusBottomLeft(
                                widget.isMe, widget.index),
                            bottomRight: controller.getRadiusBottomRight(
                                widget.isMe, widget.index))),
                    margin: const EdgeInsets.symmetric(
                        vertical: AppDimens.dimens_2,
                        horizontal: AppDimens.dimens_8),
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: controller.getRadiusTopLeft(
                                widget.isMe, widget.index),
                            topRight: controller.getRadiusTopRight(
                                widget.isMe, widget.index),
                            bottomLeft: controller.getRadiusBottomLeft(
                                widget.isMe, widget.index),
                            bottomRight: controller.getRadiusBottomRight(
                                widget.isMe, widget.index)),
                        child: widget.content == 'like'
                            ? Image.asset(AppStoragePath.like)
                            : Image.asset(AppStoragePath.sticker[widget.content]
                                as String)),
                  )
                ],
              ),
              if (controller.getSeenWidget(widget.index) == true)
                Padding(
                  padding: const EdgeInsets.only(
                      right: AppDimens.dimens_10,
                      top: AppDimens.dimens_3,
                      bottom: AppDimens.dimens_3),
                  child: SizedBox(
                    height: AppDimens.dimens_17,
                    width: AppDimens.dimens_17,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.image),
                    ),
                  ),
                )
            ],
          ));
    } else {
      return Padding(
          padding: widget.isMe
              ? const EdgeInsets.only(right: AppDimens.dimens_5)
              : const EdgeInsets.only(left: AppDimens.dimens_5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: widget.isMe
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: <Widget>[
                  if (widget.isMe != true &&
                      controller.getCircleAvatar(widget.index, widget.time))
                    SizedBox(
                        height: AppDimens.dimens_40,
                        width: AppDimens.dimens_40,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(widget.image),
                        )),
                  if (widget.isMe != true &&
                      !controller.getCircleAvatar(widget.index, widget.time))
                    const SizedBox(
                      height: AppDimens.dimens_40,
                      width: AppDimens.dimens_40,
                    ),
                  Container(
                      height: height * 0.06,
                      constraints: BoxConstraints(
                          maxWidth: width * 0.65, maxHeight: height * 0.075),
                      decoration: BoxDecoration(
                          color: widget.isMe
                              ? ColorConstants.swatchColor[600]
                              : ColorConstants.colorGrey2,
                          borderRadius: BorderRadius.only(
                              topLeft: controller.getRadiusTopLeft(
                                  widget.isMe, widget.index),
                              topRight: controller.getRadiusTopRight(
                                  widget.isMe, widget.index),
                              bottomLeft: controller.getRadiusBottomLeft(
                                  widget.isMe, widget.index),
                              bottomRight: controller.getRadiusBottomRight(
                                  widget.isMe, widget.index))),
                      margin: const EdgeInsets.symmetric(
                          vertical: AppDimens.dimens_2,
                          horizontal: AppDimens.dimens_8),
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                controller.onPressPlayButton(
                                    widget.index,
                                    widget.content,
                                    controller.currentDuration.value);
                              },
                              onSecondaryTap: () {
                                controller.audioPlayer.stop();
                              },
                              child: Obx(() => (controller.isPlaying &&
                                      controller.currenId.value == widget.index)
                                  ? Icon(
                                      Icons.pause,
                                      color: widget.isMe
                                          ? ColorConstants.colorGrey0
                                          : ColorConstants.themeColor,
                                    )
                                  : Icon(
                                      Icons.play_arrow,
                                      color: widget.isMe
                                          ? ColorConstants.colorGrey0
                                          : ColorConstants.themeColor,
                                    ))),
                          Obx(
                            () => Text(
                              (controller.isPlaying &&
                                      controller.currenId.value == widget.index)
                                  ? controller.formatTime(Duration(
                                      microseconds:
                                          controller.currentDuration.value))
                                  : '00:00',
                              style: const TextStyle(
                                  fontSize: AppDimens.dimens_17),
                            ),
                          ),
                          Obx(
                            () => Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: AppDimens.dimens_10),
                                  child: (controller.isPlaying &&
                                          controller.currenId.value ==
                                              widget.index)
                                      ? Slider(
                                          activeColor: widget.isMe
                                              ? ColorConstants.colorGrey0
                                              : ColorConstants.themeColor,
                                          inactiveColor:
                                              ColorConstants.colorGrey4,
                                          min: 0,
                                          max: controller.totalDuration.value
                                              .toDouble(),
                                          value: controller
                                              .currentDuration.value
                                              .toDouble(),
                                          onChanged: (value) async {
                                            final position = Duration(
                                                seconds: value.toInt());
                                            await controller.audioPlayer
                                                .seek(position);
                                            await controller.audioPlayer
                                                .resume();
                                          },
                                        )
                                      : Slider(
                                          activeColor: widget.isMe
                                              ? ColorConstants.colorGrey0
                                              : ColorConstants.themeColor,
                                          inactiveColor:
                                              ColorConstants.colorGrey4,
                                          min: 0,
                                          max: 100,
                                          value: 0,
                                          onChanged: (value) {})),
                            ),
                          )
                        ],
                      )),
                ],
              ),
              if (controller.getSeenWidget(widget.index) == true)
                Padding(
                  padding: const EdgeInsets.only(
                      right: AppDimens.dimens_10,
                      top: AppDimens.dimens_3,
                      bottom: AppDimens.dimens_3),
                  child: SizedBox(
                    height: AppDimens.dimens_17,
                    width: AppDimens.dimens_17,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.image),
                    ),
                  ),
                )
            ],
          ));
    }
  }

  @override
  bool get wantKeepAlive => true;
}
