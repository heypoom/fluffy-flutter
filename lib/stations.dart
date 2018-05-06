library stations;

class Station {
  final double lat;
  final double lon;
  final String name;

  const Station({this.name, this.lat, this.lon});
}

Map<String, Station> stations = {
  'phayaThai': new Station(name: "Phaya Thai", lat: 13.7570449, lon: 100.5317008),
  'siam': new Station(name: "Siam", lat: 13.7455162, lon: 100.5324097),
  'nationalStadium': new Station(name: "National Stadium", lat: 13.746457, lon: 100.526922),
  'bangChak': new Station(name: "Bang Chak", lat: 13.6967714, lon: 100.6031286),
};
