import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import 'package:new_ap/screen/Home_screen/View/home_screen.dart';
import 'package:new_ap/screen/Home_screen/binding/binding.dart';
import 'package:new_ap/screen/Login_screen/binding/login_binding.dart';
import 'package:new_ap/screen/Login_screen/view/auth_screen.dart';

import 'package:new_ap/screen/splash/binding/splash_binding.dart';
import 'package:new_ap/screen/splash/view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.green,
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: const Color(0xff333333)),
          buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.green,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)))),
      initialRoute: '/',
      getPages: [
        GetPage(
            name: '/auth', page: () => AuthScreen(), binding: LoginBinding()),
        GetPage(
            name: '/home-screen',
            page: () => HomeScreen(),
            binding: HomeBinding()),
        GetPage(
            name: '/', page: () => SplashScreen(), binding: SplashBinding()),
      ],
    );
  }
}
