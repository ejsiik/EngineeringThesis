import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();

  void registerUser(String email, String password) {
    String? error = Auth.instance.createUserWithEmailAndPassword(
        email: email.trim(), password: password.trim()) as String?;
    if (error != null) {
      Get.showSnackbar(GetSnackBar(
        message: error.toString(),
      ));
    }
  }
}

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();

  Future<void> login() async {
    String? error = await Auth.instance.signInWithEmailAndPassword(
        email: email.text.trim(), password: password.text.trim());
    if (error != null) {
      Get.showSnackbar(GetSnackBar(
        message: error.toString(),
      ));
    }
  }
}
