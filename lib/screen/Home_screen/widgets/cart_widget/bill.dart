import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/screen/Home_screen/controllers/cart_controller.dart';

import '../../View/promo_screen.dart';

class BillCart extends StatelessWidget {
  BillCart(this.height, {super.key});
  final double height;
  CartController controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Obx(
          () => Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              height: height * 0.1 - 10 * 2,
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
                              fontSize: 20,
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
          elevation: 5,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          color: Colors.grey[100],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: SizedBox(
            height: height * 0.25,
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'Tổng giá trị:',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      Obx(() => Text('${controller.count} VNĐ',
                          style: const TextStyle(
                            fontSize: 18,
                          )))
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'Tiền ship',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      controller.cartOrder.isEmpty
                          ? const Text('0',
                              style: TextStyle(
                                fontSize: 18,
                              ))
                          : Text('${controller.ship} VNĐ',
                              style: const TextStyle(
                                fontSize: 18,
                              )),
                      Obx(() => controller.reduceShip.value == 0
                          ? const Text('0',
                              style: TextStyle(
                                fontSize: 18,
                              ))
                          : Text('-${controller.reduceShip} VNĐ',
                              style: const TextStyle(
                                fontSize: 18,
                              )))
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'Giảm giá:',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      Obx(() => Text('${controller.reduce}',
                          style: const TextStyle(
                            fontSize: 18,
                          )))
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'Số tiền thanh toán:',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      Obx(() => controller.cartOrder.isEmpty
                          ? const Text('0',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700))
                          : Text(
                              '${controller.count.value + controller.ship - controller.reduce.toInt() - controller.reduceShip.value} VNĐ',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700)))
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
