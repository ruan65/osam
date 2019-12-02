import 'package:hive/hive.dart';
import 'package:osam/domain/state/base_state.dart';

abstract class PersistRepository {
  factory PersistRepository() => _PersistRepositoryImpl();
  Future<void> init();

  void storeState(BaseState appState);

  BaseState restoreState();

  void wipeState();
}

class _PersistRepositoryImpl implements PersistRepository {
  Box<BaseState> _persist;

  static final PersistRepository _singleton = _PersistRepositoryImpl._internal();

  factory _PersistRepositoryImpl() => _singleton;

  _PersistRepositoryImpl._internal();

  Future<void> init() async => _persist ??= await Hive.openBox('persist');

  void storeState(BaseState appState) => _persist.put('appState', appState);

  BaseState restoreState() => _persist.get('appState');

  void wipeState() => _persist.delete('appState');
}
