import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/model/promo_model.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_dimens.dart';
import '../../controllers/cart_controller.dart';

// ignore: must_be_immutable
class PromoScreen extends StatelessWidget {
  PromoScreen({super.key});
  CartController controller = Get.find<CartController>();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.colorWhite,
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
          icon: const Icon(
            Icons.arrow_back_ios,
            color: ColorConstants.themeColor,
          ),
        ),
        title: const Text(
          'Choose Voucher',
          style: TextStyle(color: ColorConstants.colorBlack),
        ),
      ),
      body: GetBuilder<CartController>(
        init: Get.find<CartController>(),
        builder: (controller) => SingleChildScrollView(
          child: Column(children: <Widget>[
            Container(
              color: ColorConstants.colorWhite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppDimens.dimens_10),
                    child: Text(
                      'Ưu đãi phí vận chuyển',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppDimens.dimens_17),
                    ),
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppDimens.dimens_10),
                    child: Text(
                      'Có thể chọn một',
                      style: TextStyle(
                          fontSize: AppDimens.dimens_15,
                          color: ColorConstants.colorGrey4),
                    ),
                  ),
                  // Shipping promo code
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.dimens_10),
                    child: SizedBox(
                      height: controller.extend
                          ? controller.shippingPromoCode.length *
                              AppDimens.dimens_105
                          : AppDimens.dimens_105 * 2,
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
                                height: AppDimens.dimens_90,
                                width: AppDimens.dimens_90,
                                child: Image.asset('assets/image/freeship.png',
                                    fit: BoxFit.fitWidth),
                              ),
                              const SizedBox(
                                width: AppDimens.dimens_13,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  controller.shippingPromoCode[index].maximum ==
                                          0
                                      ? const FittedBox(
                                          child: Text('Miễn phí vận chuyển ',
                                              style: TextStyle(
                                                  fontSize: AppDimens.dimens_20,
                                                  fontWeight: FontWeight.bold)),
                                        )
                                      : FittedBox(
                                          child: Text(
                                              'Giảm tối đa ${controller.getNewString(controller.shippingPromoCode[index].maximum.toString())}K',
                                              style: const TextStyle(
                                                  fontSize: AppDimens.dimens_20,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                  controller.shippingPromoCode[index]
                                              .applyPrice ==
                                          0
                                      ? const FittedBox(
                                          child: Text(
                                            'Áp dụng từ đơn hàng 0Đ',
                                            style: TextStyle(
                                                fontSize: AppDimens.dimens_15),
                                          ),
                                        )
                                      : FittedBox(
                                          child: Text(
                                              'Áp dụng từ đơn hàng ${controller.getNewString(controller.shippingPromoCode[index].applyPrice.toString())}K',
                                              style: const TextStyle(
                                                  fontSize:
                                                      AppDimens.dimens_15)),
                                        )
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
                          elevation: AppDimens.dimens_0,
                          backgroundColor: ColorConstants.colorWhite),
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
                                  style: TextStyle(
                                      color: ColorConstants.colorBlack),
                                ),
                                Icon(
                                  Icons.arrow_drop_up,
                                  color: ColorConstants.colorBlack,
                                )
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Xem thêm',
                                  style: TextStyle(
                                      color: ColorConstants.colorBlack),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: ColorConstants.colorBlack,
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
                  padding:
                      EdgeInsets.symmetric(horizontal: AppDimens.dimens_10),
                  child: Text(
                    'Ưu đãi giảm giá/hoàn xu',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppDimens.dimens_17),
                  ),
                ),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: AppDimens.dimens_10),
                  child: Text(
                    'Có thể chọn một',
                    style: TextStyle(
                        fontSize: AppDimens.dimens_15,
                        color: ColorConstants.colorGrey4),
                  ),
                ),
                // Promocode
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.dimens_10),
                  child: SizedBox(
                    height: controller.promoCode.length * AppDimens.dimens_105,
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.promoCode.length,
                        itemBuilder: (context, index) => Card(
                              child: CheckboxListTile(
                                title: Row(
                                  children: [
                                    SizedBox(
                                      height: AppDimens.dimens_90,
                                      width: AppDimens.dimens_90,
                                      child: Image.asset(
                                          'assets/image/promocode.png',
                                          fit: BoxFit.cover),
                                    ),
                                    const SizedBox(
                                      width: AppDimens.dimens_20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        if (controller.promoCode[index]
                                                .reducePercent !=
                                            0)
                                          FittedBox(
                                            child: Text(
                                              'Giảm: ${controller.promoCode[index].reducePercent}%',
                                              style: const TextStyle(
                                                  fontSize: AppDimens.dimens_20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        if (controller.promoCode[index]
                                                .reduceNumber !=
                                            0)
                                          FittedBox(
                                            child: Text(
                                              'Giảm: ${controller.getNewString(controller.promoCode[index].reduceNumber.toString())}K',
                                              style: const TextStyle(
                                                  fontSize: AppDimens.dimens_20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        if (controller
                                                .promoCode[index].applyPrice !=
                                            0)
                                          FittedBox(
                                            child: Text(
                                              'Đơn tối thiểu ${controller.getNewString(controller.promoCode[index].applyPrice.toString())}K',
                                              style: const TextStyle(
                                                  fontSize:
                                                      AppDimens.dimens_15),
                                            ),
                                          ),
                                        if (controller
                                                .promoCode[index].applyPrice ==
                                            0)
                                          const FittedBox(
                                            child: Text('Đơn tối thiểu 0Đ',
                                                style: TextStyle(
                                                    fontSize:
                                                        AppDimens.dimens_15)),
                                          ),
                                        if (controller
                                                .promoCode[index].maximum !=
                                            0)
                                          FittedBox(
                                            child: Text(
                                                'Giảm tối đa ${controller.getNewString(controller.promoCode[index].maximum.toString())}K',
                                                style: const TextStyle(
                                                    fontSize:
                                                        AppDimens.dimens_15)),
                                          )
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
          margin: const EdgeInsets.symmetric(
              horizontal: AppDimens.dimens_10, vertical: AppDimens.dimens_10),
          height: AppDimens.dimens_60,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimens.dimens_15))),
              onPressed: () {
                controller.getApplyPromoCode();
                controller.getApplyShipping();

                Get.back();
              },
              child: const Text('Đồng ý',
                  style: TextStyle(
                      fontSize: AppDimens.dimens_23,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.colorWhite)))),
    );
  }
}
