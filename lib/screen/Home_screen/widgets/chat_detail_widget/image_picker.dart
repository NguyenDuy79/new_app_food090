import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_font.dart';
import 'package:new_ap/screen/Home_screen/controllers/message_controller.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_dimens.dart';

class ImagePickerBottom extends StatefulWidget {
  const ImagePickerBottom(
      this.height, this.paddingTop, this.id, this.insideChatGroup, this.notSeen,
      {super.key});
  final double height;
  final double paddingTop;
  final String id;
  final bool insideChatGroup;
  final int notSeen;

  @override
  State<ImagePickerBottom> createState() => _ImagePickerBottomState();
}

class _ImagePickerBottomState extends State<ImagePickerBottom>
    with WidgetsBindingObserver {
  final MessageController controller = Get.find<MessageController>();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      controller.getAllData(RequestType.common);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Obx(
      () => WillPopScope(
        onWillPop: () async {
          if (controller.isShowImage) {
            Get.back();
            controller.getFalseShowImagePicker();
            return false;
          } else {
            return true;
          }
        },
        child: SafeArea(
          child: AnimatedContainer(
            duration: const Duration(seconds: 0),
            height: controller.heightSheet,
            color: ColorConstants.colorWhite,
            child: Column(
              children: [
                if (controller.heightSheet >=
                    (widget.height - widget.paddingTop))
                  SizedBox(
                    height: AppDimens.dimens_50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                            onPressed: () {
                              controller.setHeightSheet(widget.height * 0.3);
                            },
                            iconSize: AppDimens.dimens_35,
                            icon: const Icon(
                              Icons.clear,
                              color: ColorConstants.themeColor,
                            )),
                        const Text('Tất cả các ảnh',
                            style: TextStyle(
                              fontSize: AppDimens.dimens_25,
                              fontWeight: AppFont.semiBold,
                            )),
                        IconButton(
                            onPressed: () {},
                            iconSize: AppDimens.dimens_35,
                            icon: const Icon(
                              Icons.add,
                              color: ColorConstants.themeColor,
                            ))
                      ],
                    ),
                  ),
                if (controller.heightSheet <
                    (widget.height - widget.paddingTop))
                  GestureDetector(
                    onVerticalDragUpdate: (details) {
                      if (0 > details.delta.dy) {
                        controller.setFalseGestureDown();
                      } else {
                        controller.setTrueGestureDown();
                      }

                      controller.reduceHeightSheet(
                          -details.delta.dy, widget.height - widget.paddingTop);
                      if (controller.heightSheet >
                          (widget.height - widget.paddingTop)) {
                        controller.setHeightSheet(
                            (widget.height - widget.paddingTop));
                      } else if (controller.heightSheet < AppDimens.dimens_20) {
                        controller.setHeightSheet(AppDimens.dimens_0);
                      }
                    },
                    onVerticalDragEnd: (detail) {
                      if (controller.gestureDown) {
                        if (controller.heightSheet < 0.3 * widget.height) {
                          controller.setHeightSheet(AppDimens.dimens_0);
                          Get.back();
                        } else if (controller.height < 0.35 * widget.height &&
                            detail.primaryVelocity! > 200) {
                          controller.setHeightSheet(AppDimens.dimens_0);
                          Get.back();
                        } else {
                          controller.setHeightSheet(widget.height * 0.4);
                        }
                      } else {
                        if (controller.heightSheet > widget.height * 0.41) {
                          controller.setHeightSheet(
                              (widget.height - widget.paddingTop));
                        } else {
                          controller.setHeightSheet(widget.height * 0.4);
                        }
                      }
                    },
                    child: Container(
                        width: double.infinity,
                        height: controller.heightSheet < AppDimens.dimens_20
                            ? AppDimens.dimens_0
                            : AppDimens.dimens_20,
                        color: ColorConstants.colorWhite,
                        child: Center(
                          child: Container(
                            height: AppDimens.dimens_7,
                            width: AppDimens.dimens_50,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(AppDimens.dimens_5),
                              color: ColorConstants.colorGrey3,
                            ),
                          ),
                        )),
                  ),
                Flexible(
                  child: Stack(alignment: Alignment.center, children: <Widget>[
                    Container(
                      height: controller.heightSheet >=
                              (widget.height - widget.paddingTop)
                          ? controller.heightSheet - AppDimens.dimens_74
                          : controller.heightSheet < AppDimens.dimens_20
                              ? AppDimens.dimens_0
                              : controller.heightSheet - AppDimens.dimens_20,
                      color: ColorConstants.colorGrey1,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: AppDimens.dimens_2,
                                mainAxisSpacing: AppDimens.dimens_2,
                                childAspectRatio: 1),
                        itemBuilder: (context, index) {
                          AssetEntity assetEntity = controller.assetList[index];

                          return imageItemPicker(assetEntity);
                        },
                        itemCount: controller.assetList.length,
                      ),
                    ),
                    if (controller.selectedAssetList.isNotEmpty)
                      Positioned(
                        bottom: AppDimens.dimens_15,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(
                              height: AppDimens.dimens_35,
                              width: width * 0.275,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          ColorConstants.themeColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              AppDimens.dimens_10)),
                                      padding: const EdgeInsets.all(
                                          AppDimens.dimens_0)),
                                  onPressed: () {},
                                  child: const Text(
                                    'Chỉnh sửa',
                                    style: TextStyle(
                                        fontSize: AppDimens.dimens_20,
                                        fontWeight: AppFont.semiBold,
                                        color: ColorConstants.colorWhite),
                                  )),
                            ),
                            SizedBox(
                              width: width * 0.1,
                            ),
                            SizedBox(
                              height: AppDimens.dimens_35,
                              width: width * 0.275,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          ColorConstants.colorWhite,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              AppDimens.dimens_10)),
                                      padding: const EdgeInsets.all(
                                          AppDimens.dimens_0)),
                                  onPressed: () {
                                    controller.submitMultiImage(
                                        widget.id,
                                        context,
                                        widget.notSeen,
                                        widget.insideChatGroup);
                                  },
                                  child: const Text(
                                    'Gửi',
                                    style: TextStyle(
                                        fontSize: AppDimens.dimens_20,
                                        fontWeight: AppFont.semiBold,
                                        color: ColorConstants.colorBlack),
                                  )),
                            )
                          ],
                        ),
                      )
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget imageItemPicker(AssetEntity assetEntity) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
            child: Padding(
          padding: const EdgeInsets.all(AppDimens.dimens_0),
          child: AssetEntityImage(
            assetEntity,
            isOriginal: false,
            thumbnailSize: const ThumbnailSize.square(250),
            fit: BoxFit.cover,
            errorBuilder: (context, eror, stackTrace) {
              return const Center(
                child: Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              );
            },
          ),
        )),
        Positioned.fill(
          child: Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                controller.selected(assetEntity);
              },
              child: Obx(() {
                return Padding(
                  padding: const EdgeInsets.only(right: AppDimens.dimens_5),
                  child: Container(
                    decoration: BoxDecoration(
                        color:
                            controller.selectedAssetList.contains(assetEntity)
                                ? ColorConstants.colorBlue1
                                : ColorConstants.colorTransparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: AppDimens.dimens_1,
                            color: ColorConstants.colorWhite)),
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimens.dimens_10),
                      child: Text(
                          (controller.selectedAssetList.indexOf(assetEntity) +
                                  1)
                              .toString()),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
