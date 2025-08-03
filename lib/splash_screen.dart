import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    Future.delayed(Duration(seconds: 3)).then((value) {
      // TODO کنترل این که کاربر ثبت نام کرده یا نه
      Get.offAndToNamed(NamedRoute.loginPage);
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
