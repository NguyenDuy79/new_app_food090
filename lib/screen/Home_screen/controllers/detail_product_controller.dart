import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:new_ap/common_app/common_widget.dart';
import 'package:new_ap/model/cart_model.dart';

import '../../../config/app_another.dart';
import '../../../config/firebase_api.dart';

class DetailProductController extends GetxController {
  ValueNotifier<bool> loading = ValueNotifier(false);
  final RxBool _loadingData = false.obs;
  bool get loadingData => _loadingData.value;
  final RxInt _count = 1.obs;
  int get count => _count.value;
  final Rx<List<CartModel>> _cart = Rx<List<CartModel>>([]);

  List<CartModel> get cart => _cart.value;
  int selectIndex = -1;
  @override
  void onInit() {
    if (FirebaseAuth.instance.currentUser != null) {
      _cart.bindStream(
          AppAnother.cartStream(FirebaseAuth.instance.currentUser!.uid));
    }
    super.onInit();
  }

  increase() {
    _count.value += 1;
  }

  reduce() {
    _count.value -= 1;
  }

  Future<void> addItem(
      BuildContext context,
      String kitchenName,
      String productId,
      String price,
      String name,
      String url,
      String kitchenId,
      int quantity) async {
    _loadingData.value = true;
    final dateTime = DateTime.now();
    CartModel cart = CartModel(
        id: dateTime.toString(),
        name: name,
        price: price,
        quantity: quantity,
        kitchenName: kitchenName,
        url: url,
        kitchenId: kitchenId,
        productId: productId);
    List<QueryDocumentSnapshot<Object?>> listData = [];
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseApi()
          .getCartFirestore(FirebaseAuth.instance.currentUser!.uid)
          .then((value) async {
        if (value.isEmpty) {
          loading.value = true;
        } else {
          for (int i = 0; i < value.length; i++) {
            listData.add(value[i]);
          }
          int result = listData.indexWhere((element) =>
              ((element.data() as Map<String, dynamic>)['productId'] as String)
                  .trim() ==
              productId.trim());

          if (result < 0) {
            loading.value = true;
          } else {
            try {
              _loadingData.value = true;
              await FirebaseApi()
                  .cartCollection(FirebaseAuth.instance.currentUser!.uid)
                  .doc((value[result].data() as Map<String, dynamic>)['id'])
                  .update({
                'quantity':
                    (value[result].data() as Map<String, dynamic>)['quantity'] +
                        cart.quantity
              }).then((value) {
                CommonWidget.showDialogSuccess(context);
              });
              _loadingData.value = false;
            } on PlatformException catch (err) {
              Get.back();
              log(err.message.toString());
              CommonWidget.showErrorDialog(context);
            } catch (err) {
              Get.back();
              CommonWidget.showErrorDialog(context);
            }
          }
        }
        if (loading.value == true) {
          try {
            await FirebaseApi()
                .cartCollection(FirebaseAuth.instance.currentUser!.uid)
                .doc(dateTime.toString())
                .set(cart.toJson())
                .then((value) {
              CommonWidget.showDialogSuccess(context);
            });
            loading.value = false;
            _loadingData.value = false;
            log('add');
          } on PlatformException catch (err) {
            Get.back();
            log(err.message.toString());

            // ignore: use_build_context_synchronously
            CommonWidget.showErrorDialog(context);
          } catch (err) {
            Get.back();
            // ignore: use_build_context_synchronously
            CommonWidget.showErrorDialog(context);
          }
        }
      });
    }
  }
}
