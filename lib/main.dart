import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ocean_sys/cubit/login/login_cubit.dart';
import 'package:ocean_sys/cubit/user/user_bloc.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_info/customer_info_bloc.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_edit/customer_edit_bloc.dart';
import 'package:ocean_sys/cubit/location_sync/location_sync_bloc.dart';
import 'package:ocean_sys/cubit/main/main_bloc.dart';
import 'package:ocean_sys/data/repository/customer_repository.dart';
import 'package:ocean_sys/data/repository/user_repository.dart';
import 'package:ocean_sys/data/repository/customer_info_repository.dart';
import 'package:ocean_sys/data/repository/location_repository.dart';
import 'package:ocean_sys/view/splash_screen.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => CustomerRepository()),
        RepositoryProvider(create: (context) => UserRepository()),
        RepositoryProvider(create: (context) => CustomerInfoRepository()),
        RepositoryProvider(create: (context) => LocationRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LoginCubit()),
          BlocProvider(
            create: (context) => UserBloc(context.read<UserRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                CustomerInfoBloc(context.read<CustomerInfoRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                CustomerEditBloc(context.read<CustomerRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                LocationSyncBloc(context.read<LocationRepository>()),
          ),
          BlocProvider(create: (context) => MainBloc()),
        ],
        child: GetMaterialApp(
          locale: const Locale("fa"),
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
          theme: ThemeData(
            fontFamily: "dona",
            textTheme: const TextTheme(
              titleLarge: TextStyle(color: Colors.black87, fontSize: 18),
              bodyLarge: TextStyle(
                color: Colors.white,
                fontSize: 15,
                overflow: TextOverflow.ellipsis,
                fontFamily: "dona",
              ),
              bodyMedium: TextStyle(
                color: Colors.black,
                fontSize: 12,
                overflow: TextOverflow.ellipsis,
                fontFamily: "dona",
              ),
              bodySmall: TextStyle(
                color: Colors.white,
                fontSize: 12,
                overflow: TextOverflow.ellipsis,
                fontFamily: "dona",
              ),
              labelMedium: TextStyle(
                color: Colors.black,
                fontSize: 13,
                overflow: TextOverflow.ellipsis,
                fontFamily: "dona",
              ),
              labelSmall: TextStyle(color: Colors.black87, fontSize: 10),
            ),
          ),
        ),
      ),
    );
  }
}
