import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/config/app_dimens.dart';
import 'package:new_ap/config/app_storage_path.dart';
import 'package:new_ap/screen/Home_screen/controllers/main_controller.dart';

import '../../../../config/app_font.dart';

// ignore: must_be_immutable
class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({super.key});
  MainController controller = Get.find<MainController>();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.colorWhite,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: ColorConstants.themeColor,
          ),
        ),
        elevation: AppDimens.dimens_0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(right: AppDimens.dimens_25),
          child: Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: AppDimens.dimens_0,
                    backgroundColor: ColorConstants.colorGrey2,
                  ),
                  onPressed: () {
                    controller.changeStatusEmpty();
                    controller.getSuggest(controller.textEditing.text);
                    //Get.to(() => SearchScreen());
                  },
                  child: SizedBox(
                      height: AppDimens.dimens_40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Icon(
                            Icons.search,
                            size: AppDimens.dimens_35,
                            color: ColorConstants.colorGrey4,
                          ),
                          const SizedBox(
                            width: AppDimens.dimens_20,
                          ),
                          controller.textEditing.text == ''
                              ? const Text('Search Categories',
                                  style: TextStyle(
                                      fontSize: AppDimens.dimens_18,
                                      fontWeight: AppFont.medium,
                                      color: ColorConstants.colorGrey4))
                              : Text(
                                  controller.textEditing.text,
                                  style: const TextStyle(
                                      fontSize: AppDimens.dimens_18,
                                      fontWeight: AppFont.medium,
                                      color: ColorConstants.colorBlack),
                                )
                        ],
                      )))),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimens.dimens_15),
        child: Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 7 / 12,
                crossAxisSpacing: AppDimens.dimens_20),
            itemBuilder: ((context, index) {
              return Column(
                children: <Widget>[
                  SizedBox(
                    width: (width - AppDimens.dimens_20 * 4) / 4,
                    height: (width - AppDimens.dimens_20 * 4) / 4,
                    child: CircleAvatar(
                      backgroundImage: AssetImage(
                          AppStoragePath.categories[index]['image'] as String),
                    ),
                  ),
                  const SizedBox(
                    width: AppDimens.dimens_15,
                    height: AppDimens.dimens_15,
                  ),
                  FittedBox(
                    child: Text(
                      AppStoragePath.categories[index]['title'] as String,
                      style: const TextStyle(
                          fontSize: AppDimens.dimens_18,
                          fontWeight: AppFont.semiBold),
                    ),
                  )
                ],
              );
            }),
            itemCount: AppStoragePath.categories.length,
          ),
        ),
      ),
    );
  }
}
