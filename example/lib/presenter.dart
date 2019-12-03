import 'dart:async';

import 'package:example/main.dart';
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

  void increment() => store.dispatchEvent<int>(
      event: Event.modify(
          reducer: (state, bundle) => state..increment(bundle),
          type: EventType.increment,
          bundle: 3));

  int get initialData => store.state.count;

  Stream<int> get stream =>
      store.state.propertyStream<int>((state) => state.list.length);

  @override
  void dispose() {
    propertySub?.cancel();
    modelBroadcaster?.close();
  }
}
