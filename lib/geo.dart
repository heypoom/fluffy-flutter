import 'dart:math';
import 'package:vector_math/vector_math.dart';
import 'package:collection/collection.dart';

import 'stations.dart';

const earthRadius = 6371000;
const stationRadius = 300;

class Position {
  final double lat;
  final double lon;

  const Position(this.lat, this.lon);
}

class Geometry {
  static Vector3 toCartesian(double lat, double lon) {
    final latRad = lat / 180 * pi;
    final lonRad = lon / 180 * pi;

    return new Vector3(
      earthRadius * cos(latRad) * cos(lonRad),
      earthRadius * cos(latRad) * sin(lonRad),
      earthRadius * sin(latRad)
    );
  }

  static double getDistance(Position current, Station station) {
    final currentPoint = Geometry.toCartesian(current.lat, current.lon);
    final stationPoint = Geometry.toCartesian(station.lat, station.lon);

    return currentPoint.distanceTo(stationPoint);
  }

  static Station getClosestStation(Position pos) {
    final closestStation = minBy(stations.values, (station) => Geometry.getDistance(pos, station));

    final name = closestStation.name;
    final distance = Geometry.getDistance(pos, closestStation);

    // If the station is within range
    if (distance < stationRadius) {
      print('Station $name is $distance metres away!');

      return closestStation;
    }

    return null;
  }
}
