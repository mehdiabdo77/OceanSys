class LatAndlongModel {
  final String? customerCode;
  final double lat;
  final double long;

  LatAndlongModel({this.customerCode, required this.lat, required this.long});

  Map<String, dynamic> toJson() {
    final map = {
      if (customerCode != null) 'customer_code': customerCode,
      'lat': lat,
      'lng': long,
    };
    return map;
  }
}
