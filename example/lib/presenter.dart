import 'package:example/state.dart';
import 'package:osam/presentation/presenter.dart';
import 'package:osam/util/event.dart';

import 'main.dart';

class MPresenter extends Presenter {
  void increment() {
    this.store.dispatchEvent<Counter>(
        event: Event.modify(
            reducerCaller: (state, _) => state.increment(1), type: EventType.increment));
  }

  @override
  void dispose() {}

  @override
  void init() {}
}
