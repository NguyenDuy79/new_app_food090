import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_ap/config/app_another.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/config/app_dimens.dart';
import 'package:new_ap/config/firebase_api.dart';
import 'package:new_ap/model/rate_and_comment_model.dart';
import 'package:new_ap/model/user_model.dart';
import 'package:new_ap/screen/Home_screen/View/pages/edit_profile_screen.dart';

import '../../../common_app/common_widget.dart';

class ProfileController extends GetxController {
  ValueNotifier<bool> _isOldPassword = ValueNotifier(true);
  final Rx<UserModel> _user = UserModel(
    id: '',
    email: '',
    image: '',
    mobile: '',
    userName: '',
  ).obs;
  ValueNotifier<bool> get isOldPassword => _isOldPassword;

  UserModel updateUser = UserModel(
    id: '',
    email: '',
    image: '',
    mobile: '',
    userName: '',
  );
  UserModel get user => _user.value;
  File? _storeImage;
  File? get storeImage => _storeImage;
  String newPassword = '';
  String oldPassword = '';
  RxBool isOldPasswordObscure = true.obs;
  RxBool isNewPasswordObscure = true.obs;
  RxBool isChangePasswordLoading = false.obs;
  final editProfile = GlobalKey<FormState>();
  final oldPasswordKey = GlobalKey<FormState>();
  final newPasswordKey = GlobalKey<FormState>();
  final Rx<List<RateAndCommentModel>> _rateAndComment =
      Rx<List<RateAndCommentModel>>([]);
  List<RateAndCommentModel> get rateAndComment => _rateAndComment.value;
  final Rx<List<Favorite>> _favorite = Rx<List<Favorite>>([]);
  List<Favorite> get favorite => _favorite.value;
  @override
  void onInit() {
    if (FirebaseAuth.instance.currentUser != null) {
      _user.bindStream(getUser(FirebaseAuth.instance.currentUser!.uid));
      _rateAndComment.bindStream(getRateAndComment(AppAnother.userAuth!.uid));
      _favorite.bindStream(getFavoriteStream(AppAnother.userAuth!.uid));
    }

    super.onInit();
  }

  changeStatusOld() {
    isOldPasswordObscure.value = !isOldPasswordObscure.value;
    update();
  }

  changeStatusNew() {
    isNewPasswordObscure.value = !isNewPasswordObscure.value;
    update();
  }

  ImageProvider<Object> getImage() {
    if (_storeImage != null) {
      return FileImage(storeImage!);
    } else {
      return NetworkImage(
        user.image,
      );
    }
  }

  Stream<List<RateAndCommentModel>> getRateAndComment(String uid) {
    return FirebaseApi()
        .reviewCollection(uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((event) {
      List<RateAndCommentModel> listRateAndComment = [];
      for (int i = 0; i < event.docs.length; i++) {
        listRateAndComment.add(RateAndCommentModel.fromJson(
            event.docs[i].data() as Map<String, dynamic>));
      }
      return listRateAndComment;
    });
  }

  Stream<List<Favorite>> getFavoriteStream(String uid) {
    return FirebaseApi().favoriteCollection(uid).snapshots().map((event) {
      List<Favorite> favoriteStream = [];
      for (int i = 0; i < event.docs.length; i++) {
        favoriteStream.add(
            Favorite.fromJson(event.docs[i].data() as Map<String, dynamic>));
      }
      return favoriteStream;
    });
  }

  Stream<UserModel> getUser(String uid) {
    return FirebaseApi().userCollection.doc(uid).snapshots().map((event) {
      UserModel userStream =
          UserModel.fromJson(event.data() as Map<String, dynamic>);
      return userStream;
    });
  }

  Future<void> takePictureCamera() async {
    final imageFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxHeight: 400, maxWidth: 400);
    if (imageFile == null) {
      return;
    }
    _storeImage = File(imageFile.path);
    update();
  }

