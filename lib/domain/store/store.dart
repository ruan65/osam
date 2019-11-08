import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:osam/domain/middleware/middleware.dart';
import 'package:osam/domain/state/base_state.dart';
import 'package:osam/util/event.dart';

//todo: make it singleton?
class Store {
  // ignore: close_sinks
  StreamController<Event> _dispatcher;
  Stream<Event> get eventStream => _dispatcher.stream;

  final List<BaseState> states;
  final _denormalizedDomainStates = <String, BaseState>{};

  final List<Middleware> middleWares;

  void _initStore() => _dispatcher = StreamController<Event>.broadcast();

  void initMiddleware() => middleWares.forEach((middleware) {
        middleware.store = this;
      });

  Store({@required this.states, this.middleWares = const <Middleware>[]}) {
    _initStore();
    if (middleWares.isNotEmpty) initMiddleware();

    _dispatcher.stream.listen((event) {
      for (Middleware middleware in middleWares) {
        final nextEvent = middleware(event);
        if (nextEvent)
          continue;
        else
          break;
      }
      final targetState = _findState(states, event.stateType);
      final lastKnownHashCode = targetState.hashCode;
      event(targetState, event.bundle);
      if (lastKnownHashCode != targetState.hashCode) targetState.update();
    });
  }

  Stream<ST> nextState<ST>() =>
      _findState(states, ST.toString()).stateStream.map((state) => state as ST);

  ST getState<ST extends BaseState>() => _findState(states, ST.toString()) as ST;

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
