import 'package:osam/domain/state/base_state.dart';
import 'package:osam/domain/store/store.dart';
import 'package:osam/util/event.dart';

typedef bool Condition(Store store, Event<BaseState> event);

abstract class Middleware {
  bool nextEvent(bool next) => next;
  List<Condition> get conditions;
}
