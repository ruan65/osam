import 'package:osam/domain/state/base_state.dart';
import 'package:osam/domain/store/store.dart';

abstract class Presenter<S extends Store<BaseState>> {
  S store;

  void init();

  void dispose();
}
