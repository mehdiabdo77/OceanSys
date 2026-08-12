import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:ocean_sys/constans/decrations.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/data/repository/permission_repository.dart';
import 'package:ocean_sys/data/repository/user_repository.dart';
import 'package:ocean_sys/view/manage%20_user/bloc/add_user_bloc.dart';

class AddUserPage extends StatelessWidget {
  const AddUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddUserBloc(
        userRepository: UserRepository(),
        permissionRepository: PermissionRepository(),
      )..add(FetchRolesEvent()),
      child: const AddUserView(),
    );
  }
}

class AddUserView extends StatefulWidget {
  const AddUserView({Key? key}) : super(key: key);

  @override
  State<AddUserView> createState() => _AddUserViewState();
}

class _AddUserViewState extends State<AddUserView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isActive = true;
  String? _selectedRole;

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedRole == null) {
        Get.snackbar(
          'خطا',
          'لطفاً یک نقش را انتخاب کنید',
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
        return;
      }

      // بررسی برای تطبیق دقیق با admin یا user
      String roleToSend = _selectedRole!.toLowerCase();
      if (roleToSend != 'admin' && roleToSend != 'user') {
        // اگر سرور فقط این دو مقدار رو قبول می‌کنه، مقادیر دیگر رو به یکی از این دو نگاشت می‌کنیم
        // یا می‌تونیم یه ارور به کاربر نشون بدیم
        if (roleToSend.contains('admin')) {
          roleToSend = 'admin';
        } else {
          roleToSend = 'user'; // پیش‌فرض برای بقیه نقش‌ها
        }
      }

      context.read<AddUserBloc>().add(
        SubmitAddUserEvent(
          username: _usernameController.text.trim(),
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          password: _passwordController.text.trim(),
          isActive: _isActive,
          role: roleToSend,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SolidColors.homepage,
      appBar: AppBar(
        title: Text('ایجاد کاربر جدید', style: MyTextStyle.appBarStyle),
        backgroundColor: SolidColors.appBorColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: SolidColors.iconmain),
      ),
      body: BlocConsumer<AddUserBloc, AddUserState>(
        listener: (context, state) {
          if (state is AddUserSuccess) {
            Get.snackbar(
              'موفق',
              state.message,
              backgroundColor: Colors.green.withOpacity(0.8),
              colorText: Colors.white,
            );
            // خالی کردن فرم بعد از موفقیت
            _usernameController.clear();
            _firstNameController.clear();
            _lastNameController.clear();
            _passwordController.clear();
            setState(() {
              _isActive = true;
              _selectedRole = null;
            });
          } else if (state is AddUserFailure) {
            Get.snackbar(
              'خطا',
              state.error,
              backgroundColor: Colors.red.withOpacity(0.8),
              colorText: Colors.white,
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: MyDecorations.cardDecoration,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('اطلاعات کاربر', style: MyTextStyle.textBlack16),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _usernameController,
                          style: MyTextStyle.textBlak12,
                          decoration: MyDecorations.inputDecoration.copyWith(
                            labelText: 'نام کاربری',
                            labelStyle: MyTextStyle.textBlak12,
                            prefixIcon: const Icon(Icons.person_outline),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'نام کاربری الزامی است'
                              : null,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _firstNameController,
                          style: MyTextStyle.textBlak12,
                          decoration: MyDecorations.inputDecoration.copyWith(
                            labelText: 'نام',
                            labelStyle: MyTextStyle.textBlak12,
                            prefixIcon: const Icon(Icons.badge_outlined),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'نام الزامی است'
                              : null,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _lastNameController,
                          style: MyTextStyle.textBlak12,
                          decoration: MyDecorations.inputDecoration.copyWith(
                            labelText: 'نام خانوادگی',
                            labelStyle: MyTextStyle.textBlak12,
                            prefixIcon: const Icon(Icons.badge_outlined),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'نام خانوادگی الزامی است'
                              : null,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          style: MyTextStyle.textBlak12,
                          decoration: MyDecorations.inputDecoration.copyWith(
                            labelText: 'رمز عبور',
                            labelStyle: MyTextStyle.textBlak12,
                            prefixIcon: const Icon(Icons.lock_outline),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'رمز عبور الزامی است'
                              : null,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    decoration: MyDecorations.cardDecoration,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('تنظیمات دسترسی', style: MyTextStyle.textBlack16),
                        const SizedBox(height: 16),

                        // Dropdown for Role
                        if (state is RolesErrorState)
                          Text(
                            'خطا در دریافت نقش‌ها: ${state.message}',
                            style: const TextStyle(color: Colors.red),
                          )
                        else if (state is RolesLoadedState ||
                            context.read<AddUserBloc>().rolesList.isNotEmpty)
                          DropdownButtonFormField<String>(
                            value: _selectedRole,
                            style: MyTextStyle.textBlak12,
                            decoration: MyDecorations.inputDecoration.copyWith(
                              labelText: 'نقش (دسترسی)',
                              labelStyle: MyTextStyle.textBlak12,
                              prefixIcon: const Icon(Icons.security),
                            ),
                            items: context.read<AddUserBloc>().rolesList.map((
                              role,
                            ) {
                              // چک می‌کنیم اگر نام رول معتبر هست اون رو توی لیست نشون بدیم
                              // اگر لیست نقش‌ها نام‌های متفاوتی دارن می‌تونیم همینجا تغییر بدیم.
                              return DropdownMenuItem<String>(
                                value: role.name,
                                child: Text(
                                  role.name ?? 'نامشخص',
                                  style: MyTextStyle.textBlak12,
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedRole = val;
                              });
                            },
                          )
                        else
                          const Center(child: CircularProgressIndicator()),

                        const SizedBox(height: 16),

                        // Switch for IsActive
                        Material(
                          color: Colors.transparent,
                          child: SwitchListTile(
                            title: Text(
                              'وضعیت فعال بودن',
                              style: MyTextStyle.checkboxFont,
                            ),
                            value: _isActive,
                            activeColor: SolidColors.accentColor,
                            onChanged: (val) {
                              setState(() {
                                _isActive = val;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: MyDecorations.mainButtom,
                      onPressed: state is AddUserLoading ? null : _submit,
                      child: state is AddUserLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('ثبت کاربر'),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
