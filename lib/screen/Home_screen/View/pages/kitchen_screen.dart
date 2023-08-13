import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_storage_path.dart';
import 'package:new_ap/screen/Search_Screen/home/search_kitchen_screen.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_dimens.dart';
import '../../../../config/app_font.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/main_controller.dart';
import '../../widgets/main_widget.dart/grid_kitchen.dart';

class KitchenScreen extends StatelessWidget {
  KitchenScreen({super.key});
  final MainController controller = Get.find<MainController>();
  @override
  Key? get key => const ValueKey('Key');
  @override
  Widget build(BuildContext context) {
    final heightImage = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          controller.textEditing.clear();
          controller.changeStatusEmpty();
          controller.getTrueIsMain();
          controller.getListQuery('');
          Get.find<CartController>().reduceCountScrenn();
          return true;
        },
        child: Scaffold(
          backgroundColor: ColorConstants.colorWhite,
          body: SingleChildScrollView(
            child: Obx(
              () => controller.kitchenSearch.isEmpty
                  ? Center(
                      child: SizedBox(
                          height: height * 0.6,
                          child: Image.asset(AppStoragePath.empty)),
                    )
                  : Column(children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(
                              top: AppDimens.dimens_30,
                              left: AppDimens.dimens_5,
                              right: AppDimens.dimens_25),
                          child: SizedBox(
                              height: AppDimens.dimens_40,
                              child: Row(
                                children: [
                                  IconButton(
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () {
                                        controller.textEditing.text = '';
                                        controller.changeStatusEmpty();
                                        controller.getListQuery('');
                                        controller.getTrueIsMain();
                                        Get.find<CartController>()
                                            .reduceCountScrenn();
                                        Get.back();
                                      },
                                      iconSize: AppDimens.dimens_30,
                                      icon: const Icon(
                                        Icons.arrow_back_ios,
                                        color: ColorConstants.themeColor,
                                      )),
                                  Expanded(
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor:
                                                ColorConstants.colorGrey2,
                                          ),
                                          onPressed: () {
                                            controller.changeStatusEmpty();
                                            controller.getSuggest(
                                                controller.textEditing.text);
                                            Get.to(() => SearchKitchenScreen());
                                          },
                                          child: SizedBox(
                                              height: 40,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  const Icon(
                                                    Icons.search,
                                                    size: 35,
                                                    color: ColorConstants
                                                        .colorGrey4,
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  controller.textEditing.text ==
                                                          ''
                                                      ? const Text(
                                                          'Search Product',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  AppFont
                                                                      .medium,
                                                              color: ColorConstants
                                                                  .colorGrey4))
                                                      : Text(
                                                          controller
                                                              .textEditing.text,
                                                          style: const TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  AppFont
                                                                      .medium,
                                                              color: ColorConstants
                                                                  .colorBlack),
                                                        )
                                                ],
                                              )))),
                                ],
                              ))),
                      controller.reload == true
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Container(
                              padding: const EdgeInsets.only(
                                top: AppDimens.dimens_20,
                              ),
                              height: (heightImage / 2) *
                                      (3.05 / 2) *
                                      (controller.getLenght(
                                              controller.kitchenSearch.length) /
                                          2) +
                                  20,
                              width: double.infinity,
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: AppDimens.dimens_20,
                                        childAspectRatio: 2 / 3.05),
                                itemBuilder: (ctx, i) => kitChenItem(
                                    controller,
                                    context,
                                    heightImage,
                                    controller.kitchenSearch[i],
                                    controller.kitchenSearch[i].imageUrl,
                                    controller.kitchenSearch[i].imagechefUrl,
                                    controller.kitchenSearch[i].name,
                                    controller.kitchenSearch[i].time,
                                    controller.kitchenSearch[i].ship,
                                    controller.kitchenSearch[i].intoduct),
                                itemCount: controller.kitchenSearch.length,
                              ),
                            ),
                    ]),
            ),
          ),
        ),
      ),
    );
  }
}
