import 'package:flutter/material.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/view/manage%20_user/add_user_page.dart';
import 'package:ocean_sys/view/manage%20_user/change_user_status_page.dart';

class UserManager extends StatelessWidget {
  const UserManager({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('مدیریت کاربران', style: MyTextStyle.appBarStyle),
          bottom: TabBar(
            labelColor: SolidColors.primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: SolidColors.primaryColor,
            tabs: const [
              Tab(text: 'افزودن کاربر', icon: Icon(Icons.add)),
              Tab(text: 'غیرفعال  و فعال سازی', icon: Icon(Icons.delete)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [AddUserPage(), ChangeUserStatusPage()],
        ),
      ),
    );
  }
}
