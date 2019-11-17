import 'dart:async';

import 'package:example/state.dart';
import 'package:osam/domain/store/store.dart';
import 'package:osam/osam.dart';
import 'package:osam/presentation/presenter.dart';

class ExamplePresenter<S extends Store<AppState>> extends Presenter<S> {
  StreamSubscription propertySub;
  StreamController<int> modelBroadcaster;

  @override
  void init() {
    modelBroadcaster = StreamController<int>();
    store.nextState(store.state).listen((data) {});
  }

  void increment() =>
      store.dispatchEvent(event: Event.modify(reducer: (state, _) => state..increment(1)));

  List<int> get initialData => store.state.count;

  Stream<List<int>> get stream => store.state.propertyStream<List<int>>((state) => state.count);

  @override
  void dispose() {
    propertySub?.cancel();
    modelBroadcaster?.close();
  }
}
