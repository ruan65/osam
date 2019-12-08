import 'package:example/state/state.dart';
import 'package:osam/domain/event/event.dart';
import 'package:osam/domain/middleware/middleware.dart';
import 'package:osam/domain/store/store.dart';

class MyMiddleware extends Middleware<Store<AppState>> {
  bool isIncrement(Event event) {
    if (event is IncrementEvent) {
      Future.delayed(Duration(seconds: 1), () {
        store.dispatchEvent(event: IncrementEvent());
      });
    }
    return nextEvent(true);
  }

  @override
  List<Condition> get conditions => [isIncrement];
}

class IncrementEvent extends ModificationEvent<AppState, int> {
  IncrementEvent({int bundle});

  @override
  get reducer => (AppState state, int bundle) => state..increment();
}
