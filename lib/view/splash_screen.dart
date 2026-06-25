import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/constans/storage_const.dart';
import 'package:ocean_sys/cubit/login/login_cubit.dart';
import 'package:ocean_sys/cubit/login/login_state.dart';
import 'package:ocean_sys/view/auth/login_page.dart';
import 'package:ocean_sys/view/main/menu_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

final storage = GetStorage();

class _SplashScreenState extends State<SplashScreen> {
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((value) async {
      if (!mounted) return;
      if (storage.read(StorageKey.username) == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: context.read<LoginCubit>(),
              child: const LoginPage(),
            ),
          ),
        );
      } else {
        await context.read<LoginCubit>().login();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MenuPage()),
            (route) => false,
          );
        } else if (state is LoginError) {
          setState(() {
            _error = true;
            _loading = false;
          });
        }
      },
      child: Scaffold(
        body: Center(
          child: _loading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "لطفا صبر کنید ...",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _loading = true;
                          _error = false;
                        });
                        await context.read<LoginCubit>().login();
                      },
                      child: const Text('تلاش مجدد'),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}

Widget loading() {
  return const Center(child: SpinKitRing(color: SolidColors.primaryColor));
}
