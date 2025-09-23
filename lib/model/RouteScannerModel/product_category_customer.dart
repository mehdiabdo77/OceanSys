class ProductCategoryCustomer {
  final String customerCode;
  final List<String> sku;

  ProductCategoryCustomer({required this.customerCode, required this.sku});

  Map<String, dynamic> toJson() => {"customer_code": customerCode, "sku": sku};
}
