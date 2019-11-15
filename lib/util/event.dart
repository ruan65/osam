import 'package:flutter/cupertino.dart';
import 'package:osam/domain/state/base_state.dart';

typedef BaseState Reducer<ST extends BaseState>(ST state, Object bundle);

abstract class Event<ST extends BaseState> {
  final Object type;
  final Object bundle;

  Event({
    this.type = const Object(),
    this.bundle,
  });

  factory Event.modify({Object bundle, @required Reducer<ST> reducer, Object type}) =>
      ModificationEvent<ST>(bundle: bundle, reducer: reducer, type: type);

  factory Event.sideEffect({@required Object type, Object bundle}) =>
      SideEffectEvent<ST>(bundle: bundle, type: type);
}

class ModificationEvent<ST extends BaseState> extends Event<ST> {
  final Object type;
  final Object bundle;
  final Reducer<ST> reducer;

  ModificationEvent({this.bundle, this.reducer, this.type}) : super(type: type, bundle: bundle);

  void call(ST state, Object bundle) => reducer(state, bundle).update();
}

class SideEffectEvent<ST extends BaseState> extends Event<ST> {
  final Object bundle;
  Object type;

  SideEffectEvent({this.bundle, this.type}) : super(type: type, bundle: bundle);
}
