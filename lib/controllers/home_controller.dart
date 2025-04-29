import 'dart:convert';
import 'package:egyption_foods/constants/extensions.dart';
import 'package:egyption_foods/constants/strings.dart';
import 'package:egyption_foods/models/food_model.dart';
import 'package:egyption_foods/models/services/firebase_services.dart';
import 'package:egyption_foods/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  bool isExpanded = false;
  num totalTotalPrice = 0;
  bool isFavLoading = false;
  bool isCartLoading = false;
  UserModel user = Get.arguments[0];
  List<FoodModel> recommendedFoodsList = [];
  String selectedScreen = AppStrings.homeText;
  List<FoodModel> foodsList = Get.arguments[1];
  String selectedCategory = AppStrings.allText;
  TextEditingController searchController = TextEditingController();
  List<String> categoriesList = [AppStrings.allText, AppStrings.mainDishesText, AppStrings.appetizersAndSidesText];
  List<FoodModel> foodsMainDishesList = Get.arguments[1].where((element) => element.category == AppStrings.mainDishesText).toList();
  List<FoodModel> foodsAppetizersAndSidesList = Get.arguments[1].where((element) => element.category == AppStrings.appetizersAndSidesText).toList();
  var isLoading = false.obs;

  @override
  void onInit() {
    getRecommendedFoodsList();
    getTotalPrice();
    super.onInit();
  }

  // Function to update the favorite food list and refresh recommendations
  void updateFavList(String foodId) async {
    isFavLoading = true;
    update();

    await FirebaseServices.updateUserFavFood(foodId).then((value) {
      if (value is bool && value) {
        if (!user.fav.contains(foodId)) {
          user.fav.add(foodId);
        } else {
          user.fav.remove(foodId);
        }
        update();

        // Update recommendations immediately after modifying fav list
        getRecommendedFoodsList(); // <-- تحديث التوصيات بعد التفاعل مع المفضلة
      } else {
        value.toString().showToast;
      }
    });
    isFavLoading = false;
    update();
  }

  // Function to update the cart food list and refresh recommendations
  void updateCartList(String foodId) async {
    isCartLoading = true;
    update();

    await FirebaseServices.updateUserCartFood(foodId).then((value) {
      if (value is bool && value) {
        if (!user.cart.contains(foodId)) {
          user.cart.add(foodId);
        } else {
          user.cart.remove(foodId);
        }
        update();

        // Update recommendations after modifying cart
        getRecommendedFoodsList(); // <-- تحديث التوصيات بعد التفاعل مع السلة
      } else {
        value.toString().showToast;
      }
    });
    isCartLoading = false;
    update();
  }

  // Function to calculate the total price of foods in the cart
  void getTotalPrice() {
    totalTotalPrice = 0;
    for (FoodModel food in foodsList.where((food) => user.cart.contains(food.id)).toList()) {
      totalTotalPrice += food.totalPrice;
    }
  }
  // void getRecommendedFoodsList() {
  //   foodsList.sort((a, b) => b.selled.compareTo(a.selled));
  //   recommendedFoodsList = foodsList.take(5).toList();
  // }

  // Function to fetch the recommended foods from the server based on filters
  Future<void> getRecommendedFoodsList({String? category, double? minPrice, double? maxPrice}) async {
    final queryParameters = <String, String>{};

    if (category != null) queryParameters['category'] = category;
    if (minPrice != null) queryParameters['min_price'] = minPrice.toString();
    if (maxPrice != null) queryParameters['max_price'] = maxPrice.toString();

    final url = Uri.http('10.0.2.2:5000', '/recommend', queryParameters);

    try {
      isLoading.value = true; // Adding loading state
      update();
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final List<dynamic> recommendedData = data['recommended_foods'];

        // Take top 5 recommended foods
        final List<dynamic> top5Recommended = recommendedData.take(5).toList();

        // Convert the data to FoodModel
        recommendedFoodsList = top5Recommended.map((item) => FoodModel.asModel(item)).toList();

        isLoading.value = false; // Set loading state to false
        update();
      } else {
        print('Failed to load recommendations from Python API: ${response.statusCode}');
        isLoading.value = false;
        update();
      }
    } catch (e) {
      print('Error fetching recommendations from Python API: $e');
      isLoading.value = false;
      update();
    }
  }
}
