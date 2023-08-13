import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/screen/Search_Screen/partner/search_history_partner_product_screen.dart';
import 'package:new_ap/screen/partner_screen/controller/history_order_controller.dart';
import 'package:new_ap/screen/partner_screen/view/pages/order_completed_detail_screen.dart';

import '../../../../config/app_dimens.dart';
import '../../../../config/app_font.dart';

// ignore: must_be_immutable
class OrdersHistoryScreen extends StatelessWidget {
  OrdersHistoryScreen({super.key});
  HistoryController controller = Get.find<HistoryController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.colorWhite,
      appBar: AppBar(
        title: const Text(
          'Lịch sử vận đơn',
          style: TextStyle(
              fontSize: AppDimens.dimens_24,
              fontWeight: FontWeight.bold,
              color: ColorConstants.colorBlack),
        ),
        backgroundColor: ColorConstants.colorWhite,
        automaticallyImplyLeading: false,
        elevation: AppDimens.dimens_0,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: ColorConstants.themeColor,
            )),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => HisotryOrderPartnerSearchScreen());
              },
              iconSize: AppDimens.dimens_35,
              icon: const Icon(
                Icons.search,
                color: ColorConstants.themeColor,
              ))
        ],
      ),
      body: ListView.builder(
        itemCount: controller.order.length,
        itemBuilder: (contex, index) {
          return GestureDetector(
            onTap: () {
              Get.to(() => OrderCompletedDetailScreen(index));
            },
            child: Container(
              height: AppDimens.dimens_175,
              width: double.infinity,
              margin: const EdgeInsets.all(AppDimens.dimens_20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimens.dimens_15),
                  color: ColorConstants.colorGrey1),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.dimens_20,
                        vertical: AppDimens.dimens_10),
                    child: Row(
                      children: <Widget>[
                        const Icon(
                          size: AppDimens.dimens_25,
                          Icons.store,
                          color: ColorConstants.themeColor,
                        ),
                        const SizedBox(
                          width: AppDimens.dimens_5,
                        ),
                        Text(
                          controller.order[index].kitchenName,
                          style: const TextStyle(
                              fontSize: AppDimens.dimens_25,
                              fontWeight: AppFont.semiBold),
                        ),
                        const Expanded(child: SizedBox()),
                        Text(
                          controller.order[index].status,
                          style: const TextStyle(
                              fontSize: AppDimens.dimens_20,
                              fontWeight: AppFont.light,
                              color: ColorConstants.themeColor),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(AppDimens.dimens_10),
                        child: SizedBox(
                          height: AppDimens.dimens_100,
                          width: AppDimens.dimens_100,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(AppDimens.dimens_15),
                            child: Image.network(
                              controller.order[index].url[0],
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: AppDimens.dimens_5),
                              child: Text(
                                '${controller.order[index].name[0][0].toUpperCase()}${controller.order[index].name[0].substring(1)} ',
                                style: const TextStyle(
                                    fontSize: AppDimens.dimens_20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                                '${controller.order[index].productId.length} items',
                                style: const TextStyle(
                                  fontSize: AppDimens.dimens_20,
                                )),
                            Container(
                              padding: const EdgeInsets.only(
                                  top: AppDimens.dimens_5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    '${controller.getNewPrice(controller.order[index].price)}VNĐ',
                                    style: const TextStyle(
                                        fontSize: AppDimens.dimens_15,
                                        color: ColorConstants.themeColor),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(
                                        AppDimens.dimens_5),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(
                                            AppDimens.dimens_5)),
                                    child: Text(
                                      controller.order[index].statusDelivery,
                                      style: const TextStyle(
                                          fontSize: AppDimens.dimens_15,
                                          color: ColorConstants.colorWhite),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
