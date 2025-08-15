class DisactiveCustomerRequest {
  final String customerCode;
  final String reason;
  final String description;

  DisactiveCustomerRequest({
    required this.customerCode,
    required this.reason,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    "customer_code": customerCode,
    "Reason": reason,
    "Description": description,
  };
}
