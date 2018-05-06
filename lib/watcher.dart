import 'dart:async';

import 'package:geolocation/geolocation.dart';
import 'package:local_notifications/local_notifications.dart';

import 'stations.dart';
import 'geo.dart';
import 'store.dart';

class ArrivedEvent {
  final Station station;

  const ArrivedEvent(station);
}

class LocationWatcher {
  StreamController controller;

  Future start() async {
    final perms = const LocationPermission(
      android: LocationPermissionAndroid.fine,
      ios: LocationPermissionIOS.always
    );

    final req = await Geolocation.requestLocationPermission(perms);

    if (!req.isSuccessful) {
      return false;
    }

    final geoData = await Geolocation.currentLocation(
      accuracy: LocationAccuracy.best,
      inBackground: false
    ).first;

    final loc = geoData.location;

    final watcher = Geolocation.locationUpdates(
      accuracy: LocationAccuracy.best,
      inBackground: true,
      displacementFilter: 10.0
    );

    final controller = new StreamController();
    final eventStream = controller.stream;

    // When new location events arrive, handle them.
    final listener = watcher.listen(this.handle);

    // When the stream is cancelled, stop listening to location updates.
    controller.onCancel = listener.cancel;

    await LocalNotifications.createNotification(
      title: "Location Tracking Active!",
      content: "Lat is ${loc.latitude} and Lon is ${loc.longitude}",
      id: 0
    );

    this.controller = controller;

    return eventStream;
  }

  void stop() {
    this.controller.close();
  }

  void handle (result) {
    if (result.isSuccessful) {
      final lat = result.location.latitude;
      final lon = result.location.longitude;

      print('Current Location is: ($lat, $lon)');

      final pos = new Position(lat, lon);
      final station = Geometry.getClosestStation(pos);

      if (station == null) {
        return;
      }

      if (!store.whitelist.contains(station)) {
        print('Station ${station.name} is not whitelisted. Ignoring.');

        return;
      }

      if (station == store.lastKnown) {
        print('We are already at ${station.name}. Ignoring.');

        return;
      }

      final distance = Geometry.getDistance(pos, station);
      store.lastKnown = station;

      LocalNotifications.createNotification(
        title: "You have arrived at ${station.name}!",
        content: "Distance to ${station.name} is $distance.",
        id: 0
      );
    }
  }
}
