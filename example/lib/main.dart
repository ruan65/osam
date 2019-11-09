import 'package:flutter/material.dart';
import 'package:osam/osam.dart';

void main() => runApp(MyApp());

// ignore: must_be_immutable
class Counter extends BaseState {
  var count = 0;

  @override
  Map<String, Object> get namedProps => {'count': count};
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StoreProvider(
        child: MyHomePage(),
        store: Store(states: [
          Counter(),
        ]),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = StoreProvider.of(context).getState<Counter>();
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              StreamBuilder(
                initialData: state.count,
                stream: state.propertyStream<int>('count'),
                builder: (ctx, AsyncSnapshot<int> snapshot) {
                  return Text(
                    snapshot.data.toString(),
                    style: TextStyle(fontSize: 50),
                  );
                },
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            StoreProvider.of(context).dispatchEvent<Counter>(
                event: Event(reducerCaller: (state, bundle) => state.count++));
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ));
  }
}
