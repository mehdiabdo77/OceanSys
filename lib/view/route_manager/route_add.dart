import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocean_sys/constans/decrations.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/model/UserModel/user_model.dart';
import 'package:ocean_sys/model/route_model.dart';
import 'package:ocean_sys/view/route_manager/bloc/route_bloc.dart';
import 'package:ocean_sys/view/route_manager/bloc/route_event.dart';
import 'package:ocean_sys/view/route_manager/bloc/route_state.dart';
import 'package:ocean_sys/view/route_manager/widget/dialog_search_user.dart';

class RouteAddPage extends StatefulWidget {
  const RouteAddPage({super.key});

  @override
  State<RouteAddPage> createState() => _RouteAddPageState();
}

class _RouteAddPageState extends State<RouteAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _routeController = TextEditingController();
  final _areaController = TextEditingController();
  final _regionController = TextEditingController();
  final _dateController = TextEditingController();
  final _userIdController = TextEditingController();

  @override
  void dispose() {
    _routeController.dispose();
    _areaController.dispose();
    _regionController.dispose();
    _dateController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('افزودن مسیر جدید', style: MyTextStyle.textBlack16),
              const SizedBox(height: 20),
              TextFormField(
                controller: _routeController,
                decoration: MyDecorations.inputDecoration.copyWith(
                  labelText: 'نام مسیر',
                  prefixIcon: const Icon(Icons.route),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'نام مسیر الزامی است'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _areaController,
                decoration: MyDecorations.inputDecoration.copyWith(
                  labelText: 'محدوده',
                  prefixIcon: const Icon(Icons.map),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'محدوده الزامی است' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _regionController,
                decoration: MyDecorations.inputDecoration.copyWith(
                  labelText: 'منطقه',
                  prefixIcon: const Icon(Icons.location_on),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'منطقه الزامی است' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                decoration: MyDecorations.inputDecoration.copyWith(
                  labelText: 'تاریخ بازدید (YYYY-MM-DD)',
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'تاریخ الزامی است' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _userIdController,
                readOnly: true,
                onTap: () async {
                  final user = await showDialog<UserModel>(
                    context: context,
                    builder: (context) => const DialogSearchUser(),
                  );
                  if (user != null) {
                    _userIdController.text = user.id.toString();
                  }
                },
                decoration: MyDecorations.inputDecoration.copyWith(
                  labelText: 'انتخاب کاربر (شناسه)',
                  prefixIcon: const Icon(Icons.person_search),
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
                    _formKey.currentState?.reset();
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final route = RouteModel(
                          route: _routeController.text,
                          area: _areaController.text,
                          region: _regionController.text,
                          visitDate: _dateController.text,
                          userId: int.parse(_userIdController.text),
                        );
                        context.read<RouteBloc>().add(RouteAddSubmitted(route));
                      }
                    },
                    style: MyDecorations.mainButtom,
                    child: const Text('ثبت مسیر'),
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
