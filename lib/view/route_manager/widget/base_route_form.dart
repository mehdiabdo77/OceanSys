import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocean_sys/constans/decrations.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/model/UserModel/user_model.dart';
import 'package:ocean_sys/view/route_manager/bloc/route_bloc.dart';
import 'package:ocean_sys/view/route_manager/bloc/route_state.dart';
import 'package:ocean_sys/view/route_manager/widget/dialog_persian_calendar.dart';
import 'package:ocean_sys/view/route_manager/widget/dialog_search_user.dart';

class BaseRouteFormWidget extends StatelessWidget {
  final String title;
  final String submitButtonText;
  final Color? submitButtonColor;
  final GlobalKey<FormState> formKey;
  final TextEditingController routeController;
  final TextEditingController areaController;
  final TextEditingController regionController;
  final TextEditingController dateController;
  final TextEditingController userIdController;
  final Function(Map<String, String>) onDateSelected;
  final Function(UserModel) onUserSelected;
  final void Function() onSubmit;

  const BaseRouteFormWidget({
    super.key,
    required this.title,
    required this.submitButtonText,
    this.submitButtonColor,
    required this.formKey,
    required this.routeController,
    required this.areaController,
    required this.regionController,
    required this.dateController,
    required this.userIdController,
    required this.onDateSelected,
    required this.onUserSelected,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: MyTextStyle.textBlack16),
              const SizedBox(height: 20),
              TextFormField(
                controller: routeController,
                decoration: MyDecorations.inputDecoration.copyWith(
                  labelText: 'نام مسیر',
                  prefixIcon: const Icon(Icons.route),
                ),
                style: MyTextStyle.textBlack16,
                validator: (value) => value == null || value.isEmpty
                    ? 'نام مسیر الزامی است'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: areaController,
                decoration: MyDecorations.inputDecoration.copyWith(
                  labelText: 'ناحیه',
                  prefixIcon: const Icon(Icons.map),
                ),
                style: MyTextStyle.textBlack16,
                validator: (value) =>
                    value == null || value.isEmpty ? 'محدوده الزامی است' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: regionController,
                decoration: MyDecorations.inputDecoration.copyWith(
                  labelText: 'محدوده',
                  prefixIcon: const Icon(Icons.location_on),
                ),
                style: MyTextStyle.textBlack16,
                validator: (value) =>
                    value == null || value.isEmpty ? 'منطقه الزامی است' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: dateController,
                readOnly: true,
                onTap: () async {
                  final result = await showDialog<Map<String, String>>(
                    context: context,
                    builder: (context) => const DialogPersianCalendar(),
                  );
                  if (result != null) {
                    onDateSelected(result);
                  }
                },
                style: MyTextStyle.textBlack16,
                decoration: MyDecorations.inputDecoration.copyWith(
                  labelText: 'تاریخ بازدید (YYYY-MM-DD)',
                  prefixIcon: const Icon(Icons.calendar_today),
                  hintStyle: MyTextStyle.textBlack16,
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'تاریخ الزامی است' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: userIdController,
                readOnly: true,
                onTap: () async {
                  final user = await showDialog<UserModel>(
                    context: context,
                    builder: (context) => const DialogSearchUser(),
                  );
                  if (user != null) {
                    onUserSelected(user);
                  }
                },
                style: MyTextStyle.textBlack16,
                decoration: MyDecorations.inputDecoration.copyWith(
                  labelText: 'انتخاب کاربر (شناسه)',
                  prefixIcon: const Icon(Icons.person_search),
                  hintStyle: MyTextStyle.textBlack16,
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'لطفا یک کاربر انتخاب کنید'
                    : null,
              ),
              const SizedBox(height: 30),
              BlocConsumer<RouteBloc, RouteState>(
                listener: (context, state) {
                  if (state is RouteSuccess) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                    formKey.currentState?.reset();
                  } else if (state is RouteFailure) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.error)));
                  }
                },
                builder: (context, state) {
                  if (state is RouteLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ElevatedButton(
                    onPressed: onSubmit,
                    style: submitButtonColor != null
                        ? MyDecorations.mainButtom.copyWith(
                            backgroundColor: WidgetStateProperty.all(
                              submitButtonColor,
                            ),
                          )
                        : MyDecorations.mainButtom,
                    child: Text(submitButtonText),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
