import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:osam/util/comparable_wrapper.dart';

// ignore: must_be_immutable
abstract class BaseState extends Equatable {
  BaseState() {
    _init();
  }

  StreamController<BaseState> _stateBroadcaster;
  Stream<BaseState> get stateStream => _stateBroadcaster.stream;

  @protected
  void _init() => _stateBroadcaster = StreamController<BaseState>.broadcast();

  void update() {
    if (_stateBroadcaster.isClosed) _init();
    _stateBroadcaster.sink.add(this);
    rememberLastKnownHashCodes();
  }

  @override
  List<Object> get props => namedProps.values.toList();

  Map<String, Object> get namedProps;

  final _lastKnownHashCodes = <String, int>{};

  int propertyHashCode(String propertyName) => _lastKnownHashCodes[propertyName];

  void rememberLastKnownHashCodes() {
    namedProps.forEach((k, v) {
      _lastKnownHashCodes.putIfAbsent(k, () => v.hashCode);
    });
  }

  void clear() {
    _stateBroadcaster.close();
    namedProps.clear();
    props.clear();
    _lastKnownHashCodes.clear();
  }

  Stream<V> propertyStream<V>(String propertyName) =>
      stateStream.map<V>((state) => state.namedProps[propertyName]).distinct((prev, next) =>
          ComparableWrapper(propertyHashCode(propertyName)) == ComparableWrapper(next));
}
