import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:egyption_foods/constants/extensions.dart';
import 'package:egyption_foods/constants/strings.dart';
import 'package:egyption_foods/models/services/auth_services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  bool obscure = true;
  bool isLoading = false;
  bool isLoginClicked = false;
  String email = AppStrings.emptySign;
  String password = AppStrings.emptySign;
  GlobalKey<FormState> loginFormStateKey = GlobalKey<FormState>();

  /// To reset all fields.
  void resetFields() {
    email = AppStrings.emptySign;
    password = AppStrings.emptySign;
    update();
  }

  /// To check the fields after the user click submit.
  void checkFields() {
    if (isLoginClicked) {
      loginFormStateKey.currentState!.validate();
    }
    update();
  }

  /// To login, and check if the user is on guest account or not to.
  Future<void> login() async {
    isLoading = true;
    isLoginClicked = true;
    checkFields();
    if (loginFormStateKey.currentState!.validate()) {
      loginFormStateKey.currentState!.save();
      dynamic loginResponse = await FirebaseAuthService().login(email, password);
      if (loginResponse is User) {
        Get.offNamed(AppStrings.splashRoute);
      } else {
        loginResponse.toString().showToast;
      }
    }
    isLoading = false;
    update();
  }

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
     await FirebaseAuth.instance.signInWithCredential(credential);
      Get.offNamed(AppStrings.homeRoute);

  }
}
