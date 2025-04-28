import 'package:carousel_slider/carousel_slider.dart';
import 'package:egyption_foods/constants/colors.dart';
import 'package:egyption_foods/constants/extensions.dart';
import 'package:egyption_foods/constants/strings.dart';
import 'package:egyption_foods/controllers/home_controller.dart';
import 'package:egyption_foods/models/food_model.dart';
import 'package:egyption_foods/views/widgets/hero_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class HomeScreen extends GetWidget<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Padding(
            padding: 10.edgeInsetsAll,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.lightBlueColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: AppColors.lightBlueColor, offset: const Offset(0, 0), blurRadius: 8, spreadRadius: 1)],
              ),
              child: TextFormField(
                controller: controller.searchController,
                enableInteractiveSelection: false,
                style: TextStyle(color: AppColors.lightParchmentToneColor),
                cursorColor: AppColors.lightParchmentToneColor,
                onTapOutside: (_) {
                  controller.update();
                  FocusScope.of(context).unfocus();
                },
                decoration: InputDecoration(
                  fillColor: AppColors.lightBlueColor,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: 15.borderRadiusAll, borderSide: BorderSide(color: AppColors.darkBlueColor)),
                  focusedBorder: OutlineInputBorder(borderRadius: 15.borderRadiusAll, borderSide: BorderSide(color: AppColors.darkBlueColor)),
                  enabledBorder: OutlineInputBorder(borderRadius: 15.borderRadiusAll, borderSide: BorderSide(color: AppColors.darkBlueColor)),
                  disabledBorder: OutlineInputBorder(borderRadius: 15.borderRadiusAll, borderSide: BorderSide(color: AppColors.darkBlueColor)),
                  focusedErrorBorder: OutlineInputBorder(borderRadius: 15.borderRadiusAll, borderSide: BorderSide(color: AppColors.darkBlueColor)),
                  prefixIcon: InkWell(
                    onTap: () {
                      controller.update();
                      FocusScope.of(context).unfocus();
                    },
                    child: const Icon(Icons.search, color: AppColors.lightParchmentToneColor),
                  ),
                  hintText: AppStrings.searchHereText,
                  hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.lightParchmentToneColor),
                ),
              ),
            ),
          ),

          Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (controller.recommendedFoodsList.isEmpty) {
              return Center(
                child: Text('No data available', style: TextStyle(color: Colors.grey)),
              );
            } else {
              return CarouselSlider.builder(
                itemCount: controller.recommendedFoodsList.length,
                options: CarouselOptions(
                  scrollPhysics: const BouncingScrollPhysics(),
                  height: 170,
                  autoPlay: true,
                  viewportFraction: 0.8,
                  enableInfiniteScroll: true,
                  enlargeCenterPage: true,
                  pageSnapping: true,
                  autoPlayCurve: Curves.easeIn,
                ),
                itemBuilder: (_, int index, __) {
                  FoodModel food = controller.recommendedFoodsList[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: InkWell(
                      onTap: () => Get.toNamed(AppStrings.detailsRoute, arguments: food),
                      child: Container(
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
                                  Text(AppStrings.boughtByText + AppStrings.spaceSign + food.selled.toString(), style: TextStyle(color: AppColors.lightParchmentToneColor)),
                                  Row(
                                    children: [
                                      Icon(food.rate >= 1 ? Icons.star_rounded : Icons.star_half_rounded, color: AppColors.goldColor),
                                      Icon(
                                        food.rate <= 1.1
                                            ? Icons.star_border_rounded
                                            : food.rate >= 2
                                            ? Icons.star_rounded
                                            : Icons.star_half_rounded,
                                        color: AppColors.goldColor,
                                      ),
                                      Icon(
                                        food.rate <= 2.1
                                            ? Icons.star_border_rounded
                                            : food.rate >= 3
                                            ? Icons.star_rounded
                                            : Icons.star_half_rounded,
                                        color: AppColors.goldColor,
                                      ),
                                      Icon(
                                        food.rate <= 3.1
                                            ? Icons.star_border_rounded
                                            : food.rate >= 4
                                            ? Icons.star_rounded
                                            : Icons.star_half_rounded,
                                        color: AppColors.goldColor,
                                      ),
                                      Icon(
                                        food.rate <= 4.1
                                            ? Icons.star_border_rounded
                                            : food.rate >= 5
                                            ? Icons.star_rounded
                                            : Icons.star_half_rounded,
                                        color: AppColors.goldColor,
                                      ),
                                      Text(AppStrings.spaceSign + food.rate.toDouble().toString(), style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.lightParchmentToneColor)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          }),
          10.gap,
          SizedBox(
            height: 30,
            child: ListView.separated(
              padding: 10.edgeInsetsHorizontal,
              scrollDirection: Axis.horizontal,
              itemCount: controller.categoriesList.length,
              itemBuilder: (_, int index) {
                String category = controller.categoriesList[index];
                return InkWell(
                  onTap: () {
                    controller.selectedCategory = category;
                    controller.update();
                  },
                  child: GetBuilder<HomeController>(
                    builder: (_) {
                      return AnimatedContainer(
                        duration: 1.sec,
                        alignment: Alignment.center,
                        padding: 10.edgeInsetsHorizontal,
                        decoration: BoxDecoration(
                          color: controller.selectedCategory == category ? AppColors.lightBlueColor : AppColors.lightParchmentToneColor,
                          borderRadius: 15.borderRadiusAll,
                          border: Border.all(color: AppColors.lightBlueColor),
                        ),
                        child: Text(category, style: TextStyle(color: controller.selectedCategory == category ? AppColors.lightParchmentToneColor : AppColors.lightBlueColor)),
                      );
                    },
                  ),
                );
              },
              separatorBuilder: (_, __) {
                return 10.gap;
              },
            ),
          ),
          10.gap,
          (controller.selectedCategory == AppStrings.allText
                  ? controller.foodsList.where((plant) => plant.title.toLowerCase().contains(controller.searchController.text.toLowerCase())).isEmpty
                  : controller.selectedCategory == AppStrings.mainDishesText
                  ? controller.foodsMainDishesList.where((plant) => plant.title.toLowerCase().contains(controller.searchController.text.toLowerCase())).isEmpty
                  : controller.foodsAppetizersAndSidesList.where((plant) => plant.title.toLowerCase().contains(controller.searchController.text.toLowerCase())).isEmpty)
              ? Padding(
                padding: 15.edgeInsetsVertical,
                child: Text(AppStrings.noItemsFoundText, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.greyColor, fontWeight: FontWeight.bold)),
              )
              : GetBuilder<HomeController>(
                builder: (_) {
                  return MasonryGridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: 10.edgeInsetsHorizontal,
                    gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    itemCount:
                        controller.selectedCategory == AppStrings.allText
                            ? controller.foodsList.where((plant) => plant.title.toLowerCase().contains(controller.searchController.text.toLowerCase())).length
                            : controller.selectedCategory == AppStrings.mainDishesText
                            ? controller.foodsMainDishesList.where((plant) => plant.title.toLowerCase().contains(controller.searchController.text.toLowerCase())).length
                            : controller.foodsAppetizersAndSidesList.where((plant) => plant.title.toLowerCase().contains(controller.searchController.text.toLowerCase())).length,
                    itemBuilder: (itemBuilder, index) {
                      List<FoodModel> foodsList =
                          controller.selectedCategory == AppStrings.allText
                              ? controller.foodsList.where((plant) => plant.title.toLowerCase().contains(controller.searchController.text.toLowerCase())).toList()
                              : controller.selectedCategory == AppStrings.mainDishesText
                              ? controller.foodsMainDishesList.where((plant) => plant.title.toLowerCase().contains(controller.searchController.text.toLowerCase())).toList()
                              : controller.foodsAppetizersAndSidesList.where((plant) => plant.title.toLowerCase().contains(controller.searchController.text.toLowerCase())).toList();
                      FoodModel food = foodsList[index];
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
                                                    child: Icon(
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
          75.gap,
        ],
      ),
    );
  }
}
