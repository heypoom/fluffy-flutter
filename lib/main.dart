import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new App());

class WordHeading extends StatefulWidget {
  @override
  createState() => new WordHeadingState();
}

class WordHeadingState extends State<WordHeading> {
  final _suggestions = <WordPair>[];
  final _saved = new Set<WordPair>();

  final _biggerFont = const TextStyle(
    fontSize: 18.0,
    color: Colors.teal,
    fontFamily: "Sukhumvit Set",
  );

  Widget _buildSuggestions() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();

        final index = i ~/ 2;

        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair wordPair) {
    final alreadySaved = _saved.contains(wordPair);

    return new ListTile(
      title: new Text(
        wordPair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(wordPair);
          } else {
            _saved.add(wordPair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    final route = new MaterialPageRoute(builder: (context) {
      final tiles = _saved.map((pair) => new ListTile(
        title: new Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
      ));

      final divided = ListTile
        .divideTiles(context: context, tiles: tiles)
        .toList();

      return new Scaffold(
        appBar: new AppBar(
          title: new Text('Saved Suggestions'),
        ),
        body: new ListView(children: divided),
      );
    });

    Navigator.of(context).push(route);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Fluffy Rabbit 🐇'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Fluffy Notifier',
      home: new WordHeading(),
      theme: new ThemeData(
        primaryColor: Colors.teal
      ),
    );
  }
}
