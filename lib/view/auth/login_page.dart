import 'package:flutter/material.dart';
import 'package:blobs/blobs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocean_sys/constans/decrations.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/cubit/login/login_cubit.dart';
import 'package:ocean_sys/cubit/login/login_state.dart';
import 'package:ocean_sys/view/main/menu_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    context.read<LoginCubit>().init();
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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: SolidColors.homepage,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Blob.fromID(
                            id: ['8-9-986541'],
                            size: 150,
                            styles: BlobStyles(color: const Color(0xFFF48B94)),
                          ),
                        ),
                        Positioned(
                          top: 50,
                          left: 60,
                          right: 0,
                          child: Blob.fromID(
                            id: ['9-4-73592'],
                            size: 300,
                            styles: BlobStyles(color: const Color(0xFF8E5D9F)),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: -40,
                          child: Blob.fromID(
                            id: ['7-7-98356'],
                            size: 200,
                            styles: BlobStyles(color: const Color(0xFFF9D976)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
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
                          controller: context
                              .read<LoginCubit>()
                              .usernameController,
                          decoration: const InputDecoration(
                            hintText: 'UserName',
                            border: UnderlineInputBorder(),
                          ),
                          style: MyTextStyle.textBlack16,
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          obscureText: true,
                          controller: context
                              .read<LoginCubit>()
                              .passwordController,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            border: UnderlineInputBorder(),
                          ),
                          style: MyTextStyle.textBlak12,
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            const Text(
                              "Sign in",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const Spacer(),
                            BlocBuilder<LoginCubit, LoginState>(
                              builder: (context, state) {
                                if (state is LoginLoading) {
                                  return const CircularProgressIndicator();
                                }
                                return ElevatedButton(
                                  onPressed: () async {
                                    await context.read<LoginCubit>().login();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF8E5D9F),
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(14),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward,
                                    size: 40,
                                    color: SolidColors.primaryColor,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                getServerAddress(context);
                              },
                              child: const Text("Adress Server"),
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
      ),
    );
  }

  void getServerAddress(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Server Address"),
        content: TextField(
          controller: context.read<LoginCubit>().serverAddressController,
          style: MyTextStyle.textBlak12,
          decoration: const InputDecoration(
            hintText: 'لطفا ادرس سرور را وارد کنید',
            border: UnderlineInputBorder(),
          ),
        ),
        actions: [
          ElevatedButton(
            style: MyDecorations.mainButtom,
            onPressed: () {
              context.read<LoginCubit>().saveServerAddress();
              Navigator.pop(context);
            },
            child: Text("ذخیره", style: MyTextStyle.bottomstyle),
          ),
        ],
      ),
    );
  }
}
