import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocean_sys/view/main/bloc/main_state.dart';

abstract class MainEvent {}

class MainChangePage extends MainEvent {
  final int index;
  MainChangePage(this.index);
}

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainState()) {
    on<MainChangePage>(_onChangePage);
  }

  void _onChangePage(MainChangePage event, Emitter<MainState> emit) {
    emit(state.copyWith(currentIndex: event.index));
  }
}
