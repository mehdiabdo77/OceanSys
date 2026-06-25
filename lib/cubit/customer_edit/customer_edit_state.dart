class CustomerEditState {
  final bool isCustomerVisit;
  final bool isOwnerInShop;
  final bool isCooperation;
  final String selectedDisActive;
  final List<String> selectedProducts;

  CustomerEditState({
    this.isCustomerVisit = false,
    this.isOwnerInShop = false,
    this.isCooperation = false,
    this.selectedDisActive = "",
    this.selectedProducts = const [],
  });

  CustomerEditState copyWith({
    bool? isCustomerVisit,
    bool? isOwnerInShop,
    bool? isCooperation,
    String? selectedDisActive,
    List<String>? selectedProducts,
  }) {
    return CustomerEditState(
      isCustomerVisit: isCustomerVisit ?? this.isCustomerVisit,
      isOwnerInShop: isOwnerInShop ?? this.isOwnerInShop,
      isCooperation: isCooperation ?? this.isCooperation,
      selectedDisActive: selectedDisActive ?? this.selectedDisActive,
      selectedProducts: selectedProducts ?? this.selectedProducts,
    );
  }
}
