import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:new_ap/database/Firebase_home.dart';

import 'package:new_ap/database/Firebase_users.dart';

import '../../../model/kitchen_model.dart';

class MainController extends GetxController {
  ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get loading => _loading;

  List<KitchenModel> _kitchenModel = [];
  List<KitchenModel> get kitchenModel => _kitchenModel;
  int count = 0;

  MainController() {
    getKitchen();
    getCartItemCount();
  }

  getKitchen() async {
    _loading.value = true;
    await FirebaseHome().getKitchenFromFirestore().then((value) => {
          for (int i = 0; i < value.length; i++)
            {
              _kitchenModel.add(KitchenModel.formJson(
                  value[i].data() as Map<String, dynamic>)),
              _loading.value = false
            },
        });
    update();
  }

  getCartItemCount() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FireBaseUsers()
          .getCartFirestore(FirebaseAuth.instance.currentUser!.uid)
          .then((value) {
        if (value.isNotEmpty) {
          count = value.length;
        } else {
          count = 0;
        }
      });
      print(count);
      update();
    }

    // FirebaseUser()
    //     .getCartFirestore(FirebaseAuth.instance.currentUser!.uid)
    //     .then((value) {
    //   if (value.isNotEmpty) {
    //     count.value = value.length;
    //   }
    // });
  }

  Future<void> reset() async {
    _kitchenModel = [];
    getKitchen();
  }
}
