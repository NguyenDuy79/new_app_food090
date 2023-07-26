import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_another.dart';
import 'package:new_ap/config/firebase_api.dart';
import 'package:new_ap/model/cart_model.dart';
import 'package:new_ap/model/orders_model.dart';
import '../../../config/app_colors.dart';
import '../../../model/promo_model.dart';

class CartController extends GetxController {
  final Rx<List<CartModel>> _cart = Rx<List<CartModel>>([]);
  List<CartModel> get cart => _cart.value;
  List<String> kitchen = [];
  // Promocode
  RxBool checkShipping = false.obs;
  RxBool checkPromo = false.obs;
  RxBool error = false.obs;
  final Rx<List<PromoCode>> _promoCode = Rx<List<PromoCode>>([]);
  List<PromoCode> get promoCode => _promoCode.value;
  final Rx<List<ShippingPromoCode>> _shippingPromoCode =
      Rx<List<ShippingPromoCode>>([]);
  List<ShippingPromoCode> get shippingPromoCode => _shippingPromoCode.value;
  bool extend = false;
  int selectIndexShipping = -1;
  int selectIndexPromo = -1;
  bool value = false;
  ShippingPromoCode selectShippingPromoCode =
      ShippingPromoCode(id: '', applyPrice: 0, maximum: 0);
  PromoCode selectPromoCode = PromoCode(
      id: '', applyPrice: 0, maximum: 0, reducePercent: 0, reduceNumber: 0);
  List<CartModel> cartOrder = [];
  //Thanh toán
  RxInt count = 0.obs;
  RxInt selectIndex = (-1).obs;
  RxInt ship = 0.obs;
  RxInt reduceShip = 0.obs;
  RxDouble reduce = (0.0).obs;

  @override
  void onInit() {
    if (FirebaseAuth.instance.currentUser != null) {
      _cart.bindStream(
          AppAnother().cartStream(FirebaseAuth.instance.currentUser!.uid));
      _promoCode.bindStream(AppAnother().promoCodeStream());
      _shippingPromoCode.bindStream(AppAnother().shippingPromoCode());
    }

    super.onInit();
  }

  //cart
  getKitchen() {
    kitchen = [];
    if (_cart.value.isNotEmpty) {
      for (int i = 0; i < _cart.value.length; i++) {
        if (!kitchen.contains(_cart.value[i].kitchenId)) {
          kitchen.add(_cart.value[i].kitchenId);
        }
      }
    }
  }

