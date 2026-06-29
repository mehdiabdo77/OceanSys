import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_edit/customer_edit_state.dart';
import 'package:ocean_sys/view/RouteScanner/CustomerPages/bloc/customer_edit/customer_edit_event.dart';
import 'package:ocean_sys/data/repository/customer_repository.dart';

class CustomerEditBloc extends Bloc<CustomerEditEvent, CustomerEditState> {
  final CustomerRepository repository;

  final TextEditingController nationalCode = TextEditingController();
  final TextEditingController roleCode = TextEditingController();
  final TextEditingController postalCode = TextEditingController();
  final TextEditingController customername = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController customerboard = TextEditingController();
  final TextEditingController mobileNumber = TextEditingController();
  final TextEditingController mobileNumber2 = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController storeArea = TextEditingController();
  final TextEditingController crmCustomerDescription = TextEditingController();
  final TextEditingController disActiveDescription = TextEditingController();

  CustomerEditBloc(this.repository) : super(CustomerEditState()) {
    on<ToggleCustomerVisit>(_onToggleCustomerVisit);
    on<ToggleOwnerInShop>(_onToggleOwnerInShop);
    on<ToggleCooperation>(_onToggleCooperation);
    on<SelectDisActive>(_onSelectDisActive);
    on<ToggleProduct>(_onToggleProduct);
    on<SendDisActiveDescription>(_onSendDisActiveDescription);
    on<TaskComplete>(_onTaskComplete);
    on<SendCRMCustomerDescription>(_onSendCRMCustomerDescription);
    on<SendProductCategoryCustomer>(_onSendProductCategoryCustomer);
    on<SendEditCustomer>(_onSendEditCustomer);
  }

  void _onToggleCustomerVisit(
    ToggleCustomerVisit event,
    Emitter<CustomerEditState> emit,
  ) {
    emit(state.copyWith(isCustomerVisit: event.value));
  }

  void _onToggleOwnerInShop(
    ToggleOwnerInShop event,
    Emitter<CustomerEditState> emit,
  ) {
    emit(state.copyWith(isOwnerInShop: event.value));
  }

  void _onToggleCooperation(
    ToggleCooperation event,
    Emitter<CustomerEditState> emit,
  ) {
    emit(state.copyWith(isCooperation: event.value));
  }

  void _onSelectDisActive(
    SelectDisActive event,
    Emitter<CustomerEditState> emit,
  ) {
    emit(state.copyWith(selectedDisActive: event.value));
  }

  void _onToggleProduct(
    ToggleProduct event,
    Emitter<CustomerEditState> emit,
  ) {
    final products = List<String>.from(state.selectedProducts);
    if (products.contains(event.product)) {
      products.remove(event.product);
    } else {
      products.add(event.product);
    }
    emit(state.copyWith(selectedProducts: products));
  }

  Future<void> _onSendDisActiveDescription(
    SendDisActiveDescription event,
    Emitter<CustomerEditState> emit,
  ) async {
    await repository.sendDisActiveDescription(
      event.customerCode,
      event.selectedDisActive,
      event.description,
    );
  }

  Future<void> _onTaskComplete(
    TaskComplete event,
    Emitter<CustomerEditState> emit,
  ) async {
    await repository.taskComplete(event.customerCode);
  }

  Future<void> _onSendCRMCustomerDescription(
    SendCRMCustomerDescription event,
    Emitter<CustomerEditState> emit,
  ) async {
    await repository.sendCRMCustomerDescription(
      event.customerCode,
      event.description,
      event.isCustomerVisit,
      event.isOwnerInShop,
      event.isCooperation,
    );
  }

  Future<void> _onSendProductCategoryCustomer(
    SendProductCategoryCustomer event,
    Emitter<CustomerEditState> emit,
  ) async {
    await repository.sendProductCategoryCustomer(
      event.customerCode,
      event.selectedProducts,
    );
  }

  Future<void> _onSendEditCustomer(
    SendEditCustomer event,
    Emitter<CustomerEditState> emit,
  ) async {
    await repository.sendEditCustomer(
      customerCode: event.customerCode,
      nationalCode: event.nationalCode,
      roleCode: event.roleCode,
      postalCode: event.postalCode,
      customerBoard: event.customerBoard,
      customerName: event.customerName,
      address: event.address,
      mobileNumber: event.mobileNumber,
      mobileNumber2: event.mobileNumber2,
      phoneNumber: event.phoneNumber,
      storeArea: event.storeArea,
    );
  }

  @override
  Future<void> close() {
    nationalCode.dispose();
    roleCode.dispose();
    postalCode.dispose();
    customername.dispose();
    address.dispose();
    customerboard.dispose();
    mobileNumber.dispose();
    mobileNumber2.dispose();
    phoneNumber.dispose();
    storeArea.dispose();
    crmCustomerDescription.dispose();
    disActiveDescription.dispose();
    return super.close();
  }
}
