import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/database/Firebase_users.dart';

class DetailProductController extends GetxController {
  ValueNotifier<bool> loading = ValueNotifier(false);
  RxBool _loadingData = false.obs;
  RxBool get loadingData => _loadingData;

  Future<void> addItem(BuildContext context, String productId, String price,
      String name, String url, String kitchenId, int quantity) async {
    _loadingData.value = true;
    final dateTime = DateTime.now();
    List<QueryDocumentSnapshot<Object?>> listData = [];
    if (FirebaseAuth.instance.currentUser != null) {
      FireBaseUsers()
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
              await FireBaseUsers()
                  .cartCollection(FirebaseAuth.instance.currentUser!.uid)
                  .doc((value[result].data() as Map<String, dynamic>)['id'])
                  .update({
                'quantity':
                    (value[result].data() as Map<String, dynamic>)['quantity'] +
                        quantity
              }).then((value) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                return ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Thêm vào giỏ hàng thành công')));
              });
              _loadingData.value = false;
            } catch (error) {
              showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: const Text('An error ocurrend!'),
                        content: Text(error.toString()),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Text('Ok'))
                        ],
                      ));
            }
          }
        }
        if (loading.value == true) {
          try {
            await FireBaseUsers()
                .cartCollection(FirebaseAuth.instance.currentUser!.uid)
                .doc(dateTime.toString())
                .set({
              'id': dateTime.toString(),
              'quantity': quantity,
              'url': url,
              'productId': productId,
              'price': price,
              'name': name,
              'kitchenId': kitchenId
            }).then((value) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Thêm vào giỏ hàng thành công')));
            });
            loading.value = false;
            _loadingData.value = false;
            log('add');
          } catch (error) {
            rethrow;
          }
        }
      });
    }
  }
}
