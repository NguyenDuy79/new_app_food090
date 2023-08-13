import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:new_ap/common_app/common_widget.dart';
import 'package:new_ap/config/app_another.dart';
import 'package:new_ap/config/app_string.dart';
import 'package:new_ap/config/firebase_api.dart';
import 'package:new_ap/model/rate_and_comment_model.dart';
import 'package:new_ap/screen/Home_screen/controllers/main_controller.dart';

class ReviewPageController extends GetxController {
  final RxInt _startValue = 5.obs;
  int get starValue => _startValue.value;
  final TextEditingController editingController = TextEditingController();
  final RxInt _selectIndex = 0.obs;
  int get selecIndex => _selectIndex.value;
  final RxBool _checkEmpty = true.obs;
  bool get checkEmpty => _checkEmpty.value;
  final RxBool _isLoading = false.obs;
  bool get isLoading => true;
  final List<String> _reviewText = [
    AppString.reviewText5,
    AppString.reviewText4,
    AppString.reviewText3,
    AppString.reviewText2,
    AppString.reviewText1
  ];
  List<String> get reviewText => _reviewText;
  changeStarValue(int index) {
    _startValue.value = index + 1;
  }

  confirmTextSuggest(int value) {
    if (value == 1) {
      _selectIndex.value = 1;
      editingController.text = 'Chất lượng sản phẩm:';
      changeStatusCheckEmpty();
    } else if (value == 2) {
      _selectIndex.value = 2;
      editingController.text = 'Vệ sinh:';
      changeStatusCheckEmpty();
    } else {
      _selectIndex.value = 3;
      editingController.text = 'Thời gian:';
      changeStatusCheckEmpty();
    }
  }

  resetSelectIndex() {
    _selectIndex.value = 0;
  }

  changeStatusCheckEmpty() {
    if (editingController.text.replaceAll('\n', '').trim() == '') {
      _checkEmpty.value = true;
    } else {
      _checkEmpty.value = false;
    }
  }

  Future<void> submitReview(
      BuildContext context,
      List<String> name,
      List<int> quantity,
      String kitchenId,
      String kitchenName,
      String orderId) async {
    String dateTime = DateTime.now().toString();
    Timestamp timestamp = Timestamp.now();

    if (AppAnother.userAuth != null) {
      RateAndCommentModel inKitchen = RateAndCommentModel(
          id: dateTime,
          comment: editingController.text.trim().replaceAll('\n', ''),
          timestamp: timestamp,
          like: 0,
          listLike: [],
          kitchenOrUserId: AppAnother.userAuth!.uid,
          kitchenOrUserImage: Get.find<MainController>().user.image,
          kitchenOrUserName: Get.find<MainController>().user.userName,
          name: name,
          quantity: quantity,
          rate: starValue);
      RateAndCommentModel inUser = RateAndCommentModel(
          id: dateTime,
          comment: editingController.text.trim().replaceAll('\n', ''),
          timestamp: timestamp,
          kitchenOrUserId: kitchenId,
          kitchenOrUserImage: '',
          kitchenOrUserName: kitchenName,
          like: 0,
          listLike: [],
          name: name,
          quantity: quantity,
          rate: starValue);
      Map<String, List> getQuantity = {'quantity': quantity};
      try {
        _isLoading.value = true;
        CommonWidget.showDialogLoading(context);
        await FirebaseApi()
            .orderCollection(AppAnother.userAuth!.uid)
            .doc(orderId)
            .update({'review': true});
        await FirebaseApi()
            .kitchenReviewCollection(kitchenId)
            .doc(dateTime)
            .set(inKitchen.toJson())
            .then((value) async {
          await FirebaseApi()
              .kitchenReviewCollection(kitchenId)
              .doc(dateTime)
              .update(getQuantity);
        });
        await FirebaseApi()
            .reviewCollection(AppAnother.userAuth!.uid)
            .doc(dateTime)
            .set(inUser.toJson())
            .then((value) async {
          await FirebaseApi()
              .reviewCollection(AppAnother.userAuth!.uid)
              .doc(dateTime)
              .update(getQuantity);
        });
        _isLoading.value = false;
        Get.back();
        Get.back();

        // ignore: use_build_context_synchronously
        CommonWidget.showDialogSuccess(context);
        updateRate(kitchenId);
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

  updateRate(String id) async {
    await FirebaseApi().getKitchenReview(id).then((value) async {
      int count = 0;
      for (int i = 0; i < value.length; i++) {
        count += (value[i].data() as Map<String, dynamic>)['rate'] as int;
      }
      try {
        await FirebaseApi()
            .kitchenCollection
            .doc(id)
            .update({'rating': (count / value.length).toStringAsFixed(1)});
      } on PlatformException {
        rethrow;
      } catch (err) {
        rethrow;
      }
    });
  }
}
