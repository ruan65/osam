import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:osam/util/comparable_wrapper.dart';

typedef V ValueMapper<ST extends BaseState, V>(ST state);

// ignore: must_be_immutable
abstract class BaseState extends Equatable {
  BaseState() {
    _lastKnownHashCode = this.hashCode;
  }

  @protected
  int _lastKnownHashCode;

  StreamController<BaseState> _stateBroadcaster = StreamController<BaseState>.broadcast();
  Stream<ST> stateStream<ST extends BaseState>() =>
      _stateBroadcaster.stream.map((state) => state as ST);

  Stream<V> propertyStream<ST extends BaseState, V>(ValueMapper<ST, V> mapper) =>
      _PropertyStream<V>(stateStream().map<V>((state) => mapper(state))).propertyStream;

  @protected
  void _init() => _stateBroadcaster = StreamController<BaseState>.broadcast();

  void update() {
    if (_stateBroadcaster.isClosed) _init();
    if (_lastKnownHashCode != this.hashCode) {
      _stateBroadcaster.sink.add(this);
      _lastKnownHashCode = this.hashCode;
    }
  }

  @override
  List<Object> get props;

  void clear() => _stateBroadcaster.close();
}

class _PropertyStream<V> {
  final Stream<V> inputStream;
  int _valueHashCode;
  _PropertyStream(this.inputStream);

  Stream<V> get propertyStream => inputStream.distinct((_, next) {
        return _valueHashCode == ComparableWrapper(next).hashCode;
      }).map((value) {
        _valueHashCode = ComparableWrapper(value).hashCode;
        return value;
      });
}
