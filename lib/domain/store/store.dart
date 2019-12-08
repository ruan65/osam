import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:osam/domain/event/event.dart';
import 'package:osam/domain/middleware/middleware.dart';
import 'package:osam/domain/state/base_state.dart';
import 'package:osam/persist/persist_interface.dart';
import 'package:osam/persist/persist_repository.dart';

abstract class Store<ST extends BaseState<ST>> implements Persist {
  factory Store(ST state,
          {List<Middleware<Store<BaseState<ST>>>> middleWares = const [], bool logging = false}) =>
      _StoreImpl(appState: state, middleWares: middleWares, logging: logging);

  ST get state;

  bool get isPersistEnabled;

  Stream<ST> get nextState;

  Stream<Event> get eventStream;

  void dispatchEvent({@required Event event});
}

class _StoreImpl<ST extends BaseState<ST>> implements Store<ST> {
  ST appState;
  final List<Middleware<Store<BaseState<ST>>>> middleWares;
  final _denormalizedConditions = <Condition>[];
  final bool logging;

  // ignore: close_sinks
  StreamController<Event> _dispatcher;

  _StoreImpl({this.appState, this.middleWares, this.logging}) {
    _initStore();
  }

  @override
  ST get state => appState;

  @override
  bool get isPersistEnabled => PersistRepository().isEnabled;

  @override
  Stream<ST> get nextState => appState.stateStream;

  @override
  Stream<Event> get eventStream => _dispatcher.stream;

  @override
  Future<void> initPersist() async => await PersistRepository().init();

  @override
  void dispatchEvent({@required Event event}) => _dispatcher.sink.add(event);

  @override
  void storeState() => PersistRepository().storeState(appState);

  @override
  void restoreState() => this.appState = PersistRepository().restoreState() ?? this.appState;

  @override
  void deleteState() => PersistRepository().deleteState();

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
      if (logging)
        debugPrint(
            'Event in stores event stream is : ${'runtimeType: ' + event.runtimeType.toString()}');
      if (event is ModificationEvent<ST, Object>) {
        try {
          event.reducer(appState, event.bundle).update();
        } catch (e) {
          print('store error while reducer calling: $e');
        }
      }
    });
  }
}
