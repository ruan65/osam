import 'package:example/presenter.dart';
import 'package:example/state/state.dart';
import 'package:example/subState.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:osam/osam.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.init((await getApplicationDocumentsDirectory()).path);
  Hive.registerAdapter(AppStateAdapter(), 0);
  Hive.registerAdapter(SubStateAdapter(), 1);
  final store = Store(AppState());
  await store.initPersist();
  store.restoreState();
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
