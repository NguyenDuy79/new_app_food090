import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/screen/partner_screen/controller/order_now_controller.dart';

import '../../../config/app_dimens.dart';

// ignore: must_be_immutable
class OrdersNowScreen extends StatelessWidget {
  OrdersNowScreen({super.key});
  OrderNowController controller = Get.find<OrderNowController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorConstants.colorWhite,
        elevation: AppDimens.dimens_5,
        title: const Text(
          'Đơn hàng có thể nhận',
          style: TextStyle(
              fontSize: AppDimens.dimens_24,
              fontWeight: FontWeight.bold,
              color: ColorConstants.colorBlack),
        ),
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
                Get.back();
              },
              icon: const Icon(
                Icons.search,
                color: ColorConstants.themeColor,
              ))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return controller.refreshIndicator();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.dimens_20, vertical: AppDimens.dimens_20),
            child: GetX<OrderNowController>(
              init: Get.find<OrderNowController>(),
              builder: (OrderNowController controller) => SizedBox(
                height: controller.order.isEmpty
                    ? 100
                    : controller.order.length * AppDimens.dimens_210,
                child: controller.order.isEmpty
                    ? const Center(
                        child: Text(
                          'Không có đơn nào có thể nhận',
                          style: TextStyle(fontSize: 30),
                        ),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.order.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: AppDimens.dimens_4,
                            color: ColorConstants.colorGrey1,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppDimens.dimens_10)),
                            child: SizedBox(
                              width: double.infinity,
                              height: AppDimens.dimens_175,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        SizedBox(
                                          height: AppDimens.dimens_120,
                                          width: AppDimens.dimens_150,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                AppDimens.dimens_10),
                                            child: Image.network(
                                              controller.order[index].url[0],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              FittedBox(
                                                child: Text(
                                                  controller
                                                      .order[index].kitchenName,
                                                  style: const TextStyle(
                                                      fontSize:
                                                          AppDimens.dimens_25,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: AppDimens.dimens_18,
                                              ),
                                              FittedBox(
                                                child: Text(
                                                  '${controller.order[index].productId.length} items',
                                                  style: const TextStyle(
                                                      fontSize:
                                                          AppDimens.dimens_22),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: AppDimens.dimens_5,
                                              ),
                                              FittedBox(
                                                child: Text(
                                                    '${controller.order[index].price}VNĐ',
                                                    style: const TextStyle(
                                                        fontSize:
                                                            AppDimens.dimens_16,
                                                        color: ColorConstants
                                                            .themeColor)),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    const Divider(
                                      height: AppDimens.dimens_5,
                                      thickness: AppDimens.dimens_0,
                                    ),
                                    Container(
                                      height: AppDimens.dimens_50,
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: AppDimens.dimens_10,
                                          horizontal: AppDimens.dimens_40),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  ColorConstants.themeColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          AppDimens
                                                              .dimens_15))),
                                          onPressed: () {
                                            if (controller
                                                .orderActive.isEmpty) {
                                              controller.chooseOrder(
                                                  controller.order[index],
                                                  context);
                                            } else {
                                              controller.getDialog(context);
                                            }
                                          },
                                          child: const Text(
                                            'Nhận đơn',
                                            style: TextStyle(
                                                fontSize: AppDimens.dimens_20,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    ColorConstants.colorBlack),
                                          )),
                                    ),
                                  ]),
                            ),
                          );
                        }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
