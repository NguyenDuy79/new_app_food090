import 'package:get/get.dart';
import 'package:new_ap/screen/Login_screen/controller/authController.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}
