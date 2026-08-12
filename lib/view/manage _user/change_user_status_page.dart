import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:ocean_sys/constans/decrations.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/model/UserModel/user_model.dart';
import 'package:ocean_sys/view/permissions/cubit/permission_cubit.dart';
import 'package:ocean_sys/view/permissions/cubit/permission_state.dart';
import 'package:ocean_sys/view/route_manager/widget/dialog_search_user.dart';

class ChangeUserStatusPage extends StatelessWidget {
  const ChangeUserStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PermissionCubit()..loadData(),
      child: const ChangeUserStatusView(),
    );
  }
}

class ChangeUserStatusView extends StatefulWidget {
  const ChangeUserStatusView({super.key});

  @override
  State<ChangeUserStatusView> createState() => _ChangeUserStatusViewState();
}

class _ChangeUserStatusViewState extends State<ChangeUserStatusView> {
  UserModel? _selectedUser;
  final TextEditingController _userDisplayController = TextEditingController();

  @override
  void dispose() {
    _userDisplayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SolidColors.homepage,
      appBar: AppBar(
        title: Text('تغییر وضعیت کاربر', style: MyTextStyle.appBarStyle),
        backgroundColor: SolidColors.appBorColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: SolidColors.iconmain),
      ),
      body: BlocConsumer<PermissionCubit, PermissionState>(
        listener: (context, state) {
          if (state is UserStatusUpdated) {
            Get.snackbar(
              'موفق',
              state.message,
              backgroundColor: Colors.green.withOpacity(0.8),
              colorText: Colors.white,
            );
            setState(() {
              if (_selectedUser != null) {
                _selectedUser!.isActive = !(_selectedUser!.isActive == true);
              }
            });
          } else if (state is PermissionError) {
            Get.snackbar(
              'خطا',
              state.message,
              backgroundColor: Colors.red.withOpacity(0.8),
              colorText: Colors.white,
            );
          }
        },
        builder: (context, state) {
          if (state is PermissionLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: MyDecorations.cardDecoration,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('انتخاب کاربر', style: MyTextStyle.textBlack16),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _userDisplayController,
                        readOnly: true,
                        onTap: () async {
                          final user = await showDialog<UserModel>(
                            context: context,
                            builder: (context) => const DialogSearchUser(),
                          );
                          if (user != null) {
                            setState(() {
                              _selectedUser = user;
                              _userDisplayController.text =
                                  '${user.firstName ?? ''} ${user.lastName ?? ''} (${user.user ?? ''})';
                            });
                            if (mounted) {
                              context.read<PermissionCubit>().loadData();
                            }
                          }
                        },
                        style: MyTextStyle.textBlak12,
                        decoration: MyDecorations.inputDecoration.copyWith(
                          labelText: 'انتخاب کاربر',
                          labelStyle: MyTextStyle.textBlak12,
                          prefixIcon: const Icon(Icons.person_search),
                          hintStyle: MyTextStyle.textBlak12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (_selectedUser != null)
                  Container(
                    decoration: MyDecorations.cardDecoration,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('اطلاعات کاربر', style: MyTextStyle.textBlack16),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          'نام و نام خانوادگی',
                          '${_selectedUser!.firstName ?? ''} ${_selectedUser!.lastName ?? ''}',
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          'نام کاربری',
                          _selectedUser!.user ?? 'ندارد',
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          'شناسه کاربر',
                          _selectedUser!.id?.toString() ?? 'ندارد',
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoRow(
                                'وضعیت فعلی',
                                _selectedUser!.isActive == true
                                    ? 'فعال'
                                    : 'غیرفعال',
                                color: _selectedUser!.isActive == true
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: state is PermissionUpdating
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton.icon(
                                  onPressed:
                                      _selectedUser != null &&
                                          _selectedUser!.user != null
                                      ? () {
                                          final nextState =
                                              !(_selectedUser!.isActive ==
                                                  true);
                                          context
                                              .read<PermissionCubit>()
                                              .updateUserStatus(
                                                username: _selectedUser!.user!,
                                                isActive: nextState,
                                              );
                                        }
                                      : null,
                                  icon: Icon(
                                    _selectedUser!.isActive == true
                                        ? Icons.person_off
                                        : Icons.person,
                                  ),
                                  style: MyDecorations.mainButtom.copyWith(
                                    backgroundColor: WidgetStateProperty.all(
                                      _selectedUser!.isActive == true
                                          ? Colors.red
                                          : SolidColors.accentColor,
                                    ),
                                  ),
                                  label: Text(
                                    _selectedUser!.isActive == true
                                        ? 'غیرفعال کردن کاربر'
                                        : 'فعال کردن کاربر',
                                  ),
                                ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    decoration: MyDecorations.cardDecoration,
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.person_search,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لطفاً ابتدا یک کاربر را انتخاب کنید',
                          style: MyTextStyle.textBlack16,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'برای انتخاب کاربر روی فیلد بالا کلیک کنید',
                          style: MyTextStyle.caption,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: MyTextStyle.textBlak12.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: MyTextStyle.textBlak12.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
