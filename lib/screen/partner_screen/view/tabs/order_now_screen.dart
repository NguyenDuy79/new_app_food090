import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/config/app_storage_path.dart';
import 'package:new_ap/screen/Search_Screen/partner/search_order_now_screen.dart';
import 'package:new_ap/screen/partner_screen/controller/order_now_controller.dart';

import '../../../../config/app_dimens.dart';
import '../../../../config/app_font.dart';

// ignore: must_be_immutable
class OrdersNowScreen extends StatelessWidget {
  OrdersNowScreen({super.key});
  OrderNowController controller = Get.find<OrderNowController>();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ColorConstants.colorWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorConstants.colorWhite,
        title: const Text(
          'Đơn hàng có thể nhận',
          style: TextStyle(
              fontSize: AppDimens.dimens_24,
              fontWeight: FontWeight.bold,
              color: ColorConstants.colorBlack),
        ),
        centerTitle: true,
        elevation: AppDimens.dimens_0,
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
                Get.to(() => SearchOrderNowScreen());
              },
              iconSize: AppDimens.dimens_35,
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
                    ? height * 0.5
                    : controller.order.length * AppDimens.dimens_235,
                child: controller.order.isEmpty
                    ? Center(child: Image.asset(AppStoragePath.empty))
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
                              height: AppDimens.dimens_225,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.only(
                                          right: AppDimens.dimens_20,
                                          top: AppDimens.dimens_5,
                                          bottom: AppDimens.dimens_5,
                                          left: AppDimens.dimens_5),
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
                                          const Text(
                                            'Cách ... km',
                                            style: TextStyle(
                                                fontSize: AppDimens.dimens_20,
                                                fontWeight: AppFont.light,
                                                color:
                                                    ColorConstants.themeColor),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: AppDimens.dimens_10,
                                          right: AppDimens.dimens_10),
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(
                                            height: AppDimens.dimens_120,
                                            width: AppDimens.dimens_150,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppDimens.dimens_15),
                                              child: Image.network(
                                                controller.order[index].url[0],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: AppDimens.dimens_5),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  FittedBox(
                                                    child: Text(
                                                      controller.order[index]
                                                          .kitchenName,
                                                      style: const TextStyle(
                                                          fontSize: AppDimens
                                                              .dimens_25,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: AppDimens.dimens_5,
                                                  ),
                                                  FittedBox(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          '${controller.order[index].productId.length} items',
                                                          style: const TextStyle(
                                                              fontSize: AppDimens
                                                                  .dimens_22),
                                                        ),
                                                        const SizedBox(
                                                          width: AppDimens
                                                              .dimens_20,
                                                        ),
                                                        Text(
                                                            '${controller.order[index].price}VNĐ',
                                                            style: const TextStyle(
                                                                fontSize: AppDimens
                                                                    .dimens_22,
                                                                color: ColorConstants
                                                                    .themeColor)),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: AppDimens.dimens_5,
                                                  ),
                                                  FittedBox(
                                                      child: Text(
                                                    'Thời gian đặt: ${controller.formatTime(controller.order[index].timeStamp)} trước',
                                                    style: const TextStyle(
                                                        fontSize: AppDimens
                                                            .dimens_17),
                                                  ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
                                          onPressed: () async {
                                            if (controller
                                                .orderActive.isEmpty) {
                                              await controller.chooseOrder(
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
