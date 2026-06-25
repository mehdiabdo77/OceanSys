import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocean_sys/cubit/customer_edit/customer_edit_state.dart';
import 'package:ocean_sys/data/repository/customer_repository.dart';

class CustomerEditCubit extends Cubit<CustomerEditState> {
  final CustomerRepository _repository;

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

  CustomerEditCubit(this._repository) : super(CustomerEditState());

  void toggleCustomerVisit(bool value) {
    emit(state.copyWith(isCustomerVisit: value));
  }

  void toggleOwnerInShop(bool value) {
    emit(state.copyWith(isOwnerInShop: value));
  }

  void toggleCooperation(bool value) {
    emit(state.copyWith(isCooperation: value));
  }

  void selectDisActive(String value) {
    emit(state.copyWith(selectedDisActive: value));
  }

  void toggleProduct(String product) {
    final products = List<String>.from(state.selectedProducts);
    if (products.contains(product)) {
      products.remove(product);
    } else {
      products.add(product);
    }
    emit(state.copyWith(selectedProducts: products));
  }

  Future<void> sendDisActiveDescription(var customerCode) async {
    await _repository.sendDisActiveDescription(
      customerCode,
      state.selectedDisActive,
      disActiveDescription.text,
    );
  }

  Future<void> taskComplete(var customerCode) async {
    await _repository.taskComplete(customerCode);
  }

  Future<void> sendCRMCustomerDescription(var customerCode) async {
    await _repository.sendCRMCustomerDescription(
      customerCode,
      crmCustomerDescription.text,
      state.isCustomerVisit,
      state.isOwnerInShop,
      state.isCooperation,
    );
  }

  Future<void> sendProductCategoryCustomer(var customerCode) async {
    await _repository.sendProductCategoryCustomer(
      customerCode,
      state.selectedProducts,
    );
  }

  Future<void> sendEditCustomer(var customerCode) async {
    await _repository.sendEditCustomer(
      customerCode: customerCode,
      nationalCode: nationalCode.text,
      roleCode: int.tryParse(roleCode.text),
      postalCode: postalCode.text,
      customerBoard: customerboard.text,
      customerName: customername.text,
      address: address.text,
      mobileNumber: mobileNumber.text,
      mobileNumber2: mobileNumber2.text,
      phoneNumber: phoneNumber.text,
      storeArea: int.tryParse(storeArea.text) ?? 0,
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
