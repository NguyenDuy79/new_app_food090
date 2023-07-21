import 'dart:developer';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:new_ap/config/app_colors.dart';

class LoginController extends GetxController {
  final loginFormKey = GlobalKey<FormState>();
  final signInFormKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String emailSignIn = '';
  String passwordSignIn = '';
  String fullName = '';
  String mobile = '';
  RxBool isLogin = true.obs;
  final FocusNode _emailLoginFocus = FocusNode();
  FocusNode get emailLoginFocus => _emailLoginFocus;
  final FocusNode _passWorkLoginFocus = FocusNode();
  FocusNode get passWorkLoginFocus => _passWorkLoginFocus;
  final FocusNode _emailSigninFocus = FocusNode();
  FocusNode get emailSigninFocus => _emailSigninFocus;
  final FocusNode _passworkSigninFocus = FocusNode();
  FocusNode get passworkSigninFocus => _passworkSigninFocus;
  final FocusNode _mobileFocus = FocusNode();
  FocusNode get mobileFocus => _mobileFocus;
  final FocusNode _fullNameFocus = FocusNode();
  FocusNode get fullNameFocus => _fullNameFocus;

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: ColorConstants.colorBlack,
      content: Text(
        content,
        style: const TextStyle(
            color: ColorConstants.colorRed2, letterSpacing: 0.5),
      ),
    );
  }

  RxBool isLoading = false.obs;
  changeIsLoading() => isLoading.toggle();
  final _auth = FirebaseAuth.instance;
  // ignore: unused_field
  final _facebookLogin = FacebookAuthProvider();

  void loginInWithEmailAndPassword(
      String email, String password, BuildContext ctx) async {
    // ignore: unused_local_variable
    UserCredential authResult;
    try {
      changeIsLoading();
      authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      Get.offNamed('/home-screen');
      changeIsLoading();
    } on FirebaseAuthException catch (err) {
      changeIsLoading();
      var message = 'An error occurred, please check your credentials';
      if (err.message != null) {
        message = err.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(customSnackBar(content: message));
    } catch (err) {
      changeIsLoading();
      rethrow;
    }
  }

  void createUserWithEmailAndPassword(String email, String password,
      String mobile, String fullName, BuildContext ctx) async {
    UserCredential authResult;
    try {
      changeIsLoading();
      authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user!.uid)
          .set({
        'id': authResult.user!.uid,
        'username': fullName,
        'email': email,
        'mobile': mobile,
        'image':
            'https://firebasestorage.googleapis.com/v0/b/newapp-91776.appspot.com/o/user.png?alt=media&token=daacc737-9f4d-4b74-9b32-f083089ace0a',
        'partner': false
      }).then((value) async {
        authResult = await _auth.signInWithEmailAndPassword(
            email: emailSignIn, password: passwordSignIn);
      }).then((value) {
        changeIsLoading();
        Get.offNamed('/home-screen');
      });
    } on PlatformException catch (err) {
      changeIsLoading();
      var message = 'An error occurred, please check your credentials';
      if (err.message != null) {
        message = err.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).colorScheme.error,
      ));
    } catch (err) {
      changeIsLoading();
      log(err.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // ignore: unused_local_variable
    UserCredential? userCredential;
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      try {
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'id': userCredential.user!.uid,
          'username': userCredential.user!.displayName,
          'email': userCredential.user!.email,
          'mobile': userCredential.user!.phoneNumber == null
              ? '0'
              : userCredential.user!.phoneNumber.toString(),
          'image': userCredential.user!.photoURL,
          'partner': false
        });

        Get.offNamed('/home-screen');
      } on FirebaseAuthException catch (e) {
        Get.snackbar('error', '$e');
      }
    }
  }

  Future<UserCredential> loginWithFaceBook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      await FacebookAuth.instance.getUserData();
    } else {
      Get.snackbar('error', result.message.toString());
    }
    final OAuthCredential facebookAuthCrendential =
        FacebookAuthProvider.credential(result.accessToken!.token);
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCrendential);
  }

  void onSave(BuildContext ctx, bool isLogin) {
    if (isLogin) {
      final isValid = loginFormKey.currentState!.validate();
      if (isValid) {
        loginFormKey.currentState!.save();
        loginInWithEmailAndPassword(email, password, ctx);
      }
    } else {
      final isValidSignIn = signInFormKey.currentState!.validate();
      if (isValidSignIn) {
        signInFormKey.currentState!.save();
        createUserWithEmailAndPassword(
            emailSignIn, passwordSignIn, mobile, fullName, ctx);
      }
    }
  }
}
