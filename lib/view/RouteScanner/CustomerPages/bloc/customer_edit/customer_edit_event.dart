abstract class CustomerEditEvent {}

class ToggleCustomerVisit extends CustomerEditEvent {
  final bool value;
  ToggleCustomerVisit(this.value);
}

class ToggleOwnerInShop extends CustomerEditEvent {
  final bool value;
  ToggleOwnerInShop(this.value);
}

class ToggleCooperation extends CustomerEditEvent {
  final bool value;
  ToggleCooperation(this.value);
}

class SelectDisActive extends CustomerEditEvent {
  final String value;
  SelectDisActive(this.value);
}

class ToggleProduct extends CustomerEditEvent {
  final String product;
  ToggleProduct(this.product);
}

class SendDisActiveDescription extends CustomerEditEvent {
  final dynamic customerCode;
  final String selectedDisActive;
  final String description;
  SendDisActiveDescription(
    this.customerCode,
    this.selectedDisActive,
    this.description,
  );
}

class TaskComplete extends CustomerEditEvent {
  final dynamic customerCode;
  TaskComplete(this.customerCode);
}

class SendCRMCustomerDescription extends CustomerEditEvent {
  final dynamic customerCode;
  final String description;
  final bool isCustomerVisit;
  final bool isOwnerInShop;
  final bool isCooperation;
  SendCRMCustomerDescription(
    this.customerCode,
    this.description,
    this.isCustomerVisit,
    this.isOwnerInShop,
    this.isCooperation,
  );
}

class SendProductCategoryCustomer extends CustomerEditEvent {
  final dynamic customerCode;
  final List<String> selectedProducts;
  SendProductCategoryCustomer(this.customerCode, this.selectedProducts);
}

class SendEditCustomer extends CustomerEditEvent {
  final dynamic customerCode;
  final String? nationalCode;
  final int? roleCode;
  final String? postalCode;
  final String? customerBoard;
  final String? customerName;
  final String? address;
  final String? mobileNumber;
  final String? mobileNumber2;
  final String? phoneNumber;
  final int storeArea;
  SendEditCustomer({
    required this.customerCode,
    this.nationalCode,
    this.roleCode,
    this.postalCode,
    this.customerBoard,
    this.customerName,
    this.address,
    this.mobileNumber,
    this.mobileNumber2,
    this.phoneNumber,
    required this.storeArea,
  });
}
