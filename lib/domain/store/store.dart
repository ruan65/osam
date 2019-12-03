import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:osam/persist/persist_interface.dart';
import 'package:osam/persist/persist_repository.dart';
import 'package:osam/domain/event/event.dart';
import 'package:osam/domain/middleware/middleware.dart';
import 'package:osam/domain/state/base_state.dart';

abstract class Store<ST extends BaseState<ST>> implements Persist {
  factory Store(ST state, {List<Middleware<Store<BaseState<ST>>>> middleWares = const [], bool logging = false}) =>
      _StoreImpl(appState: state, middleWares: middleWares, logging: logging);

  ST get state;

  Stream<ST> get nextState;

  Stream<Event<ST, Object>> get eventStream;

  void dispatchEvent<BT extends Object>({@required Event<ST, BT> event});
}

class _StoreImpl<ST extends BaseState<ST>> implements Store<ST> {
  ST appState;
  final List<Middleware<Store<BaseState<ST>>>> middleWares;
  final _denormalizedConditions = <Condition>[];
  final bool logging;

  // ignore: close_sinks
  StreamController<Event<ST, Object>> _dispatcher;

  _StoreImpl({this.appState, this.middleWares, this.logging}) {
    _initStore();
  }

  @override
  ST get state => appState;

  @override
  Stream<ST> get nextState => appState.stateStream;

  @override
  Stream<Event<ST, Object>> get eventStream => _dispatcher.stream;

  @override
  Future<void> initPersist() async => await PersistRepository().init();

  @override
  void dispatchEvent<BT extends Object>({@required Event<ST, BT> event}) => _dispatcher.sink.add(event);

  @override
  void storeState() => PersistRepository().storeState(appState);

  @override
  void restoreState() => this.appState = PersistRepository().restoreState() ?? this.appState;

  @override
  void deleteState() => PersistRepository().deleteState();

  void _initStore() {
    _dispatcher = StreamController<Event<ST, Object>>.broadcast();
    middleWares.forEach((middleWares) => middleWares.store = this);
    _denormalizedConditions.addAll(middleWares.expand((middleWare) => middleWare.conditions).toList());
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
            'Event in stores event stream is : ${'type: ' + event.type.toString() + ' bundle: ' + event.bundle.toString() + ' runtimeType: ' + event.runtimeType.toString()}');
      if (event is ModificationEvent) {
        if (logging) debugPrint('reducer called : ${(event as ModificationEvent).reducer.toString}');
        try {
          event(appState, event.bundle);
        } catch (e) {
          print('store error while reducer calling: $e');
        }
      }
    });
  }
}