  onSaveOldPassword(BuildContext ctx) async {
    final isValid = oldPasswordKey.currentState!.validate();
    // ignore: unused_local_variable
    UserCredential authResult;
    if (isValid) {
      oldPasswordKey.currentState!.save();
      try {
        isChangePasswordLoading.value = true;
        authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _user.value.email, password: oldPassword);
        _isOldPassword = ValueNotifier(false);
      } on PlatformException catch (err) {
        var message = 'An error occurred, please check your credentials';
        if (err.message != null) {
          message = err.message!;
        }
        ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).colorScheme.error,
        ));
      } catch (err) {
        ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(err.toString()),
          backgroundColor: Theme.of(ctx).colorScheme.error,
        ));
      }
      isChangePasswordLoading.value = false;
    }
  }

  onSaveNewPassword(ctx) {
    final isValid = newPasswordKey.currentState!.validate();
    if (isValid) {
      newPasswordKey.currentState!.save();
      try {
        isChangePasswordLoading.value = false;
        FirebaseAuth.instance.currentUser!
            .updatePassword(newPassword)
            .then((value) {
          Get.off(() => EditProfile());
        });
      } on PlatformException catch (err) {
        Get.back();
        log(err.message.toString());
        // ignore: use_build_context_synchronously
        CommonWidget.showErrorDialog(ctx);
      } catch (err) {
        Get.back();
        // ignore: use_build_context_synchronously
        CommonWidget.showErrorDialog(ctx);
      }
      isChangePasswordLoading.value = false;
    }
  }

  onSave() async {
    final isValid = editProfile.currentState!.validate();
    if (isValid) {
      editProfile.currentState!.save();
      if (FirebaseAuth.instance.currentUser != null) {
        try {
          FirebaseAuth.instance.currentUser!.updateEmail(updateUser.email);
          if (_storeImage != null) {
            var ref = FirebaseStorage.instance.ref().child('image_user').child(
                '${FirebaseAuth.instance.currentUser!.uid}${DateTime.now()}.png');
            await ref.putFile(storeImage!);
            final url = await ref.getDownloadURL();

            await FirebaseApi()
                .userCollection
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({
              'email': updateUser.email,
              'username': updateUser.userName,
              'mobile': updateUser.mobile,
              'image': url
            });
          } else {
            await FirebaseApi()
                .userCollection
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({
              'email': updateUser.email,
              'username': updateUser.userName,
              'mobile': updateUser.mobile.toString(),
              'image': _user.value.image
            });
          }
        } on FirebaseAuthException catch (err) {
          var message = 'An error occurred, please check your credentials';
          if (err.message != null) {
            message = err.message!;
          }
          Get.snackbar('Faile', message);
        } catch (err) {
          Get.snackbar('Fail', err.toString());
        }
      }
    }
  }

  getPartner(BuildContext ctx) {
    if (_user.value.partner == false) {
      showDialog(
          context: ctx,
          builder: (ctx) => AlertDialog(
                backgroundColor: ColorConstants.colorTransparent,
                title: const Text(
                  'Bạn không phải là đối tác của chúng tôi',
                  style: TextStyle(fontSize: AppDimens.dimens_22),
                ),
                content: const Text(
                  'Chở thành đối tác',
                  style: TextStyle(
                      fontSize: AppDimens.dimens_25,
                      fontWeight: FontWeight.bold),
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      if (FirebaseAuth.instance.currentUser != null) {
                        await FirebaseApi()
                            .userCollection
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({'partner': true}).then((value) async {
                          await FirebaseApi()
                              .partner
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .set({
                            'id': FirebaseAuth.instance.currentUser!.uid,
                            'date': DateTime.now().toIso8601String()
                          });

                          Get.back();
                          Get.offNamed('/partner');
                        });
                      }
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('No'),
                  )
                ],
              ));
    } else {
      Get.offNamed('/partner');
    }
  }

  String getBooked(int index) {
    String value = '';
    for (int i = 0; i < rateAndComment[index].quantity.length; i++) {
      if (rateAndComment[index].quantity[i] == 1) {
        value = value + rateAndComment[index].name[i];
      } else {
        value =
            '$value${rateAndComment[index].name[i]} x ${rateAndComment[index].quantity[i]} ';
      }
    }
    return value;
  }

  Map<String, dynamic> getIcon(String id) {
    if (Get.find<ProfileController>().favorite.isEmpty) {
      return {
        'icon': Icons.favorite_border,
        'color': ColorConstants.themeColor
      };
    } else {
      List<String> allId = [];
      for (var item in Get.find<ProfileController>().favorite) {
        allId.add(item.id);
      }
      if (allId.contains(id)) {
        return {'icon': Icons.favorite, 'color': ColorConstants.colorRed1};
      } else {
        return {
          'icon': Icons.favorite_border,
          'color': ColorConstants.themeColor
        };
      }
    }
  }

  Future<void> favoriteMethod(String kitchenId, BuildContext ctx) async {
    Timestamp timestamp = Timestamp.now();
    if (AppAnother.userAuth != null) {
      try {
        if (Get.find<ProfileController>().favorite.isEmpty) {
          await FirebaseApi()
              .favoriteCollection(AppAnother.userAuth!.uid)
              .doc(kitchenId)
              .set({'id': kitchenId, 'timestamp': timestamp});
          await FirebaseApi()
              .favoriteKitchenCollection(kitchenId)
              .doc(AppAnother.userAuth!.uid)
              .set({'id': AppAnother.userAuth!.uid, 'timestamp': timestamp});
        } else {
          List<String> allId = [];
          for (var item in Get.find<ProfileController>().favorite) {
            allId.add(item.id);
          }
          if (allId.contains(kitchenId)) {
            await FirebaseApi()
                .favoriteCollection(AppAnother.userAuth!.uid)
                .doc(kitchenId)
                .delete();
            await FirebaseApi()
                .favoriteKitchenCollection(kitchenId)
                .doc(AppAnother.userAuth!.uid)
                .delete();
          } else {
            await FirebaseApi()
                .favoriteCollection(AppAnother.userAuth!.uid)
                .doc(kitchenId)
                .set({'id': kitchenId, 'timestamp': timestamp});
            await FirebaseApi()
                .favoriteKitchenCollection(kitchenId)
                .doc(AppAnother.userAuth!.uid)
                .set({'id': AppAnother.userAuth!.uid, 'timestamp': timestamp});
          }
        }
      } on PlatformException catch (err) {
        Get.back();
        log(err.message.toString());

        CommonWidget.showErrorDialog(ctx);
      } catch (err) {
        CommonWidget.showErrorDialog(ctx);
      }
    }
  }
}
