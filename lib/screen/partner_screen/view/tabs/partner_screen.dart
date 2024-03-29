import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/screen/partner_screen/controller/partner_controller.dart';
import '../../../../config/app_dimens.dart';

// ignore: must_be_immutable
class PartnerScreen extends StatelessWidget {
  PartnerScreen({super.key});

  PartnerController controller = Get.put(PartnerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.colorWhite,
        body: Obx(() => controller.page[controller.selectedPage.value]),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            elevation: AppDimens.dimens_5,
            onTap: (index) {
              controller.selectPage(index);
            },
            backgroundColor: ColorConstants.colorGrey4,
            unselectedItemColor: ColorConstants.colorBlack,
            selectedItemColor: ColorConstants.themeColor,
            currentIndex: controller.selectedPage.value,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_outlined),
                  label: 'Receive purchase order'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.call_missed_outgoing_outlined),
                  label: 'Progress'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.message_outlined), label: 'Message'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.history_outlined), label: 'History'),
            ],
          ),
        ));
  }
}
