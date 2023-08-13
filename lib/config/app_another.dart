import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_ap/model/promo_model.dart';

import '../model/cart_model.dart';
import 'firebase_api.dart';

class AppAnother {
  static final User? userAuth = FirebaseAuth.instance.currentUser;
  static final pageBucket = PageStorageBucket();
  static String getUpperFistIndex(String content) {
    return '${content[0].toUpperCase()}${content.substring(1)}';
  }

  static Stream<List<CartModel>> cartStream(String uid) {
    return FirebaseApi()
        .cartCollection(uid)
        .snapshots()
        .map((QuerySnapshot query) {
      List<CartModel> listCartStream = [];
      for (int i = 0; i < query.docs.length; i++) {
        listCartStream.add(
            CartModel.fromJson(query.docs[i].data() as Map<String, dynamic>));
      }

      return listCartStream;
    });
  }

  static Stream<List<PromoCode>> promoCodeStream() {
    return FirebaseApi().promoCodeCollection.snapshots().map((event) {
      List<PromoCode> listPromoStream = [];
      for (int i = 0; i < event.docs.length; i++) {
        listPromoStream.add(
            PromoCode.fromJson(event.docs[i].data() as Map<String, dynamic>));
      }
      FirebaseApi()
          .getOrderFirestore(FirebaseAuth.instance.currentUser!.uid)
          .then((value) {
        if (value.isNotEmpty) {
          listPromoStream.removeWhere((element) => element.id == 'firstorder');
        }
      });
      return listPromoStream;
    });
  }

  static Stream<List<ShippingPromoCode>> shippingPromoCode() {
    return FirebaseApi().shippingPromoCodeCollection.snapshots().map((event) {
      List<ShippingPromoCode> listShippingPromoCode = [];
      for (int i = 0; i < event.docs.length; i++) {
        listShippingPromoCode.add(ShippingPromoCode.formJson(
            event.docs[i].data() as Map<String, dynamic>));
      }

      return listShippingPromoCode;
    });
  }

  static String capitalizefirstletter(String value) {
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }
}
