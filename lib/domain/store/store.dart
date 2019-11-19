import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:osam/domain/event/event.dart';
import 'package:osam/domain/middleware/middleware.dart';
import 'package:osam/domain/state/base_state.dart';

abstract class Store<ST extends BaseState<ST>> {
  ST get state;

  factory Store(ST state, {List<Middleware> middleWares = const <Middleware>[]}) =>
      _StoreImpl(appState: state, middleWares: middleWares);

  Stream<ST> nextState(ST state);

  void dispatchEvent({@required Event<ST> event});

  Stream<Event<ST>> get eventStream;
}

class _StoreImpl<ST extends BaseState<ST>> implements Store<ST> {
  final ST appState;

  @override
  ST get state => appState;

  final List<Middleware> middleWares;

  _StoreImpl({this.appState, this.middleWares}) {
    _initStore();
  }

  // ignore: close_sinks
  StreamController<Event<ST>> _dispatcher;

  @override
  Stream<Event<ST>> get eventStream => _dispatcher.stream;

  final _denormalizedConditions = <Condition>[];

  void _initStore() {
    _dispatcher = StreamController<Event<ST>>.broadcast();
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
        try {
          event(appState, event.bundle);
        } catch (e) {
          debugPrint(e);
        }
      }
    });
  }

  @override
  Stream<ST> nextState(ST state) => state.stateStream;

  @override
  void dispatchEvent({@required Event<ST> event}) => _dispatcher.sink.add(event);
}
