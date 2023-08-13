import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/screen/partner_screen/controller/order_now_controller.dart';
import 'package:new_ap/screen/partner_screen/view/pages/order_now_search_result_screen.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_dimens.dart';

class SearchOrderNowScreen extends StatelessWidget {
  SearchOrderNowScreen({super.key});
  final OrderNowController controller = Get.find<OrderNowController>();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    controller.getValueHistorySearch();
    return Scaffold(
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
                width: double.infinity,
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
                        hintText: 'Search Order',
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
                              Get.off(() => OrderNowSearchResultScreen());
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
                                  Get.off(() => OrderNowSearchResultScreen());
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
            Obx(() => controller.isCheck == true
                ? SizedBox(
                    height: height * 0.8,
                    child: Obx(
                      () => ListView.builder(
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              if (controller.isMain) {
                                controller.submitQuerySearch(
                                    controller.suggestString[index], context);
                                controller.getListQuery(
                                    controller.suggestString[index]);
                                controller.textEditing.text =
                                    controller.suggestString[index];
                                controller.getFalseIsMain();
                                Get.off(() => OrderNowSearchResultScreen());
                              } else {
                                controller.submitQuerySearch(
                                    controller.suggestString[index], context);
                                controller.getListQuery(
                                    controller.suggestString[index]);
                                controller.textEditing.text =
                                    controller.suggestString[index];

                                Get.back();
                              }
                            },
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: Text(
                                    controller.suggestString[index],
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
                        itemCount: controller.suggestString.length,
                      ),
                    ))
                : SizedBox(
                    height: height * 0.8,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (controller.isMain) {
                              controller.submitQuerySearch(
                                  controller.historySearch[index], context);
                              controller.getListQuery(
                                  controller.historySearch[index]);
                              controller.changeStatusEmpty();
                              controller.textEditing.text =
                                  controller.historySearch[index];
                              controller.getFalseIsMain();
                              Get.off(() => OrderNowSearchResultScreen());
                            } else {
                              controller.submitQuerySearch(
                                  controller.historySearch[index], context);

                              controller.changeStatusEmpty();
                              controller.textEditing.text =
                                  controller.historySearch[index];
                              Get.back();
                              controller.getListQuery(
                                  controller.historySearch[index]);
                            }
                          },
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: Text(
                                  controller.historySearch[index],
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
                      itemCount: controller.historySearch.length,
                    ),
                  ))
          ],
        ),
      ),
    );
  }
}
