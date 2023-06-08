import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:new_ap/model/cart_model.dart';
import 'package:new_ap/screen/Home_screen/controllers/cart_controller.dart';

class ItemCart extends StatefulWidget {
  ItemCart(this.cartOfKitchen, this.index1, this.cartItem, this.height,
      this.index, this.width,
      {super.key});
  final double height;
  final double width;
  final CartModel cartItem;
  final int index;
  final List<CartModel> cartOfKitchen;
  final int index1;

  @override
  State<ItemCart> createState() => _ItemCartState();
}

class _ItemCartState extends State<ItemCart> {
  CartController controller = Get.find<CartController>();
  bool checker = false;
  int count = 0;
  @override
  void initState() {
    count = widget.cartItem.quantity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.selectIndex.value == widget.index1 &&
        controller.cartOrder.length == widget.cartOfKitchen.length) {
      checker = true;
    } else if (controller.selectIndex.value != widget.index1 &&
        controller.cartOrder.isEmpty) {
      checker = false;
    } else if (controller.selectIndex.value != widget.index1 &&
        controller.cartOrder.isNotEmpty) {
      checker = false;
    }
    return Slidable(
      key: ValueKey(widget.index),
      endActionPane:
          ActionPane(extentRatio: 0.2, motion: const ScrollMotion(), children: [
        SlidableAction(
          onPressed: (BuildContext context) {
            controller.deleteCart(widget.cartItem.id).then((value) {});
          },
          backgroundColor: Colors.red,
          foregroundColor: Colors.grey,
          icon: Icons.delete,
        ),
      ]),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
              height: 0.05 * widget.width,
              width: 0.05 * widget.width,
              child: Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
                      value: checker,
                      onChanged: (value) {
                        if (controller.cartOrder.length > 1 &&
                            controller.selectIndex.value == widget.index1) {
                          if (value == false) {
                            controller.unChooseProduct(widget.cartItem);
                            controller.getApplyPromoCode();
                            controller.getApplyShipping();
                            setState(() {
                              checker = value!;
                            });
                          } else {
                            controller.chooseProduct(widget.cartItem);
                            controller.getApplyPromoCode();
                            controller.getApplyShipping();
                            setState(() {
                              checker = value!;
                            });
                          }
                        } else if (controller.cartOrder.length == 1 &&
                            controller.selectIndex.value == widget.index1) {
                          if (value == false) {
                            controller.selectIndex.value = -1;
                            controller.unChooseProduct(widget.cartItem);
                            controller.getApplyPromoCode();
                            controller.getApplyShipping();
                            setState(() {
                              checker = value!;
                            });
                          } else {
                            controller.chooseProduct(widget.cartItem);
                            controller.getApplyPromoCode();
                            controller.getApplyShipping();
                            setState(() {
                              checker = value!;
                            });
                          }
                        } else if (controller.cartOrder.isEmpty) {
                          controller.selectIndex.value = widget.index1;
                          controller.chooseProduct(widget.cartItem);
                          controller.getApplyPromoCode();
                          controller.getApplyShipping();
                          setState(() {
                            checker = true;
                          });
                        } else if (controller.cartOrder.isNotEmpty &&
                            controller.selectIndex.value != -1) {
                          controller.cartOrder = [];
                          controller.selectIndex.value = widget.index1;

                          controller.chooseProduct(widget.cartItem);
                          controller.getApplyPromoCode();
                          controller.getApplyShipping();
                          setState(() {
                            checker = true;
                          });
                        }
                      })),
            ),
          ),
          Container(
              width: widget.width * 0.95 - 10 * 3,
              padding: const EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: widget.height * 0.15 - 20,
                    width: widget.height * 0.15 - 20,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.cartItem.url),
                    ),
                  ),
                  SizedBox(
                    width: widget.width * 0.015,
                  ),
                  SizedBox(
                    height: widget.height * 0.15 - 20,
                    width: widget.width -
                        60 -
                        (widget.height * 0.175 - 20) -
                        widget.width * 0.015,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.cartItem.name,
                          style: const TextStyle(
                              fontSize: 23, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: widget.height * 0.025,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '${int.parse(widget.cartItem.price) * count} VNĐ',
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                width: widget.width * 0.21,
                                height: widget.height * 0.04,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context).primaryColor),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        width: widget.width * 0.08,
                                        height: widget.height * 0.04,
                                        alignment: Alignment.center,
                                        child: TextButton(
                                            onPressed: () {
                                              if (count > 1) {
                                                controller
                                                    .updateQuantity(
                                                        widget.cartItem,
                                                        count - 1)
                                                    .then((value) {
                                                  controller
                                                      .getApplyPromoCode();
                                                  controller.getApplyShipping();
                                                  setState(() {
                                                    count--;
                                                  });
                                                });
                                              }
                                            },
                                            child: const Text(
                                              '-',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ))),
                                    SizedBox(
                                        width: widget.width * 0.05,
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${count}',
                                              style:
                                                  const TextStyle(fontSize: 17),
                                            ))),
                                    Container(
                                      width: widget.width * 0.08,
                                      height: widget.height * 0.040,
                                      alignment: Alignment.center,
                                      child: TextButton(
                                          onPressed: () {
                                            controller
                                                .updateQuantity(
                                                    widget.cartItem, count + 1)
                                                .then((value) {
                                              controller.getApplyPromoCode();
                                              controller.getApplyShipping();
                                              setState(() {
                                                count++;
                                              });
                                            });
                                          },
                                          child: const Text(
                                            '+',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      ],
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
