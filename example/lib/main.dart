import 'package:example/middleware.dart';
import 'package:example/presenter.dart';
import 'package:example/state.dart';
import 'package:flutter/material.dart';
import 'package:osam/osam.dart';

void main() => runApp(MyApp());

enum EventType { increment }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StoreProvider(
        child: MyHomePage(),
        store: Store(states: [
          Counter(),
        ], middleWares: [
          MyMiddleware()
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
        floatingActionButton:
            PresenterProvider<MPresenter>(child: Button(), presenter: MPresenter()));
  }
}

class Button extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        PresenterProvider.of<MPresenter>(context).increment();
      },
      tooltip: 'Increment',
      child: Icon(Icons.add),
    );
  }
}
