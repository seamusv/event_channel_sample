import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Channel Sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Event and Method Channel Sample'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const stream = const EventChannel('com.yourcompany.eventchannelsample/stream');

  int _timer = 0;
  StreamSubscription _timerSubscription;

  void _enableTimer() {
    if (_timerSubscription == null) {
      _timerSubscription = stream.receiveBroadcastStream().listen(_updateTimer);
    }
  }

  void _disableTimer() {
    if (_timerSubscription != null) {
      _timerSubscription.cancel();
      _timerSubscription = null;
    }
  }

  void _updateTimer(timer) {
    debugPrint("Timer $timer");
    setState(() => _timer = timer);
  }

  @override
  Widget build(BuildContext context) {
    var timerCard = Card(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      const ListTile(
        leading: const Icon(Icons.timer),
        title: const Text('Event and Method Channel Sample'),
        subtitle: const Text('An example application showing off the communications between Flutter and native Android.'),
      ),
      Center(
        child: Text(
          '$_timer',
          style: Theme.of(context).textTheme.display1,
        ),
      ),
      ButtonBar(children: <Widget>[
        FlatButton(
          child: const Text('Enable'),
          onPressed: _enableTimer,
        ),
        FlatButton(
          child: const Text('Disable'),
          onPressed: _disableTimer,
        ),
      ]),
    ]));

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          padding: EdgeInsets.all(8.0),
          child: timerCard,
        ));
  }
}
