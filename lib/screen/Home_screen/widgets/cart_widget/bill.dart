import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/screen/Home_screen/controllers/cart_controller.dart';

import '../../../../config/app_dimens.dart';
import '../../View/pages/promo_screen.dart';

// ignore: must_be_immutable
class BillCart extends StatelessWidget {
  BillCart(this.height, this.width, {super.key});
  final double height;
  final double width;
  CartController controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Obx(
          () => Container(
              margin: const EdgeInsets.symmetric(
                  vertical: AppDimens.dimens_10,
                  horizontal: AppDimens.dimens_20),
              height: AppDimens.dimens_50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade100),
                  onPressed: () {
                    if (controller.cartOrder.isEmpty) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Hãy chọn sảm phẩm'),
                        duration: Duration(seconds: 1),
                      ));
                    } else {
                      Get.to(() => PromoScreen());
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('Add Promo code',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: AppDimens.dimens_20,
                              fontWeight: FontWeight.w700)),
                      if (controller.checkPromo.value == true)
                        SizedBox(
                          height: height * 0.1 - 10 * 4,
                          width: height * 0.1 - 10 * 4,
                          child: Image.asset('assets/image/promocode.png'),
                        ),
                      if (controller.checkShipping.value == true)
                        SizedBox(
                          height: height * 0.1 - 10 * 4,
                          width: height * 0.1 - 10 * 4,
                          child: Image.asset('assets/image/freeship.png'),
                        ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).primaryColor,
                      )
                    ],
                  ))),
        ),
        Card(
          elevation: AppDimens.dimens_5,
          margin: const EdgeInsets.symmetric(
              horizontal: AppDimens.dimens_20, vertical: AppDimens.dimens_10),
          color: Colors.grey[100],
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
                      Obx(() => Text('${controller.count} VNĐ',
                          style: const TextStyle(
                            fontSize: AppDimens.dimens_18,
                          )))
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
                      Obx(
                        () => Text('${controller.ship} VNĐ',
                            style: const TextStyle(
                              fontSize: AppDimens.dimens_18,
                            )),
                      ),
                      Obx(() => controller.reduceShip.value == 0
                          ? const Text('0',
                              style: TextStyle(
                                fontSize: AppDimens.dimens_18,
                              ))
                          : Text('-${controller.reduceShip} VNĐ',
                              style: const TextStyle(
                                fontSize: AppDimens.dimens_18,
                              )))
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
                      Obx(() => Text('${controller.reduce}',
                          style: const TextStyle(
                            fontSize: AppDimens.dimens_18,
                          )))
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
                        'Số tiền thanh t oán:',
                        style: TextStyle(
                            fontSize: AppDimens.dimens_20,
                            fontWeight: FontWeight.w700),
                      ),
                      Obx(() => Text(
                          '${controller.count.value + controller.ship.value - controller.reduce.toInt() - controller.reduceShip.value} VNĐ',
                          style: const TextStyle(
                              fontSize: AppDimens.dimens_20,
                              fontWeight: FontWeight.w700)))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
