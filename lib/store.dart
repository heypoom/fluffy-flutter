import 'stations.dart';

class Store {
  final Set<Station> whitelist;
  Station lastKnown;

  Store({this.whitelist});
}

final store = new Store(
  whitelist: new Set()
);
