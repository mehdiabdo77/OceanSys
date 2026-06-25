import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:ocean_sys/cubit/customer_info/customer_info_state.dart';
import 'package:ocean_sys/data/repository/customer_info_repository.dart';

class CustomerInfoCubit extends Cubit<CustomerInfoState> {
  final CustomerInfoRepository _repository;

  CustomerInfoCubit(this._repository) : super(CustomerInfoInitial());

  List<Map<String, dynamic>> customerPoints = [];

  Future<void> getCustomerInfo() async {
    emit(CustomerInfoLoading());
    try {
      final customers = await _repository.getCustomerInfo();
      emit(CustomerInfoLoaded(customers));
    } catch (e) {
      emit(CustomerInfoError("خطا در ارتباط با سرور: $e"));
    }
  }

  List<Map<String, dynamic>> getPoints() {
    if (state is! CustomerInfoLoaded) {
      return [];
    }

    final customers = (state as CustomerInfoLoaded).customers;
    customerPoints.clear();

    for (var customer in customers) {
      if (customer.latitude != null &&
          customer.longitude != null &&
          customer.address != null) {
        customerPoints.add({
          'name': customer.customerBoard,
          'isvusit': customer.visited,
          'location': LatLng(
            double.tryParse(customer.latitude.toString()) ?? 0.0,
            double.tryParse(customer.longitude.toString()) ?? 0.0,
          ),
        });
      }
    }

    return customerPoints;
  }
}
