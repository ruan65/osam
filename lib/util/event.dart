import 'package:flutter/cupertino.dart';
import 'package:osam/domain/state/base_state.dart';

typedef BaseState ReducerCaller<ST extends BaseState>(ST state, Object bundle);

abstract class Event<ST extends BaseState> {
  final Object type;
  final Object bundle;
  Event({
    this.type = const Object(),
    this.bundle,
  });

  factory Event.modify({Object bundle, @required ReducerCaller<ST> reducerCaller, Object type}) =>
      ModificationEvent<ST>(bundle: bundle, reducerCaller: reducerCaller, type: type);

  factory Event.sideEffect({@required Object type, Object bundle}) =>
      SideEffectEvent<ST>(bundle: bundle, type: type);
}

class ModificationEvent<ST extends BaseState> extends Event<ST> {
  final Object type;
  final Object bundle;
  final ReducerCaller<ST> reducerCaller;

  ModificationEvent({this.bundle, this.reducerCaller, this.type})
      : super(type: type, bundle: bundle);

  void call(ST state, bundle) => reducerCaller(state, bundle).update();
}

class SideEffectEvent<ST extends BaseState> extends Event<ST> {
  final Object bundle;
  Object type;

  SideEffectEvent({this.bundle, this.type}) : super(type: type, bundle: bundle);
}
