import 'package:egyption_foods/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/chat_controller.dart';
import '../widgets/chat_widget.dart';


class FoodChatbot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FoodChatbotController>(
      init: FoodChatbotController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.lightBlueColor,
          appBar: AppBar(
            iconTheme: IconThemeData(color: AppColors.lightParchmentToneColor),
              title: Text('Foods Chatbot',style: TextStyle(color: AppColors.lightParchmentToneColor),),
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.more_vert)),

          ],),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/logo11.png"),
                  fit: BoxFit.fitWidth, // يخلي الصورة مغطية الشاشة كلها
                  colorFilter: ColorFilter.mode(
                    AppColors.lightBlueColor.withOpacity(0.1), // التحكم في الشفافية
                    BlendMode.dstATop,
                  ),
                ),
              ),            child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(12),
                      itemCount: controller.messages.length,
                      itemBuilder: (context, index) {
                        final msg = controller.messages[index];
                        return FoodChatMessageWidget(
                          text: msg['text']!,
                          isUser: msg['sender'] == 'user',
                        );
                      },
                    ),
                  ),
                  if (controller.isLoading)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: TextStyle(color:AppColors.lightParchmentToneColor ),
                            controller: controller.controller,
                            decoration: InputDecoration(
                              hintText: "Type a message...",
                              hintStyle: TextStyle(color: AppColors.lightParchmentToneColor),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: AppColors.lightParchmentToneColor)
                              ),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color:AppColors.lightParchmentToneColor )

                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                        IconButton(
                          icon: Icon(Icons.photo_library, color: AppColors.lightParchmentToneColor),
                          onPressed: () async {
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickImage(source: ImageSource.gallery);

                            if (pickedFile != null) {
                              print('Image Path: ${pickedFile.path}');
                            } else {
                              print('No image selected.');
                            }
                          },
                        ),

                        IconButton(
                          icon: Icon(Icons.send,color: AppColors.lightParchmentToneColor,),
                          onPressed: controller.isLoading
                              ? null
                              : () {
                            String text = controller.controller.text.trim();
                            if (text.isNotEmpty) {
                              controller.controller.clear();
                              controller.sendMessage(text);
                            }
                          },
                        )
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
}
