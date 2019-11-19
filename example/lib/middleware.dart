import 'package:example/main.dart';
import 'package:example/state/state.dart';
import 'package:osam/domain/event/event.dart';
import 'package:osam/domain/middleware/middleware.dart';
import 'package:osam/domain/state/base_state.dart';
import 'package:osam/domain/store/store.dart';

class MyMiddleware<S extends Store<AppState>> extends Middleware<S> {
  bool isIncrement(Event<BaseState> event) {
    if (event.type == EventType.increment) {
      Future.delayed(Duration(seconds: 1), () {
        store.dispatchEvent(
            event: Event.modify(
                reducer: (state, _) => state..increment(1), type: EventType.increment));
      });
    }
    return nextEvent(true);
  }

  @override
  List<Condition> get conditions => [isIncrement];
}
