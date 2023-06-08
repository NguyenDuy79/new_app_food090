import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  final loginFormKey = GlobalKey<FormState>();
  String email = '';
  String passWord = '';
  String fullName = '';
  String mobile = '';
  RxBool isLogin = true.obs;
  void changeStatus() {
    isLogin.toggle();
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  RxBool isLoading = false.obs;
  changeIsLoading() => isLoading.toggle();
  final _auth = FirebaseAuth.instance;
  final _facebookLogin = FacebookAuthProvider();

  void signInWithEmailAndPassword(
      String email, String password, BuildContext ctx) async {
    UserCredential authResult;
    try {
      authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      Get.offNamed('/home-screen');
    } on FirebaseAuthException catch (err) {
      var message = 'An error occurred, please check your credentials';
      if (err.message != null) {
        message = err.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(customSnackBar(content: message));
    } catch (err) {}
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
      });
      authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      changeIsLoading();
      Get.offNamed('/home-screen');
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials';
      if (err.message != null) {
        message = err.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).colorScheme.error,
      ));
    } catch (err) {
      print(err);
    }
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
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
          'username': userCredential.user!.displayName,
          'email': userCredential.user!.email,
          'mobile': userCredential.user!.phoneNumber,
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
    final isValid = loginFormKey.currentState!.validate();
    if (isValid) {
      loginFormKey.currentState!.save();
      if (isLogin) {
        signInWithEmailAndPassword(email, passWord, ctx);
      } else {
        createUserWithEmailAndPassword(email, passWord, mobile, fullName, ctx);
      }
    }
  }
}
