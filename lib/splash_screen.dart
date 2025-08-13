import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/constans/storage_const.dart';
import 'package:ocean_sys/controller/register_controller.dart';
import 'package:ocean_sys/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

final storage = GetStorage();

class _SplashScreenState extends State<SplashScreen> {
  RegisterController registerController = Get.put(RegisterController());
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((value) {
      if (storage.read(StorageKey.username) == null) {
        Get.offAndToNamed(NamedRoute.loginPage);
      } else {
        registerController.veryfy();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image(image: Assets.images.logo.provider(), height: 64),
            Text(
              "لطفا صبر کنید ...",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 20),
            loading(),
          ],
        ),
      ),
    );
  }
}

loading() {
  return Center(child: SpinKitRing(color: SolidColors.primaryColor));
  // return Center(
  //   child: CircularProgressIndicator(
  //     color: Colors.deepOrange,
  //     strokeWidth: 5.0,
  //   ),
  // );
}
