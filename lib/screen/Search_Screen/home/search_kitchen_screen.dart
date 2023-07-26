import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_dimens.dart';
import 'package:new_ap/screen/Home_screen/View/pages/kitchen_screen.dart';
import 'package:new_ap/screen/Home_screen/controllers/main_controller.dart';

import '../../../config/app_colors.dart';

class SearchKitchenScreen extends StatelessWidget {
  SearchKitchenScreen({super.key});
  final MainController controller = Get.find<MainController>();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    controller.getValueHistorySearch();
    return WillPopScope(
        onWillPop: () async {
          controller.textEditing.text = '';
          controller.changeStatusEmpty();
          return true;
        },
        child: Scaffold(
            body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: AppDimens.dimens_30,
                    bottom: AppDimens.dimens_5,
                    left: AppDimens.dimens_5,
                    right: AppDimens.dimens_5),
                child: SizedBox(
                  height: AppDimens.dimens_40,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            controller.textEditing.text = '';
                            controller.changeStatusEmpty();
                            Get.back();
                          },
                          iconSize: AppDimens.dimens_30,
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: ColorConstants.themeColor,
                          )),
                      Expanded(
                          child: TextField(
                        controller: controller.textEditing,
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppDimens.dimens_20,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: ColorConstants.colorTransparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorConstants.themeColor)),
                          filled: true,
                          fillColor: ColorConstants.colorGrey2,
                        ),
                        focusNode: controller.focusNode,
                        onChanged: (value) {
                          if (value.trim() != '') {
                            controller.changeStatusEmpty();
                            controller.getSuggest(value.trim());
                          } else {
                            controller.changeStatusEmpty();
                          }
                        },
                        onSubmitted: (_) {
                          if (controller.textEditing.text.trim() != '') {
                            if (controller.isMain) {
                              if (controller.isCheck) {
                                controller.submitQuerySearch(
                                    controller.textEditing.text, context);
                                controller
                                    .getListQuery(controller.textEditing.text);
                                controller.getFalseIsMain();
                                Get.off(() => KitchenScreen());
                              }
                            } else {
                              if (controller.isCheck) {
                                controller.submitQuerySearch(
                                    controller.textEditing.text, context);
                                controller
                                    .getListQuery(controller.textEditing.text);
                                Get.back();
                              }
                            }
                          } else {
                            controller.textEditing.text = '';
                          }
                        },
                      )),
                      Container(
                        color: ColorConstants.themeColor,
                        child: IconButton(
                            onPressed: () {
                              if (controller.textEditing.text.trim() != '') {
                                if (controller.isMain) {
                                  if (controller.isCheck) {
                                    controller.submitQuerySearch(
                                        controller.textEditing.text, context);
                                    controller.getListQuery(
                                        controller.textEditing.text);
                                    controller.getFalseIsMain();
                                    Get.off(() => KitchenScreen());
                                  }
                                } else {
                                  if (controller.isCheck) {
                                    controller.submitQuerySearch(
                                        controller.textEditing.text, context);
                                    controller.getListQuery(
                                        controller.textEditing.text);
                                    Get.back();
                                  }
                                }
                              } else {
                                controller.textEditing.text = '';
                              }
                            },
                            iconSize: AppDimens.dimens_30,
                            padding: const EdgeInsets.all(0),
                            icon: const Icon(
                              Icons.search,
                              color: ColorConstants.colorWhite,
                            )),
                      )
                    ],
                  ),
                ),
              ),

              Obx(
                () => SizedBox(
                  height: height * 0.8,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          if (controller.isMain) {
                            controller.submitQuerySearch(
                                controller.kitchenName[index], context);
                            controller
                                .getListQuery(controller.kitchenName[index]);
                            controller.textEditing.text =
                                controller.kitchenName[index];
                            controller.getFalseIsMain();
                            Get.off(() => KitchenScreen());
                          } else {
                            controller.submitQuerySearch(
                                controller.kitchenName[index], context);
                            controller
                                .getListQuery(controller.kitchenName[index]);
                            controller.textEditing.text =
                                controller.kitchenName[index];

                            Get.back();
                          }
                        },
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Text(
                                controller.kitchenName[index],
                                style: const TextStyle(
                                    fontSize: AppDimens.dimens_18),
                              ),
                            ),
                            const Divider(
                              thickness: AppDimens.dimens_1,
                              height: AppDimens.dimens_0,
                            )
                          ],
                        ),
                      );
                    },
                    itemCount: controller.kitchenName.length,
                  ),
                ),
              ),
              // if (controller.isCheck == false)
              //   SizedBox(
              //       height: height * 0.8,
              //       child: ListView.builder(
              //         itemBuilder: (context, index) {
              //           return GestureDetector(
              //             onTap: () {
              //               if (controller.isMain) {
              //                 controller.submitQuerySearch(
              //                     controller.historySearch[index], context);
              //                 controller.getListQuery(
              //                     controller.historySearch[index]);
              //                 controller.changeStatusEmpty();
              //                 controller.textEditing.text =
              //                     controller.historySearch[index];
              //                 controller.getFalseIsMain();
              //                 Get.off(() => KitchenScreen());
              //               } else {
              //                 controller.submitQuerySearch(
              //                     controller.historySearch[index], context);

              //                 controller.changeStatusEmpty();
              //                 controller.textEditing.text =
              //                     controller.historySearch[index];
              //                 Get.back();
              //                 controller.getListQuery(
              //                     controller.historySearch[index]);
              //               }
              //             },
              //             child: Column(
              //               children: <Widget>[
              //                 ListTile(
              //                   leading: Text(
              //                     controller.historySearch[index],
              //                     style: const TextStyle(
              //                         fontSize: AppDimens.dimens_18),
              //                   ),
              //                 ),
              //                 const Divider(
              //                   thickness: AppDimens.dimens_1,
              //                   height: AppDimens.dimens_0,
              //                 )
              //               ],
              //             ),
              //           );
              //         },
              //         itemCount: controller.itemCount.value,
              //       ))
            ],
          ),
        )));
  }
}
