import 'package:osam/domain/event/event.dart';
import 'package:osam/domain/state/base_state.dart';
import 'package:osam/domain/store/store.dart';

typedef bool Condition(Event<BaseState, Object> event);

abstract class Middleware<S extends Store<BaseState>> {
  S store;

  bool nextEvent(bool next) => next;
  List<Condition> get conditions;
}
