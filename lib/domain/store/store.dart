import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:osam/domain/middleware/middleware.dart';
import 'package:osam/domain/state/base_state.dart';
import 'package:osam/util/event.dart';

abstract class Store<ST extends BaseState> {
  ST get state;
  factory Store(ST state, {List<Middleware> middleWares = const <Middleware>[]}) =>
      _StoreImpl(generalState: state, middleWares: middleWares);

  Stream<ST> nextState(ST state);

  void dispatchEvent({@required Event<ST> event});

  Stream<Event> get eventStream;
}

class _StoreImpl<ST extends BaseState> implements Store<ST> {
  final ST generalState;

  @override
  ST get state => generalState;

  final List<Middleware> middleWares;

  _StoreImpl({this.generalState, this.middleWares}) {
    _initStore();
  }

  // ignore: close_sinks
  StreamController<Event> _dispatcher;

  @override
  Stream<Event> get eventStream => _dispatcher.stream;

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
        event(state, event.bundle);
      }
    });
  }

  @override
  Stream<ST> nextState(ST state) => state.stateStream;

  @override
  void dispatchEvent({@required Event<ST> event}) => _dispatcher.sink.add(event);
}
