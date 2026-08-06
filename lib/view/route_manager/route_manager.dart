import 'package:flutter/material.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/view/route_manager/route_add.dart';
import 'package:ocean_sys/view/route_manager/route_delet.dart';

class RouteManager extends StatelessWidget {
  const RouteManager({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('مدیریت مسیرها', style: MyTextStyle.appBarStyle),
          bottom: TabBar(
            labelColor: SolidColors.primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: SolidColors.primaryColor,
            tabs: const [
              Tab(text: 'افزودن مسیر', icon: Icon(Icons.add_location_alt)),
              Tab(text: 'حذف مسیر', icon: Icon(Icons.wrong_location)),
            ],
          ),
        ),
        body: const TabBarView(children: [RouteAddPage(), RouteDeletePage()]),
      ),
    );
  }
}
