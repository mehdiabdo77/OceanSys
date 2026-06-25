import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:ocean_sys/cubit/customer_info/customer_info_state.dart';
import 'package:ocean_sys/data/repository/customer_info_repository.dart';
import 'package:ocean_sys/model/RouteScannerModel/customer_info_model.dart';

abstract class CustomerInfoEvent {}

class CustomerInfoFetchData extends CustomerInfoEvent {}

class CustomerInfoBloc extends Bloc<CustomerInfoEvent, CustomerInfoState> {
  final CustomerInfoRepository repository;

  CustomerInfoBloc(this.repository) : super(CustomerInfoInitial()) {
    on<CustomerInfoFetchData>(_onFetchData);
  }

  Future<void> _onFetchData(
    CustomerInfoFetchData event,
    Emitter<CustomerInfoState> emit,
  ) async {
    emit(CustomerInfoLoading());
    try {
      final customers = await repository.getCustomerInfo();
      emit(CustomerInfoLoaded(customers));
    } catch (e) {
      emit(CustomerInfoError("خطا در ارتباط با سرور: $e"));
    }
  }

  List<Map<String, dynamic>> getPoints(List<CustomerInfoModel> customers) {
    List<Map<String, dynamic>> customerPoints = [];
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
