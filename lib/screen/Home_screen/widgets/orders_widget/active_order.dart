import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/database/Firebase_users.dart';
import 'package:new_ap/screen/Home_screen/controllers/orders_controller.dart';

class ActiveOrder extends StatelessWidget {
  ActiveOrder(this.height, this.width, {super.key});
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

          controller.getActiveOrder(document);
          return ListView.builder(
              itemCount: controller.activeOrders.length,
              itemBuilder: (contex, index) {
                return Container(
                  height:
                      controller.activeOrders[index].statusDelivery == 'Done'
                          ? height * 0.265
                          : height * 0.2,
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
                                    controller.activeOrders[index].url[0],
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  width - height * 0.145 - 20 * 2 - 10 * 2 - 10,
                              height: height * 0.145,
                              padding: const EdgeInsets.only(
                                  bottom: 10, top: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      '${controller.activeOrders[index].name[0][0].toUpperCase()}${controller.activeOrders[index].name[0].substring(1)} ',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                      '${controller.activeOrders[index].productId.length} items',
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
                                          '${controller.getNewPrice(controller.activeOrders[index].price)}VNĐ',
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
                                            controller.activeOrders[index]
                                                .statusDelivery,
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
                      if (controller.activeOrders[index].statusDelivery ==
                          'Done')
                        const Divider(),
                      if (controller.activeOrders[index].statusDelivery ==
                          'Done')
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Đã thanh toán ${controller.getNewPrice(controller.activeOrders[index].price)}VNĐ',
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  onPressed: () {
                                    controller.setStateShipDelivery(
                                        controller.activeOrders[index].id);
                                  },
                                  child: const Text('Xác nhận')),
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
