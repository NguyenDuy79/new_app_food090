import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import 'package:new_ap/model/kitchen_model.dart';
import 'package:new_ap/model/product_model.dart';
import 'package:new_ap/screen/Home_screen/View/detail_dish_screen.dart';

class KitchenMenu extends StatelessWidget {
  KitchenMenu(this.kitchen, {super.key});
  final KitchenModel kitchen;

  List<ProductModel> product = [];
  getProductInKitchen(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> document,
      String kitchenId) {
    List<Map<String, dynamic>> productKitchen = [];
    for (int i = 0; i < document.length; i++) {
      if (((document[i].data())['kitchenId'] as String).trim() ==
          kitchenId.trim()) {
        productKitchen.add(document[i].data());
      }
    }

    for (int i = 0; i < productKitchen.length; i++) {
      product.add(ProductModel(
          id: productKitchen[i]['id'],
          imageUrl: productKitchen[i]['image'],
          name: productKitchen[i]['name'],
          intoduct: productKitchen[i]['intoduct'],
          kitchenId: productKitchen[i]['kitchenId'],
          price: productKitchen[i]['price'],
          topping: productKitchen[i]['topping'],
          favorite: productKitchen[i]['favorite']));
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = (MediaQuery.of(context).size.width - 20 * 3) / 2;
    return CustomScrollView(slivers: [
      SliverAppBar(
        toolbarHeight: 50,
        pinned: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.green,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.white,
        expandedHeight: MediaQuery.of(context).size.height * 0.20,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search_outlined,
                color: Colors.green,
              )),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.add_shopping_cart_outlined,
              color: Colors.green,
            ),
          )
        ],
        flexibleSpace: FlexibleSpaceBar(
          background: Image.network(
            kitchen.imageUrl,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Container(
              width: double.infinity,
              height: 40,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Colors.white,
              ),
              child: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 1))),
                child: Center(
                  child: Text(
                    '${kitchen.name[0].toUpperCase()}${kitchen.name.substring(1).toLowerCase()}',
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )),
        ),
      ),
      SliverToBoxAdapter(
        child: Container(
          color: Colors.white,
          child: Column(children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Card(
                elevation: 5,
                child: Column(children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'Đánh giá :',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        RatingBarIndicator(
                          rating: double.parse(kitchen.rating),
                          itemCount: 5,
                          direction: Axis.horizontal,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const <Widget>[
                          Text('Nhận xét :',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 8, left: 8, bottom: 10, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const <Widget>[
                          Text('Địa chỉ :',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('product')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                        height: 900,
                        child: Center(child: CircularProgressIndicator()));
                  } else {
                    final document = snapshot.data!.docs;
                    getProductInKitchen(document, kitchen.id);

                    return Container(
                      height: 900,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 2 / 2,
                                mainAxisSpacing: 20),
                        itemBuilder: (context, index) => menuItem(
                          height,
                          product[index],
                        ),
                        itemCount: product.length,
                      ),
                    );
                  }
                })
          ]),
        ),
      )
    ]);
  }
}

Widget menuItem(double height, ProductModel map) {
  return GestureDetector(
    onTap: () {
      Get.to(() => DetailDishScreen(map));
    },
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SizedBox(
                height: height * 0.7,
                child: Image.network(
                  map.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                map.name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              child: Text(
                '${map.price} VNĐ',
                style: const TextStyle(fontSize: 15),
              ),
            )
          ]),
    ),
  );
}
