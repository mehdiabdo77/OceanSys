import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocean_sys/view/main/bloc/main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainState());

  void changePage(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}
