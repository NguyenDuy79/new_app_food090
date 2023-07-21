import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/screen/Home_screen/controllers/orders_controller.dart';
import 'package:new_ap/screen/Home_screen/widgets/orders_widget/active_order.dart';
import 'package:new_ap/screen/Home_screen/widgets/orders_widget/cancelled_order.dart';
import 'package:new_ap/screen/Home_screen/widgets/orders_widget/completed_order.dart';

import '../../../../config/app_dimens.dart';

// ignore: must_be_immutable
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
            backgroundColor: ColorConstants.colorWhite,
            title: const Text(
              'Orders',
              style: TextStyle(
                  fontSize: AppDimens.dimens_20,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.colorBlack),
            ),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search_outlined,
                    color: ColorConstants.themeColor,
                  ))
            ],
            bottom: TabBar(
              labelStyle: const TextStyle(
                  fontSize: AppDimens.dimens_15, fontWeight: FontWeight.w500),
              unselectedLabelColor: ColorConstants.colorGrey4,
              labelColor: ColorConstants.themeColor,
              controller: controller.controller,
              tabs: controller.myTabs,
            ),
          ),
          body: TabBarView(
            controller: controller.controller,
            children: <Widget>[
              ActiveOrder(height, width),
              CompletedOrder(height, width),
              const CancelledOrder()
            ],
          ),
        ));
  }
}
