import 'package:example/state/state.dart';
import 'package:osam/domain/event/event.dart';

class IncrementEvent extends ModificationEvent<AppState, int> {
  IncrementEvent({int bundle});

  @override
  get reducer => (AppState state, int bundle) => state..increment();
}
