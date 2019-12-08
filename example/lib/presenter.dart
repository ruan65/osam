import 'dart:async';

import 'package:example/state/state.dart';
import 'package:osam/domain/store/store.dart';
import 'package:osam/osam.dart';
import 'package:osam/presentation/presenter.dart';

import 'middleware.dart';

class ExamplePresenter extends Presenter<Store<AppState>> {
  StreamSubscription<int> propertySub;
  StreamController<int> modelBroadcaster;

  @override
  void init() {
    modelBroadcaster = StreamController<int>();
  }

  void increment() => store.dispatchEvent(event: IncrementEvent());

  int get initialData => store.state.counter;

  Stream<int> get stream => store.state.propertyStream<int>((state) => state.counter);

  @override
  void dispose() {
    propertySub?.cancel();
    modelBroadcaster?.close();
  }
}
