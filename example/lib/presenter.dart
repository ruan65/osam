import 'dart:async';

import 'package:example/state/state.dart';
import 'package:osam/domain/store/store.dart';
import 'package:osam/osam.dart';
import 'package:osam/presentation/presenter.dart';

class ExamplePresenter extends Presenter<Store<AppState>> {
  StreamSubscription propertySub;
  StreamController<int> modelBroadcaster;

  @override
  void init() {
    modelBroadcaster = StreamController<int>();
  }

  void increment() =>
      store.dispatchEvent(event: Event.modify(reducer: (state, _) => state..increment(1)));

  int get initialData => store.state.count;

  Stream<int> get stream => store.state.propertyStream<int>((state) => state.list.length);

  @override
  void dispose() {
    propertySub?.cancel();
    modelBroadcaster?.close();
  }
}
