import 'package:egyption_foods/constants/colors.dart';
import 'package:egyption_foods/constants/extensions.dart';
import 'package:egyption_foods/constants/strings.dart';
import 'package:egyption_foods/controllers/home_controller.dart';
import 'package:egyption_foods/models/food_model.dart';
import 'package:egyption_foods/views/screens/payment.dart';
import 'package:egyption_foods/views/widgets/hero_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'check_out_screen.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FoodModel foodFromArguments = Get.arguments;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.lightParchmentToneColor,
        body: HeroWidget(
          tag: foodFromArguments.image,
          child: Container(
            height: double.infinity,
            color: AppColors.lightBlueColor,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: 15.borderRadiusAll,
                      child: Image.network(
                        foodFromArguments.image,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                foodFromArguments.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.titlesColor,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 0,
                              child: Text(
                                AppStrings.dollarSign +
                                    foodFromArguments.price.toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  color: AppColors.titlesColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        5.gap,
                        Text(
                          AppStrings.boughtByText +
                              AppStrings.spaceSign +
                              foodFromArguments.selled.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.lightParchmentToneColor,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              foodFromArguments.rate >= 1
                                  ? Icons.star_rounded
                                  : Icons.star_half_rounded,
                              color: AppColors.goldColor,
                            ),
                            Icon(
                              foodFromArguments.rate <= 1.1
                                  ? Icons.star_border_rounded
                                  : foodFromArguments.rate >= 2
                                  ? Icons.star_rounded
                                  : Icons.star_half_rounded,
                              color: AppColors.goldColor,
                            ),
                            Icon(
                              foodFromArguments.rate <= 2.1
                                  ? Icons.star_border_rounded
                                  : foodFromArguments.rate >= 3
                                  ? Icons.star_rounded
                                  : Icons.star_half_rounded,
                              color: AppColors.goldColor,
                            ),
                            Icon(
                              foodFromArguments.rate <= 3.1
                                  ? Icons.star_border_rounded
                                  : foodFromArguments.rate >= 4
                                  ? Icons.star_rounded
                                  : Icons.star_half_rounded,
                              color: AppColors.goldColor,
                            ),
                            Icon(
                              foodFromArguments.rate <= 4.1
                                  ? Icons.star_border_rounded
                                  : foodFromArguments.rate >= 5
                                  ? Icons.star_rounded
                                  : Icons.star_half_rounded,
                              color: AppColors.goldColor,
                            ),
                            Text(
                              AppStrings.spaceSign +
                                  foodFromArguments.rate.toDouble().toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.lightParchmentToneColor,
                              ),
                            ),
                          ],
                        ),
                        15.gap,
                        Text(
                          foodFromArguments.subTitle,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.lightParchmentToneColor,
                          ),
                        ),
                        Text(
                          foodFromArguments.description,
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.lightParchmentToneColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  10.gap,
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Container(
          padding: 10.edgeInsetsAll,
          width: double.infinity,
          decoration: BoxDecoration(color: AppColors.lightBlueColor),
          child: GetBuilder<HomeController>(
            builder: (controller) {
              bool isContainedToFav = controller.user.fav.contains(
                foodFromArguments.id,
              );
              bool isContainedToCart = controller.user.cart.contains(
                foodFromArguments.id,
              );
              return Row(
                children: [
                  Expanded(
                    flex: 15,
                    child:
                        controller.isFavLoading
                            ? Padding(
                              padding: 15.edgeInsetsHorizontal,
                              child: 20.lightLoading,
                            )
                            : InkWell(
                              onTap:
                                  () => controller.updateFavList(
                                    foodFromArguments.id,
                                  ),
                              child: Icon(
                                isContainedToFav
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                    isContainedToFav
                                        ? AppColors.redColor
                                        : AppColors.lightParchmentToneColor,
                              ),
                            ),
                  ),
                  Expanded(
                    flex: 15,
                    child:
                        controller.isCartLoading
                            ? Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: 20.lightLoading,
                            )
                            : InkWell(
                              onTap:
                                  () => controller.updateCartList(
                                    foodFromArguments.id,
                                  ),
                              child: Icon(
                                isContainedToCart
                                    ? Icons.shopping_cart
                                    : Icons.shopping_cart_outlined,
                                color:
                                    isContainedToCart
                                        ? AppColors.goldColor
                                        : AppColors.lightParchmentToneColor,
                              ),
                            ),
                  ),
                  Expanded(
                    flex: 15,
                    child: InkWell(
                      onTap:
                          () =>
                              AppStrings
                                  .sorryThisFeatureIsNotAvailableYetToast
                                  .showToast,
                      child: Icon(
                        Icons.share_outlined,
                        color: AppColors.lightParchmentToneColor,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 55,
                    child: InkWell(
                      onTap: () {
                        if (controller.user.cart.any((item) => item.toString().trim() == foodFromArguments.id.toString().trim())) {
                          Get.toNamed(
                            AppStrings.checkOutRoute,
                            arguments: [foodFromArguments],
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Add this product in card .'),

                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },

                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        alignment: Alignment.center,
                        padding: 8.edgeInsetsVertical,
                        decoration: BoxDecoration(
                          color: AppColors.lightParchmentToneColor,
                          borderRadius: 15.borderRadiusAll,
                        ),
                        child: SizedBox(
                          child: Text(
                            AppStrings.buyNowText,
                            style: TextStyle(
                              color: AppColors.lightBlueColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
