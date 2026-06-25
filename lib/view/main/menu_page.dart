import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocean_sys/constans/permission_constans.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/cubit/user/user_bloc.dart';
import 'package:ocean_sys/cubit/user/user_state.dart';
import 'package:ocean_sys/gen/assets.gen.dart';
import 'package:ocean_sys/data/repository/customer_repository.dart';
import 'package:ocean_sys/view/widgets/menuWidget.dart';
import 'package:ocean_sys/view/RouteScanner/map/route_scanner.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(UserFetchData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Menu", style: MyTextStyle.appBarStyle)),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserError) {
            return Center(child: Text(state.message));
          } else if (state is UserLoaded) {
            final userBloc = context.read<UserBloc>();
            return GridView.count(
              crossAxisCount: 2,
              children: [
                if (userBloc.checkPermission(
                  PermissionConstans.customerScan,
                  state.user,
                ))
                  MenuItem(
                    svgPath: Assets.icons.customerScan.path,
                    title: "scan customer",
                    subtitle: "بازرسی مشتریان مسیر",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                      );
                    },
                  ),
                if (userBloc.checkPermission(
                  PermissionConstans.uploadData,
                  state.user,
                ))
                  MenuItem(
                    svgPath: Assets.icons.upload.path,
                    title: "upload data",
                    subtitle: "ارسال اطلاعات ارسال نشده",
                    onTap: () {
                      context.read<CustomerRepository>().sendOfflineRequest();
                    },
                  ),
                if (userBloc.checkPermission(
                  PermissionConstans.userManage,
                  state.user,
                ))
                  MenuItem(
                    svgPath: Assets.icons.userManager.path,
                    title: "USER",
                    subtitle: "مدیریت کاربران",
                    onTap: () {},
                  ),
                if (userBloc.checkPermission(
                  PermissionConstans.newCustomer,
                  state.user,
                ))
                  MenuItem(
                    svgPath: Assets.icons.storeAdd.path,
                    title: "New Customer",
                    subtitle: "اضافه کردن کاربران جدید",
                    onTap: () {},
                  ),
                if (userBloc.checkPermission(
                  PermissionConstans.competitorPrices,
                  state.user,
                ))
                  MenuItem(
                    svgPath: Assets.icons.competitorPrices.path,
                    title: "Competitor Prices",
                    subtitle: "استعلام قیمت رقبا",
                    onTap: () {},
                  ),
              ],
            );
          }
          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }
}
