import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/model/promo_model.dart';
import '../controllers/cart_controller.dart';

class PromoScreen extends StatelessWidget {
  PromoScreen({super.key});
  CartController controller = Get.find<CartController>();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            controller.extend = false;
            controller.selectPromoCode = PromoCode(
                id: '',
                applyPrice: 0,
                maximum: 0,
                reducePercent: 0,
                reduceNumber: 0);
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: const Text('Choose Voucher'),
      ),
      body: GetBuilder<CartController>(
        init: Get.find<CartController>(),
        builder: (controller) => SingleChildScrollView(
          child: Column(children: <Widget>[
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Ưu đãi phí vận chuyển',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Có thể chọn một',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ),
                  // Shipping promo code
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      height: controller.extend
                          ? (height * 0.105 + 16) *
                              controller.shippingPromoCode.length
                          : (height * 0.105 + 16) * 2,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.shippingPromoCode.length,
                        itemBuilder: (context, index) => Card(
                          child: CheckboxListTile(
                            value: controller.selectIndexShipping == index,
                            onChanged: (value) {
                              if (controller.selectIndexShipping == index) {
                                controller.unChooseShippingPromo();
                              } else {
                                controller.chooseShippingPromo(index);
                              }
                            },
                            title: Row(children: <Widget>[
                              SizedBox(
                                height: height * 0.105,
                                width: height * 0.105,
                                child: Image.asset('assets/image/freeship.png',
                                    fit: BoxFit.fitWidth),
                              ),
                              SizedBox(
                                width: width * 0.04,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  controller.shippingPromoCode[index].maximum ==
                                          0
                                      ? const Text('Miễn phí vận chuyển ',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold))
                                      : Text(
                                          'Giảm tối đa ${controller.getNewString(controller.shippingPromoCode[index].maximum.toString())}K',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                  controller.shippingPromoCode[index]
                                              .applyPrice ==
                                          0
                                      ? const Text(
                                          'Áp dụng từ đơn hàng 0Đ',
                                          style: TextStyle(fontSize: 15),
                                        )
                                      : Text(
                                          'Áp dụng từ đơn hàng ${controller.getNewString(controller.shippingPromoCode[index].applyPrice.toString())}K',
                                          style: const TextStyle(fontSize: 15))
                                ],
                              )
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: height * 0.05,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0, backgroundColor: Colors.white),
                      onPressed: () {
                        controller.extend = !controller.extend;
                        controller.update();
                      },
                      child: controller.extend
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Thu gọn',
                                  style: TextStyle(color: Colors.black),
                                ),
                                Icon(
                                  Icons.arrow_drop_up,
                                  color: Colors.black,
                                )
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Xem thêm',
                                  style: TextStyle(color: Colors.black),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                )
                              ],
                            ),
                    ),
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Ưu đãi giảm giá/hoàn xu',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Có thể chọn một',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ),
                // Promocode
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    height: (height * 0.105 + 20) * controller.promoCode.length,
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.promoCode.length,
                        itemBuilder: (context, index) => Card(
                              child: CheckboxListTile(
                                title: Row(
                                  children: [
                                    SizedBox(
                                      height: height * 0.105,
                                      width: height * 0.105,
                                      child: Image.asset(
                                          'assets/image/promocode.png',
                                          fit: BoxFit.cover),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        if (controller.promoCode[index]
                                                .reducePercent !=
                                            0)
                                          Text(
                                            'Giảm: ${controller.promoCode[index].reducePercent}%',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        if (controller.promoCode[index]
                                                .reduceNumber !=
                                            0)
                                          Text(
                                            'Giảm: ${controller.getNewString(controller.promoCode[index].reduceNumber.toString())}K',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        if (controller
                                                .promoCode[index].applyPrice !=
                                            0)
                                          Text(
                                            'Đơn tối thiểu ${controller.getNewString(controller.promoCode[index].applyPrice.toString())}K',
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                        if (controller
                                                .promoCode[index].applyPrice ==
                                            0)
                                          const Text('Đơn tối thiểu 0Đ',
                                              style: TextStyle(fontSize: 15)),
                                        if (controller
                                                .promoCode[index].maximum !=
                                            0)
                                          Text(
                                              'Giảm tối đa ${controller.getNewString(controller.promoCode[index].maximum.toString())}K',
                                              style:
                                                  const TextStyle(fontSize: 15))
                                      ],
                                    )
                                  ],
                                ),
                                onChanged: (value) {
                                  if (controller.selectIndexPromo == index) {
                                    controller.unChoosePromoCode();
                                  } else {
                                    controller.choosePromoCode(index);
                                  }
                                },
                                value: controller.selectIndexPromo == index,
                              ),
                            )),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
      bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          height: height * 0.08,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              onPressed: () {
                controller.getApplyPromoCode();
                controller.getApplyShipping();

                Get.back();
              },
              child: const Text('Đồng ý',
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)))),
    );
  }
}
