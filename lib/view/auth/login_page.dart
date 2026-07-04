import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ocean_sys/constans/decrations.dart';
import 'package:ocean_sys/constans/storage_const.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/view/auth/cubit/login_cubit.dart';
import 'package:ocean_sys/view/auth/cubit/login_state.dart';
import 'package:ocean_sys/view/main/menu_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;
  double _xOffset = 0.0;
  double _yOffset = 0.0;
  final Random _random = Random();
  final List<Bubble> _bubbles = [];
  late Timer _bubbleTimer;
  late AnimationController _waveController;
  final storage = GetStorage();
  bool _hasSavedCredentials = false;

  @override
  void initState() {
    super.initState();
    context.read<LoginCubit>().init();
    _checkSavedCredentials();
    _initBubbles();
    _startBubbleAnimation();
    _listenToSensors();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  void _checkSavedCredentials() {
    final username = storage.read(StorageKey.username);
    final password = storage.read(StorageKey.password);
    setState(() {
      _hasSavedCredentials = username != null && password != null;
    });
  }

  void _initBubbles() {
    for (int i = 0; i < 40; i++) {
      _bubbles.add(
        Bubble(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: 5 + _random.nextDouble() * 25,
          speed: 0.3 + _random.nextDouble() * 1.2,
          opacity: 0.1 + _random.nextDouble() * 0.4,
        ),
      );
    }
  }

  void _startBubbleAnimation() {
    _bubbleTimer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      setState(() {
        for (var bubble in _bubbles) {
          bubble.y -= bubble.speed * 0.006;
          bubble.x += sin(bubble.y * 10) * 0.001;
          if (bubble.y < -0.1) {
            bubble.y = 1.1;
            bubble.x = _random.nextDouble();
            bubble.size = 5 + _random.nextDouble() * 25;
            bubble.speed = 0.3 + _random.nextDouble() * 1.2;
            bubble.opacity = 0.1 + _random.nextDouble() * 0.4;
          }
        }
      });
    });
  }

  void _listenToSensors() {
    _accelerometerSubscription = accelerometerEventStream().listen((event) {
      setState(() {
        _xOffset = event.x;
        _yOffset = event.y;
      });
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription.cancel();
    _bubbleTimer.cancel();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF00D2FF),
                const Color(0xFF3A7BD5),
                const Color(0xFF0B3D91),
              ],
            ),
          ),
          child: Stack(
            children: [
              ..._bubbles.map(
                (bubble) => Positioned(
                  left: (bubble.x + _xOffset * 0.01) * size.width,
                  top: (bubble.y + _yOffset * 0.01) * size.height,
                  child: Container(
                    width: bubble.size,
                    height: bubble.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: bubble.opacity),
                      border: Border.all(
                        color: Colors.white.withValues(
                          alpha: bubble.opacity + 0.2,
                        ),
                        width: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: WaveAnimation(controller: _waveController, size: size),
              ),
              SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Column(
                      children: [
                        SizedBox(height: size.height / 10),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 32),
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text(
                                "Welcome To Ocean sys",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0B3D91),
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 40),
                              TextField(
                                controller: context
                                    .read<LoginCubit>()
                                    .usernameController,
                                decoration: InputDecoration(
                                  hintText: 'UserName',
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color: Color(0xFF3A7BD5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF3A7BD5),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF0B3D91),
                                      width: 2,
                                    ),
                                  ),
                                ),
                                style: MyTextStyle.textBlack16,
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                obscureText: true,
                                controller: context
                                    .read<LoginCubit>()
                                    .passwordController,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    color: Color(0xFF3A7BD5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF3A7BD5),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF0B3D91),
                                      width: 2,
                                    ),
                                  ),
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
                                      color: Color(0xFF0B3D91),
                                    ),
                                  ),
                                  const Spacer(),
                                  BlocBuilder<LoginCubit, LoginState>(
                                    builder: (context, state) {
                                      if (state is LoginLoading) {
                                        return const CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Color(0xFF0B3D91),
                                              ),
                                        );
                                      }
                                      return ElevatedButton(
                                        onPressed: () async {
                                          await context
                                              .read<LoginCubit>()
                                              .login();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF0B3D91,
                                          ),
                                          shape: const CircleBorder(),
                                          padding: const EdgeInsets.all(18),
                                        ),
                                        child: const Icon(
                                          Icons.arrow_forward,
                                          size: 32,
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Fingerprint auth kept commented out
                              // if (_hasSavedCredentials)
                              //   Column(
                              //     children: [
                              //       const Divider(),
                              //       const SizedBox(height: 20),
                              //       const Text(
                              //         "یا با اثر انگشت وارد شوید",
                              //         style: TextStyle(
                              //           color: Color(0xFF0B3D91),
                              //           fontSize: 16,
                              //         ),
                              //       ),
                              //       const SizedBox(height: 16),
                              //       BlocBuilder<LoginCubit, LoginState>(
                              //         builder: (context, state) {
                              //           if (state is LoginLoading) {
                              //             return const CircularProgressIndicator(
                              //               valueColor:
                              //                   AlwaysStoppedAnimation<Color>(
                              //                 Color(0xFF0B3D91),
                              //               ),
                              //             );
                              //           }
                              //           return ElevatedButton.icon(
                              //             onPressed: () {},
                              //             style: ElevatedButton.styleFrom(
                              //               backgroundColor: const Color(
                              //                 0xFF0B3D91,
                              //               ),
                              //               padding: const EdgeInsets.symmetric(
                              //                 horizontal: 32,
                              //                 vertical: 12,
                              //               ),
                              //               shape: RoundedRectangleBorder(
                              //                 borderRadius:
                              //                     BorderRadius.circular(15),
                              //               ),
                              //             ),
                              //             icon: const Icon(
                              //               Icons.fingerprint,
                              //               size: 32,
                              //               color: Colors.white,
                              //             ),
                              //             label: const Text(
                              //               "ورود با اثر انگشت",
                              //               style: TextStyle(
                              //                 color: Colors.white,
                              //                 fontSize: 16,
                              //               ),
                              //             ),
                              //           );
                              //         },
                              //       ),
                              //       const SizedBox(height: 20),
                              //     ],
                              //   ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      getServerAddress(context);
                                    },
                                    child: const Text(
                                      "Adress Server",
                                      style: TextStyle(
                                        color: Color(0xFF3A7BD5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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

class Bubble {
  double x;
  double y;
  double size;
  double speed;
  double opacity;

  Bubble({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class WaveAnimation extends StatelessWidget {
  final AnimationController controller;
  final Size size;

  const WaveAnimation({
    super.key,
    required this.controller,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return ClipPath(
          clipper: WaveClipper(controller.value),
          child: Container(
            height: size.height * 0.25,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF0B3D91).withValues(alpha: 0.6),
                  const Color(0xFF0B3D91).withValues(alpha: 0.9),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  final double animation;

  WaveClipper(this.animation);

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    for (double i = 0; i <= size.width; i++) {
      final y =
          sin((i / size.width * 2 * 3.1415) + (animation * 2 * 3.1415)) * 15 +
          30;
      if (i == 0) {
        path.moveTo(i, y);
      } else {
        path.lineTo(i, y);
      }
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
