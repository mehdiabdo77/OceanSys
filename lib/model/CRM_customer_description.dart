class CRMCustomerDescriptionRequest {
  final String customerCode;
  final String description;

  CRMCustomerDescriptionRequest({
    required this.customerCode,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    "customer_code": customerCode,
    "Description": description,
  };
}
