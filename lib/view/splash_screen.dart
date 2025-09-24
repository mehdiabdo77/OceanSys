import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/constans/storage_const.dart';
import 'package:ocean_sys/controller/register_controller.dart';
import 'package:ocean_sys/route_manager/names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

final storage = GetStorage();

class _SplashScreenState extends State<SplashScreen> {
  RegisterController registerController = Get.put(RegisterController());
  bool _loading = true;
  bool _error = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((value) async {
      if (storage.read(StorageKey.username) == null) {
        Get.offAndToNamed(NamedRoute.loginPage);
      } else {
        bool ok = await registerController.veryfy();
        if (ok) {
          Get.offAllNamed(NamedRoute.menuPage);
        } else {
          setState(() {
            _error = true;
            _loading = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _loading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "لطفا صبر کنید ...",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: 20),
                  loading(),
                ],
              )
            : _error
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'خطا در ارتباط با سرور',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _loading = true;
                        _error = false;
                      });
                      registerController.veryfy().then((ok) {
                        if (ok) {
                          Get.offAllNamed(NamedRoute.menuPage);
                        } else {
                          setState(() {
                            _loading = false;
                            _error = true;
                          });
                        }
                      });
                    },
                    child: Text('تلاش مجدد'),
                  ),
                ],
              )
            : SizedBox.shrink(),
      ),
    );
  }
}

loading() {
  return Center(child: SpinKitRing(color: SolidColors.primaryColor));
}
