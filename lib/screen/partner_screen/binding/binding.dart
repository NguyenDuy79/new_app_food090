import 'package:get/get.dart';

import 'package:new_ap/screen/partner_screen/controller/history_order_controller.dart';
import 'package:new_ap/screen/partner_screen/controller/message_partner_controller.dart';
import 'package:new_ap/screen/partner_screen/controller/order_now_controller.dart';
import 'package:new_ap/screen/partner_screen/controller/partner_controller.dart';

class PartnerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PartnerController());
    Get.lazyPut(() => OrderNowController());
    Get.lazyPut(() => HistoryController());
    Get.lazyPut(() => MessagePartnerController());
  }
}
