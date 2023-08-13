import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/screen/Home_screen/controllers/message_controller.dart';

class ChatImageClickScreen extends StatefulWidget {
  const ChatImageClickScreen(this.url, {super.key});
  final String url;

  @override
  State<ChatImageClickScreen> createState() => _ChatImageClickScreenState();
}

class _ChatImageClickScreenState extends State<ChatImageClickScreen> {
  final MessageController controller = Get.find<MessageController>();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final double remaining =
        AppBar().preferredSize.height - MediaQuery.of(context).padding.top;
    return PageView.builder(
      reverse: true,
      onPageChanged: (value) {},
      controller: PageController(
          initialPage: controller.listImage
              .indexWhere((element) => element == widget.url)),
      itemCount: controller.listImage.length,
      itemBuilder: (context, index) {
        controller.setHeight(height);
        controller.setHeight1(height - remaining);
        return Obx(
          () => controller.isFill == true
              ? WillPopScope(
                  onWillPop: () async {
                    return true;
                  },
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedContainer(
                      height: controller.height,
                      width: width,
                      curve: Curves.fastOutSlowIn,
                      duration: const Duration(milliseconds: 0),
                      color: ColorConstants.colorBlack,
                      child: GestureDetector(
                        onTap: () {
                          controller.changeStatusFill();
                        },
                        onVerticalDragUpdate: (details) {
                          if (0 < details.delta.dy) {
                            controller.setFalseGestureUp();
                          } else {
                            controller.setTrueGestureUp();
                          }
                          controller.reduceHeight(details.delta.dy);
                          if (controller.height > height) {
                            controller.setHeight(height);
                          } else if (controller.height < height * 0.3) {
                            controller.setHeight(height * 0.3);
                          }
                        },
                        onVerticalDragEnd: (details) {
                          if (controller.gestureUp) {
                            controller.setHeight(height);
                          } else {
                            if (details.primaryVelocity! > 500 &&
                                controller.height <= height * 0.7) {
                              Get.back();
                            } else if (details.primaryVelocity! > 500 &&
                                controller.height > height * 0.7) {
                              controller.setHeight(height);
                            } else if (controller.height == height * 0.3) {
                              Get.back();
                            } else {
                              controller.setHeight(height);
                            }
                          }
                        },
                        child: Hero(
                          tag: controller.listImage[index],
                          child: Image.network(
                            controller.listImage[index],
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : WillPopScope(
                  onWillPop: () async {
                    controller.resetFill();
                    return true;
                  },
                  child: GestureDetector(
                    onTap: () {
                      controller.changeStatusFill();
                    },
                    onVerticalDragEnd: (details) {
                      if (details.primaryVelocity! > 10) {
                        controller.resetFill();
                        Get.back();
                      }
                    },
                    child: Scaffold(
                      backgroundColor: ColorConstants.colorWhite,
                      appBar: AppBar(
                        backgroundColor: ColorConstants.colorWhite,
                        elevation: 0,
                        leading: IconButton(
                            onPressed: () {
                              controller.resetFill();
                              Get.back();
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: ColorConstants.themeColor,
                            )),
                        actions: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.archive_outlined,
                                color: ColorConstants.themeColor,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.dehaze,
                                color: ColorConstants.themeColor,
                              ))
                        ],
                      ),
                      body: Align(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedContainer(
                          height: controller.height1,
                          width: width * 0.8,
                          curve: Curves.fastOutSlowIn,
                          duration: const Duration(milliseconds: 0),
                          child: GestureDetector(
                            onTap: () {
                              controller.changeStatusFill();
                            },
                            onVerticalDragUpdate: (details) {
                              if (0 < details.delta.dy) {
                                controller.setFalseGestureUp();
                              } else {
                                controller.setTrueGestureUp();
                              }
                              controller.reduceHeight1(details.delta.dy);
                              if (controller.height1 > (height - remaining)) {
                                controller.setHeight1((height - remaining));
                              } else if (controller.height1 < height * 0.2) {
                                controller.setHeight1(height * 0.2);
                              }
                            },
                            onVerticalDragEnd: (details) {
                              if (controller.gestureUp) {
                                controller.setHeight1((height - remaining));
                              } else {
                                if (details.primaryVelocity! > 500 &&
                                    controller.height1 <= height * 0.6) {
                                  Get.back();
                                } else if (details.primaryVelocity! > 300 &&
                                    controller.height1 > height * 0.6) {
                                  controller.setHeight1((height - remaining));
                                } else if (controller.height1 == height * 0.2) {
                                  Get.back();
                                } else {
                                  controller.setHeight1(height - remaining);
                                }
                              }
                            },
                            child: Hero(
                              tag: controller.listImage[index],
                              child: Image.network(
                                controller.listImage[index],
                                fit: BoxFit.contain,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
