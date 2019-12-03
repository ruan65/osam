import 'package:flutter/foundation.dart';
import 'package:osam/domain/state/base_state.dart';

typedef BaseState Reducer<ST extends BaseState<ST>>(ST state, Object bundle);

abstract class Event<ST extends BaseState<ST>, BT extends Object> {
  final BT bundle;
  final Object type;

  Event({
    this.bundle,
    this.type = const Object(),
  });

  factory Event.modify(
          {BT bundle, @required Reducer<ST> reducer, Object type}) =>
      ModificationEvent<ST, BT>(bundle: bundle, reducer: reducer, type: type);

  factory Event.sideEffect({BT bundle, @required Object type}) =>
      SideEffectEvent<ST, BT>(bundle: bundle, type: type);

  void call(ST state, BT bundle);
}

class ModificationEvent<ST extends BaseState<ST>, BT extends Object>
    extends Event<ST, BT> {
  final BT bundle;
  final Object type;
  final Reducer<ST> reducer;

  ModificationEvent({this.bundle, this.reducer, this.type})
      : super(type: type, bundle: bundle);

  void call(ST state, Object bundle) => reducer(state, bundle).update();
}

class SideEffectEvent<ST extends BaseState<ST>, BT extends Object>
    extends Event<ST, BT> {
  final BT bundle;
  final Object type;

  SideEffectEvent({this.bundle, this.type}) : super(type: type, bundle: bundle);

  @override
  void call(ST state, Object bundle) {}
}
