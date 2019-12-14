import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:osam/domain/state/base_state.dart';

abstract class PersistRepository {
  factory PersistRepository() => _PersistRepositoryImpl();

  Future<void> init();

  void storeState<ST extends BaseState>(ST appState);

  ST restoreState<ST extends BaseState>();

  void deleteState();

  bool get isEnabled;
}

class _PersistRepositoryImpl implements PersistRepository {
  Box<BaseState> _persist;

  static final PersistRepository _singleton = _PersistRepositoryImpl._internal();

  factory _PersistRepositoryImpl() => _singleton;

  _PersistRepositoryImpl._internal();

  Future<void> init() async => _persist ??= await Hive.openBox('persist');

  void storeState<ST extends BaseState>(ST appState) {
    if (_persist == null) debugPrint('insure you called initPersist from your store in main');
    _persist.put('appState', appState);
  }

  ST restoreState<ST extends BaseState>() {
    if (_persist == null) debugPrint('insure you called initPersist from your store in main');
    return _persist.get('appState');
  }

  void deleteState() {
    if (_persist == null) debugPrint('insure you called initPersist from your store in main');
    _persist.delete('appState');
  }

  @override
  bool get isEnabled => _persist == null ? false : true;
}
