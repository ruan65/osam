import 'dart:async';

import 'package:example/state.dart';
import 'package:osam/domain/store/store.dart';
import 'package:osam/osam.dart';
import 'package:osam/presentation/presenter.dart';

class ExamplePresenter<S extends Store<AppState>> extends Presenter<S> {
  StreamSubscription stateSub;
  StreamController<int> modelBroadcaster;

  @override
  void init() {
    modelBroadcaster = StreamController<int>();
    store.nextState(store.state).listen((data) {});
  }

  void increment() =>
      store.dispatchEvent(event: Event.modify(reducer: (state, _) => state..increment(1)));

  int get initialData => store.state.count;
  Stream<int> get valueStream => store.state.propertyStream<int>((state) => state.count);

  @override
  void dispose() {
    stateSub?.cancel();
    modelBroadcaster?.close();
  }
}
