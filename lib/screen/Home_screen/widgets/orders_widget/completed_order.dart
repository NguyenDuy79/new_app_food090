import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/screen/Home_screen/controllers/orders_controller.dart';

import '../../../../database/Firebase_users.dart';

class CompletedOrder extends StatelessWidget {
  CompletedOrder(this.height, this.width, {super.key});
  final double height;
  final double width;
  OrderController controller = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FireBaseUsers()
          .orderCollection(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final document = snapshot.data!.docs;
          print(document.length);

          controller.getCompletedOrder(document);
          return controller.completedOrders.isEmpty
              ? const Center(
                  child: Text(
                  'Bạn chưa hoàn thành đơn hàng nào',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ))
              : ListView.builder(
                  itemCount: controller.completedOrders.length,
                  itemBuilder: (contex, index) {
                    return Container(
                      height: height * 0.145 + height * 0.07 + 22,
                      width: width,
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey.shade100),
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {},
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: SizedBox(
                                    height: height * 0.145,
                                    width: height * 0.145,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        controller
                                            .completedOrders[index].url[0],
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: width -
                                      height * 0.145 -
                                      20 * 2 -
                                      10 * 2 -
                                      10,
                                  height: height * 0.145,
                                  padding: const EdgeInsets.only(
                                      bottom: 10, top: 10, right: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          '${controller.completedOrders[index].name[0][0].toUpperCase()}${controller.completedOrders[index].name[0].substring(1)} ',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(
                                          '${controller.completedOrders[index].productId.length} items',
                                          style: const TextStyle(
                                            fontSize: 20,
                                          )),
                                      Container(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              '${controller.getNewPrice(controller.completedOrders[index].price)}VNĐ',
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.green),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Text(
                                                controller
                                                    .completedOrders[index]
                                                    .status,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Divider(
                            indent: 20,
                            endIndent: 20,
                            thickness: 2,
                            height: 0,
                          ),
                          Container(
                            height: height * 0.07,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SizedBox(
                                  height: height * 0.07 - 25,
                                  width: (width - 20 * 4 - 30) / 2,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  width: 3,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          backgroundColor: Colors.white),
                                      onPressed: () {
                                        controller.setStateShipDelivery(
                                            controller.activeOrders[index].id);
                                      },
                                      child: const Text(
                                        'Đánh giá',
                                        style: TextStyle(color: Colors.green),
                                      )),
                                ),
                                SizedBox(
                                  height: height * 0.07 - 25,
                                  width: (width - 20 * 4 - 30) / 2,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          backgroundColor:
                                              Theme.of(context).primaryColor),
                                      onPressed: () {
                                        controller.setStateShipDelivery(
                                            controller.activeOrders[index].id);
                                      },
                                      child: const Text('Mua lại')),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  });
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
