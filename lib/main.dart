import 'package:flutter/material.dart';
import 'package:local_notifications/local_notifications.dart';

import 'stations.dart';
import 'watcher.dart';
import 'store.dart';

void main() {
  runApp(new App());
}

class Landing extends StatefulWidget {
  @override
  createState() => new LandingState();
}

class LandingState extends State<Landing> {
  final watcher = new LocationWatcher();
  int id = 0;

  final _biggerFont = new TextStyle(
    fontSize: 20.0,
    color: Colors.teal,
    fontFamily: "Roboto",
  );

  Widget _buildItems() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();

        final index = i ~/ 2;
        final station = stations.values.elementAt(index);

        return _buildRow(station);
      },
      itemCount: (stations.length * 2) - 1
    );
  }

  Widget _buildRow(Station station) {
    final alreadySaved = store.whitelist.contains(station);

    return new ListTile(
      title: new Text(
        station.name,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () async {
        setState(() {
          if (alreadySaved) {
            store.whitelist.remove(station);
          } else {
            store.whitelist.add(station);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = store.lastKnown != null ? store.lastKnown.name : 'None';

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Metro Notifier 🚆'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.build), onPressed: watcher.start),
        ],
      ),
      body: new Column(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(top: 20.0),
            child: new Text(
              'Last Known Station: $name',
              style: new TextStyle(fontSize: 23.0)
            ),
          ),
          new Container(
            height: 500.0,
            child: this._buildItems()
          )
        ]
      )
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Fluffy Notifier',
      home: new Landing(),
      theme: new ThemeData(
        primaryColor: Colors.teal
      ),
    );
  }
}
