import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ocean_sys/cubit/location_sync/location_sync_state.dart';
import 'package:ocean_sys/data/repository/location_repository.dart';
import 'package:ocean_sys/model/point_model.dart';

class LocationSyncCubit extends Cubit<LocationSyncState> {
  final LocationRepository _repository;

  LocationSyncCubit(this._repository) : super(LocationSyncState());

  Timer? _syncTimer;
  StreamSubscription<Position>? _positionSub;

  Future<void> startLocationSync() async {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(minutes: 10), (_) async {
      await _updateCurrentLocation();
      await sendUserLocation();
    });
  }

  void startFastUpdates({
    Duration androidInterval = const Duration(seconds: 5),
    int distanceFilter = 0,
  }) {
    if (_positionSub != null) return;

    LocationSettings settings = const LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0,
    );

    if (defaultTargetPlatform == TargetPlatform.android) {
      settings = AndroidSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: distanceFilter,
        intervalDuration: androidInterval,
        forceLocationManager: false,
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      settings = AppleSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0,
        pauseLocationUpdatesAutomatically: true,
      );
    }

    _positionSub = Geolocator.getPositionStream(locationSettings: settings)
        .listen((pos) {
          emit(state.copyWith(lat: pos.latitude, long: pos.longitude));
        });
  }

  void stopFastUpdates() {
    _positionSub?.cancel();
    _positionSub = null;
  }

  Future<void> changeLocation(String code) async {
    await _updateCurrentLocation();
    await sendUserLocation(customerCode: code);
  }

  Future<void> _updateCurrentLocation() async {
    final position = await _getCurrentPosition();
    if (position != null) {
      emit(state.copyWith(lat: position.latitude, long: position.longitude));
    }
  }

  Future<void> sendUserLocation({String? customerCode}) async {
    final payload = LatAndlongModel(
      lat: state.lat,
      long: state.long,
      customerCode: customerCode,
    );
    await _repository.sendUserLocation(payload);
  }

  Future<bool> _ensurePermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<Position?> _getCurrentPosition() async {
    if (!await _ensurePermission()) return null;

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 5,
      timeLimit: Duration(seconds: 20),
    );

    return Geolocator.getCurrentPosition(locationSettings: locationSettings);
  }

  String getDistanceInKm(dynamic endLat, dynamic endLng) {
    _updateCurrentLocation();

    if (endLat == " " || endLng == " ") {
      return "فاقد لت و لانگ";
    }

    final distance =
        Geolocator.distanceBetween(endLat, endLng, state.lat, state.long) /
        1000;
    return " KM ${distance.toStringAsFixed(3)}";
  }

  @override
  Future<void> close() {
    _syncTimer?.cancel();
    _positionSub?.cancel();
    return super.close();
  }
}
