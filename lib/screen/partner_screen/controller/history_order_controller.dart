import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/config/firebase_api.dart';
import '../../../config/app_dimens.dart';
import '../../../model/orders_model.dart';

class HistoryController extends GetxController {
  final Rx<List<OrderModel>> _order = Rx<List<OrderModel>>([]);
  List<OrderModel> get order => _order.value;
  List<String> url = [];
  @override
  void onInit() {
    if (FirebaseAuth.instance.currentUser != null) {
      _order.bindStream(orderNowStream());
    }
    super.onInit();
  }

  Stream<List<OrderModel>> orderNowStream() {
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
              url.add(
                  (query.docs[i].data() as Map<String, dynamic>)['billImage']);

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
}
