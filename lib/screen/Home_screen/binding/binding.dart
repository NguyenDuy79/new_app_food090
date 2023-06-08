import 'package:get/get.dart';
import 'package:new_ap/screen/Home_screen/controllers/cart_controller.dart';
import 'package:new_ap/screen/Home_screen/controllers/orders_controller.dart';

import '../controllers/Main_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => MainController());
    Get.lazyPut(() => OrderController());
    Get.put(MainController());
    //Get.put(HomeController());
    //Get.lazyPut(() => CartController());
    Get.put(CartController());
  }
}
