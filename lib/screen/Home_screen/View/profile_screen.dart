import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        child: Text('Log out'),
        onPressed: () {
          FirebaseAuth.instance.signOut();
          Get.offNamed('/auth');
        },
      ),
    );
  }
}
