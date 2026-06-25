import 'package:ocean_sys/model/RouteScannerModel/customer_info_model.dart';

abstract class CustomerInfoState {}

class CustomerInfoInitial extends CustomerInfoState {}

class CustomerInfoLoading extends CustomerInfoState {}

class CustomerInfoLoaded extends CustomerInfoState {
  final List<CustomerInfoModel> customers;

  CustomerInfoLoaded(this.customers);
}

class CustomerInfoError extends CustomerInfoState {
  final String message;

  CustomerInfoError(this.message);
}
