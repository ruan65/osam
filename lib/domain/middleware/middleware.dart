import 'package:osam/domain/state/base_state.dart';
import 'package:osam/domain/store/store.dart';
import 'package:osam/util/event.dart';

abstract class Middleware {
  Store store;
  // todo: what about nested
  bool call(Event<BaseState> event) => moveNext();
  bool moveNext();
}
