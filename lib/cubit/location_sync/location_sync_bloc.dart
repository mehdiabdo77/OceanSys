import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ocean_sys/cubit/location_sync/location_sync_state.dart';
import 'package:ocean_sys/data/repository/location_repository.dart';
import 'package:ocean_sys/model/point_model.dart';

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

class LocationSyncBloc extends Bloc<LocationSyncEvent, LocationSyncState> {
  final LocationRepository repository;

  Timer? _syncTimer;
  StreamSubscription<Position>? _positionSub;

  LocationSyncBloc(this.repository) : super(LocationSyncState()) {
    on<StartLocationSync>(_onStartLocationSync);
    on<StartFastUpdates>(_onStartFastUpdates);
    on<StopFastUpdates>(_onStopFastUpdates);
    on<ChangeLocation>(_onChangeLocation);
    on<SendUserLocation>(_onSendUserLocation);
  }

  Future<void> _onStartLocationSync(
    StartLocationSync event,
    Emitter<LocationSyncState> emit,
  ) async {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(minutes: 10), (_) async {
      await _updateCurrentLocation(emit);
      await _sendUserLocation(emit, null);
    });
  }

  Future<void> _onStartFastUpdates(
    StartFastUpdates event,
    Emitter<LocationSyncState> emit,
  ) async {
    if (_positionSub != null) return;

    if (!await _ensurePermission()) return;

    LocationSettings settings = const LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0,
    );

    if (defaultTargetPlatform == TargetPlatform.android) {
      settings = AndroidSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: event.distanceFilter,
        intervalDuration: event.androidInterval,
        forceLocationManager: false,
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      settings = AppleSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0,
        pauseLocationUpdatesAutomatically: true,
      );
    }

    final stream = Geolocator.getPositionStream(locationSettings: settings)
        .handleError((error) {
          print('Location stream error: $error');
        });

    // Save subscription so we can cancel it later
    _positionSub = stream.listen(null);

    // Proper bloc way: use emit.forEach to handle stream emissions
    await emit.forEach<Position>(
      stream,
      onData: (pos) => state.copyWith(lat: pos.latitude, long: pos.longitude),
    );
  }

  void _onStopFastUpdates(
    StopFastUpdates event,
    Emitter<LocationSyncState> emit,
  ) {
    _positionSub?.cancel();
    _positionSub = null;
  }

  Future<void> _onChangeLocation(
    ChangeLocation event,
    Emitter<LocationSyncState> emit,
  ) async {
    await _updateCurrentLocation(emit);
    await _sendUserLocation(emit, event.customerCode);
  }

  Future<void> _onSendUserLocation(
    SendUserLocation event,
    Emitter<LocationSyncState> emit,
  ) async {
    await _sendUserLocation(emit, event.customerCode);
  }

  Future<void> _updateCurrentLocation(Emitter<LocationSyncState> emit) async {
    final position = await _getCurrentPosition();
    if (position != null) {
      emit(state.copyWith(lat: position.latitude, long: position.longitude));
    }
  }

  Future<void> _sendUserLocation(
    Emitter<LocationSyncState> emit,
    String? customerCode,
  ) async {
    final payload = LatAndlongModel(
      lat: state.lat,
      long: state.long,
      customerCode: customerCode,
    );
    await repository.sendUserLocation(payload);
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
