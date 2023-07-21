import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/screen/Home_screen/View/pages/search_screen.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_dimens.dart';
import '../../../../config/app_font.dart';
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

    return WillPopScope(
      onWillPop: () async {
        controller.textEditing.text = '';
        controller.changeStatusEmpty();
        controller.getTrueIsMain();
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Obx(
            () => Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: AppDimens.dimens_30,
                    left: AppDimens.dimens_5,
                    right: AppDimens.dimens_5),
                child: SizedBox(
                  height: AppDimens.dimens_40,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            controller.textEditing.text = '';
                            controller.changeStatusEmpty();
                            controller.getTrueIsMain();
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
                                backgroundColor: ColorConstants.colorGrey2,
                              ),
                              onPressed: () {
                                controller.changeStatusEmpty();
                                controller
                                    .getSuggest(controller.textEditing.text);
                                Get.to(() => SearchScreen());
                              },
                              child: SizedBox(
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      const Icon(
                                        Icons.search,
                                        size: 35,
                                        color: ColorConstants.colorGrey4,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        controller.textEditing.text,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: AppFont.medium,
                                            color: ColorConstants.colorBlack),
                                      )
                                    ],
                                  )))),
                      Container(
                        color: ColorConstants.themeColor,
                        child: const Icon(
                          Icons.search,
                          size: AppDimens.dimens_40,
                          color: ColorConstants.colorWhite,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              controller.reload == true
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      padding: const EdgeInsets.only(
                          top: AppDimens.dimens_20,
                          right: AppDimens.dimens_10,
                          left: AppDimens.dimens_10),
                      height: (heightImage / 2) *
                              (3.05 / 2) *
                              (controller.getLenght(
                                      controller.kitchenSearch.length) /
                                  2) +
                          10,
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
    );
  }
}