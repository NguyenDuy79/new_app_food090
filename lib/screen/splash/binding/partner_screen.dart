import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/screen/partner_screen/controller/partner_controller.dart';

class PartnerScreen extends StatelessWidget {
  PartnerScreen({super.key});

  PartnerController controller = Get.put(PartnerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            Obx(() => controller.page[controller.selectedPage.value] as Widget),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            elevation: 5,
            onTap: (index) {
              controller.selectPage(index);
            },
            backgroundColor: Colors.grey,
            unselectedItemColor: Colors.black,
            selectedItemColor: Theme.of(context).primaryColor,
            currentIndex: controller.selectedPage.value,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_outlined),
                  label: 'Receive purchase order'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.message_outlined), label: 'Message'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.call_missed_outgoing_outlined),
                  label: 'Progress'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.history_outlined), label: 'History'),
            ],
          ),
        ));
  }
}
