import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/strings.dart';
import '../views/screens/payment.dart';

class PaymentController extends GetxController {
  RxString selectedMethod = 'cash'.obs;

  void updatePaymentMethod(String method) {
    selectedMethod.value = method;
  }

  void proceedToPayment() {
    if (selectedMethod.value == 'cash') {
      Get.snackbar(
        'Delivery',
        'Your delivery is coming now!',
        backgroundColor: Color(0xFFE0F7FA),
        colorText: Colors.black,
        icon: Icon(Icons.delivery_dining, color: Colors.green),
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        duration: Duration(seconds: 2),
      );

      Future.delayed(Duration(seconds: 2), () {
        Get.offAllNamed(AppStrings.splashRoute);
      });

    } else if (selectedMethod.value == 'card') {
      Get.to(CreditCardScreen());
    } else if (selectedMethod.value == 'vodafone') {
      Get.to(VodafoneCashScreen());
    } else {
      Get.to(PaypalScreen());
    }
  }

}
