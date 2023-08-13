import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:new_ap/model/cart_model.dart';
import 'package:new_ap/screen/Home_screen/controllers/cart_controller.dart';

import '../../../../config/app_dimens.dart';

class ItemCart extends StatefulWidget {
  const ItemCart(this.cartOfKitchen, this.index1, this.cartItem, this.height,
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
  void didChangeDependencies() {
    count = widget.cartItem.quantity;
    super.didChangeDependencies();
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
        endActionPane: ActionPane(
            extentRatio: 0.2,
            motion: const ScrollMotion(),
            children: [
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
              padding: const EdgeInsets.only(left: AppDimens.dimens_10),
              child: SizedBox(
                height: AppDimens.dimens_30,
                width: AppDimens.dimens_30,
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
                      }),
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.all(AppDimens.dimens_10),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      height: AppDimens.dimens_110,
                      width: AppDimens.dimens_110,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(widget.cartItem.url),
                      ),
                    ),
                    const SizedBox(
                      width: AppDimens.dimens_10,
                    ),
                    SizedBox(
                      height: AppDimens.dimens_110,
                      width: widget.width - AppDimens.dimens_190,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          FittedBox(
                            child: Text(
                              widget.cartItem.name,
                              style: const TextStyle(
                                  fontSize: AppDimens.dimens_23,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: AppDimens.dimens_30,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                FittedBox(
                                  child: Text(
                                    '${int.parse(widget.cartItem.price) * count} VNĐ',
                                    style: const TextStyle(
                                        fontSize: AppDimens.dimens_17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  width: AppDimens.dimens_90,
                                  height: AppDimens.dimens_35,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          AppDimens.dimens_10),
                                      color: Theme.of(context).primaryColor),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                          width: AppDimens.dimens_25,
                                          height: AppDimens.dimens_35,
                                          alignment: Alignment.center,
                                          child: TextButton(
                                              onPressed: () {
                                                if (count > 1) {
                                                  controller
                                                      .updateQuantity(
                                                          widget.cartItem,
                                                          count - 1,
                                                          context)
                                                      .then((value) {
                                                    controller
                                                        .getApplyPromoCode();
                                                    controller
                                                        .getApplyShipping();
                                                    setState(() {
                                                      count--;
                                                    });
                                                  });
                                                }
                                              },
                                              child: const FittedBox(
                                                child: Text(
                                                  '-',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ))),
                                      SizedBox(
                                          width: AppDimens.dimens_40,
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: FittedBox(
                                                child: Text(
                                                  count.toString(),
                                                  style: const TextStyle(
                                                      fontSize:
                                                          AppDimens.dimens_17),
                                                ),
                                              ))),
                                      Container(
                                        width: AppDimens.dimens_25,
                                        height: AppDimens.dimens_35,
                                        alignment: Alignment.center,
                                        child: TextButton(
                                            onPressed: () {
                                              controller
                                                  .updateQuantity(
                                                      widget.cartItem,
                                                      count + 1,
                                                      context)
                                                  .then((value) {
                                                controller.getApplyPromoCode();
                                                controller.getApplyShipping();
                                                setState(() {
                                                  count++;
                                                });
                                              });
                                            },
                                            child: const FittedBox(
                                              child: Text(
                                                '+',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        AppDimens.dimens_18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
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
        ));
  }
}
