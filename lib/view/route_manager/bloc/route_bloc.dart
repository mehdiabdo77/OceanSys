import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocean_sys/data/repository/route_repository.dart';
import 'package:ocean_sys/view/route_manager/bloc/route_event.dart';
import 'package:ocean_sys/view/route_manager/bloc/route_state.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  final RouteRepository repository;

  RouteBloc(this.repository) : super(RouteInitial()) {
    on<RouteAddSubmitted>(_onAddRoute);
    on<RouteDeleteSubmitted>(_onDeleteRoute);
  }

  Future<void> _onAddRoute(
    RouteAddSubmitted event,
    Emitter<RouteState> emit,
  ) async {
    emit(RouteLoading());
    final success = await repository.setRoute(event.route);
    if (success) {
      emit(RouteSuccess("مسیر با موفقیت ثبت شد"));
    } else {
      emit(RouteFailure("خطا در ثبت مسیر"));
    }
  }

  Future<void> _onDeleteRoute(
    RouteDeleteSubmitted event,
    Emitter<RouteState> emit,
  ) async {
    emit(RouteLoading());
    final success = await repository.deleteRoute(event.route);
    if (success) {
      emit(RouteSuccess("مسیر با موفقیت حذف شد"));
    } else {
      emit(RouteFailure("خطا in حذف مسیر"));
    }
  }
}
