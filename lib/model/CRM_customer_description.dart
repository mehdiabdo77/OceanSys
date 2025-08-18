class CRMCustomerDescriptionRequest {
  final String customerCode;
  final String description;
  final bool customerVisit;
  final bool ownerInShop;

  CRMCustomerDescriptionRequest({
    required this.customerCode,
    required this.description,
    required this.customerVisit,
    required this.ownerInShop,
  });

  Map<String, dynamic> toJson() => {
    "customer_code": customerCode,
    "Description": description,
    "is_customer_visit": customerVisit,
    "is_owner_in_shop": ownerInShop,
  };
}
