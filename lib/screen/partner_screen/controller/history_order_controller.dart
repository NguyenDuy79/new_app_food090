import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/config/firebase_api.dart';
import '../../../common_app/common_widget.dart';
import '../../../config/app_another.dart';
import '../../../config/app_dimens.dart';
import '../../../model/orders_model.dart';
import '../../../model/user_model.dart';

class HistoryController extends GetxController {
  final Rx<List<OrderModel>> _order = Rx<List<OrderModel>>([]);
  List<OrderModel> get order => _order.value;
  List<String> url = [];
  @override
  void onInit() {
    if (FirebaseAuth.instance.currentUser != null) {
      _order.bindStream(orderHistoryStream());
      _historySearch.bindStream(getStreamHisrtory(AppAnother.userAuth!.uid));
    }
    super.onInit();
  }

  Stream<List<OrderModel>> orderHistoryStream() {
    return FirebaseApi()
        .orderHistoryPartner(FirebaseAuth.instance.currentUser!.uid)
        .orderBy('timeStamp', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<OrderModel> listOrderStream = [];

      if (FirebaseAuth.instance.currentUser != null) {
        if (query.docs.isNotEmpty) {
          if ((query.docs[0].data() as Map<String, dynamic>)['quantity'] !=
                  null &&
              (query.docs[0].data() as Map<String, dynamic>)['productPrice'] !=
                  null) {
            for (int i = 0; i < query.docs.length; i++) {
              if ((query.docs[i].data() as Map<String, dynamic>)['status'] ==
                  'Completed') {
                url.add((query.docs[i].data()
                    as Map<String, dynamic>)['billImage']);
              } else {
                url.add('');
              }

              listOrderStream.add(OrderModel.fromJson(
                  query.docs[i].data() as Map<String, dynamic>));
            }
          }
        }
      }

      return listOrderStream;
    });
  }

  String getNewPrice(int price) {
    var length = price.toString().length;
    var reuslt =
        '${price.toString().substring(0, length - 3)}.${price.toString().substring(length - 3, length)}';
    return reuslt;
  }

  List<String> statusDelivery = [
    'Đã nhận đơn hàng',
    'Đang chuẩn bị',
    'Đang trên đường giao đến bạn',
    ' Giao hàng thành công'
  ];

  int getprice(List<String> price, List<int> quantity) {
    var totalPrice = 0;
    for (int i = 0; i < price.length; i++) {
      totalPrice = totalPrice + int.parse(price[i]) * quantity[i];
    }
    return totalPrice;
  }

  Widget getWidget(
      BuildContext context, int count, IconData icon, String time, int index) {
    return Container(
      height: AppDimens.dimens_130,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.dimens_20,
      ),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Icon(
                icon,
                color: ColorConstants.themeColor,
              ),
              Container(
                height: AppDimens.dimens_100,
                width: AppDimens.dimens_5,
                decoration:
                    const BoxDecoration(color: ColorConstants.themeColor),
              )
            ],
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(top: AppDimens.dimens_10),
            child: Column(
              children: <Widget>[
                FittedBox(
                  child: Text(
                    'Tình trạng: ${statusDelivery[count - 1]}',
                    style: const TextStyle(
                        fontSize: AppDimens.dimens_20,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.colorBlack),
                  ),
                ),
                Text(
                  '${time.split(':')[0]}:${time.split(':')[1]}',
                  style: const TextStyle(color: ColorConstants.colorBlack),
                ),
                if (count == 2)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppDimens.dimens_10),
                    height: AppDimens.dimens_80,
                    width: AppDimens.dimens_50,
                    child: Image.network(
                      url[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                const Expanded(child: SizedBox()),
                const Divider(
                    height: AppDimens.dimens_0,
                    thickness: AppDimens.dimens_2,
                    color: ColorConstants.themeColor)
              ],
            ),
          ))
        ],
      ),
    );
  }

  final TextEditingController textEditing = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  FocusNode get focusNode => _focusNode;
  final Rx<List<SearchModel>> _historySearch = Rx<List<SearchModel>>([]);
  List<String> historySearch = [];
  final Rx<List<String>> _suggestString = Rx<List<String>>([]);
  List<String> get suggestString => _suggestString.value;
  final Rx<List<OrderModel>> _resultSearch = Rx<List<OrderModel>>([]);
  List<OrderModel> get resultSearch => _resultSearch.value;
  final RxBool _isCheck = false.obs;
  bool get isCheck => _isCheck.value;
  final RxBool _isMain = true.obs;
  bool get isMain => _isMain.value;
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  Stream<List<SearchModel>> getStreamHisrtory(String uid) {
    return FirebaseApi()
        .orderHistorySearchCollection(uid)
        .orderBy('id', descending: true)
        .snapshots()
        .map((event) {
      List<SearchModel> listSearchStream = [];
      for (var item in event.docs) {
        listSearchStream
            .add(SearchModel.fromJson(item.data() as Map<String, dynamic>));
      }
      return listSearchStream;
    });
  }

  Future<void> submitQuerySearch(String query, BuildContext ctx) async {
    Timestamp timestamp = Timestamp.now();

    if (AppAnother.userAuth != null) {
      try {
        if (historySearch.length <= 10) {
          await FirebaseApi()
              .orderHistorySearchCollection(AppAnother.userAuth!.uid)
              .doc(timestamp.toString())
              .set({'id': timestamp, 'search value': query.trim()}).catchError(
                  (e) => throw e);
        } else {
          Timestamp id =
              _historySearch.value[_historySearch.value.length - 1].id;
          await FirebaseApi()
              .orderHistorySearchCollection(AppAnother.userAuth!.uid)
              .doc(timestamp.toString())
              .set({'id': timestamp, 'search value': query.trim()}).then(
                  (value) => FirebaseApi()
                      .orderSearchCollection(AppAnother.userAuth!.uid)
                      .doc(id.toString())
                      .delete());
        }
      } on PlatformException catch (err) {
        Get.back();
        log(err.message.toString());

        CommonWidget.showErrorDialog(ctx);
      } catch (err) {
        Get.back();

        CommonWidget.showErrorDialog(ctx);
      }
    }
  }

  changeStatusEmpty() {
    if (textEditing.text.trim() == '') {
      _isCheck.value = false;
    } else {
      _isCheck.value = true;
    }
  }

  getTrueIsMain() {
    _isMain.value = true;
  }

  getFalseIsMain() {
    _isMain.value = false;
  }

  getSuggest(String value) {
    _suggestString.value = [];
    for (var item in _order.value) {
      if (item.kitchenName.toLowerCase().contains(value.toLowerCase())) {
        if (!_suggestString.value.contains(item.kitchenName)) {
          _suggestString.value.add(item.kitchenName);
        }
      }
      for (var name in item.name) {
        if (name.toLowerCase().contains(value.toLowerCase())) {
          if (!_suggestString.value.contains(name)) {
            _suggestString.value.add(name);
          }
        }
      }
    }
  }

  getListQuery(String query) {
    _isLoading.value = true;
    _resultSearch.value = [];
    for (var item in _order.value) {
      if (item.kitchenName.toLowerCase().contains(query.toLowerCase())) {
        if (!_resultSearch.value.contains(item)) {
          _resultSearch.value.add(item);
        }
      }
      for (var name in item.name) {
        if (name.toLowerCase().contains(query.toLowerCase())) {
          if (!_resultSearch.value.contains(item)) {
            _resultSearch.value.add(item);
          }
        }
      }
    }
    _isLoading.value = false;
  }

  getValueHistorySearch() {
    historySearch = [];
    for (var item in _historySearch.value) {
      if (!historySearch.contains(item.query)) {
        historySearch.add(item.query);
      }
    }
  }
}
