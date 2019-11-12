import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:osam/domain/middleware/middleware.dart';
import 'package:osam/domain/state/base_state.dart';
import 'package:osam/util/event.dart';

abstract class Store {
  factory Store({List<BaseState> states, List<Middleware> middleWares = const <Middleware>[]}) =>
      _StoreImpl(states: states, middleWares: middleWares);

  Stream<ST> nextState<ST>();

  ST getState<ST extends BaseState>();

  void dispatchEvent<ST extends BaseState>({@required Event<ST> event});

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
    middleWares.forEach((middleWares) => middleWares.store = this);
    _denormalizedConditions
        .addAll(middleWares.expand((middleWare) => middleWare.conditions).toList());

    _dispatcher.stream.listen((event) {
      for (Condition condition in _denormalizedConditions) {
        final nextEvent = condition(event);
        if (nextEvent)
          continue;
        else
          break;
      }
      if (event is ModificationEvent) {
        final targetState = _findState(states, event.stateType);
        final lastKnownHashCode = targetState.hashCode;
        event(targetState, event.bundle);
        if (lastKnownHashCode != targetState.hashCode) targetState.update();
      }
    });
  }

  @override
  Stream<ST> nextState<ST>() =>
      _findState(states, ST.toString()).stateStream.map((state) => state as ST);

  @override
  ST getState<ST extends BaseState>() => _findState(states, ST.toString()) as ST;

  @override
  void dispatchEvent<ST extends BaseState>({@required Event<ST> event}) =>
      _dispatcher.sink.add(event);

  void _fillDenormalizedStates(Iterable<BaseState> statesMap) =>
      _denormalizedDomainStates.addAll(Map<String, BaseState>.fromIterable(statesMap,
          key: (state) => state.runtimeType.toString(), value: (state) => state));

  BaseState _findState(List<BaseState> reactiveIncomeStates, String stateType) {
    final denormalizedPotentialState = _denormalizedDomainStates[stateType];

    if (denormalizedPotentialState != null) {
      return denormalizedPotentialState;
    }
    final potentialState = reactiveIncomeStates
        .firstWhere((state) => state.runtimeType.toString() == stateType, orElse: () => null);

    if (potentialState != null) {
      _denormalizedDomainStates.putIfAbsent(stateType, () => potentialState);
      return potentialState;
    }

    final parentStates = reactiveIncomeStates
        .where((state) => (state.props.where((prop) => prop is BaseState).isNotEmpty));

    _fillDenormalizedStates(parentStates);

    final listWithStates = parentStates
        .map<List<BaseState>>((state) => state.props.where((prop) => prop is BaseState).toList())
        .toList()
        .expand((state) => state)
        .toList()
        .map<BaseState>((state) => state)
        .toList();

    _fillDenormalizedStates(listWithStates);

    return _findState(listWithStates, stateType);
  }
}
