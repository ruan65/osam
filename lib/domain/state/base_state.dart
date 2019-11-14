import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:osam/util/comparable_wrapper.dart';

typedef V ValueMapper<ST extends BaseState, V>(ST state);

// ignore: must_be_immutable
abstract class BaseState extends Equatable {
  @protected
  int _lastKnownHashCode;

  StreamController<BaseState> _stateBroadcaster = StreamController<BaseState>.broadcast();
  Stream<BaseState> get stateStream => _stateBroadcaster.stream;

  Stream<V> propertyStream<ST extends BaseState, V>(ValueMapper<ST, V> mapper) =>
      _PropertyStream<V>(stateStream.map<V>((state) => mapper(state))).propertyStream;

  @protected
  void _init() => _stateBroadcaster = StreamController<BaseState>.broadcast();

  void update() {
    if (_stateBroadcaster.isClosed) _init();
    if (_lastKnownHashCode != this.hashCode) {
      _broadcastItSelf().then((_) {
        _lastKnownHashCode = this.hashCode;
      });
    }
  }

  @protected
  Future<void> _broadcastItSelf() async => _stateBroadcaster.sink.add(this);

  @override
  List<Object> get props;

  void clear() => _stateBroadcaster.close();
}

class _PropertyStream<V> {
  final Stream<V> inputStream;
  int valueHashCode;
  _PropertyStream(this.inputStream);

  Stream<V> get propertyStream => inputStream.distinct((prev, next) {
        return valueHashCode == ComparableWrapper(next).hashCode;
      }).map((value) {
        valueHashCode = ComparableWrapper(value).hashCode;
        return value;
      });
}
