class LocationSyncState {
  final double lat;
  final double long;

  LocationSyncState({this.lat = 0.0, this.long = 0.0});

  LocationSyncState copyWith({
    double? lat,
    double? long,
  }) {
    return LocationSyncState(
      lat: lat ?? this.lat,
      long: long ?? this.long,
    );
  }
}
