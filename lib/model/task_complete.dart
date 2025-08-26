class TaskComplete {
  final String customerCode;

  TaskComplete({required this.customerCode});

  Map<String, dynamic> toJson() => {"customer_code": customerCode};
}
