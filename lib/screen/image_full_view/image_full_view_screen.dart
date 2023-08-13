import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/screen/image_full_view/image_view_controller.dart';

import '../../config/app_colors.dart';

class ImageFullViewScreen extends StatelessWidget {
  ImageFullViewScreen(this.tag, this.imageUrl, {super.key});
  final String tag;
  final String imageUrl;
  final ImageViewController controller = Get.put(ImageViewController());
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    controller.setHeight(height);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.colorWhite,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: ColorConstants.themeColor,
            )),
      ),
      body: Obx(
        () => Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedContainer(
              height: controller.height,
              width: width,
              curve: Curves.fastOutSlowIn,
              duration: const Duration(milliseconds: 0),
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (0 < details.delta.dy) {
                    controller.setFalseGestureUp();
                  } else {
                    controller.setTrueGestureUp();
                  }
                  controller.reduceHeight(details.delta.dy);
                  if (controller.height > (height)) {
                    controller.setHeight((height));
                  } else if (controller.height < height * 0.2) {
                    controller.setHeight(height * 0.2);
                  }
                },
                onVerticalDragEnd: (details) {
                  if (controller.gestureUp) {
                    controller.setHeight((height));
                  } else {
                    if (details.primaryVelocity! > 500 &&
                        controller.height <= height * 0.6) {
                      Get.back();
                    } else if (details.primaryVelocity! > 300 &&
                        controller.height > height * 0.6) {
                      controller.setHeight((height));
                    } else if (controller.height == height * 0.2) {
                      Get.back();
                    } else {
                      controller.setHeight(height);
                    }
                  }
                },
                child: Hero(
                  tag: tag,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
