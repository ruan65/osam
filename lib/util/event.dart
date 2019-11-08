import 'package:flutter/foundation.dart';
import 'package:osam/domain/state/base_state.dart';

typedef void ReducerCaller<ST extends BaseState>(ST state, Object bundle);

class Event<ST extends BaseState> {
  final Object bundle;
  final ReducerCaller<ST> reducerCaller;
  Object type;
  String stateType;

  Event(this.reducerCaller, {@required this.bundle, this.type}) {
    stateType = ST.toString();
    this.type = type.runtimeType;
  }

  void call(ST state, bundle) => reducerCaller(state, bundle);
}
