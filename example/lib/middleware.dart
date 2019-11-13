import 'package:example/state.dart';
import 'package:osam/domain/middleware/middleware.dart';
import 'package:osam/domain/state/base_state.dart';
import 'package:osam/util/event.dart';

import 'main.dart';

class MyMiddleware extends Middleware {
  bool isIncrement(Event<BaseState> event) {
    if (event.type == EventType.increment) {
      // side effect
      Future.delayed(Duration(seconds: 1), () {
        store.dispatchEvent<Counter>(
            event:
                Event.modify(reducer: (state, _) => state.increment(1), type: EventType.increment));
      });
    }
    return nextEvent(true);
  }

  @override
  List<Condition> get conditions => [isIncrement];
}
