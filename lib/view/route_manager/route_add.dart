import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocean_sys/model/route_model.dart';
import 'package:ocean_sys/view/route_manager/bloc/route_bloc.dart';
import 'package:ocean_sys/view/route_manager/bloc/route_event.dart';
import 'package:ocean_sys/view/route_manager/widget/base_route_form.dart';

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
  String _visitDateGregorian = '';

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
    return BaseRouteFormWidget(
      title: 'افزودن مسیر جدید',
      submitButtonText: 'ثبت مسیر',
      formKey: _formKey,
      routeController: _routeController,
      areaController: _areaController,
      regionController: _regionController,
      dateController: _dateController,
      userIdController: _userIdController,
      onDateSelected: (result) {
        _dateController.text = result['jalali']!;
        _visitDateGregorian = result['gregorian']!;
      },
      onUserSelected: (user) {
        _userIdController.text = user.id.toString();
      },
      onSubmit: () {
        if (_formKey.currentState!.validate()) {
          final route = RouteModel(
            route: _routeController.text,
            area: _areaController.text,
            region: _regionController.text,
            visitDate: _visitDateGregorian,
            userId: int.tryParse(_userIdController.text) ?? 0,
          );
          context.read<RouteBloc>().add(RouteAddSubmitted(route));
        }
      },
    );
  }
}
