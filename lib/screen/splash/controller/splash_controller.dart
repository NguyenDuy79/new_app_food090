import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  void _delay() {
    Future.delayed(const Duration(seconds: 2), () async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Get.offAllNamed('/home-screen');
      } else {
        Get.offAllNamed('/auth');
      }
    });
  }

  @override
  void onReady() {
    _delay();
    super.onReady();
  }
}
