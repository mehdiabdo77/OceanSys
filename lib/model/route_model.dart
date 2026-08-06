class RouteModel {
  final String route;
  final String area;
  final String region;
  final String visitDate;
  final int userId;

  RouteModel({
    required this.route,
    required this.area,
    required this.region,
    required this.visitDate,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'route': route,
      'area': area,
      'region': region,
      'visit_date': visitDate,
      'userId': userId,
    };
  }
}
