import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:osam/domain/middleware/middleware.dart';
import 'package:osam/domain/state/base_state.dart';
import 'package:osam/util/event.dart';

abstract class Store<ST extends BaseState> {
  final ST state;

  Store(this.state);

  factory Store.single(ST state, {List<Middleware> middleWares = const <Middleware>[]}) =>
      _StoreImpl(state: state, middleWares: middleWares);

  Stream<ST> nextState<ST extends BaseState>(ST state);

  void dispatchEvent<ST extends BaseState>({@required Event<ST> event});

  Stream<Event> get eventStream;
}

class _StoreImpl<ST extends BaseState> implements Store<ST> {
  final ST state;
  final List<Middleware> middleWares;

  _StoreImpl({this.state, this.middleWares}) {
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
  Stream<ST> nextState<ST extends BaseState>(ST state) => state.stateStream;

  @override
  void dispatchEvent<ST extends BaseState>({@required Event<ST> event}) =>
      _dispatcher.sink.add(event);
}
