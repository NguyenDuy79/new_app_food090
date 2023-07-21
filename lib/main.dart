import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:new_ap/config/app_colors.dart';
import 'package:new_ap/config/app_font.dart';
import 'package:new_ap/screen/Home_screen/View/tabs/home_screen.dart';
import 'package:new_ap/screen/Home_screen/binding/binding.dart';
import 'package:new_ap/screen/Login_screen/binding/login_binding.dart';
import 'package:new_ap/screen/Login_screen/view/auth_screen.dart';
import 'package:new_ap/screen/partner_screen/binding/binding.dart';
import 'package:new_ap/screen/partner_screen/view/partner_screen.dart';
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
          brightness: Brightness.light,
          fontFamily: AppFont.robotoCondensed,
          primarySwatch: MaterialColor(0xff39c166, ColorConstants.swatchColor),
          primaryColor: ColorConstants.themeColor,
          colorScheme: ColorScheme.fromSwatch().copyWith(error: Colors.red)),
      initialRoute: '/',
      getPages: [
        GetPage(
            name: '/partner',
            page: () => PartnerScreen(),
            binding: PartnerBinding()),
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
