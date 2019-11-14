import 'package:example/state.dart';
import 'package:flutter/material.dart';
import 'package:osam/osam.dart';

import 'model.dart';

void main() => runApp(MyApp());

enum EventType { increment, incrementValue }

class MyApp extends StatelessWidget {
  final store = Store<Counter>.single(Counter(), middleWares: []);

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
    final state = StoreProvider.of(context).state as Counter;
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              StreamBuilder(
                initialData: state.count.values.toList(),
                stream: state
                    .propertyStream<Counter, List<Model>>((state) => state.count.values.toList()),
                builder: (ctx, AsyncSnapshot<List<Model>> snapshot) {
                  print('123');
                  return Column(
                    children: snapshot.data.map((model) => RText(model: model)).toList(),
                  );
                },
              )
            ],
          ),
        ),
        floatingActionButton: Button());
  }
}

class RText extends StatelessWidget {
  final Model model;
  const RText({Key key, this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: model.number,
      stream: model.propertyStream<Model, int>((state) => state.number),
      builder: (ctx, AsyncSnapshot<int> snapshot) {
        print('model');
        return GestureDetector(
          onTap: () {
            StoreProvider.of(context).dispatchEvent<Counter>(
                event: Event.modify(
                    reducerCaller: (state, bundle) => state.count[model.key]..increment()));
          },
          child: Text(
            snapshot.data.toString(),
            style: TextStyle(fontSize: 25),
          ),
        );
      },
    );
  }
}

class Button extends StatelessWidget {
  int number = 0;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        number++;
        StoreProvider.of(context).dispatchEvent<Counter>(
            event: Event.modify(reducerCaller: (state, _) => state..increment(number)));
      },
      tooltip: 'Increment',
      child: Icon(Icons.add),
    );
  }
}
