import 'package:osam/domain/state/base_state.dart';

typedef void ReducerCaller<ST extends BaseState>(ST state);

abstract class Event<ST extends BaseState> {
  Object type;
  Object bundle;
  Event({this.type = const Object()});

  factory Event.modify({Object bundle, ReducerCaller<ST> reducerCaller, Object type}) =>
      ModificationEvent<ST>(bundle: bundle, reducerCaller: reducerCaller, type: type);

  factory Event.sideEffect({Object type, Object bundle}) => SideEffectEvent<ST>(bundle: bundle);
}

class ModificationEvent<ST extends BaseState> extends Event<ST> {
  final Object bundle;
  final ReducerCaller<ST> reducerCaller;
  String stateType;
  Object type;
  ModificationEvent({this.bundle, this.reducerCaller, this.type}) : super(type: type) {
    stateType = ST.toString();
    this.type = type;
  }

  void call(ST state, bundle) => reducerCaller(state);
}

class SideEffectEvent<ST extends BaseState> extends Event<ST> {
  final Object bundle;
  Object type;

  SideEffectEvent({this.bundle, this.type}) : super(type: type) {
    this.type = type.runtimeType;
  }
}
