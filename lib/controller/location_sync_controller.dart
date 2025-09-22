import 'dart:async';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ocean_sys/constans/api_constant.dart';
import 'package:ocean_sys/constans/storage_const.dart';
import 'package:ocean_sys/model/point_model.dart';
import 'package:ocean_sys/servies/dio_service.dart';
import 'package:ocean_sys/servies/location_service.dart';

class LocationSyncController extends GetxController {
  final _lat = 0.0.obs;
  final _long = 0.0.obs;
  Timer? _syncTimer;
  final _service = LocationService();

  // مختص استریم سریع در صفحه نقشه
  StreamSubscription<Position>? _positionSub;

  double get lat => _lat.value;
  double get long => _long.value;

  @override
  void onInit() {
    super.onInit();
    startLocationSync();
  }

  void startLocationSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(minutes: 10), (_) async {
      await _updateCurrentLocation();
      await sendUserLocation();
    });
  }

  // استریم سریع: فقط وقتی MapPage باز است صدا بزن
  void startFastUpdates({
    Duration androidInterval = const Duration(seconds: 5),
    int distanceFilter = 0,
  }) {
    // اگر قبلا فعال است، چیزی انجام نده
    if (_positionSub != null) return;

    LocationSettings settings = const LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0, // هر تغییر کوچکی را دریافت کن
    );

    // برای اندروید، فرکانس را دقیق‌تر کنترل می‌کنیم
    if (GetPlatform.isAndroid) {
      settings = AndroidSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: distanceFilter,
        intervalDuration: androidInterval,
        forceLocationManager: false,
      );
    } else if (GetPlatform.isIOS) {
      settings = AppleSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0,
        pauseLocationUpdatesAutomatically: true,
      );
    }

    _positionSub = Geolocator.getPositionStream(locationSettings: settings)
        .listen((pos) {
          _lat.value = pos.latitude;
          _long.value = pos.longitude;
        });
  }

  void stopFastUpdates() {
    _positionSub?.cancel();
    _positionSub = null;
  }

  changeLoction(String code) async {
    await _updateCurrentLocation();
    await sendUserLocation(customercode: code);
  }

  Future<void> _updateCurrentLocation() async {
    final position = await _getCurrentPosition();
    print("postion ${position}");
    if (position != null) {
      _lat.value = position.latitude;
      _long.value = position.longitude;
    }
  }

  Future<void> sendUserLocation({String? customercode}) async {
    final payload = LatAndlongModel(
      lat: _lat.value,
      long: _long.value,
      customerCode: customercode,
    );
    await _service.sendUserLocation(payload);
  }

  @override
  void onClose() {
    _syncTimer?.cancel();
    _positionSub?.cancel();
    super.onClose();
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

    // تنظیمات مشترک برای هر دو پلتفرم
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best, // بالاترین دقت
      distanceFilter: 5, // فقط بعد از حداقل ۵ متر جابجایی
      timeLimit: Duration(
        seconds: 20,
      ), // در صورت عدم دریافت، پس از 20 ثانیه تایم‌اوت
    );

    return Geolocator.getCurrentPosition(locationSettings: locationSettings);
  }

  // برای منوی لیست مشتریان
  String getDistanceInKm(var endLat, var endLng) {
    _updateCurrentLocation();

    print("lat is ${_lat.value}");
    if (endLat == " " || endLng == " ") {
      return "فاقد لت و لانگ";
    }

    final distance =
        Geolocator.distanceBetween(endLat, endLng, _lat.value, _long.value) /
        1000;
    print(distance);

    return " KM ${distance.toStringAsFixed(3)}";
  }
}
