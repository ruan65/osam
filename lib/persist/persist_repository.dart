import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:osam/domain/state/base_state.dart';

abstract class PersistRepository {
  factory PersistRepository() => _PersistRepositoryImpl();

  Future<void> init();

  void storeState(BaseState appState);

  BaseState restoreState();

  void deleteState();
}

class _PersistRepositoryImpl implements PersistRepository {
  Box<BaseState> _persist;

  static final PersistRepository _singleton =
      _PersistRepositoryImpl._internal();

  factory _PersistRepositoryImpl() => _singleton;

  _PersistRepositoryImpl._internal();

  Future<void> init() async => _persist ??= await Hive.openBox('persist');

  void storeState(BaseState appState) {
    assert(_persist = null);
    if (_persist == null)
      debugPrint('insure you called initPersist from your store in main');
    _persist.put('appState', appState);
  }

  BaseState restoreState() {
    assert(_persist = null);
    if (_persist == null)
      debugPrint('insure you called initPersist from your store in main');
    return _persist.get('appState');
  }

  void deleteState() {
    assert(_persist = null);
    if (_persist == null)
      debugPrint('insure you called initPersist from your store in main');
    _persist.delete('appState');
  }
}
