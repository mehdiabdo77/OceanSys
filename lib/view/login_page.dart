import 'package:flutter/material.dart';
import 'package:blobs/blobs.dart';
import 'package:get/get.dart';
import 'package:ocean_sys/constans/decrations.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/controller/register_controller.dart';
import 'package:ocean_sys/route_manager/names.dart';

class LoginPage extends StatelessWidget {
  var registerController = Get.put<RegisterController>(RegisterController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SolidColors.homepage, // رنگ زمینه بژ روشن
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              children: [
                Container(
                  height: Get.height / 3,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Stack(
                    children: [
                      // Blob صورتی بالا چپ
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Blob.fromID(
                          id: ['8-9-986541'],
                          size: 150,
                          styles: BlobStyles(color: Color(0xFFF48B94)),
                        ),
                      ),
                      // Blob بنفش وسط
                      Positioned(
                        top: 50,
                        left: 60,
                        right: 0,
                        child: Blob.fromID(
                          id: ['9-4-73592'],
                          size: 300,
                          styles: BlobStyles(color: Color(0xFF8E5D9F)),
                        ),
                      ),
                      // Blob زرد راست
                      Positioned(
                        top: 10,
                        right: -40,
                        child: Blob.fromID(
                          id: ['7-7-98356'],
                          size: 200,
                          styles: BlobStyles(color: Color(0xFFF9D976)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        "Welcome To Ocean sys",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 80),
                      TextField(
                        controller: registerController.usercontroler,
                        decoration: InputDecoration(
                          hintText: 'UserName',
                          border: UnderlineInputBorder(),
                        ),
                        style: MyTextStyle.textBlack16,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        obscureText: true,
                        controller: registerController.passwordcontroler,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          border: UnderlineInputBorder(),
                        ),
                        style: MyTextStyle.textBlak12,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Text(
                            "Sign in",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Spacer(),
                          ElevatedButton(
                            onPressed: () async {
                              bool ok = await registerController.veryfy();
                              if (ok) {
                                Get.offAllNamed(NamedRoute.homepage);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF8E5D9F),
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(14),
                            ),
                            child: Icon(
                              Icons.arrow_forward,
                              size: 40,
                              color: SolidColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              getserveraddress();
                            },
                            child: Text("Adress Server"), //TODO استایل و فونت
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getserveraddress() {
    Get.defaultDialog(
      title: "Server Address",
      content: TextField(
        controller: registerController.serverAddressController,
        style: MyTextStyle.textBlak12,
        decoration: InputDecoration(
          hintText: 'لطفا ادرس سرور را وارد کنید',
          border: UnderlineInputBorder(),
        ),
      ),
      confirm: ElevatedButton(
        style: MyDecorations.mainButtom,
        onPressed: () {
          registerController.saveBaseUrl();
          Get.back();
        },
        child: Text("ذخیره", style: MyTextStyle.bottomstyle),
      ),
    );
  }
}
