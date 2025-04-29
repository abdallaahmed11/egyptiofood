import 'package:egyption_foods/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/strings.dart';
import '../../controllers/payment_controller.dart';

// شاشة الدفع
class Payment extends StatelessWidget {
  const Payment({super.key});

  @override
  Widget build(BuildContext context) {
    // ربط الـ Controller هنا باستخدام Get.put
    final PaymentController controller = Get.put(PaymentController());

    return Scaffold(
      backgroundColor: AppColors.lightBlueColor,

      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.lightParchmentToneColor),
        title: Text('Foods Chatbot',style: TextStyle(color: AppColors.lightParchmentToneColor),),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.more_vert)),

        ],),      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            // عرض الخيارات باستخدام RadioListTile
            paymentOption('Cash on Delivery', 'cash', controller, 'assets/images/logo.png',),
            paymentOption('Credit / Debit Card', 'card', controller, 'assets/images/credit.png'),
            paymentOption('Vodafone Cash', 'vodafone', controller, 'assets/images/vodafone.png'),
            paymentOption('PayPal', 'paypal', controller, 'assets/images/paypal.png'),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // هنا ستتم عملية الدفع
                controller.proceedToPayment(); // تنفيذ الدفع
                // محاكاة إتمام الدفع وعرض الرسالة
              },
              child: Text('Next process'),
            ),
          ],
        ),
      ),
    );
  }

  // طريقة الدفع
  Widget paymentOption(String title, String value, PaymentController controller, String imagePath,) {
    return Obx(() {
      return RadioListTile(
        title: Row(
          children: [
            Image.asset(imagePath, width: 50, height: 30), // إضافة الصورة
            SizedBox(width: 10),
            Text(title,style: TextStyle(color: Colors.white),),

          ],
        ),
        value: value,
        groupValue: controller.selectedMethod.value, // استخدام القيمة من الـ Controller
        onChanged: (val) {
          controller.updatePaymentMethod(val.toString());
        },
      );
    });
  }

  // محاكاة عملية الدفع وعرض الرسالة

}

// شاشات الدفع المتنوعة


class CreditCardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Card payment', style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/Visa1.png', width: 70),
                  SizedBox(width: 10),
                  Image.asset('assets/images/mastercard.png', width: 50),
                  SizedBox(width: 10),
                ],
              ),
              SizedBox(height: 30),
              buildTextField(label: 'Number of card', hint: '0xxxxxx'),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: buildTextField(label: 'Expiration date', hint: 'MM/YY'),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: buildTextField(label: ' (CVV)', hint: 'CVV', obscureText: true),
                  ),
                ],
              ),
              SizedBox(height: 16),
              buildTextField(label: "Cardholder's name", hint: 'Type your name on the card'),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1565C0),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Get.snackbar(
                    'Delivery',
                    'Your delivery is coming now!',
                    backgroundColor: Color(0xFFE0F7FA),
                    colorText: Colors.black,
                    icon: Icon(Icons.delivery_dining, color: Colors.green),
                    snackPosition: SnackPosition.TOP,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    duration: Duration(seconds: 3),
                  );

                  Future.delayed(Duration(seconds: 2), () {
                    Get.offNamed(AppStrings.homeRoute);
                    // غير HomeScreen دي بالصفحة الرئيسية عندك
                  });
                },

                child: Text('Complete payment', style: TextStyle(fontSize: 18,color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({required String label, required String hint, bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}




class VodafoneCashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Vodafone Cash Payment'),
        backgroundColor: Colors.red, // اللون الأحمر المشهور لفودافون
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              'assets/images/vodafone.png', // حط اللوجو هنا
              height: 30,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان الرئيسي
              Text(
                'Complete Your Payment with Vodafone Cash',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red, // استخدام اللون الأحمر لفودافون
                ),
              ),
              SizedBox(height: 20),

              // رقم فودافون كاش
              TextField(
                decoration: InputDecoration(
                  labelText: 'Vodafone Cash Number',
                  hintText: 'Enter your Vodafone Cash number',
                  prefixIcon: Icon(Icons.phone_android, color: Colors.red),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 16),

              // المبلغ المطلوب
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount to Pay',
                  hintText: 'Enter the amount',
                  prefixIcon: Icon(Icons.attach_money, color: Colors.red),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 30),

              // زر الدفع
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // لون الزر الأحمر
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Get.snackbar(
                    'Delivery',
                    'Your delivery is coming now!',
                    backgroundColor: Color(0xFFE0F7FA),
                    colorText: Colors.black,
                    icon: Icon(Icons.delivery_dining, color: Colors.green),
                    snackPosition: SnackPosition.TOP,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    duration: Duration(seconds: 3),
                  );

                  Future.delayed(Duration(seconds: 2), () {
                    Get.offNamed(AppStrings.homeRoute);
                    // غير HomeScreen دي بالصفحة الرئيسية عندك
                  });
                },

                child: Text(
                  'Complete Payment',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),

              // رسالة توجيهية صغيرة بعد الدفع
              Center(
                child: Text(
                  'Make sure to enter your Vodafone Cash number and the amount correctly.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




class PaypalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('PayPal Payment'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent, // لون PayPal الأساسي
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/paypal.png', // حط هنا اللوجو بتاعك
              height: 30,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your PayPal account details',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20),

              // TextField للبريد الإلكتروني
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'PayPal Email',
                  hintText: 'Enter your PayPal email',
                  prefixIcon: Icon(Icons.email, color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 16),

              // TextField لرقم الهاتف
              TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter your phone number',
                  prefixIcon: Icon(Icons.phone, color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 30),

              // زر متابعة الدفع
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Redirecting to PayPal'),
                          content: Text('You will be redirected to PayPal to complete the payment.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Redirected to PayPal')),
                                );
                              },
                              child: Text('Proceed'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    'Continue to PayPal',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 40),

              // اللوجو بتاع PayPal
              Center(
                child: Image.asset(
                  'assets/images/paypal.png',
                  width: 150,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
