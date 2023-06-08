import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/database/Firebase_users.dart';
import 'package:new_ap/model/kitchen_model.dart';
import 'package:new_ap/screen/Home_screen/controllers/Main_controller.dart';
import 'package:new_ap/screen/Home_screen/controllers/cart_controller.dart';
import 'package:new_ap/screen/Home_screen/widgets/cart_widget/bill.dart';
import 'package:new_ap/screen/Home_screen/widgets/cart_widget/list_cart.dart';
import '../../../model/cart_model.dart';
import '../../../model/promo_model.dart';

class CartScreen extends StatelessWidget {
  CartScreen(this.listKitchen, {super.key});

  final List<KitchenModel> listKitchen;
  CartController controller = Get.find<CartController>();
  List<CartModel> cart = [];
  List<String> kitchen = [];

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;

    return WillPopScope(
      onWillPop: () async {
        controller.count.value = 0;
        controller.selectIndex.value = -1;
        controller.selectIndexShipping = -1;
        controller.selectIndexPromo = -1;
        controller.cartOrder = [];
        controller.checkPromo.value = false;
        controller.checkShipping.value = false;
        controller.selectShippingPromoCode =
            ShippingPromoCode(id: '', applyPrice: 0, maximum: 0);
        controller.selectPromoCode = PromoCode(
            id: '',
            applyPrice: 0,
            maximum: 0,
            reducePercent: 0,
            reduceNumber: 0);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              controller.count.value = 0;
              controller.selectIndex.value = -1;
              controller.selectIndexShipping = -1;
              controller.selectIndexPromo = -1;
              controller.cartOrder = [];
              controller.checkPromo.value = false;
              controller.checkShipping.value = false;
              controller.selectShippingPromoCode =
                  ShippingPromoCode(id: '', applyPrice: 0, maximum: 0);
              controller.selectPromoCode = PromoCode(
                  id: '',
                  applyPrice: 0,
                  maximum: 0,
                  reducePercent: 0,
                  reduceNumber: 0);

              Get.back();
            },
            icon: Icon(
              Icons.subdirectory_arrow_left_sharp,
              color: Theme.of(context).primaryColor,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Cart',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          actions: [],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder(
                stream: FireBaseUsers()
                    .cartCollection(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final document = snapshot.data!.docs;
                    cart = [];
                    kitchen = [];

                    if (document.isNotEmpty) {
                      for (int i = 0; i < document.length; i++) {
                        cart.add(CartModel.fromJson(
                            document[i].data() as Map<String, dynamic>));
                      }

                      for (int i = 0; i < cart.length; i++) {
                        if (!kitchen.contains(cart[i].kitchenId.trim())) {
                          kitchen.add(cart[i].kitchenId.trim());
                        }
                      }
                    } else {
                      cart = [];
                    }

                    return SizedBox(
                        height: height * 0.5,
                        width: double.infinity,
                        child: ListCart(listKitchen, cart, kitchen));
                  }
                },
              ),
              BillCart(height)
            ],
          ),
        ),
        bottomNavigationBar: Obx(() => Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: height * 0.08,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                onPressed: () {
                  if (controller.cartOrder.isNotEmpty) {
                    try {
                      controller.orders().then((value) {
                        Get.snackbar('Done', 'Đặt hàng thành công');
                        Get.offNamed('/home-screen');
                        controller.deleteCartOrder();
                        controller.count.value = 0;
                        controller.selectIndex.value = -1;
                        controller.selectIndexShipping = -1;
                        controller.selectIndexPromo = -1;
                        controller.cartOrder = [];
                        controller.checkPromo.value = false;
                        controller.checkShipping.value = false;
                        controller.selectShippingPromoCode = ShippingPromoCode(
                            id: '', applyPrice: 0, maximum: 0);
                        controller.selectPromoCode = PromoCode(
                            id: '',
                            applyPrice: 0,
                            maximum: 0,
                            reducePercent: 0,
                            reduceNumber: 0);
                        MainController().getCartItemCount();
                      });
                    } catch (error) {
                      Get.snackbar('Lỗi', error.toString());
                    }
                  } else {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Không thể tiến hành đặt hàng'),
                      duration: Duration(seconds: 1),
                    ));
                  }
                },
                child: controller.error.value
                    ? const Text('Không thể áp dụng mã giảm',
                        style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))
                    : const Text('Đặt hàng',
                        style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))))),
      ),
    );
  }
}
