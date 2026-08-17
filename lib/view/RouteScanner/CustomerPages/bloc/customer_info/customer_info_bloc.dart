import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_info/customer_info_state.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_info/customer_info_event.dart';
import 'package:ocean_sys/data/repository/customer_info_repository.dart';
import 'package:ocean_sys/model/RouteScannerModel/customer_info_model.dart';

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
    for (var i = 0; i < customers.length; i++) {
      final customer = customers[i];
      if (customer.latitude != null &&
          customer.longitude != null &&
          customer.address != null) {
        final lat = double.tryParse(customer.latitude.toString());
        final lng = double.tryParse(customer.longitude.toString());

        // Only add if both lat and lng are valid (not 0,0)
        if (lat != null && lng != null && lat != 0.0 && lng != 0.0) {
          customerPoints.add({
            'index': i,
            'name': customer.customerBoard,
            'isvusit': customer.visited,
            'location': LatLng(lat, lng),
          });
        }
      }
    }
    return customerPoints;
  }
}
