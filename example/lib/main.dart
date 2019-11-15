import 'package:example/middleware.dart';
import 'package:example/presenter.dart';
import 'package:example/state.dart';
import 'package:flutter/material.dart';
import 'package:osam/osam.dart';

void main() => runApp(MyApp());

enum EventType { increment, incrementValue }

class MyApp extends StatelessWidget {
  final store = Store(AppState(), middleWares: [MyMiddleware()]);

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
            ],
          ),
        ),
        floatingActionButton: PresenterProvider<ExamplePresenter, Store<AppState>>(
          presenter: ExamplePresenter(),
          child: Button(),
        ));
  }
}

class Button extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = PresenterProvider.of<ExamplePresenter<Store<AppState>>>(context);
    return FloatingActionButton(
      onPressed: () {
        presenter.increment();
      },
      child: StreamBuilder(
        initialData: presenter.initialData,
        stream: presenter.valueStream,
        builder: (ctx, AsyncSnapshot<int> snapshot) {
          return Text(snapshot.data.toString());
        },
      ),
    );
  }
}
