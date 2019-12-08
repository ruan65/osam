import 'package:example/state/state.dart';
import 'package:osam/domain/event/event.dart';

class IncrementEvent extends ModificationEvent<AppState, int> {
  @override
  AppState reducer(AppState state, _) => state..increment();
}

class SideExample extends SideEffectEvent<int> {}
