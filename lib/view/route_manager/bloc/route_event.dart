import 'package:ocean_sys/model/route_model.dart';

abstract class RouteEvent {}

class RouteAddSubmitted extends RouteEvent {
  final RouteModel route;
  RouteAddSubmitted(this.route);
}

class RouteDeleteSubmitted extends RouteEvent {
  final RouteModel route;
  RouteDeleteSubmitted(this.route);
}
