import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:osam/util/comparable_wrapper.dart';

typedef V ValueMapper<ST, V>(ST state);

// ignore: must_be_immutable
abstract class BaseState<ST> extends Equatable {
  BaseState() {
    _lastKnownHashCode = this.hashCode;
  }

  @protected
  int _lastKnownHashCode;

  StreamController<ST> _stateBroadcaster = StreamController<ST>.broadcast();
  Stream<ST> get stateStream => _stateBroadcaster.stream.map((state) => state);
  Stream<V> propertyStream<V>(ValueMapper<ST, V> mapper) =>
      _PropertyStream<V>(stateStream.map<V>((state) {
        try {
          return mapper(state);
        } catch (e) {
          print(e);
          return null;
        }
      })).propertyStream;

  /// Hive restoring workaround
  /// don't call this method only in hive adapters
  void refreshHashcode() => _lastKnownHashCode = this.hashCode;

  @protected
  void _init() => _stateBroadcaster = StreamController<ST>.broadcast();

  void update() {
    if (_stateBroadcaster.isClosed) _init();
    if (_lastKnownHashCode != this.hashCode) {
      _stateBroadcaster.sink.add(this as ST);
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
        if (next != null) return _valueHashCode == ComparableWrapper(next).hashCode;
        return true;
      }).map((value) {
        _valueHashCode = ComparableWrapper(value).hashCode;
        return value;
      });
}
