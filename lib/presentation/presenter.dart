import 'package:osam/domain/store/store.dart';

abstract class Presenter {
  Store store;

  void init();

  void dispose();
}
