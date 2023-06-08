import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:new_ap/screen/Home_screen/controllers/Main_controller.dart';

import 'package:new_ap/screen/Home_screen/View/cart_screen.dart';

import 'package:new_ap/screen/Home_screen/widgets/cart_widget/badged.dart';
import 'package:new_ap/screen/Home_screen/widgets/main_widget.dart/categori_widget.dart';
import 'package:new_ap/screen/Home_screen/widgets/main_widget.dart/grid_kitchen.dart';

class MainScreen extends GetView<MainController> {
  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const CircleAvatar(),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_none_outlined,
                color: Theme.of(context).primaryColor,
              )),
          // StreamBuilder(
          //   stream: FirebaseUser().cartCollection.snapshots(),
          //   builder: (context, snapshot) {
          //     String value = '0';
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return Badged(
          //           value: value,
          //           child: IconButton(
          //             onPressed: () {
          //               Get.to(() => CartScreen(controller.kitchenModel))!
          //                   .then((value) {
          //                 controller.reset();
          //                 controller.getKitchen();
          //               });
          //             },
          //             icon: Icon(Icons.shopping_cart_outlined,
          //                 color: Theme.of(context).primaryColor),
          //           ));
          //     }
          //     final document = snapshot.data!.docs;

          //     if (document == null) {
          //       value = '0';
          //     } else {
          //       value = document.length.toString();
          //     }
          //     return Badged(
          //         value: value,
          //         child: IconButton(
          //           onPressed: () {
          //             Get.to(() => CartScreen(controller.kitchenModel));
          //           },
          //           icon: Icon(Icons.shopping_cart_outlined,
          //               color: Theme.of(context).primaryColor),
          //         ));
          //   },
          // )
          GetBuilder<MainController>(
            init: Get.find<MainController>(),
            builder: (controller) => Badged(
                value: controller.count.toString(),
                child: IconButton(
                  onPressed: () {
                    Get.to(() {
                      return CartScreen(controller.kitchenModel);
                    })!
                        .then((value) => controller.getCartItemCount());
                  },
                  icon: Icon(Icons.shopping_cart_outlined,
                      color: Theme.of(context).primaryColor),
                )),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return controller.reset();
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Categories',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          'See all',
                          style: TextStyle(color: Colors.blue),
                        ))
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(height: 120, child: CategoriesWidget()),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Kitchen near you',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          'See all',
                          style: TextStyle(color: Colors.blue),
                        ))
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: GirdKitchen(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
