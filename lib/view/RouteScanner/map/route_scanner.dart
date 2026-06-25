import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/cubit/main/main_bloc.dart';
import 'package:ocean_sys/cubit/main/main_state.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/customer_list_page.dart';
import 'package:ocean_sys/view/RouteScanner/map_page.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [const CustomerListPage(), const MapPage()];
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: SolidColors.appBorColor,
            elevation: 0,
            centerTitle: true,
            title: Text(
              state.currentIndex == 0 ? "لیست مشتریان" : "نقشه مسیر",
              style: const TextStyle(
                fontFamily: 'dona',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          body: pages[state.currentIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: state.currentIndex,
              onTap: (index) =>
                  context.read<MainBloc>().add(MainChangePage(index)),
              backgroundColor: Colors.white,
              elevation: 0,
              selectedItemColor: SolidColors.primaryColor,
              unselectedItemColor: Colors.grey[400],
              selectedLabelStyle: const TextStyle(
                fontFamily: 'dona',
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'dona',
                fontWeight: FontWeight.w400,
              ),
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.list_outlined),
                  activeIcon: Icon(Icons.list_rounded),
                  label: "لیست مشتریان",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.map_outlined),
                  activeIcon: Icon(Icons.map_rounded),
                  label: "نقشه",
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
