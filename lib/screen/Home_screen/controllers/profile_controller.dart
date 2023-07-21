import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/config/app_dimens.dart';
import 'package:new_ap/config/firebase_api.dart';
import 'package:new_ap/model/user_model.dart';
import 'package:new_ap/screen/Home_screen/View/pages/edit_profile_screen.dart';

class ProfileController extends GetxController {
  ValueNotifier<bool> _isOldPassword = ValueNotifier(true);
  final Rx<UserModel> _user =
      UserModel(id: '', email: '', image: '', mobile: '', userName: '').obs;
  ValueNotifier<bool> get isOldPassword => _isOldPassword;

  UserModel updateUser =
      UserModel(id: '', email: '', image: '', mobile: '', userName: '');
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
  @override
  void onInit() {
    if (FirebaseAuth.instance.currentUser != null) {
      _user.bindStream(getUser(FirebaseAuth.instance.currentUser!.uid));
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
        var message = 'An error, try again';
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
                          Get.toNamed('/partner');
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
      Get.toNamed('/partner');
    }
  }
}
