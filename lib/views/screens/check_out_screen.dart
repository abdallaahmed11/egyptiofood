import 'package:egyption_foods/constants/colors.dart';
import 'package:egyption_foods/constants/extensions.dart';
import 'package:egyption_foods/constants/strings.dart';
import 'package:egyption_foods/controllers/home_controller.dart';
import 'package:egyption_foods/models/food_model.dart';
import 'package:egyption_foods/views/screens/payment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckOutScreen extends GetWidget<HomeController> {
  const CheckOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<FoodModel> cartFoods = Get.arguments;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.lightBlueColor,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: 10.edgeInsetsAll,
          decoration: BoxDecoration(color: AppColors.lightParchmentToneColor, borderRadius: 15.borderRadiusTop),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(AppStrings.checkOutText, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors.titlesColor)),
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: cartFoods.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (_, int index) {
                    FoodModel food = cartFoods[index];
                    return Container(
                      padding: 10.edgeInsetsAll,
                      width: double.infinity,
                      decoration: BoxDecoration(color: AppColors.lightBlueColor, borderRadius: 15.borderRadiusAll),
                      child: Row(
                        children: [
                          Expanded(flex: 0, child: Image.network(food.image, width: 100)),
                          10.gap,
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(food.title, style: TextStyle(fontSize: 18, color: AppColors.titlesColor)),
                                Text(food.subTitle, style: TextStyle(color: AppColors.lightParchmentToneColor)),
                                GetBuilder<HomeController>(
                                  builder: (_) {
                                    return Text(
                                      AppStrings.priceText + AppStrings.colonSign + AppStrings.spaceSign + AppStrings.dollarSign + food.totalPrice.toString(),
                                      style: TextStyle(color: AppColors.lightParchmentToneColor),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          10.gap,
                          Expanded(
                            flex: 0,
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    food.count++;
                                    food.totalPrice = food.price * food.count;
                                    controller.getTotalPrice();
                                    controller.update();
                                  },
                                  child: Text("+", style: TextStyle(color: AppColors.lightParchmentToneColor, fontSize: 24, fontWeight: FontWeight.bold)),
                                ),
                                GetBuilder<HomeController>(
                                  builder: (_) {
                                    return Text(food.count.toString(), style: TextStyle(color: AppColors.lightParchmentToneColor, fontSize: 24, fontWeight: FontWeight.bold));
                                  },
                                ),
                                InkWell(
                                  onTap: () {
                                    if (food.count > 1) {
                                      food.count--;
                                      food.totalPrice = food.price * food.count;
                                      controller.getTotalPrice();
                                      controller.update();
                                    } else {
                                      AppStrings.countCanNotBeLessThenOneToast.showToast;
                                    }
                                  },
                                  child: Text("-", style: TextStyle(color: AppColors.lightParchmentToneColor, fontSize: 24, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          10.gap,
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (_, __) {
                    return 10.gap;
                  },
                ),
                10.gap,
                Align(
                  alignment: Alignment.centerLeft,
                  child: GetBuilder<HomeController>(
                    builder: (_) {
                      return Text(
                        AppStrings.totalPriceText + AppStrings.colonSign + AppStrings.spaceSign + controller.totalTotalPrice.toDouble().toString(),
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.lightBlueColor),
                      );
                    },
                  ),
                ),
                10.gap,
                InkWell(
                  onTap: () {
                    final nameController = TextEditingController();
                    final phoneController = TextEditingController();
                    final addressController = TextEditingController();

                    Get.bottomSheet(
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('معلومات التوصيل', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(labelText: 'اسم العميل'),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: phoneController,
                              decoration: InputDecoration(labelText: 'رقم الهاتف'),
                              keyboardType: TextInputType.phone,
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: addressController,
                              decoration: InputDecoration(labelText: 'العنوان'),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                final name = nameController.text.trim();
                                final phone = phoneController.text.trim();
                                final address = addressController.text.trim();

                                if (name.isEmpty || phone.isEmpty || address.isEmpty) {
                                  Get.snackbar(
                                    'خطأ',
                                    'من فضلك املى كل البيانات المطلوبة',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red.shade100,
                                    colorText: Colors.black,
                                    duration: Duration(seconds: 3),
                                  );
                                } else {
                                  Get.back(); // اقفل bottom sheet
                                  Get.to(() => Payment()); // روح على الدفع
                                }
                              },
                              child: Text('متابعة للدفع'),
                            ),
                          ],
                        ),
                      ),
                      isScrollControlled: true,
                    );
                  },

                  child: Container(
                    alignment: Alignment.center,
                    padding: 10.edgeInsetsAll,
                    decoration: BoxDecoration(color: AppColors.lightBlueColor, borderRadius: 15.borderRadiusAll, border: Border.all(color: AppColors.lightParchmentToneColor)),
                    child: Text(AppStrings.buyNowText, style: TextStyle(color: AppColors.lightParchmentToneColor)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
