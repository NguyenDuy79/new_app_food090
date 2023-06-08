// ignore_for_file: invalid_return_type_for_catch_error

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:new_ap/database/Firebase_partner.dart';
import 'package:new_ap/database/Firebase_users.dart';
import 'package:new_ap/model/cart_model.dart';
import '../../../database/Firebase_checkout.dart';
import '../../../model/promo_model.dart';

class CartController extends GetxController {
  // Promocode
  RxBool checkShipping = false.obs;
  RxBool checkPromo = false.obs;
  RxBool error = false.obs;
  List<PromoCode> _promoCode = [];
  List<PromoCode> get promoCode => _promoCode;
  List<ShippingPromoCode> _shippingPromoCode = [];
  List<ShippingPromoCode> get shippingPromoCode => _shippingPromoCode;
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
  final int ship = 40000;
  RxInt reduceShip = 0.obs;
  RxDouble reduce = (0.0).obs;

  CartController() {
    getPromoCode();
    getShippingPromoCode();
  }

  //cart

  Future<void> deleteCart(String cartId) async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FireBaseUsers()
          .cartCollection(FirebaseAuth.instance.currentUser!.uid)
          .doc(cartId)
          .delete()
          .then((value) {
        Get.snackbar('Xong', 'Xóa thành công');
        cartOrder.removeWhere((element) => element.id == cartId);
        getCount();
        getApplyPromoCode();
        getApplyShipping();
      }).catchError((error) => Get.snackbar('Failde to delete', error));
    }
  }

  Future<void> updateQuantity(CartModel cartItem, int quantity) async {
    await FireBaseUsers()
        .cartCollection(FirebaseAuth.instance.currentUser!.uid)
        .doc(cartItem.id)
        .update({'quantity': quantity}).then((value) {
      for (int i = 0; i < cartOrder.length; i++) {
        if (cartOrder[i].id == cartItem.id) {
          cartOrder.removeWhere((element) => element.id == cartItem.id);
          cartOrder.add(CartModel(
              id: cartItem.id,
              name: cartItem.name,
              price: cartItem.price,
              quantity: quantity,
              url: cartItem.url,
              kitchenId: cartItem.kitchenId,
              productId: cartItem.productId));
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
  }

  // Kiểm tra checkbox

  chooseProduct(CartModel cartItem) {
    cartOrder.add(CartModel(
        id: cartItem.id,
        name: cartItem.name,
        price: cartItem.price,
        quantity: cartItem.quantity,
        url: cartItem.url,
        kitchenId: cartItem.kitchenId,
        productId: cartItem.productId));
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
        id: _shippingPromoCode[indexShipping].id,
        applyPrice: _shippingPromoCode[indexShipping].applyPrice,
        maximum: _shippingPromoCode[indexShipping].maximum);
    update();
  }

  choosePromoCode(int index) {
    selectIndexPromo = index;

    selectPromoCode = PromoCode(
        id: _promoCode[index].id,
        applyPrice: _promoCode[index].applyPrice,
        maximum: _promoCode[index].maximum,
        reducePercent: _promoCode[index].reducePercent,
        reduceNumber: _promoCode[index].reduceNumber);
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

  getShippingPromoCode() async {
    await FirebaseCheckout().getShippingPromoCode().then((value) {
      if (value.isNotEmpty) {
        for (int i = 0; value.length > i; i++) {
          _shippingPromoCode.add(ShippingPromoCode(
              id: (value[i].data() as Map<String, dynamic>)['id'],
              applyPrice:
                  (value[i].data() as Map<String, dynamic>)['apply price'],
              maximum: (value[i].data() as Map<String, dynamic>)['maximum']));
        }
      } else {
        _shippingPromoCode = [];
      }
    });
  }

  getApplyPromoCode() {
    if (selectPromoCode.id != '') {
      checkPromo.value = true;
      if (count.value != 0) {
        error.value = false;
        if (count.value >= selectPromoCode.applyPrice) {
          if (selectPromoCode.reducePercent != 0) {
            reduce.value = selectPromoCode.maximum.toDouble();
          } else {
            reduce.value = selectPromoCode.reduceNumber.toDouble();
          }
          if ((count.value * (selectPromoCode.reducePercent / 100)) >
              selectPromoCode.maximum.toDouble()) {
          } else {
            reduce.value = count.value * (selectPromoCode.reducePercent / 100);
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

  getPromoCode() async {
    await FirebaseCheckout().getPromoCode().then((value) {
      if (value.isNotEmpty) {
        for (int i = 0; i < value.length; i++) {
          _promoCode.add(PromoCode(
              id: (value[i].data() as Map<String, dynamic>)['id'],
              applyPrice:
                  (value[i].data() as Map<String, dynamic>)['apply price'],
              maximum: (value[i].data() as Map<String, dynamic>)['maximum'],
              reducePercent:
                  (value[i].data() as Map<String, dynamic>)['reduce percent'],
              reduceNumber:
                  (value[i].data() as Map<String, dynamic>)['reduce number']));
        }
      } else {
        _promoCode = [];
      }
    });
    if (FirebaseAuth.instance.currentUser != null) {
      await FireBaseUsers()
          .getOrderFirestore(FirebaseAuth.instance.currentUser!.uid)
          .then((value) {
        if (value.isNotEmpty) {
          _promoCode.removeWhere((element) => element.id == 'firstorder');
        }
      });
    }
  }

  getApplyShipping() {
    if (selectShippingPromoCode.id != '') {
      checkShipping.value = true;
      if (count.value >= selectShippingPromoCode.applyPrice) {
        if (selectShippingPromoCode.maximum == 0) {
          reduceShip.value = ship;
        } else {
          if (selectShippingPromoCode.maximum < ship) {
            reduceShip.value = selectShippingPromoCode.maximum;
          } else {
            reduceShip.value = ship;
          }
        }
      } else {
        reduceShip = 0.obs;
      }
    } else {
      checkShipping.value = false;
    }
  }

  deleteCartOrder() async {
    for (int i = 0; i < cartOrder.length; i++) {
      await FireBaseUsers()
          .cartCollection(FirebaseAuth.instance.currentUser!.uid)
          .doc(cartOrder[i].id)
          .delete();
    }
  }

  // Đặt hàng
  Future<void> orders() async {
    List<String> product = [];
    List<String> name = [];
    List<String> url = [];
    List<int> quantity = [];
    for (int i = 0; i < cartOrder.length; i++) {
      product.add(cartOrder[i].productId);
      name.add(cartOrder[i].name);
      url.add(cartOrder[i].url);
      quantity.add(cartOrder[i].quantity);
    }
    String dateTime = DateTime.now().toString();
    if (FirebaseAuth.instance.currentUser != null) {
      await FireBaseUsers()
          .orderCollection(FirebaseAuth.instance.currentUser!.uid)
          .doc(dateTime)
          .set({
        'id': dateTime,
        'price': (count.value + ship - reduce.toInt() - reduceShip.value),
        'product': FieldValue.arrayUnion(product),
        'promoCode': selectPromoCode.id,
        'shippingCode': selectShippingPromoCode.id,
        'name': FieldValue.arrayUnion(name),
        'url': FieldValue.arrayUnion(url),
        'quantity': FieldValue.arrayUnion(quantity),
        'kitchenId': cartOrder[0].kitchenId,
        'status': 'active',
        'status delivery': 'Chờ nhận đơn'
      }).then((value) async {
        await FirebasePartner().ordersNow.doc(dateTime).set({
          'id': dateTime,
          'price': (count.value + ship - reduce.toInt() - reduceShip.value),
          'product': FieldValue.arrayUnion(product),
          'promoCode': selectPromoCode.id,
          'shippingCode': selectShippingPromoCode.id,
          'name': FieldValue.arrayUnion(name),
          'url': FieldValue.arrayUnion(url),
          'quantity': FieldValue.arrayUnion(quantity),
          'status': 'active',
          'kitchenId': cartOrder[0].kitchenId,
          'status delivery': 'Chờ nhận đơn',
          'userId': FirebaseAuth.instance.currentUser!.uid
        }).catchError((error) {
          throw error;
        });
      }).catchError((error) {
        throw error;
      });
    }
  }
}
