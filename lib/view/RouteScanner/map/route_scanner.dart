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
            toolbarHeight: 40,
          ),
          body: pages[state.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.currentIndex,
            onTap: (index) => context.read<MainBloc>().add(MainChangePage(index)),
            backgroundColor: SolidColors.bottomNav,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.view_list_rounded),
                label: "List Customer",
                backgroundColor: Colors.amber,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.location_on_rounded),
                label: "loction",
              ),
            ],
          ),
        );
      },
    );
  }
}