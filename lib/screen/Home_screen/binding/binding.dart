import 'package:get/get.dart';
import 'package:new_ap/screen/Home_screen/controllers/cart_controller.dart';
import 'package:new_ap/screen/Home_screen/controllers/message_controller.dart';
import 'package:new_ap/screen/Home_screen/controllers/orders_controller.dart';
import 'package:new_ap/screen/Home_screen/controllers/profile_controller.dart';

import '../controllers/main_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => MainController());
    Get.lazyPut(() => OrderController());
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => MessageController());
    //Get.put(HomeController());
    //Get.lazyPut(() => CartController());
    Get.put(CartController());
  }
}
