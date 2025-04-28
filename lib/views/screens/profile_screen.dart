import 'package:egyption_foods/constants/colors.dart';
import 'package:egyption_foods/constants/extensions.dart';
import 'package:egyption_foods/constants/strings.dart';
import 'package:egyption_foods/controllers/home_controller.dart';
import 'package:egyption_foods/models/food_model.dart';
import 'package:egyption_foods/models/services/auth_services.dart';
import 'package:egyption_foods/views/widgets/hero_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class ProfileScreen extends GetWidget<HomeController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 30,right: 10,left: 10,top:10 ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: double.infinity),
          10.gap,
          InkWell(
            onTap: () {
              FirebaseAuthService().signOut();
              SystemNavigator.pop();
            },
            child: CircleAvatar(radius: 50, backgroundColor: AppColors.lightBlueColor, child: Icon(Icons.logout, color: AppColors.lightParchmentToneColor, size: 50)),
          ),
          10.gap,
          Text(controller.user.name, style: TextStyle(color: AppColors.lightBlueColor, fontSize: 20, fontWeight: FontWeight.bold)),
          10.gap,
          Text(controller.user.email, style: TextStyle(color: AppColors.lightBlueColor, fontSize: 16)),
          10.gap,
          Row(
            children: [Text(AppStrings.favoriteItemsText + AppStrings.colonSign + AppStrings.minusSign, style: TextStyle(color: AppColors.lightBlueColor, fontSize: 16, fontWeight: FontWeight.bold))],
          ),
          10.gap,
          GetBuilder<HomeController>(
            builder: (_) {
              return controller.foodsList.where((food) => controller.user.fav.contains(food.id)).toList().isEmpty
                  ? Text(AppStrings.noFavoriteItemsYetText, style: TextStyle(color: AppColors.lightBlueColor, fontSize: 16, fontWeight: FontWeight.bold))
                  : MasonryGridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.foodsList.where((food) => controller.user.fav.contains(food.id)).toList().length,
                    gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    itemBuilder: (itemBuilder, index) {
                      List<FoodModel> foodList = controller.foodsList.where((food) => controller.user.fav.contains(food.id)).toList();
                      FoodModel food = foodList[index];
                      return InkWell(
                        onTap: () {
                          Get.toNamed(AppStrings.detailsRoute, arguments: food);
                        },
                        child: HeroWidget(
                          tag: food.image,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.lightBlueColor,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [BoxShadow(color: AppColors.lightBlueColor, offset: const Offset(0, 0), blurRadius: 8, spreadRadius: 1)],
                            ),
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(padding: 10.edgeInsetsHorizontal, child: Center(child: ClipRRect(borderRadius: 15.borderRadiusAll, child: Image.network(food.image)))),
                                    5.gap,
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(food.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.titlesColor)),
                                                5.gap,
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                                                      decoration: BoxDecoration(color: AppColors.lightParchmentToneColor, borderRadius: BorderRadius.circular(20)),
                                                      child: Text(
                                                        food.price.toString() + AppStrings.spaceSign + AppStrings.dollarSign,
                                                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.lightBlueColor),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          10.gap,
                                          Expanded(
                                            flex: 0,
                                            child: GetBuilder<HomeController>(
                                              builder: (controller) {
                                                bool isContainedToFav = controller.user.fav.contains(food.id);
                                                return InkWell(
                                                  onTap: () => controller.updateFavList(food.id),
                                                  child: CircleAvatar(
                                                    radius: 15,
                                                    backgroundColor: AppColors.lightParchmentToneColor,
                                                    child:
                                                        controller.isFavLoading
                                                            ? Padding(padding: const EdgeInsets.symmetric(horizontal: 15), child: 18.darkLoading)
                                                            : Icon(
                                                              isContainedToFav ? Icons.favorite : Icons.favorite_border,
                                                              color: isContainedToFav ? AppColors.redColor : AppColors.lightBlueColor,
                                                              size: 18,
                                                            ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
            },
          ),
          Divider(height: 25, color: AppColors.lightBlueColor),
          Row(children: [Text(AppStrings.cartItemsText + AppStrings.colonSign + AppStrings.minusSign, style: TextStyle(color: AppColors.lightBlueColor, fontSize: 16, fontWeight: FontWeight.bold))]),
          10.gap,
          GetBuilder<HomeController>(
            builder: (_) {
              return controller.foodsList.where((food) => controller.user.cart.contains(food.id)).toList().isEmpty
                  ? Text(AppStrings.noItemsFoundAtYourCartText, style: TextStyle(color: AppColors.lightBlueColor, fontSize: 16, fontWeight: FontWeight.bold))
                  : MasonryGridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.foodsList.where((food) => controller.user.cart.contains(food.id)).toList().length,
                    gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    itemBuilder: (itemBuilder, index) {
                      List<FoodModel> foodList = controller.foodsList.where((food) => controller.user.cart.contains(food.id)).toList();
                      FoodModel food = foodList[index];
                      return InkWell(
                        onTap: () {
                          Get.toNamed(AppStrings.detailsRoute, arguments: food);
                        },
                        child: HeroWidget(
                          tag: food.image,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.lightBlueColor,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [BoxShadow(color: AppColors.lightBlueColor, offset: const Offset(0, 0), blurRadius: 8, spreadRadius: 1)],
                            ),
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(padding: 10.edgeInsetsHorizontal, child: Center(child: ClipRRect(borderRadius: 15.borderRadiusAll, child: Image.network(food.image)))),
                                    5.gap,
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(food.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.titlesColor)),
                                                5.gap,
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                                                      decoration: BoxDecoration(color: AppColors.lightParchmentToneColor, borderRadius: BorderRadius.circular(20)),
                                                      child: Text(
                                                        food.price.toString() + AppStrings.spaceSign + AppStrings.dollarSign,
                                                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.lightBlueColor),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          10.gap,
                                          Expanded(
                                            flex: 0,
                                            child: GetBuilder<HomeController>(
                                              builder: (controller) {
                                                bool isContainedToCart = controller.user.cart.contains(food.id);
                                                return InkWell(
                                                  onTap: () => controller.updateCartList(food.id),
                                                  child: CircleAvatar(
                                                    radius: 15,
                                                    backgroundColor: AppColors.lightParchmentToneColor,
                                                    child:
                                                        controller.isCartLoading
                                                            ? Padding(padding: const EdgeInsets.symmetric(horizontal: 15), child: 20.darkLoading)
                                                            : Icon(
                                                              isContainedToCart ? Icons.shopping_cart : Icons.shopping_cart_outlined,
                                                              color: isContainedToCart ? AppColors.goldColor : AppColors.lightBlueColor,
                                                              size: 18,
                                                            ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
            },
          ),
          10.gap,
          GetBuilder<HomeController>(
            builder: (_) {
              return controller.foodsList.where((food) => controller.user.cart.contains(food.id)).toList().isEmpty
                  ? 0.gap
                  : InkWell(
                    onTap: () {
                      Get.toNamed(AppStrings.checkOutRoute, arguments: controller.foodsList.where((food) => controller.user.cart.contains(food.id)).toList());
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: 10.edgeInsetsAll,
                      decoration: BoxDecoration(color: AppColors.lightBlueColor, borderRadius: 15.borderRadiusAll, border: Border.all(color: AppColors.lightParchmentToneColor)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(AppStrings.checkOutText, style: TextStyle(color: AppColors.lightParchmentToneColor)),
                          10.gap,
                          Icon(Icons.double_arrow_rounded, color: AppColors.lightParchmentToneColor),
                        ],
                      ),
                    ),
                  );
            },
          ),
          75.gap,
        ],
      ),
    );
  }
}