  Future<void> deleteCart(String cartId) async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseApi()
          .cartCollection(FirebaseAuth.instance.currentUser!.uid)
          .doc(cartId)
          .delete()
          .then((value) {
        Get.snackbar('Xong', 'Xóa thành công');
        cartOrder.removeWhere((element) => element.id == cartId);
        getCount();
        getApplyPromoCode();
        getApplyShipping();
        // ignore: invalid_return_type_for_catch_error
      }).catchError(
              // ignore: invalid_return_type_for_catch_error
              (error) => Get.snackbar('Failde to delete', error.toString()));
    }
  }

  Future<void> updateQuantity(CartModel cartItem, int quantity) async {
    cartItem.quantity = quantity;
    log(cartItem.quantity.toString());
    await FirebaseApi()
        .cartCollection(FirebaseAuth.instance.currentUser!.uid)
        .doc(cartItem.id)
        .update({'quantity': quantity}).then((value) {
      for (int i = 0; i < cartOrder.length; i++) {
        if (cartOrder[i].id == cartItem.id) {
          cartOrder.removeWhere((element) => element.id == cartItem.id);
          cartOrder.add(cartItem);
          getCount();
        }
      }
    });
  }

  String getNewString(String string) {
    final lenght = string.length;
    final result = string.substring(0, lenght - 3);
    return result;
  }

  getCount() {
    count.value = 0;
    for (int i = 0; i < cartOrder.length; i++) {
      count = count + cartOrder[i].quantity * int.parse(cartOrder[i].price);
    }
    if (count.value > 0) {
      ship.value = 40000;
    } else {
      ship.value = 0;
    }
  }

  // Kiểm tra checkbox

  chooseProduct(CartModel cartItem) {
    cartOrder.add(cartItem);
    getCount();
  }

  unChooseProduct(CartModel cartItem) {
    cartOrder.removeWhere((element) => element.id == cartItem.id);
    getCount();
  }

  // Xử lý promo code
  chooseShippingPromo(int indexShipping) {
    selectIndexShipping = indexShipping;
    selectShippingPromoCode = ShippingPromoCode(
        id: _shippingPromoCode.value[indexShipping].id,
        applyPrice: _shippingPromoCode.value[indexShipping].applyPrice,
        maximum: _shippingPromoCode.value[indexShipping].maximum);
    update();
  }

  choosePromoCode(int index) {
    selectIndexPromo = index;

    selectPromoCode = PromoCode(
        id: _promoCode.value[index].id,
        applyPrice: _promoCode.value[index].applyPrice,
        maximum: _promoCode.value[index].maximum,
        reducePercent: _promoCode.value[index].reducePercent,
        reduceNumber: _promoCode.value[index].reduceNumber);
    update();
  }

  unChooseShippingPromo() {
    selectIndexShipping = -1;
    selectShippingPromoCode =
        ShippingPromoCode(id: '', applyPrice: 0, maximum: 0);
    update();
  }

  unChoosePromoCode() {
    selectIndexPromo = -1;
    selectPromoCode = PromoCode(
        id: '', applyPrice: 0, maximum: 0, reducePercent: 0, reduceNumber: 0);
    update();
  }

  getApplyPromoCode() {
    reduce.value = 0;
    if (selectPromoCode.id != '') {
      checkPromo.value = true;
      if (count.value != 0) {
        error.value = false;
        if (count.value >= selectPromoCode.applyPrice) {
          if (selectPromoCode.reducePercent == 0) {
            reduce.value = selectPromoCode.reduceNumber.toDouble();
          } else {
            if ((count.value * (selectPromoCode.reducePercent / 100)) >
                selectPromoCode.maximum.toDouble()) {
              reduce.value =
                  count.value * (selectPromoCode.reducePercent / 100);
            } else {
              reduce.value =
                  count.value * (selectPromoCode.reducePercent / 100);
            }
          }
        } else {
          reduce = (0.0).obs;
        }
      } else {
        reduce.value = 0;
        if (checkPromo.value || checkShipping.value) {
          error.value = true;
        }
      }
    } else {
      checkPromo.value = false;
    }
  }

  firstOrder() async {
    if (FirebaseAuth.instance.currentUser != null) {}
  }

  getApplyShipping() {
    if (selectShippingPromoCode.id != '') {
      checkShipping.value = true;
      if (count.value >= selectShippingPromoCode.applyPrice) {
        if (selectShippingPromoCode.maximum == 0) {
          reduceShip.value = ship.value;
        } else {
          if (selectShippingPromoCode.maximum < ship.value) {
            reduceShip.value = selectShippingPromoCode.maximum;
          } else {
            reduceShip.value = ship.value;
          }
        }
      } else {
        reduceShip = 0.obs;
      }
    } else {
      checkShipping.value = false;
    }
  }

  Future<void> deleteCartOrder() async {
    for (int i = 0; i < cartOrder.length; i++) {
      await FirebaseApi()
          .cartCollection(FirebaseAuth.instance.currentUser!.uid)
          .doc(cartOrder[i].id)
          .delete();
    }
  }

  // Đặt hàng
  Future<void> orders(BuildContext ctx) async {
    DateTime dateTime = DateTime.now();
    Timestamp timestamp = Timestamp.now();

    List<String> product = [];
    List<String> name = [];
    List<String> url = [];
    List<int> quantity = [];
    List<String> price = [];
    for (int i = 0; i < cartOrder.length; i++) {
      product.add(cartOrder[i].productId);
      name.add(cartOrder[i].name);
      url.add(cartOrder[i].url);
      quantity.add(cartOrder[i].quantity);

      price.add(cartOrder[i].price);
    }
    OrderModel newOrder = OrderModel(
        id: dateTime.toString(),
        name: name,
        timeStamp: timestamp,
        ship: ship.value.toString(),
        timeOne: '',
        timeTwo: '',
        timeThree: '',
        timeFour: '',
        productId: product,
        price: (count.value + ship.value - reduce.toInt() - reduceShip.value),
        reduce: reduce.value.toString(),
        reduceShip: reduceShip.value.toString(),
        productPrice: product,
        kitchenId: cartOrder[0].kitchenId,
        kitchenName: cartOrder[0].kitchenName,
        promoCode: selectPromoCode.id,
        uid: AppAnother.userAuth!.uid,
        quantity: quantity,
        shippingCode: selectShippingPromoCode.id,
        status: 'Active',
        statusDelivery: 'Chờ nhận đơn',
        url: url);
    Map<String, List> getQuantity = {'quantity': quantity};
    Map<String, List> getPrice = {'productPrice': price};
    if (AppAnother.userAuth != null) {
      try {
        await FirebaseApi()
            .orderCollection(AppAnother.userAuth!.uid)
            .doc(dateTime.toString())
            .set(newOrder.toJson())
            .then((value) async {
          await FirebaseApi()
              .orderCollection(AppAnother.userAuth!.uid)
              .doc(dateTime.toString())
              .update(getQuantity);
          await FirebaseApi()
              .orderCollection(AppAnother.userAuth!.uid)
              .doc(dateTime.toString())
              .update(getPrice);
        }).catchError((e) => throw e);
        await FirebaseApi()
            .orderNow
            .doc(dateTime.toString())
            .set(newOrder.toJson())
            .then((value) async {
          await FirebaseApi()
              .orderNow
              .doc(dateTime.toString())
              .update(getQuantity);

          await FirebaseApi()
              .orderNow
              .doc(dateTime.toString())
              .update(getPrice);
        }).catchError((e) => throw e);
      } on PlatformException catch (err) {
        var message = 'An error, try again';
        if (err.message != null) {
          message = err.message!;
        }
        ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: ColorConstants.colorRed1,
        ));
      } catch (err) {
        ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(err.toString()),
          backgroundColor: ColorConstants.colorRed1,
        ));
      }
    }
  }

  setValue() {
    count.value = 0;
    ship.value = 0;
    selectIndex.value = -1;
    selectIndexShipping = -1;
    selectIndexPromo = -1;
    reduce.value = 0;
    reduceShip.value = 0;
    cartOrder = [];
    checkPromo.value = false;
    checkShipping.value = false;
    selectShippingPromoCode =
        ShippingPromoCode(id: '', applyPrice: 0, maximum: 0);
    selectPromoCode = PromoCode(
        id: '', applyPrice: 0, maximum: 0, reducePercent: 0, reduceNumber: 0);
  }
}
