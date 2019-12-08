import 'package:flutter/foundation.dart';
import 'package:osam/domain/state/base_state.dart';

typedef BaseState Reducer<ST extends BaseState<ST>, B extends Object>(ST state, B bundle);

abstract class Event<ST extends BaseState<ST>, B extends Object> {
  B bundle;
  Event({this.bundle});

  factory Event.modify({B bundle, @required Reducer<ST, B> reducer}) =>
      ModificationEvent<ST, B>(bundle: bundle, reducer: reducer);

  void call(ST state, B bundle);
}

class ModificationEvent<ST extends BaseState<ST>, B extends Object> extends Event<ST, B> {
  final B bundle;
  final Reducer<ST, B> reducer;

  ModificationEvent({this.bundle, this.reducer});

  void call(ST state, Object bundle) => reducer(state, bundle).update();
}
