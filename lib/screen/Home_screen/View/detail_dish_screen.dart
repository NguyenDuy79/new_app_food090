import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/screen/Home_screen/controllers/detail_product_controller.dart';
import 'package:new_ap/model/product_model.dart';

class DetailDishScreen extends StatefulWidget {
  DetailDishScreen(this.dish, {super.key});
  final ProductModel dish;

  @override
  State<DetailDishScreen> createState() => _DetailDishScreenState();
}

class _DetailDishScreenState extends State<DetailDishScreen> {
  int count = 1;
  int price = 0;
  int selectIndex = -1;
  DetailProductController controller = Get.put(DetailProductController());

  @override
  Widget build(BuildContext context) {
    print('0');
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top;
    price = int.parse(widget.dish.price);

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.green,
            ),
          ),
          title: const Text(
            'Food',
            style: TextStyle(
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.density_medium_outlined,
                  color: Colors.green,
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            SizedBox(
                width: double.infinity,
                height: height * 0.3,
                child: Image.network(
                  widget.dish.imageUrl,
                  fit: BoxFit.cover,
                )),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.shade200,
              ),
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: width * 0.4,
                      height: height * 0.065,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Theme.of(context).primaryColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: width * 0.125,
                            height: height * 0.065,
                            alignment: Alignment.center,
                            child: TextButton(
                                onPressed: () {
                                  if (count > 1) {
                                    setState(() {
                                      count--;
                                    });
                                  }
                                },
                                child: const Text(
                                  '-',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                          SizedBox(
                              width: width * 0.1,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '$count',
                                    style: const TextStyle(fontSize: 25),
                                  ))),
                          Container(
                            width: width * 0.125,
                            height: height * 0.065,
                            alignment: Alignment.center,
                            child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    count++;
                                  });
                                },
                                child: const Text(
                                  '+',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        widget.dish.name,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: widget.dish.favorite
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(Icons.favorite_border_outlined),
                        onPressed: () {},
                      )
                    ],
                  ),
                  Center(
                    child: Container(
                      width: width * 0.25,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(5)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(
                            Icons.attach_money_sharp,
                            color: Theme.of(context).primaryColor,
                          ),
                          FittedBox(
                              child: Text(
                            widget.dish.price,
                            style: const TextStyle(fontSize: 20),
                          ))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Details',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: height * 0.2,
                    padding: const EdgeInsets.all(20),
                    child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Text(widget.dish.intoduct),
                          ),
                        ]),
                  ),
                  if ((widget.dish.topping).isNotEmpty)
                    const Text(
                      'Topping',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  if ((widget.dish.topping).isNotEmpty)
                    Container(
                      height: height * 0.15,
                      padding: const EdgeInsets.all(20),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 3 / 1,
                                crossAxisSpacing: 15),
                        itemBuilder: (ctx, index) => InkWell(
                          onTap: () {
                            setState(() {
                              selectIndex = index;
                            });
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: selectIndex == index
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey.shade300,
                                      width: 1)),
                              child: FittedBox(
                                  child: Text(
                                      widget.dish.topping.split(',')[index]))),
                        ),
                        itemCount: (widget.dish.topping).split(',').length,
                      ),
                    )
                ],
              ),
            ),
          ]),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          height: height * 0.08,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              onPressed: () {
                controller.addItem(
                    context,
                    widget.dish.id,
                    widget.dish.price,
                    widget.dish.name,
                    widget.dish.imageUrl,
                    widget.dish.kitchenId,
                    count);
              },
              child: Obx(() {
                return controller.loadingData.value == true
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'Add to cart:',
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(' ${price * count}VNĐ',
                              style: const TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))
                        ],
                      );
              })),
        ));
  }
}
