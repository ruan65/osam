import 'dart:async';

import 'package:example/state.dart';
import 'package:osam/domain/store/store.dart';
import 'package:osam/presentation/presenter.dart';

class ExamplePresenter<S extends Store<Counter>> extends Presenter<S> {
  StreamSubscription stateSub;
  StreamController<Counter> modelBroadcaster;

  @override
  void dispose() {
    stateSub?.cancel();
    modelBroadcaster.close();
  }

  @override
  void init() {
    modelBroadcaster = StreamController<Counter>();
    stateSub = store.nextState(store.state).listen((data){
      modelBroadcaster.sink.add(data);
    });
  }
}
