import 'package:osam/domain/state/base_state.dart';
import 'package:osam/domain/store/store.dart';

abstract class Presenter<ST extends BaseState> {
  Store<ST> store;

  void init();

  void dispose();
}
