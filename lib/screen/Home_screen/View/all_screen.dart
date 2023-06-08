import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/screen/Home_screen/controllers/home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() =>
            controller.page[controller.selectedPage.value]['screen'] as Widget),
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
                  icon: Icon(Icons.home_outlined), label: 'Main'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.article_outlined), label: 'Order'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.message_outlined), label: 'Message'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
          ),
        ));
  }
}
