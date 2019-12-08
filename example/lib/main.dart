import 'package:example/middleware.dart';
import 'package:example/presenter.dart';
import 'package:example/state/state.dart';
import 'package:flutter/material.dart';
import 'package:osam/osam.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = Store(AppState(), middleWares: [MyMiddleware()]);
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
  @override
  Widget build(BuildContext context) {
    final presenter = PresenterProvider.of<ExamplePresenter>(context);
    return FloatingActionButton(
      onPressed: () {
        presenter.increment();
      },
      child: StreamBuilder(
        initialData: presenter.initialData,
        stream: presenter.stream,
        builder: (ctx, AsyncSnapshot<int> snapshot) {
          return Text(snapshot.data.toString());
        },
      ),
    );
  }
}
