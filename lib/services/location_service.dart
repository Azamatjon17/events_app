import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;

class LocationService {
  static final _location = Location();
  static bool isServiceEnabled = false;
  static PermissionStatus _permissionStatsus = PermissionStatus.denied;
  static LocationData? locationData;

  static Future<void> init() async {
    await checkService();
    await checkPermission();
  }

  static Future<void> checkService() async {
    isServiceEnabled = await _location.serviceEnabled();

    if (!isServiceEnabled) {
      isServiceEnabled = await _location.requestService();

      if (!isServiceEnabled) {
        return;
      }
    }
  }

  static Future<void> checkPermission() async {
    _permissionStatsus = await _location.hasPermission();

    if (_permissionStatsus == PermissionStatus.denied) {
      await _location.requestPermission();
    }
    if (_permissionStatsus == PermissionStatus.granted) {
      return;
    }
  }

  static Future<LocationData?> getCurrentLocation() async {
    if (isServiceEnabled && _permissionStatsus == PermissionStatus.granted) {
      locationData = await _location.getLocation();
      return locationData;
    }
    return null;
  }

  static Stream<LocationData> getLiveLocation() async* {
    yield* _location.onLocationChanged;
  }

  static Future<String> getLocationInformation(double latitude, double longitude) async {
    try {
      List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final geo.Placemark place = placemarks[0];
        return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      } else {
        return "No address available";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
