import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_string.dart';
import 'package:new_ap/screen/Home_screen/controllers/orders_controller.dart';
import 'package:new_ap/screen/Search_Screen/home/search_order_screen.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_dimens.dart';
import '../../../../config/app_font.dart';
import '../../controllers/main_controller.dart';
import 'cart_screen.dart';
import 'order_done_detail.dart';

class OrderSearchResultScreen extends StatelessWidget {
  OrderSearchResultScreen({super.key});
  final OrderController controller = Get.find<OrderController>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.textEditing.clear();
        controller.changeStatusEmpty();
        controller.getListQuery('');
        controller.getTrueIsMain();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ColorConstants.colorWhite,
          body: Obx(() => Column(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(
                          top: AppDimens.dimens_30,
                          left: AppDimens.dimens_5,
                          right: AppDimens.dimens_25),
                      child: SizedBox(
                          height: AppDimens.dimens_40,
                          child: Row(
                            children: [
                              IconButton(
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () {
                                    controller.textEditing.clear();
                                    controller.changeStatusEmpty();
                                    controller.getListQuery('');
                                    controller.getTrueIsMain();
                                    Get.back();
                                  },
                                  iconSize: AppDimens.dimens_30,
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: ColorConstants.themeColor,
                                  )),
                              Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor:
                                            ColorConstants.colorGrey2,
                                      ),
                                      onPressed: () {
                                        controller.changeStatusEmpty();
                                        controller.getSuggest(
                                            controller.textEditing.text);
                                        Get.to(() => SearchOrderScreen());
                                      },
                                      child: SizedBox(
                                          height: 40,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              const Icon(
                                                Icons.search,
                                                size: 35,
                                                color:
                                                    ColorConstants.colorGrey4,
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              controller.textEditing.text == ''
                                                  ? const Text('Search Product',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              AppFont.medium,
                                                          color: ColorConstants
                                                              .colorGrey4))
                                                  : Text(
                                                      controller
                                                          .textEditing.text,
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              AppFont.medium,
                                                          color: ColorConstants
                                                              .colorBlack),
                                                    )
                                            ],
                                          )))),
                            ],
                          ))),
                  controller.reload == true
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.only(top: AppDimens.dimens_20),
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                if (controller.orderSearch[index].status ==
                                    AppString.statusActive) {
                                  return Container(
                                    height: controller
                                                .getActiveOrder()[index]
                                                .statusDelivery ==
                                            'Giao hàng thành công'
                                        ? AppDimens.dimens_200
                                        : AppDimens.dimens_160,
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(
                                        top: AppDimens.dimens_20,
                                        right: AppDimens.dimens_20,
                                        left: AppDimens.dimens_20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            AppDimens.dimens_15),
                                        color: ColorConstants.colorGrey2),
                                    child: Column(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {},
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal:
                                                            AppDimens.dimens_20,
                                                        vertical: AppDimens
                                                            .dimens_10),
                                                child: Row(
                                                  children: <Widget>[
                                                    const Icon(
                                                      size: AppDimens.dimens_25,
                                                      Icons.store,
                                                      color: ColorConstants
                                                          .themeColor,
                                                    ),
                                                    const SizedBox(
                                                      width: AppDimens.dimens_5,
                                                    ),
                                                    Text(
                                                      controller
                                                          .orderSearch[index]
                                                          .kitchenName,
                                                      style: const TextStyle(
                                                          fontSize: AppDimens
                                                              .dimens_25,
                                                          fontWeight:
                                                              AppFont.semiBold),
                                                    ),
                                                    const Expanded(
                                                        child: SizedBox()),
                                                    Text(
                                                      controller
                                                          .orderSearch[index]
                                                          .status,
                                                      style: const TextStyle(
                                                          fontSize: AppDimens
                                                              .dimens_22,
                                                          fontWeight:
                                                              AppFont.light,
                                                          color: ColorConstants
                                                              .themeColor),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            AppDimens
                                                                .dimens_10),
                                                    child: SizedBox(
                                                      height:
                                                          AppDimens.dimens_90,
                                                      width:
                                                          AppDimens.dimens_90,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                AppDimens
                                                                    .dimens_15),
                                                        child: Image.network(
                                                          controller
                                                              .orderSearch[
                                                                  index]
                                                              .url[0],
                                                          fit: BoxFit.fitHeight,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              AppDimens
                                                                  .dimens_10),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding: const EdgeInsets
                                                                    .only(
                                                                bottom: AppDimens
                                                                    .dimens_5),
                                                            child: Text(
                                                              '${controller.orderSearch[index].name[0][0].toUpperCase()}${controller.orderSearch[index].name[0].substring(1)} ',
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                      AppDimens
                                                                          .dimens_20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          Text(
                                                              '${controller.orderSearch[index].productId.length} items',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: AppDimens
                                                                    .dimens_20,
                                                              )),
                                                          Container(
                                                            padding: const EdgeInsets
                                                                    .only(
                                                                top: AppDimens
                                                                    .dimens_5),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  '${controller.getNewPrice(controller.orderSearch[index].price)}VNĐ',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          AppDimens
                                                                              .dimens_15,
                                                                      color: ColorConstants
                                                                          .themeColor),
                                                                ),
                                                                const SizedBox(
                                                                  width: AppDimens
                                                                      .dimens_15,
                                                                ),
                                                                Flexible(
                                                                  child:
                                                                      Container(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        AppDimens
                                                                            .dimens_5),
                                                                    decoration: BoxDecoration(
                                                                        color: ColorConstants
                                                                            .themeColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(AppDimens.dimens_5)),
                                                                    child:
                                                                        FittedBox(
                                                                      child:
                                                                          Text(
                                                                        controller
                                                                            .orderSearch[index]
                                                                            .statusDelivery,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                AppDimens.dimens_15,
                                                                            color: ColorConstants.colorWhite),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (controller.orderSearch[index]
                                                .statusDelivery ==
                                            'Giao hàng thành công')
                                          const Divider(
                                            height: AppDimens.dimens_1,
                                            thickness: AppDimens.dimens_0,
                                          ),
                                        if (controller.orderSearch[index]
                                                .statusDelivery ==
                                            'Giao hàng thành công')
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal:
                                                    AppDimens.dimens_20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  'Đã thanh toán ${controller.getNewPrice(controller.orderSearch[index].price)}VNĐ',
                                                  style: const TextStyle(
                                                      fontSize:
                                                          AppDimens.dimens_15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            ColorConstants
                                                                .themeColor,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius
                                                                .circular(AppDimens
                                                                    .dimens_5))),
                                                    onPressed: () {
                                                      controller
                                                          .setStateShipDelivery(
                                                              controller
                                                                  .orderSearch[
                                                                      index]
                                                                  .id);
                                                    },
                                                    child:
                                                        const Text('Xác nhận')),
                                              ],
                                            ),
                                          )
                                      ],
                                    ),
                                  );
                                }
                                if (controller.orderSearch[index].status ==
                                    AppString.statusCompleted) {
                                  return Container(
                                    height: AppDimens.dimens_210,
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(
                                        top: AppDimens.dimens_20,
                                        left: AppDimens.dimens_20,
                                        right: AppDimens.dimens_20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            AppDimens.dimens_15),
                                        color: ColorConstants.colorGrey2),
                                    child: Column(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            int value = controller
                                                .getCompletedOrder()
                                                .indexWhere((element) =>
                                                    element.id ==
                                                    controller
                                                        .orderSearch[index].id);
                                            Get.to(() => OrderDoneDetail(
                                                controller
                                                    .getCompletedOrder()[value],
                                                controller.imageUrl[value]));
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal:
                                                            AppDimens.dimens_20,
                                                        vertical: AppDimens
                                                            .dimens_10),
                                                child: Row(
                                                  children: <Widget>[
                                                    const Icon(
                                                      size: AppDimens.dimens_25,
                                                      Icons.store,
                                                      color: ColorConstants
                                                          .themeColor,
                                                    ),
                                                    const SizedBox(
                                                      width: AppDimens.dimens_5,
                                                    ),
                                                    Text(
                                                      controller
                                                          .orderSearch[index]
                                                          .kitchenName,
                                                      style: const TextStyle(
                                                          fontSize: AppDimens
                                                              .dimens_25,
                                                          fontWeight:
                                                              AppFont.semiBold),
                                                    ),
                                                    const Expanded(
                                                        child: SizedBox()),
                                                    Text(
                                                      controller
                                                          .orderSearch[index]
                                                          .status,
                                                      style: const TextStyle(
                                                          fontSize: AppDimens
                                                              .dimens_22,
                                                          fontWeight:
                                                              AppFont.light,
                                                          color: ColorConstants
                                                              .themeColor),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            AppDimens
                                                                .dimens_10),
                                                    child: SizedBox(
                                                      height:
                                                          AppDimens.dimens_90,
                                                      width:
                                                          AppDimens.dimens_90,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                AppDimens
                                                                    .dimens_15),
                                                        child: Image.network(
                                                          controller
                                                              .orderSearch[
                                                                  index]
                                                              .url[0],
                                                          fit: BoxFit.fitHeight,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: AppDimens
                                                                  .dimens_10,
                                                              top: AppDimens
                                                                  .dimens_10,
                                                              right: AppDimens
                                                                  .dimens_10),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding: const EdgeInsets
                                                                    .only(
                                                                bottom: AppDimens
                                                                    .dimens_5),
                                                            child: Text(
                                                              '${controller.orderSearch[index].name[0][0].toUpperCase()}${controller.orderSearch[index].name[0].substring(1)} ',
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                      AppDimens
                                                                          .dimens_20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          Text(
                                                              '${controller.orderSearch[index].productId.length} items',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: AppDimens
                                                                    .dimens_20,
                                                              )),
                                                          Container(
                                                            padding: const EdgeInsets
                                                                    .only(
                                                                top: AppDimens
                                                                    .dimens_5),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  '${controller.getNewPrice(controller.orderSearch[index].price)}VNĐ',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          AppDimens
                                                                              .dimens_15,
                                                                      color: ColorConstants
                                                                          .themeColor),
                                                                ),
                                                                Container(
                                                                  padding: const EdgeInsets
                                                                          .all(
                                                                      AppDimens
                                                                          .dimens_5),
                                                                  decoration: BoxDecoration(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              AppDimens.dimens_5)),
                                                                  child: Text(
                                                                    controller
                                                                        .orderSearch[
                                                                            index]
                                                                        .status,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            AppDimens
                                                                                .dimens_15,
                                                                        color: ColorConstants
                                                                            .colorWhite),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(
                                          indent: AppDimens.dimens_20,
                                          endIndent: AppDimens.dimens_20,
                                          thickness: AppDimens.dimens_2,
                                          height: AppDimens.dimens_0,
                                        ),
                                        Container(
                                          height: AppDimens.dimens_50,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: AppDimens.dimens_20,
                                              vertical: AppDimens.dimens_10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              SizedBox(
                                                height: AppDimens.dimens_35,
                                                width: AppDimens.dimens_150,
                                                child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                            side: const BorderSide(
                                                                width: AppDimens
                                                                    .dimens_2,
                                                                color: ColorConstants
                                                                    .themeColor),
                                                            borderRadius: BorderRadius
                                                                .circular(AppDimens
                                                                    .dimens_15)),
                                                        backgroundColor:
                                                            ColorConstants
                                                                .colorWhite),
                                                    onPressed: () {
                                                      controller
                                                          .setStateShipDelivery(
                                                              controller
                                                                  .orderSearch[
                                                                      index]
                                                                  .id);
                                                    },
                                                    child: const Text(
                                                      'Đánh giá',
                                                      style: TextStyle(
                                                          fontSize: AppDimens
                                                              .dimens_16,
                                                          color: ColorConstants
                                                              .themeColor),
                                                    )),
                                              ),
                                              SizedBox(
                                                height: AppDimens.dimens_30,
                                                width: AppDimens.dimens_150,
                                                child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius
                                                                .circular(AppDimens
                                                                    .dimens_15)),
                                                        backgroundColor:
                                                            Theme.of(context)
                                                                .primaryColor),
                                                    onPressed: () async {
                                                      int value = controller
                                                          .getCompletedOrder()
                                                          .indexWhere((element) =>
                                                              element.id ==
                                                              controller
                                                                  .orderSearch[
                                                                      index]
                                                                  .id);
                                                      await controller.orderAgain(
                                                          controller
                                                                  .getCompletedOrder()[
                                                              value],
                                                          context);

                                                      Get.back();
                                                      Get.back();
                                                      Get.to(() => CartScreen(
                                                          Get.find<
                                                                  MainController>()
                                                              .kitchenModel));
                                                    },
                                                    child: const Text(
                                                      'Mua lại',
                                                      style: TextStyle(
                                                          color: ColorConstants
                                                              .colorWhite,
                                                          fontSize: AppDimens
                                                              .dimens_16),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                } else {
                                  return Container(
                                    height: AppDimens.dimens_210,
                                    width: double.infinity,
                                    margin: const EdgeInsets.all(
                                        AppDimens.dimens_20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            AppDimens.dimens_15),
                                        color: ColorConstants.colorGrey1),
                                    child: Column(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () async {
                                            var value = controller
                                                .getCancelledOrder()
                                                .indexWhere((element) =>
                                                    element.id ==
                                                    controller
                                                        .orderSearch[index].id);
                                            await controller.orderAgain(
                                                controller
                                                    .getCancelledOrder()[value],
                                                context);
                                            Get.back();
                                            Get.back();
                                            Get.to(() => CartScreen(
                                                Get.find<MainController>()
                                                    .kitchenModel));
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal:
                                                            AppDimens.dimens_20,
                                                        vertical: AppDimens
                                                            .dimens_10),
                                                child: Row(
                                                  children: <Widget>[
                                                    const Icon(
                                                      size: AppDimens.dimens_25,
                                                      Icons.store,
                                                      color: ColorConstants
                                                          .themeColor,
                                                    ),
                                                    const SizedBox(
                                                      width: AppDimens.dimens_5,
                                                    ),
                                                    Text(
                                                      controller
                                                          .orderSearch[index]
                                                          .kitchenName,
                                                      style: const TextStyle(
                                                          fontSize: AppDimens
                                                              .dimens_25,
                                                          fontWeight:
                                                              AppFont.semiBold),
                                                    ),
                                                    const Expanded(
                                                        child: SizedBox()),
                                                    Text(
                                                      controller
                                                          .orderSearch[index]
                                                          .status,
                                                      style: const TextStyle(
                                                          fontSize: AppDimens
                                                              .dimens_22,
                                                          fontWeight:
                                                              AppFont.light,
                                                          color: ColorConstants
                                                              .themeColor),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            AppDimens
                                                                .dimens_10),
                                                    child: SizedBox(
                                                      height:
                                                          AppDimens.dimens_90,
                                                      width:
                                                          AppDimens.dimens_90,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                AppDimens
                                                                    .dimens_15),
                                                        child: Image.network(
                                                          controller
                                                              .orderSearch[
                                                                  index]
                                                              .url[0],
                                                          fit: BoxFit.fitHeight,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: AppDimens
                                                                  .dimens_10,
                                                              top: AppDimens
                                                                  .dimens_10,
                                                              right: AppDimens
                                                                  .dimens_10),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding: const EdgeInsets
                                                                    .only(
                                                                bottom: AppDimens
                                                                    .dimens_5),
                                                            child: Text(
                                                              '${controller.orderSearch[index].name[0][0].toUpperCase()}${controller.orderSearch[index].name[0].substring(1)} ',
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                      AppDimens
                                                                          .dimens_20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          Text(
                                                              '${controller.orderSearch[index].productId.length} items',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: AppDimens
                                                                    .dimens_20,
                                                              )),
                                                          Container(
                                                            padding: const EdgeInsets
                                                                    .only(
                                                                top: AppDimens
                                                                    .dimens_5),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  '${controller.getNewPrice(controller.orderSearch[index].price)}VNĐ',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          AppDimens
                                                                              .dimens_15,
                                                                      color: ColorConstants
                                                                          .themeColor),
                                                                ),
                                                                Container(
                                                                  padding: const EdgeInsets
                                                                          .all(
                                                                      AppDimens
                                                                          .dimens_5),
                                                                  decoration: BoxDecoration(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              AppDimens.dimens_5)),
                                                                  child: Text(
                                                                    controller
                                                                        .orderSearch[
                                                                            index]
                                                                        .status,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            AppDimens
                                                                                .dimens_15,
                                                                        color: ColorConstants
                                                                            .colorWhite),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(
                                          indent: AppDimens.dimens_20,
                                          endIndent: AppDimens.dimens_20,
                                          thickness: 2,
                                          height: AppDimens.dimens_0,
                                        ),
                                        Container(
                                          height: AppDimens.dimens_50,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: AppDimens.dimens_20,
                                              vertical: AppDimens.dimens_10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              SizedBox(
                                                height: AppDimens.dimens_35,
                                                width: AppDimens.dimens_130,
                                                child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                            side: const BorderSide(
                                                                width: AppDimens
                                                                    .dimens_3,
                                                                color: ColorConstants
                                                                    .themeColor),
                                                            borderRadius: BorderRadius
                                                                .circular(AppDimens
                                                                    .dimens_15)),
                                                        backgroundColor:
                                                            ColorConstants
                                                                .colorWhite),
                                                    onPressed: () {},
                                                    child: const Text(
                                                      'Mua lại',
                                                      style: TextStyle(
                                                          color: ColorConstants
                                                              .themeColor),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                              },
                              itemCount: controller.orderSearch.length,
                            ),
                          ),
                        )
                ],
              )),
        ),
      ),
    );
  }
}
