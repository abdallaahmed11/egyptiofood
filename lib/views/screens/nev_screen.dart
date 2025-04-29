import 'package:egyption_foods/constants/colors.dart';
import 'package:egyption_foods/constants/extensions.dart';
import 'package:egyption_foods/constants/strings.dart';
import 'package:egyption_foods/controllers/home_controller.dart';
import 'package:egyption_foods/views/screens/home_screen.dart';
import 'package:egyption_foods/views/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Aichat_screen.dart';

class NavScreen extends GetWidget<HomeController> {
  const NavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.lightBlueColor,
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.08,
                width: double.infinity,
                padding: 10.edgeInsetsAll,
                decoration: BoxDecoration(color: AppColors.lightBlueColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(flex: 0, child: Image.asset(AppStrings.logoImage, height: 38, width: 38)),
                        10.gap,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(controller.user.name, style: TextStyle(color: AppColors.titlesColor, fontWeight: FontWeight.bold)),
                              Text(AppStrings.welcomeToText + AppStrings.spaceSign + AppStrings.appTitle, style: TextStyle(color: AppColors.lightParchmentToneColor, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        10.gap,
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => GeminiChatScreen()), // فتح الشاشة بدون Get
                            );
                          },
                          icon: Image.asset("assets/images/chat.png"),
                        )

                      ],
                    ),
                  ],
                ),
              ),
              5.gap,
              Container(
                height: MediaQuery.of(context).size.height * 0.88,
                decoration: BoxDecoration(color: AppColors.lightParchmentToneColor, borderRadius: 15.borderRadiusTop),
                child: GetBuilder<HomeController>(
                  builder: (_) {
                    return controller.selectedScreen == AppStrings.homeText ? HomeScreen() : ProfileScreen();
                  },
                ),
              ),
            ],
          ),
        ),
        bottomSheet: Container(
          height: 60,
          padding: 10.edgeInsetsAll,
          decoration: BoxDecoration(
            color: AppColors.lightBlueColor,
            borderRadius: 15.borderRadiusTop,
            boxShadow: [BoxShadow(color: AppColors.lightBlueColor, offset: const Offset(0, 0), blurRadius: 8, spreadRadius: 1)],
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    controller.selectedScreen = AppStrings.homeText;
                    controller.update();
                  },
                  child: GetBuilder<HomeController>(
                    builder: (_) {
                      bool isHome = controller.selectedScreen == AppStrings.homeText;
                      return AnimatedContainer(
                        duration: 1.sec,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isHome ? AppColors.lightBlueColor : AppColors.lightParchmentToneColor,
                          borderRadius: 15.borderRadiusAll,
                          border: Border.all(color: isHome ? AppColors.lightParchmentToneColor : AppColors.lightBlueColor),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedSize(duration: 1.sec, child: isHome ? Icon(Icons.home, color: isHome ? AppColors.lightParchmentToneColor : AppColors.lightBlueColor) : 0.gap),
                            AnimatedSize(duration: 1.sec, child: isHome ? 10.gap : 0.gap),
                            Text(AppStrings.homeText, style: TextStyle(color: isHome ? AppColors.lightParchmentToneColor : AppColors.lightBlueColor)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              10.gap,
              Expanded(
                child: InkWell(
                  onTap: () {
                    controller.selectedScreen = AppStrings.profileText;
                    controller.update();
                  },
                  child: GetBuilder<HomeController>(
                    builder: (_) {
                      bool isProfile = controller.selectedScreen == AppStrings.profileText;
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isProfile ? AppColors.lightBlueColor : AppColors.lightParchmentToneColor,
                          borderRadius: 15.borderRadiusAll,
                          border: Border.all(color: isProfile ? AppColors.lightParchmentToneColor : AppColors.lightBlueColor),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedSize(duration: 1.sec, child: isProfile ? Icon(Icons.person, color: isProfile ? AppColors.lightParchmentToneColor : AppColors.lightBlueColor) : 0.gap),
                            AnimatedSize(duration: 1.sec, child: isProfile ? 10.gap : 0.gap),
                            Text(AppStrings.profileText, style: TextStyle(color: isProfile ? AppColors.lightParchmentToneColor : AppColors.lightBlueColor)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
