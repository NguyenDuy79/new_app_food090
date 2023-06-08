import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ap/screen/Login_screen/controller/authController.dart';

class AuthSignUp extends GetView<LoginController> {
  const AuthSignUp(this.isLogin, this.width, {super.key});
  final RxBool isLogin;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: controller.loginFormKey,
        child: Column(children: <Widget>[
          TextFormField(
            key: const ValueKey('email'),
            validator: (value) {
              if (value!.isEmpty || !value.contains('@')) {
                return 'Please enter a valid email address';
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                hintText: 'Email ID',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.transparent)),
                filled: true,
                fillColor: Color(0xffeeeeee)),
            onSaved: (newValue) {
              controller.email = newValue!;
            },
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            key: const ValueKey('fullname'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a valid full name';
              }
              return null;
            },
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
                hintText: 'Full name',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.transparent)),
                filled: true,
                fillColor: Color(0xffeeeeee)),
            onSaved: (newValue) {
              controller.fullName = newValue!;
            },
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            key: const ValueKey('mobile'),
            validator: (value) {
              if (value!.isEmpty ||
                  value.length != 10 ||
                  !value.isPhoneNumber) {
                return 'Please enter a valid mobile number';
              }
              return null;
            },
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                hintText: 'Mobile',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.transparent)),
                filled: true,
                fillColor: Color(0xffeeeeee)),
            onSaved: (newValue) {
              controller.mobile = newValue!;
            },
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            key: const ValueKey('password'),
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty || value.length <= 6) {
                return 'Passwork must be at least 6 characters long.';
              }
              return null;
            },
            decoration: const InputDecoration(
                hintText: 'Pass Word',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.transparent)),
                filled: true,
                fillColor: Color(0xffeeeeee)),
            onSaved: (newValue) {
              controller.passWord = newValue!;
            },
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: (width - 20 * 2) * 0.5,
            height: 50,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () {
                  controller.onSave(context, isLogin.value);
                  controller.changeStatus();
                },
                child: Obx(() {
                  return controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text('Sign up',
                          style: TextStyle(color: Colors.white));
                })),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Joined us before?'),
              TextButton(
                  onPressed: () {
                    controller.changeStatus();
                  },
                  child: const Text('Log in'))
            ],
          )
        ]),
      ),
    );
  }
}
