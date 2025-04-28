import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/payment_controller.dart';

// شاشة الدفع
class Payment extends StatelessWidget {
  const Payment({super.key});

  @override
  Widget build(BuildContext context) {
    // ربط الـ Controller هنا باستخدام Get.put
    final PaymentController controller = Get.put(PaymentController());

    return Scaffold(
      appBar: AppBar(title: Text('اختر طريقة الدفع')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            // عرض الخيارات باستخدام RadioListTile
            paymentOption('Cash on Delivery', 'cash', controller, 'assets/images/logo.png',),
            paymentOption('Credit / Debit Card', 'card', controller, 'assets/credit_card.png'),
            paymentOption('Vodafone Cash', 'vodafone', controller, 'assets/vodafone_cash.png'),
            paymentOption('PayPal', 'paypal', controller, 'assets/paypal.png'),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // هنا ستتم عملية الدفع
                controller.proceedToPayment(); // تنفيذ الدفع
                _processPayment(context); // محاكاة إتمام الدفع وعرض الرسالة
              },
              child: Text('متابعة'),
            ),
          ],
        ),
      ),
    );
  }

  // طريقة الدفع
  Widget paymentOption(String title, String value, PaymentController controller, String imagePath) {
    return Obx(() {
      return RadioListTile(
        title: Row(
          children: [
            Image.asset(imagePath, width: 30, height: 30), // إضافة الصورة
            SizedBox(width: 10),
            Text(title),
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
  void _processPayment(BuildContext context) {
    // محاكاة إتمام الدفع بعد 3 ثواني (يمكنك تغييره بناءً على وقت الدفع الفعلي)
    Future.delayed(Duration(seconds: 3), () {
      // الرسالة الأولى بعد الدفع
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.delivery_dining, color: Colors.green), // أيقونة دليفري
              SizedBox(width: 10),
              Text('Coming Soon...'),
            ],
          ),
          duration: Duration(seconds: 5), // الرسالة تظهر لمدة 5 ثواني
        ),
      );

      // بعد 5 دقائق (300 ثانية) يتم تغيير الرسالة
      Future.delayed(Duration(seconds: 300), () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green), // أيقونة تم الإتمام
                SizedBox(width: 10),
                Text('Order Completed'),
              ],
            ),
            duration: Duration(seconds: 3), // الرسالة تظهر لمدة 3 ثواني
          ),
        );
      });
    });
  }
}

// شاشات الدفع المتنوعة
class CashOnDeliveryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الدفع عند الاستلام')),
      body: Center(child: Text('تم اختيار الدفع عند الاستلام')),
    );
  }
}

class CreditCardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الدفع بالبطاقة')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'رقم البطاقة',
                hintText: 'أدخل رقم البطاقة',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'تاريخ الانتهاء',
                hintText: 'MM/YY',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'رمز الأمان (CVV)',
                hintText: 'أدخل رمز الأمان',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // هنا تقدر تبعت بيانات البطاقة للباك اند
              },
              child: Text('إتمام الدفع'),
            ),
          ],
        ),
      ),
    );
  }
}

class VodafoneCashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vodafone Cash')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'رقم فودافون كاش',
                hintText: 'أدخل رقم فودافون كاش',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'المبلغ المطلوب',
                hintText: 'أدخل المبلغ',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // هنا تقدر تبعت بيانات فودافون كاش للباك اند
              },
              child: Text('إتمام الدفع'),
            ),
          ],
        ),
      ),
    );
  }
}

class PaypalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PayPal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'إدخال بيانات حساب PayPal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'البريد الإلكتروني لحساب PayPal',
                hintText: 'أدخل بريدك الإلكتروني هنا',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'رقم الهاتف المرتبط بحساب PayPal',
                hintText: 'أدخل رقم الهاتف هنا',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // تنفيذ عملية الدفع أو التحويل إلى صفحة PayPal
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('تحويل إلى PayPal'),
                      content: Text('سيتم تحويلك الآن إلى صفحة PayPal للدفع.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // اغلق النافذة المنبثقة
                          },
                          child: Text('إلغاء'),
                        ),
                        TextButton(
                          onPressed: () {
                            // محاكاة تحويل إلى PayPal
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('تم تحويلك إلى PayPal')),
                            );
                          },
                          child: Text('موافقة'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('متابعة إلى PayPal'),
            ),
            SizedBox(height: 30),
            Center(
              child: Image.asset('assets/paypal_logo.png', width: 150), // شعار PayPal
            ),
          ],
        ),
      ),
    );
  }
}
