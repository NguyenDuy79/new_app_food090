import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/model/orders_model.dart';
import 'package:new_ap/screen/Home_screen/controllers/orders_controller.dart';

import '../../../../config/app_dimens.dart';

// ignore: must_be_immutable
class OrderDoneDetail extends StatelessWidget {
  OrderDoneDetail(this.orderDetail, {super.key});
  final OrderModel orderDetail;
  OrderController controller = Get.find<OrderController>();
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
        backgroundColor: ColorConstants.colorWhite,
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
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.dimens_10,
                            vertical: AppDimens.dimens_5),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text(
                                'ID:',
                                style: TextStyle(
                                    fontSize: AppDimens.dimens_20,
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstants.colorBlack),
                              ),
                              Flexible(
                                child: FittedBox(
                                    child: Text(orderDetail.id,
                                        style: const TextStyle(
                                          fontSize: AppDimens.dimens_20,
                                          fontWeight: FontWeight.bold,
                                          color: ColorConstants.colorBlack,
                                        ))),
                              )
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.dimens_10,
                            vertical: AppDimens.dimens_5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'Thời gian tạo:',
                              style: TextStyle(fontSize: AppDimens.dimens_20),
                            ),
                            Flexible(
                              child: FittedBox(
                                child: Text(
                                  '${orderDetail.id.split(':')[0]}:${orderDetail.id.split(':')[1]}',
                                  style: const TextStyle(
                                      fontSize: AppDimens.dimens_20),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.dimens_10,
                            vertical: AppDimens.dimens_5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'Hoàn thành:',
                              style: TextStyle(fontSize: AppDimens.dimens_20),
                            ),
                            Flexible(
                              child: FittedBox(
                                child: Text(
                                  '${orderDetail.timeFour.split(':')[0]}:${orderDetail.timeFour.split(':')[1]}',
                                  style: const TextStyle(
                                      fontSize: AppDimens.dimens_20),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: orderDetail.productId.length * AppDimens.dimens_130,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orderDetail.productId.length,
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
                                    orderDetail.url[index],
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
                                        orderDetail.name[index],
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: AppDimens.dimens_26,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      FittedBox(
                                        child: Text(
                                            '${orderDetail.productPrice[index]}VNĐ',
                                            style: const TextStyle(
                                                fontSize: AppDimens.dimens_18,
                                                color:
                                                    ColorConstants.themeColor)),
                                      ),
                                      FittedBox(
                                        child: Text(
                                            'Số lượng :${orderDetail.quantity[index]}',
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
                                '${controller.getprice(orderDetail.productPrice, orderDetail.quantity)} VNĐ',
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
                            Text('${orderDetail.ship} VNĐ',
                                style: const TextStyle(
                                  fontSize: AppDimens.dimens_18,
                                )),
                            Text('-${orderDetail.reduceShip} VNĐ',
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
                            orderDetail.reduce == '0.0'
                                ? const Text(
                                    '0 VNĐ',
                                    style: TextStyle(
                                        fontSize: AppDimens.dimens_18),
                                  )
                                : Text('${orderDetail.reduce}VNĐ',
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
                            Text('${orderDetail.price} VNĐ',
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: AppDimens.dimens_50,
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.dimens_20, vertical: AppDimens.dimens_5),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: AppDimens.dimens_5,
                backgroundColor: ColorConstants.themeColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.dimens_8))),
            onPressed: () {},
            child: const Text(
              'Mua Lại',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppDimens.dimens_25,
                  color: ColorConstants.colorBlack),
            )),
      ),
    );
  }
}
