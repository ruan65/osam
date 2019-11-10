import 'package:osam/domain/state/base_state.dart';

typedef void ReducerCaller<ST extends BaseState>(ST state, Object bundle);

class Event<ST extends BaseState> {
  final Object bundle;
  String stateType;

  Event({this.bundle}) {
    stateType = ST.toString();
  }

  factory Event.modify({Object bundle, ReducerCaller<ST> reducerCaller}) =>
      ModificationEvent<ST>(bundle: bundle, reducerCaller: reducerCaller);

//  factory Event.sideEffect({Object type, Object bundle}) =>
//      SideEffectEvent<ST>(bundle: bundle);

//
//  factory Event.extended() => _ExtendedEvent<ST>();

 // void call(ST state, bundle) => reducerCaller(state, bundle);
}
//
class ModificationEvent<ST extends BaseState> extends Event<ST> {
  final ReducerCaller<ST> reducerCaller;
//
ModificationEvent({this.bundle,this.reducerCaller});
//  ModificationEvent({this.bundle, this.reducerCaller}) : super(bundle: bundle);
//
}
//
//class SideEffectEvent<ST extends BaseState> extends Event<ST> {
//  Object type;
//  SideEffectEvent({this.type, this.bundle}) : super(bundle: bundle) {
//    this.type = type.runtimeType;
//  }
//
//
//}

//class _RegularEvent<ST extends BaseState> implements Event<ST> {
//  final ReducerCaller<ST> reducerCaller;
//  String stateType;
//

//}
//
//class _SideEffectEvent<ST extends BaseState> implements Event<ST> {
//
//  Object type;
//  _SideEffectEvent()
//
//}
//
//class _ExtendedEvent<ST extends BaseState> implements Event<ST> {}
//
////
////class Event<ST extends BaseState> {
////
////  final Object bundle;
////  final ReducerCaller<ST> reducerCaller;
////  Object type;
////  String stateType;
////
////  Event({this.reducerCaller, this.bundle, this.type}) {
////    stateType = ST.toString();
////    this.type = type.runtimeType;
////  }
////
////
////}
