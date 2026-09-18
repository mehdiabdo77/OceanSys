abstract class LocationSyncEvent {}

class StartLocationSync extends LocationSyncEvent {}

class StartFastUpdates extends LocationSyncEvent {
  final Duration androidInterval;
  final int distanceFilter;
  StartFastUpdates({
    this.androidInterval = const Duration(seconds: 5),
    this.distanceFilter = 0,
  });
}

class StopFastUpdates extends LocationSyncEvent {}

class ChangeLocation extends LocationSyncEvent {
  final String customerCode;
  ChangeLocation(this.customerCode);
}

class SendUserLocation extends LocationSyncEvent {
  final String? customerCode;
  SendUserLocation([this.customerCode]);
}