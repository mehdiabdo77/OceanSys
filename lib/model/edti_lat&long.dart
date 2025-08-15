class EdtiLatAndlong {
  final String customerCode;
  final double lat;
  final double long;

  EdtiLatAndlong({
    required this.customerCode,
    required this.lat,
    required this.long,
  });

  Map<String, dynamic> toJson() => {
    "customer_code": customerCode,
    "lat": lat,
    "long": long,
  };
}
