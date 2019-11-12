import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:osam/util/comparable_wrapper.dart';

// ignore: must_be_immutable
abstract class BaseState extends Equatable {
  StreamController<BaseState> _stateBroadcaster = StreamController<BaseState>.broadcast();
  Stream<BaseState> get stateStream => _stateBroadcaster.stream;

  Stream<V> propertyStream<V>(String propertyName) =>
      stateStream.map<V>((state) => state.namedProps[propertyName]).distinct(
          (prev, next) => _lastKnownHashCodes[propertyName] == ComparableWrapper(next).hashCode);

  Map<String, Object> get namedProps;

  @protected
  final _lastKnownHashCodes = <String, int>{};

  @protected
  void _init() => _stateBroadcaster = StreamController<BaseState>.broadcast();

  @protected
  void _rememberLastKnownHashCodes() =>
      namedProps.forEach((k, v) => _lastKnownHashCodes[k] = ComparableWrapper(v).hashCode);

  Future<void> broadcastItSelf() async {
    if (_stateBroadcaster.isClosed) _init();
    _stateBroadcaster.sink.add(this);
  }

  void update() => broadcastItSelf()..then((_) => _rememberLastKnownHashCodes());

  @override
  List<Object> get props => namedProps.values.toList();

  void clear() {
    _stateBroadcaster.close();
    namedProps.clear();
    props.clear();
    _lastKnownHashCodes.clear();
  }
}
