abstract class RouteState {}

class RouteInitial extends RouteState {}

class RouteLoading extends RouteState {}

class RouteSuccess extends RouteState {
  final String message;
  RouteSuccess(this.message);
}

class RouteFailure extends RouteState {
  final String error;
  RouteFailure(this.error);
}
