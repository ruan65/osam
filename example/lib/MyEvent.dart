import 'package:example/state/state.dart';
import 'package:osam/domain/event/event.dart';

class IncrementEvent extends Event<AppState, int> {
  int bundle;
  IncrementEvent({this.bundle}) : super(bundle: bundle);

  @override
  AppState reducer(AppState state, int bundle) => state..increment();
}
