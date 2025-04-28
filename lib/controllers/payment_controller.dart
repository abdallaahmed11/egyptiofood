import 'package:get/get.dart';

import '../views/screens/payment.dart';

class PaymentController extends GetxController {
  RxString selectedMethod = 'cash'.obs;

  void updatePaymentMethod(String method) {
    selectedMethod.value = method;
  }

  void proceedToPayment() {
    if (selectedMethod.value == 'cash') {
      Get.to(CashOnDeliveryScreen());
    } else if (selectedMethod.value == 'card') {
      Get.to(CreditCardScreen());
    } else if (selectedMethod.value == 'vodafone') {
      Get.to(VodafoneCashScreen());
    } else {
      Get.to(PaypalScreen());
    }
  }
}
