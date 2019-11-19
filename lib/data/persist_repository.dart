import 'package:hive/hive.dart';
import 'package:osam/domain/state/base_state.dart';

class PersistRepository {
  Box<BaseState> _persist;

  static final PersistRepository _singleton = PersistRepository._internal();

  factory PersistRepository() => _singleton;

  PersistRepository._internal();

  Future<void> init() async => _persist ??= await Hive.openBox('persist');

  void storeState(BaseState appState) => _persist.put('appState', appState);

  BaseState restoreState() => _persist.get('appState');

  void wipeState() => _persist.delete('appState');
}
