import 'dart:math';

import 'package:example/presenter.dart';
import 'package:example/state/state.dart';
import 'package:flutter/material.dart';
import 'package:osam/osam.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Hive.init((await getApplicationDocumentsDirectory()).path);

  final store = Store(AppState());
  //await store.initPersist();
  //store.restoreState();
  runApp(MyApp(
    store: store,
  ));
}

enum EventType { increment, incrementValue }

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  const MyApp({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StoreProvider(
        key: ValueKey('store'),
        child: MyHomePage(),
        store: store,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            )
          ],
        ),
      ),
      floatingActionButton: PresenterProvider<Store<AppState>, ExamplePresenter>(
        key: ValueKey('counter'),
        presenter: ExamplePresenter(),
        child: Button(),
      ),
    );
  }
}

class Button extends StatelessWidget {
  var index = 0;
  final places = [
    Place(address: Address(name: 'name', description: 'somethere'), location: Point(1, 2)),
    Place(address: Address(name: 'name', description: 'somethere1'), location: Point(1, 2)),
    Place(address: Address(name: 'name', description: 'somethere'), location: Point(1, 3))
  ];

  @override
  Widget build(BuildContext context) {
    final presenter = PresenterProvider.of<ExamplePresenter>(context);
    return FloatingActionButton(
      onPressed: () {
        presenter.increment(places[index]);
        index++;
        if (index == 3) index = 0;
      },
      child: StreamBuilder(
        initialData: presenter.initialData,
        stream: presenter.stream,
        builder: (ctx, AsyncSnapshot<Place> snapshot) {
          print('place changed');
          return Text(snapshot.data.hashCode.toString());
        },
      ),
    );
  }
}
