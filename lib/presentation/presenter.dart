import 'package:osam/domain/state/base_state.dart';
import 'package:osam/domain/store/store.dart';

abstract class Presenter<S extends Store<BaseState>> {
  // setts by PresenterProvider
  S store;
  // calling automatic
  void init();

  void dispose();
}
