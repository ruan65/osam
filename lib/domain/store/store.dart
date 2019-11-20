import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:osam/data/persist_repository.dart';
import 'package:osam/domain/event/event.dart';
import 'package:osam/domain/middleware/middleware.dart';
import 'package:osam/domain/state/base_state.dart';

const hiveAdaptersLimit = 223;

abstract class Store<ST extends BaseState<ST>> {
  ST get state;

  factory Store(ST state, {List<Middleware<Store<BaseState<ST>>>> middleWares = const []}) =>
      _StoreImpl(appState: state, middleWares: middleWares);

  Stream<ST> get nextState;

  void dispatchEvent({@required Event<ST> event});

  Stream<Event<ST>> get eventStream;

  Future<void> initPersist();

  void storeState();

  void wipePersist();
}

class _StoreImpl<ST extends BaseState<ST>> implements Store<ST> {
  ST appState;

  @override
  ST get state => appState;

  final List<Middleware<Store<BaseState<ST>>>> middleWares;

  // ignore: close_sinks
  StreamController<Event<ST>> _dispatcher;

  @override
  Stream<Event<ST>> get eventStream => _dispatcher.stream;

  final _denormalizedConditions = <Condition>[];

  _StoreImpl({this.appState, this.middleWares}) {
    _initStore();
  }

  @override
  Future<void> initPersist() async {
    await PersistRepository().init();
    this.appState = PersistRepository().restoreState() ?? this.appState;
  }

  @override
  void storeState() => PersistRepository().storeState(appState);

  @override
  void wipePersist() => PersistRepository().wipeState();

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
          print(e);
        }
      }
    });
  }

  @override
  Stream<ST> get nextState => appState.stateStream;

  @override
  void dispatchEvent({@required Event<ST> event}) => _dispatcher.sink.add(event);
}
