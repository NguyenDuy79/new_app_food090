import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/screen/partner_screen/controller/history_order_controller.dart';

import '../../../config/app_dimens.dart';

// ignore: must_be_immutable
class OrderCompletedDetailScreen extends StatelessWidget {
  OrderCompletedDetailScreen(this.index, {super.key});
  final int index;
  HistoryController controller = Get.find<HistoryController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đơn hàng đã hoàn thành',
          style: TextStyle(
              fontSize: AppDimens.dimens_24,
              fontWeight: FontWeight.bold,
              color: ColorConstants.colorBlack),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: AppDimens.dimens_20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.dimens_20,
                    vertical: AppDimens.dimens_10),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.dimens_10)),
                  color: ColorConstants.colorGrey1,
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimens.dimens_10),
                    child: FittedBox(
                      child: Text(
                        'ID:${controller.order[index].id}',
                        style: const TextStyle(
                            fontSize: AppDimens.dimens_20,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.colorBlack),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: controller.order[index].productId.length *
                    AppDimens.dimens_130,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.order[index].productId.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.dimens_20,
                          vertical: AppDimens.dimens_10),
                      child: Card(
                        elevation: AppDimens.dimens_5,
                        color: ColorConstants.colorGrey1,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppDimens.dimens_10)),
                        child: SizedBox(
                          width: double.infinity,
                          height: AppDimens.dimens_90,
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                height: AppDimens.dimens_90,
                                width: AppDimens.dimens_120,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      AppDimens.dimens_10),
                                  child: Image.network(
                                    controller.order[index].url[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: AppDimens.dimens_10,
                                      vertical: AppDimens.dimens_5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        controller.order[index].name[index],
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: AppDimens.dimens_26,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      FittedBox(
                                        child: Text(
                                            '${controller.order[index].productPrice[index]}VNĐ',
                                            style: const TextStyle(
                                                fontSize: AppDimens.dimens_18,
                                                color:
                                                    ColorConstants.themeColor)),
                                      ),
                                      FittedBox(
                                        child: Text(
                                            'Số lượng :${controller.order[index].quantity[index]}',
                                            style: const TextStyle(
                                                fontSize: AppDimens.dimens_18,
                                                fontWeight: FontWeight.bold)),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Card(
                elevation: AppDimens.dimens_5,
                margin: const EdgeInsets.symmetric(
                    horizontal: AppDimens.dimens_20,
                    vertical: AppDimens.dimens_10),
                color: ColorConstants.colorGrey1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.dimens_15)),
                child: SizedBox(
                  height: AppDimens.dimens_190,
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: AppDimens.dimens_10,
                            horizontal: AppDimens.dimens_15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'Tổng giá trị:',
                              style: TextStyle(
                                  fontSize: AppDimens.dimens_20,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                                '${controller.getprice(controller.order[index].productPrice, controller.order[index].quantity)} VNĐ',
                                style: const TextStyle(
                                  fontSize: AppDimens.dimens_18,
                                ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: AppDimens.dimens_10,
                            horizontal: AppDimens.dimens_15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'Tiền ship',
                              style: TextStyle(
                                  fontSize: AppDimens.dimens_20,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text('${controller.order[index].ship} VNĐ',
                                style: const TextStyle(
                                  fontSize: AppDimens.dimens_18,
                                )),
                            Text('-${controller.order[index].reduceShip} VNĐ',
                                style: const TextStyle(
                                  fontSize: AppDimens.dimens_18,
                                ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: AppDimens.dimens_10,
                            horizontal: AppDimens.dimens_15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'Giảm giá:',
                              style: TextStyle(
                                  fontSize: AppDimens.dimens_20,
                                  fontWeight: FontWeight.w700),
                            ),
                            controller.order[index].reduce == '0.0'
                                ? const Text(
                                    '0 VNĐ',
                                    style: TextStyle(
                                        fontSize: AppDimens.dimens_18),
                                  )
                                : Text('${controller.order[index].reduce}VNĐ',
                                    style: const TextStyle(
                                      fontSize: AppDimens.dimens_18,
                                    ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: AppDimens.dimens_10,
                            horizontal: AppDimens.dimens_15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'Số tiền thanh toán:',
                              style: TextStyle(
                                  fontSize: AppDimens.dimens_20,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text('${controller.order[index].price} VNĐ',
                                style: const TextStyle(
                                    fontSize: AppDimens.dimens_20,
                                    fontWeight: FontWeight.w700))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppDimens.dimens_20,
                    vertical: AppDimens.dimens_20),
                child: Text(
                  'Progress',
                  style: TextStyle(
                      fontSize: AppDimens.dimens_24,
                      fontWeight: FontWeight.bold),
                ),
              ),
              controller.getWidget(context, 1, Icons.note_alt_outlined,
                  controller.order[index].timeOne, index),
              controller.getWidget(context, 2, Icons.soup_kitchen_outlined,
                  controller.order[index].timeTwo, index),
              controller.getWidget(context, 3, Icons.delivery_dining_outlined,
                  controller.order[index].timeThree, index),
              controller.getWidget(context, 4, Icons.door_back_door_outlined,
                  controller.order[index].timeFour, index)
            ],
          ),
        ),
      ),
    );
  }
}
