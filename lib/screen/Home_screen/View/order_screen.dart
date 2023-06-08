import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/screen/Home_screen/controllers/orders_controller.dart';
import 'package:new_ap/screen/Home_screen/widgets/orders_widget/active_order.dart';
import 'package:new_ap/screen/Home_screen/widgets/orders_widget/cancelled_order.dart';
import 'package:new_ap/screen/Home_screen/widgets/orders_widget/completed_order.dart';

class OrderScreen extends StatelessWidget {
  OrderScreen({super.key});
  OrderController controller = Get.find<OrderController>();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        TabBar(tabs: controller.myTabs).preferredSize.height -
        MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              'Orders',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.search_outlined,
                    color: Theme.of(context).primaryColor,
                  ))
            ],
            bottom: TabBar(
              labelStyle:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              unselectedLabelColor: Colors.grey,
              labelColor: Theme.of(context).primaryColor,
              controller: controller.controller,
              tabs: controller.myTabs,
            ),
          ),
          body: TabBarView(
            controller: controller.controller,
            children: <Widget>[
              ActiveOrder(height, width),
              CompletedOrder(height, width),
              CancelledOrder(height, width)
            ],
          ),
        ));
  }
}
