import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:osam/domain/middleware/middleware.dart';
import 'package:osam/experemental/experemenal_event.dart';
import 'package:osam/experemental/experemental_state.dart';

abstract class Store {
  factory Store({List<BaseState> states, List<Middleware> middleWares = const <Middleware>[]}) =>
      _StoreImpl(states: states, middleWares: middleWares);

  Stream<ST> nextState<ST>();

  ST getStateByType<ST extends BaseState>({String stateType});

  ST getStateByKey<ST extends BaseState>({String key});

//  void dispatchEvent<ST extends BaseState>({@required Event<ST> event});
//
  Stream<Event> get eventStream;
}

class _StoreImpl implements Store {
  static final _StoreImpl _storeSingleton = _StoreImpl._internal();

  factory _StoreImpl(
      {@required List<BaseState> states, List<Middleware> middleWares = const <Middleware>[]}) {
    _storeSingleton.states ??= states;
    _storeSingleton.middleWares ??= middleWares;
    if (_storeSingleton._dispatcher == null) _storeSingleton._initStore();
    return _storeSingleton;
  }

  _StoreImpl._internal();

  // ignore: close_sinks
  StreamController<Event> _dispatcher;
  @override
  Stream<Event> get eventStream => _dispatcher.stream;

  List<BaseState> states;
  List<Middleware> middleWares;

  final _denormalizedDomainStates = <String, BaseState>{};
  final _denormalizedConditions = <Condition>[];

  void _initStore() {
    _dispatcher = StreamController<Event>.broadcast();
    // todo: middleWares

    _dispatcher.stream.listen((event) {
      for (Condition condition in _denormalizedConditions) {
        final nextEvent = condition(event);
        if (nextEvent)
          continue;
        else
          break;
      }
      if (event is ModificationEvent) {
        final targetState = _findState(states, stateType: event.stateType);
        final lastDynamicKeys = _dynamicPropsKeys(targetState);
        event(targetState, event.bundle);
        final differenceKeys = lastDynamicKeys.difference(_dynamicPropsKeys(targetState));
        _cleanDynamicStates(differenceKeys);
      }
    });
  }

  Set<Object> _dynamicPropsKeys(BaseState state) {
    return state.props
        .where((prop) => prop is List<DynamicBaseState>)
        .map<List<DynamicBaseState>>((prop) => prop as List<DynamicBaseState>)
        .toList()
        .expand((state) => state)
        .toList()
        .map<Object>((state) => state.key)
        .toSet();
  }

  void _cleanDynamicStates(Set<Object> keys) {
    keys.forEach((key) {
      _denormalizedDomainStates.remove(key);
    });
  }

  @override
  Stream<ST> nextState<ST>({String stateName}) =>
      _findState(states, stateType: ST.toString()).stateStream.map((state) => state as ST);

  @override
  ST getState<ST extends BaseState>({String stateKey}) =>
      _findState(states, stateType: stateKey) as ST;

  @override
  void dispatchEvent<ST extends BaseState>({@required Event<ST> event}) =>
      _dispatcher.sink.add(event);

  void _fillDenormalizedWithStates(Iterable<BaseState> statesMap) {
    _denormalizedDomainStates.addAll(Map<String, BaseState>.fromIterable(
        statesMap.where((state) => state is BaseState),
        key: (state) => state.runtimeType.toString(),
        value: (state) => state));

    _denormalizedDomainStates.addAll(Map<String, BaseState>.fromIterable(
        statesMap.where((state) => state is DynamicBaseState),
        key: (state) => (state as DynamicBaseState).key,
        value: (state) => state));
  }

  BaseState _findState(List<BaseState> incomeStates, {String stateType}) {
    final denormalizedPotentialState = _denormalizedDomainStates[stateType];

    if (denormalizedPotentialState != null) {
      return denormalizedPotentialState;
    }

    final staticPotentialState = incomeStates
        .where((state) => state is BaseState)
        .firstWhere((state) => state.runtimeType.toString() == stateType, orElse: () => null);

    if (staticPotentialState != null) {
      _denormalizedDomainStates[stateType] = staticPotentialState;
      return staticPotentialState;
    }

    final dynamicPotentialState = incomeStates
        .where((state) => state is DynamicBaseState)
        .firstWhere((state) => (state as DynamicBaseState).key == stateType, orElse: () => null);

    if (dynamicPotentialState != null) {
      _denormalizedDomainStates[stateType] = staticPotentialState;
      return staticPotentialState;
    }

    final parentStates = incomeStates.where((state) => (state.props
        .where((prop) => prop is BaseState || prop is Map<Object, DynamicBaseState>)
        .isNotEmpty));

    _fillDenormalizedWithStates(parentStates);

    final staticStates = parentStates
        .map<List<Object>>((state) => state.props
            .where((prop) => prop is BaseState)
            .map<List<Object>>((prop) => prop as List<Object>)
            .toList())
        .toList()
        .expand((state) => state)
        .toList()
        .map<BaseState>((state) => state)
        .toList();

    _fillDenormalizedWithStates(staticStates);

    final dynamicStates = parentStates
        .map<List<List<DynamicBaseState>>>((state) => state.props
            .where((prop) => prop is List<DynamicBaseState>)
            .map<List<DynamicBaseState>>((prop) => prop as List<DynamicBaseState>)
            .toList())
        .toList()
        .expand((state) => state)
        .toList()
        .expand((state) => state)
        .toList();

    _fillDenormalizedWithStates(staticStates);

    final allFoundStates = [...staticStates, ...dynamicStates];

    return _findState(allFoundStates, stateType: stateType);
  }
}
