import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:osam/util/comparable_wrapper.dart';

// ignore: must_be_immutable
abstract class BaseState extends Equatable {
  BaseState() {
    _init();
  }

  StreamController<BaseState> _stateBroadcaster;
  Stream<BaseState> get stateStream => _stateBroadcaster.stream;
  Stream<V> propertyStream<V>(String propertyName) =>
      stateStream.map<V>((state) => state.namedProps[propertyName]).distinct(
          (prev, next) => _lastKnownHashCodes[propertyName] == ComparableWrapper(next).hashCode);

  Map<String, Object> get namedProps;

  final _lastKnownHashCodes = <String, int>{};

  @protected
  void _init() => _stateBroadcaster = StreamController<BaseState>.broadcast();

  @protected
  void _rememberLastKnownHashCodes() => namedProps
      .forEach((k, v) => _lastKnownHashCodes.putIfAbsent(k, () => ComparableWrapper(v).hashCode));

  void update() {
    if (_stateBroadcaster.isClosed) _init();
    _stateBroadcaster.sink.add(this);
    _rememberLastKnownHashCodes();
  }

  @override
  List<Object> get props => namedProps.values.toList();

  void clear() {
    _stateBroadcaster.close();
    namedProps.clear();
    props.clear();
    _lastKnownHashCodes.clear();
  }
}
