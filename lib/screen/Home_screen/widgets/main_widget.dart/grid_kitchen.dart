import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/screen/Home_screen/controllers/Main_controller.dart';
import 'package:new_ap/model/kitchen_model.dart';
import 'package:new_ap/screen/Home_screen/View/kitchen_menu.dart';

class GirdKitchen extends GetView<MainController> {
  const GirdKitchen({super.key});

  @override
  Widget build(BuildContext context) {
    final heightImage = MediaQuery.of(context).size.width - 20 * 2;

    return GetBuilder<MainController>(
      init: Get.find<MainController>(),
      builder: (controller) => SizedBox(
        height:
            heightImage / 2 * (3.05 / 2) * (controller.kitchenModel.length / 2),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: heightImage / 2,
              crossAxisSpacing: 20,
              childAspectRatio: 2 / 3.05),
          itemBuilder: (ctx, i) => _kitChenItem(
              controller,
              context,
              heightImage,
              controller.kitchenModel[i],
              controller.kitchenModel[i].imageUrl,
              controller.kitchenModel[i].imagechefUrl,
              controller.kitchenModel[i].name,
              controller.kitchenModel[i].time,
              controller.kitchenModel[i].ship,
              controller.kitchenModel[i].intoduct),
          itemCount: controller.kitchenModel.length,
        ),
      ),
    );
  }
}

Widget _kitChenItem(
    MainController controller,
    BuildContext context,
    double height,
    KitchenModel kitchen,
    String url,
    String urlchef,
    String name,
    String time,
    String ship,
    String intoduct) {
  final intoductItem = intoduct.split(',');
  return GestureDetector(
    onTap: () {
      Get.to(() => KitchenMenu(kitchen))!.then(
        (value) {
          controller.reset();
          controller.getCartItemCount();
        },
      );
    },
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SizedBox(
                height: height / 2 * 0.8,
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                ),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  height: 60,
                  width: 60,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(urlchef),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  children: <Widget>[
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.motorcycle_outlined,
                            color: Theme.of(context).primaryColor),
                        Text(
                          ship,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 12),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.timer,
                          color: Theme.of(context).primaryColor,
                        ),
                        Text(
                          time,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: <Widget>[
                  ...intoductItem
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            height: 17,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5)),
                            width: (height / 2 - 5 * 2 - 16) / 3,
                            child: FittedBox(
                              child: Text(
                                e,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList()
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}
