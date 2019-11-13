import 'package:flutter/cupertino.dart';
import 'package:osam/domain/state/base_state.dart';

typedef void Reducer<ST extends BaseState>(ST state, Object bundle);
typedef void NattyReducer<O extends Object>(O model);

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

  factory Event.natty(
          {@required ST state, Object bundle, @required Reducer<ST> reducer, Object type}) =>
      NattyEvent<ST>(state: state, bundle: bundle, reducer: reducer, type: type);
}

class ModificationEvent<ST extends BaseState> extends Event<ST> {
  final Object type;
  final Object bundle;
  final Reducer<ST> reducer;
  String stateType;

  ModificationEvent({this.bundle, this.reducer, this.type}) : super(type: type, bundle: bundle) {
    stateType = ST.toString();
    assert(stateType != 'dynamic');
  }

  void call(ST state, Object bundle) {
    final lastKnownHashCode = state.hashCode;
    reducer(state, bundle);
    if (lastKnownHashCode != state.hashCode) state.update();
  }
}

class SideEffectEvent<ST extends BaseState> extends Event<ST> {
  final Object bundle;
  Object type;

  SideEffectEvent({this.bundle, this.type}) : super(type: type, bundle: bundle);
}

class NattyEvent<ST extends BaseState> extends Event<ST> {
  final Object type;
  final Object bundle;
  final Reducer<ST> reducer;
  final ST state;

  NattyEvent({this.state, this.bundle, this.reducer, this.type})
      : super(type: type, bundle: bundle);

  void call(ST state, Object bundle) {
    final lastKnownHashCode = state.hashCode;
    reducer(state, bundle);
    if (lastKnownHashCode != state.hashCode) state.update();
  }
}
