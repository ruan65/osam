import 'package:osam/domain/store/store.dart';

abstract class Presenter {
  final Store store;
  const Presenter(this.store);

  void init();

  void dispose();
}
