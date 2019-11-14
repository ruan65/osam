import 'package:example/state.dart';
import 'package:flutter/material.dart';
import 'package:osam/osam.dart';

void main() => runApp(MyApp());

enum EventType { increment, incrementValue }

class MyApp extends StatelessWidget {
  final store = Store(Counter(), middleWares: []);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StoreProvider(
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
              ),
              StreamBuilder(
                initialData: StoreProvider.of<Store<Counter>>(context).state.count,
                stream: StoreProvider.of<Store<Counter>>(context)
                    .state
                    .propertyStream<Counter, int>((state) => state.count),
                builder: (ctx, AsyncSnapshot<int> snapshot) {
                  return Text(snapshot.data.toString());
                },
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            StoreProvider.of<Store<Counter>>(context).dispatchEvent(
                event: Event.modify(reducerCaller: (state, _) => state..increment(1)));
            StoreProvider.of<Store<Counter>>(context).dispatchEvent(
                event: Event.modify(reducerCaller: (state, _) => state..increment(2)));
            StoreProvider.of<Store<Counter>>(context).dispatchEvent(
                event: Event.modify(reducerCaller: (state, _) => state..increment(3)));
          },
        ));
  }
}
